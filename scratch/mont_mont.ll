; ModuleID = 'src/aha-mont64/mont64.c'
source_filename = "src/aha-mont64/mont64.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@in_m = internal global i64 0, align 8
@in_b = internal global i64 0, align 8
@in_a = internal global i64 0, align 8
@.str = private unnamed_addr constant [50 x i8] c"Benchmark completed successfully with no errors.\0A\00", align 1
@.str.1 = private unnamed_addr constant [34 x i8] c"Benchmark completed with errors.\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @mulul64(i64 noundef %u, i64 noundef %v, ptr noundef %whi, ptr noundef %wlo) #0 {
entry:
  %u.addr = alloca i64, align 8
  %v.addr = alloca i64, align 8
  %whi.addr = alloca ptr, align 8
  %wlo.addr = alloca ptr, align 8
  %result = alloca i128, align 16
  store i64 %u, ptr %u.addr, align 8
  store i64 %v, ptr %v.addr, align 8
  store ptr %whi, ptr %whi.addr, align 8
  store ptr %wlo, ptr %wlo.addr, align 8
  %0 = load i64, ptr %u.addr, align 8
  %conv = zext i64 %0 to i128
  %1 = load i64, ptr %v.addr, align 8
  %conv1 = zext i64 %1 to i128
  %mul = mul i128 %conv, %conv1
  store i128 %mul, ptr %result, align 16
  %2 = load i128, ptr %result, align 16
  %conv2 = trunc i128 %2 to i64
  %3 = load ptr, ptr %wlo.addr, align 8
  store i64 %conv2, ptr %3, align 8
  %4 = load i128, ptr %result, align 16
  %shr = lshr i128 %4, 64
  %conv3 = trunc i128 %shr to i64
  %5 = load ptr, ptr %whi.addr, align 8
  store i64 %conv3, ptr %5, align 8
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i64 @modul64(i64 noundef %x, i64 noundef %y, i64 noundef %z) #0 {
entry:
  %x.addr = alloca i64, align 8
  %y.addr = alloca i64, align 8
  %z.addr = alloca i64, align 8
  %i = alloca i64, align 8
  %t = alloca i64, align 8
  store i64 %x, ptr %x.addr, align 8
  store i64 %y, ptr %y.addr, align 8
  store i64 %z, ptr %z.addr, align 8
  store i64 1, ptr %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i64, ptr %i, align 8
  %cmp = icmp sle i64 %0, 64
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %1 = load i64, ptr %x.addr, align 8
  %shr = ashr i64 %1, 63
  store i64 %shr, ptr %t, align 8
  %2 = load i64, ptr %x.addr, align 8
  %shl = shl i64 %2, 1
  %3 = load i64, ptr %y.addr, align 8
  %shr1 = lshr i64 %3, 63
  %or = or i64 %shl, %shr1
  store i64 %or, ptr %x.addr, align 8
  %4 = load i64, ptr %y.addr, align 8
  %shl2 = shl i64 %4, 1
  store i64 %shl2, ptr %y.addr, align 8
  %5 = load i64, ptr %x.addr, align 8
  %6 = load i64, ptr %t, align 8
  %or3 = or i64 %5, %6
  %7 = load i64, ptr %z.addr, align 8
  %cmp4 = icmp uge i64 %or3, %7
  br i1 %cmp4, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  %8 = load i64, ptr %x.addr, align 8
  %9 = load i64, ptr %z.addr, align 8
  %sub = sub i64 %8, %9
  store i64 %sub, ptr %x.addr, align 8
  %10 = load i64, ptr %y.addr, align 8
  %add = add i64 %10, 1
  store i64 %add, ptr %y.addr, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %11 = load i64, ptr %i, align 8
  %inc = add nsw i64 %11, 1
  store i64 %inc, ptr %i, align 8
  br label %for.cond, !llvm.loop !4

