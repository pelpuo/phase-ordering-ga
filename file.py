import subprocess
import time
import random
import pandas as pd

def apply_passes(input, pass_order):
    cmd = ["./compile.sh", input]
    cmd += pass_order

    result = subprocess.run(cmd, capture_output=True, text=True, check=True, cwd="./beebs")
    return result


def measure_runtime(binary, count=50, mode="cycles"):
    total_score = 0.0
    total_base = 0.0
    for _ in range(count):
        # start = time.time()
        result = subprocess.run(
            [f"./{binary}/{binary}"],
            capture_output=True,
            text=True,
            cwd="./beebs/src"
        )

        result2 = subprocess.run(
            [f"./{binary}/{binary}_base"],
            capture_output=True,
            text=True,
            cwd="./beebs/src"
        )

        if "Cycles" in result.stdout:
            cycles = int(result.stdout.split("Cycles:")[1].split()[0])
            base = int(result2.stdout.split("Cycles:")[1].split()[0])
            if mode == "cycles":
                total_score += cycles
                total_base += base
    return (total_score - total_base) / count


def measure_size(binary):
    result = subprocess.run(["size", binary], capture_output=True, text=True)
    lines = result.stdout.strip().split("\n")
    if len(lines) < 2:
        return None
    size_fields = lines[1].split()
    total_size = sum(int(x) for x in size_fields[:4])
    return total_size


def evaluate_candidate(pass_order, input, workdir, mode="runtime"):
    candidate = f"{workdir}/candidate_bin"
    try:
        apply_passes(input, pass_order)
        if mode == "runtime":
            fitness = measure_runtime(input)
        elif mode == "size":
            fitness = measure_size(input)
        else:
            raise ValueError("Invalid mode")
        return fitness
    except subprocess.CalledProcessError:
        return float("inf")  # Penalize failure
    


def random_candidate(pass_pool, max_len=5):
    # length = random.randint(1, max_len)
    return random.sample(pass_pool, max_len)



def crossover(parent1, parent2, max_len=5):
    # Pick cut points
    p1_cut = random.randint(1, len(parent1))
    p2_cut = random.randint(1, len(parent2))

    # Combine slices
    child = parent1[:p1_cut] + parent2[p2_cut:]

    # Remove duplicates while preserving order
    seen = set()
    deduped_child = []
    for p in child:
        if p not in seen:
            deduped_child.append(p)
            seen.add(p)

    # Clip to max length
    return deduped_child[:max_len]


def mutate(candidate, pass_pool, mutation_rate=0.1, max_len=5):
    # Start with a copy
    mutated = candidate[:]
    
    # Replace one random pass in the candidate
    if mutated and random.random() < mutation_rate:
        replace_idx = random.randint(0, len(mutated) - 1)
        available = list(set(pass_pool) - set(mutated))
        if available:
            mutated[replace_idx] = random.choice(available)

    # Random insertion
    if len(mutated) < max_len and random.random() < mutation_rate:
        available = list(set(pass_pool) - set(mutated))
        if available:
            insert_pos = random.randint(0, len(mutated))
            mutated.insert(insert_pos, random.choice(available))

    # Random deletion
    if len(mutated) > 1 and random.random() < mutation_rate:
        del_pos = random.randint(0, len(mutated) - 1)
        mutated.pop(del_pos)

    return mutated




def run_ga(input_bc, pass_pool, generations=10, pop_size=20, seq_length=5):
    population = [random_candidate(pass_pool, seq_length) for _ in range(pop_size)]
    stats = []

    apply_passes(input_bc, [])
    subprocess.run(["mv", f"{input_bc}/{input_bc}", f"{input_bc}/{input_bc}_base"], cwd= "./beebs/src", capture_output=True, text=True, check=True)

    # Initialize global best candidate
    global_best_candidate = None
    global_best_fitness = float("inf")

    for generation in range(generations):
        print(f"Generation {generation}")
        fitnesses = []
        for candidate in population:
            fitness = evaluate_candidate(candidate, input_bc, "./scratch")
            fitnesses.append((fitness, candidate))
            # print(f"Candidate {candidate} => Fitness {fitness}")

        # Update global best candidate
        for fitness, candidate in fitnesses:
            if fitness < global_best_fitness:
                global_best_fitness = fitness
                global_best_candidate = candidate

        # Selection
        fitnesses.sort(key=lambda x: x[0])
        population = [cand for _, cand in fitnesses[:(pop_size // 2)]]

        # Crossover and mutation
        new_population = []
        while len(new_population) < pop_size:
            parents = random.sample(population, 2)
            c1 = crossover(parents[0], parents[1], seq_length)
            c1 = mutate(c1, pass_pool, seq_length)
            new_population.append(c1)

        population = new_population

        # Collect stats for the generation
        best_fitness, best_candidate = fitnesses[0]
        worst_fitness, worst_candidate = fitnesses[-1]
        avg_fitness = sum(f[0] for f in fitnesses) / len(fitnesses)
        stats.append({
            "Generation": generation,
            "Best Candidate": best_candidate,
            "Global Best Candidate": global_best_candidate,
            "Worst Candidate": worst_candidate,
            "Best Time": best_fitness,
            "Worst Time": worst_fitness,
            "Global Best Time": global_best_fitness,
            "Average Time": avg_fitness
        })
        print(stats[-1])

    # Final best
    print(f"Global Best candidate: {global_best_candidate} with fitness {global_best_fitness}")

    # Create a DataFrame from stats
    stats_df = pd.DataFrame(stats)
    return stats_df


PASS_POOL = [
    "-fgcse-after-reload",
    "-fipa-cp-clone",
    "-floop-interchange",
    "-floop-unroll-and-jam",
    "-fpeel-loops",
    "-fpredictive-commoning",
    "-fsplit-loops",
    "-fsplit-paths",
    "-ftree-loop-distribution",
    "-ftree-partial-pre",
    "-funswitch-loops",
    "-fvect-cost-model=dynamic",
    "-fversion-loops-for-strides",   
]

if __name__ == "__main__":
    sources = ["sglib-listsort", # 1 
           "dtoa", # 2
           "fac", # 3

           "trio-snprintf", # 1 
           "fibcall", # 2
           "crc32", # 3

           "ctl-vector", # 1
           "nettle-arcfour", # 2
           "template" # 3
           ] 

    for source in sources:
        print(f"Running GA for {source}")
        stats_df = run_ga(sources[0], PASS_POOL, generations=20, pop_size=30, seq_length=5)
        stats_df.to_csv(f"results/{source}_stats.csv", index=False)