for.end:                                          ; preds = %for.cond
  %12 = load i64, ptr %x.addr, align 8
  ret i64 %12
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i64 @montmul(i64 noundef %abar, i64 noundef %bbar, i64 noundef %m, i64 noundef %mprime) #0 {
entry:
  %abar.addr = alloca i64, align 8
  %bbar.addr = alloca i64, align 8
  %m.addr = alloca i64, align 8
  %mprime.addr = alloca i64, align 8
  %thi = alloca i64, align 8
  %tlo = alloca i64, align 8
  %tm = alloca i64, align 8
  %tmmhi = alloca i64, align 8
  %tmmlo = alloca i64, align 8
  %uhi = alloca i64, align 8
  %ulo = alloca i64, align 8
  %ov = alloca i64, align 8
  store i64 %abar, ptr %abar.addr, align 8
  store i64 %bbar, ptr %bbar.addr, align 8
  store i64 %m, ptr %m.addr, align 8
  store i64 %mprime, ptr %mprime.addr, align 8
  %0 = load i64, ptr %abar.addr, align 8
  %1 = load i64, ptr %bbar.addr, align 8
  call void @mulul64(i64 noundef %0, i64 noundef %1, ptr noundef %thi, ptr noundef %tlo)
  %2 = load i64, ptr %tlo, align 8
  %3 = load i64, ptr %mprime.addr, align 8
  %mul = mul i64 %2, %3
  store i64 %mul, ptr %tm, align 8
  %4 = load i64, ptr %tm, align 8
  %5 = load i64, ptr %m.addr, align 8
  call void @mulul64(i64 noundef %4, i64 noundef %5, ptr noundef %tmmhi, ptr noundef %tmmlo)
  %6 = load i64, ptr %tlo, align 8
  %7 = load i64, ptr %tmmlo, align 8
  %add = add i64 %6, %7
  store i64 %add, ptr %ulo, align 8
  %8 = load i64, ptr %thi, align 8
  %9 = load i64, ptr %tmmhi, align 8
  %add1 = add i64 %8, %9
  store i64 %add1, ptr %uhi, align 8
  %10 = load i64, ptr %ulo, align 8
  %11 = load i64, ptr %tlo, align 8
  %cmp = icmp ult i64 %10, %11
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %12 = load i64, ptr %uhi, align 8
  %add2 = add i64 %12, 1
  store i64 %add2, ptr %uhi, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %13 = load i64, ptr %uhi, align 8
  %14 = load i64, ptr %thi, align 8
  %cmp3 = icmp ult i64 %13, %14
  %conv = zext i1 %cmp3 to i32
  %15 = load i64, ptr %uhi, align 8
  %16 = load i64, ptr %thi, align 8
  %cmp4 = icmp eq i64 %15, %16
  %conv5 = zext i1 %cmp4 to i32
  %17 = load i64, ptr %ulo, align 8
  %18 = load i64, ptr %tlo, align 8
  %cmp6 = icmp ult i64 %17, %18
  %conv7 = zext i1 %cmp6 to i32
  %and = and i32 %conv5, %conv7
  %or = or i32 %conv, %and
  %conv8 = sext i32 %or to i64
  store i64 %conv8, ptr %ov, align 8
  %19 = load i64, ptr %uhi, align 8
  store i64 %19, ptr %ulo, align 8
  store i64 0, ptr %uhi, align 8
  %20 = load i64, ptr %ulo, align 8
  %21 = load i64, ptr %m.addr, align 8
  %22 = load i64, ptr %ov, align 8
  %23 = load i64, ptr %ulo, align 8
  %24 = load i64, ptr %m.addr, align 8
  %cmp9 = icmp uge i64 %23, %24
  %conv10 = zext i1 %cmp9 to i32
  %conv11 = sext i32 %conv10 to i64
  %or12 = or i64 %22, %conv11
  %sub = sub i64 0, %or12
  %and13 = and i64 %21, %sub
  %sub14 = sub i64 %20, %and13
  store i64 %sub14, ptr %ulo, align 8
  %25 = load i64, ptr %ulo, align 8
  ret i64 %25
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @xbinGCD(i64 noundef %a, i64 noundef %b, ptr noundef %pu, ptr noundef %pv) #0 {
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %pu.addr = alloca ptr, align 8
  %pv.addr = alloca ptr, align 8
  %alpha = alloca i64, align 8
  %beta = alloca i64, align 8
  %u = alloca i64, align 8
  %v = alloca i64, align 8
  store i64 %a, ptr %a.addr, align 8
  store i64 %b, ptr %b.addr, align 8
  store ptr %pu, ptr %pu.addr, align 8
  store ptr %pv, ptr %pv.addr, align 8
  store i64 1, ptr %u, align 8
  store i64 0, ptr %v, align 8
  %0 = load i64, ptr %a.addr, align 8
  store i64 %0, ptr %alpha, align 8
  %1 = load i64, ptr %b.addr, align 8
  store i64 %1, ptr %beta, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %2 = load i64, ptr %a.addr, align 8
  %cmp = icmp ugt i64 %2, 0
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %3 = load i64, ptr %a.addr, align 8
  %shr = lshr i64 %3, 1
  store i64 %shr, ptr %a.addr, align 8
  %4 = load i64, ptr %u, align 8
  %and = and i64 %4, 1
  %cmp1 = icmp eq i64 %and, 0
  br i1 %cmp1, label %if.then, label %if.else

if.then:                                          ; preds = %while.body
  %5 = load i64, ptr %u, align 8
  %shr2 = lshr i64 %5, 1
  store i64 %shr2, ptr %u, align 8
  %6 = load i64, ptr %v, align 8
  %shr3 = lshr i64 %6, 1
  store i64 %shr3, ptr %v, align 8
  br label %if.end

if.else:                                          ; preds = %while.body
  %7 = load i64, ptr %u, align 8
  %8 = load i64, ptr %beta, align 8
  %xor = xor i64 %7, %8
  %shr4 = lshr i64 %xor, 1
  %9 = load i64, ptr %u, align 8
  %10 = load i64, ptr %beta, align 8
  %and5 = and i64 %9, %10
  %add = add i64 %shr4, %and5
  store i64 %add, ptr %u, align 8
  %11 = load i64, ptr %v, align 8
  %shr6 = lshr i64 %11, 1
  %12 = load i64, ptr %alpha, align 8
  %add7 = add i64 %shr6, %12
  store i64 %add7, ptr %v, align 8
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  br label %while.cond, !llvm.loop !6

while.end:                                        ; preds = %while.cond
  %13 = load i64, ptr %u, align 8
  %14 = load ptr, ptr %pu.addr, align 8
  store volatile i64 %13, ptr %14, align 8
  %15 = load i64, ptr %v, align 8
  %16 = load ptr, ptr %pv.addr, align 8
  store volatile i64 %15, ptr %16, align 8
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @warm_caches(i32 noundef %heat) #0 {
entry:
  %heat.addr = alloca i32, align 4
  %res = alloca i32, align 4
  store i32 %heat, ptr %heat.addr, align 4
  %0 = load i32, ptr %heat.addr, align 4
  %call = call i32 @benchmark_body(i32 noundef %0)
  store i32 %call, ptr %res, align 4
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @benchmark_body(i32 noundef %rpt) #0 {
entry:
  %rpt.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %errors = alloca i32, align 4
  %a = alloca i64, align 8
  %b = alloca i64, align 8
  %m = alloca i64, align 8
  %hr = alloca i64, align 8
  %p1hi = alloca i64, align 8
  %p1lo = alloca i64, align 8
  %p1 = alloca i64, align 8
  %p = alloca i64, align 8
  %abar = alloca i64, align 8
  %bbar = alloca i64, align 8
  %phi = alloca i64, align 8
  %plo = alloca i64, align 8
  %rinv = alloca i64, align 8
  %mprime = alloca i64, align 8
  store i32 %rpt, ptr %rpt.addr, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, ptr %i, align 4
  %1 = load i32, ptr %rpt.addr, align 4
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  store i32 0, ptr %errors, align 4
  %2 = load i64, ptr @in_m, align 8
  store i64 %2, ptr %m, align 8
  %3 = load i64, ptr @in_b, align 8
  store i64 %3, ptr %b, align 8
  %4 = load i64, ptr @in_a, align 8
  store i64 %4, ptr %a, align 8
  %5 = load i64, ptr %a, align 8
  %6 = load i64, ptr %b, align 8
  call void @mulul64(i64 noundef %5, i64 noundef %6, ptr noundef %p1hi, ptr noundef %p1lo)
  %7 = load i64, ptr %p1hi, align 8
  %8 = load i64, ptr %p1lo, align 8
  %9 = load i64, ptr %m, align 8
  %call = call i64 @modul64(i64 noundef %7, i64 noundef %8, i64 noundef %9)
  store i64 %call, ptr %p1, align 8
  %10 = load i64, ptr %p1, align 8
  %11 = load i64, ptr %p1, align 8
  call void @mulul64(i64 noundef %10, i64 noundef %11, ptr noundef %p1hi, ptr noundef %p1lo)
  %12 = load i64, ptr %p1hi, align 8
  %13 = load i64, ptr %p1lo, align 8
  %14 = load i64, ptr %m, align 8
  %call1 = call i64 @modul64(i64 noundef %12, i64 noundef %13, i64 noundef %14)
  store i64 %call1, ptr %p1, align 8
  %15 = load i64, ptr %p1, align 8
  %16 = load i64, ptr %p1, align 8
  call void @mulul64(i64 noundef %15, i64 noundef %16, ptr noundef %p1hi, ptr noundef %p1lo)
  %17 = load i64, ptr %p1hi, align 8
  %18 = load i64, ptr %p1lo, align 8
  %19 = load i64, ptr %m, align 8
  %call2 = call i64 @modul64(i64 noundef %17, i64 noundef %18, i64 noundef %19)
  store i64 %call2, ptr %p1, align 8
  store i64 -9223372036854775808, ptr %hr, align 8
  %20 = load i64, ptr %hr, align 8
  %21 = load i64, ptr %m, align 8
  call void @xbinGCD(i64 noundef %20, i64 noundef %21, ptr noundef %rinv, ptr noundef %mprime)
  %22 = load i64, ptr %hr, align 8
  %mul = mul i64 2, %22
  %23 = load volatile i64, ptr %rinv, align 8
  %mul3 = mul i64 %mul, %23
  %24 = load i64, ptr %m, align 8
  %25 = load volatile i64, ptr %mprime, align 8
  %mul4 = mul i64 %24, %25
  %sub = sub i64 %mul3, %mul4
  %cmp5 = icmp ne i64 %sub, 1
  br i1 %cmp5, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  store i32 1, ptr %errors, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body
  %26 = load i64, ptr %a, align 8
  %27 = load i64, ptr %m, align 8
  %call6 = call i64 @modul64(i64 noundef %26, i64 noundef 0, i64 noundef %27)
  store i64 %call6, ptr %abar, align 8
  %28 = load i64, ptr %b, align 8
  %29 = load i64, ptr %m, align 8
  %call7 = call i64 @modul64(i64 noundef %28, i64 noundef 0, i64 noundef %29)
  store i64 %call7, ptr %bbar, align 8
  %30 = load i64, ptr %abar, align 8
  %31 = load i64, ptr %bbar, align 8
  %32 = load i64, ptr %m, align 8
  %33 = load volatile i64, ptr %mprime, align 8
  %call8 = call i64 @montmul(i64 noundef %30, i64 noundef %31, i64 noundef %32, i64 noundef %33)
  store i64 %call8, ptr %p, align 8
  %34 = load i64, ptr %p, align 8
  %35 = load i64, ptr %p, align 8
  %36 = load i64, ptr %m, align 8
  %37 = load volatile i64, ptr %mprime, align 8
  %call9 = call i64 @montmul(i64 noundef %34, i64 noundef %35, i64 noundef %36, i64 noundef %37)
  store i64 %call9, ptr %p, align 8
  %38 = load i64, ptr %p, align 8
  %39 = load i64, ptr %p, align 8
  %40 = load i64, ptr %m, align 8
  %41 = load volatile i64, ptr %mprime, align 8
  %call10 = call i64 @montmul(i64 noundef %38, i64 noundef %39, i64 noundef %40, i64 noundef %41)
  store i64 %call10, ptr %p, align 8
  %42 = load i64, ptr %p, align 8
  %43 = load volatile i64, ptr %rinv, align 8
  call void @mulul64(i64 noundef %42, i64 noundef %43, ptr noundef %phi, ptr noundef %plo)
  %44 = load i64, ptr %phi, align 8
  %45 = load i64, ptr %plo, align 8
  %46 = load i64, ptr %m, align 8
  %call11 = call i64 @modul64(i64 noundef %44, i64 noundef %45, i64 noundef %46)
  store i64 %call11, ptr %p, align 8
  %47 = load i64, ptr %p, align 8
  %48 = load i64, ptr %p1, align 8
  %cmp12 = icmp ne i64 %47, %48
  br i1 %cmp12, label %if.then13, label %if.end14

if.then13:                                        ; preds = %if.end
  store i32 1, ptr %errors, align 4
  br label %if.end14

if.end14:                                         ; preds = %if.then13, %if.end
  br label %for.inc

for.inc:                                          ; preds = %if.end14
  %49 = load i32, ptr %i, align 4
  %inc = add nsw i32 %49, 1
  store i32 %inc, ptr %i, align 4
  br label %for.cond, !llvm.loop !7

for.end:                                          ; preds = %for.cond
  %50 = load i32, ptr %errors, align 4
  ret i32 %50
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @benchmark() #0 {
entry:
  %call = call i32 @benchmark_body(i32 noundef 423)
  ret i32 %call
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @initialise_benchmark() #0 {
entry:
  store i64 -366962936819156833, ptr @in_m, align 8
  store i64 1473642379452024179, ptr @in_b, align 8
  store i64 380896260630216687, ptr @in_a, align 8
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @verify_benchmark(i32 noundef %r) #0 {
entry:
  %r.addr = alloca i32, align 4
  store i32 %r, ptr %r.addr, align 4
  %0 = load i32, ptr %r.addr, align 4
  %cmp = icmp eq i32 0, %0
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  %errors = alloca i32, align 4
  store i32 0, ptr %retval, align 4
  call void @initialise_benchmark()
  call void @warm_caches(i32 noundef 1)
  %call = call i32 @benchmark()
  store i32 %call, ptr %errors, align 4
  %0 = load i32, ptr %errors, align 4
  %call1 = call i32 @verify_benchmark(i32 noundef %0)
  %tobool = icmp ne i32 %call1, 0
  br i1 %tobool, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %call2 = call i32 (ptr, ...) @printf(ptr noundef @.str)
  br label %if.end

if.else:                                          ; preds = %entry
  %call3 = call i32 (ptr, ...) @printf(ptr noundef @.str.1)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret i32 0
}

declare dso_local i32 @printf(ptr noundef, ...) #1

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"uwtable", i32 2}
!2 = !{i32 7, !"frame-pointer", i32 2}
!3 = !{!"clang version 18.1.8 (https://github.com/llvm/llvm-project.git 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)"}
!4 = distinct !{!4, !5}
!5 = !{!"llvm.loop.mustprogress"}
!6 = distinct !{!6, !5}
!7 = distinct !{!7, !5}
