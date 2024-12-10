; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s                               -mtriple=x86_64-apple-darwin10 | FileCheck %s --check-prefix=SDAG
; RUN: llc < %s -fast-isel -fast-isel-abort=1 -mtriple=x86_64-apple-darwin10 | FileCheck %s --check-prefixes=FAST,FAST_NOAVX
; RUN: llc < %s -fast-isel -fast-isel-abort=1 -mtriple=x86_64-apple-darwin10 -mattr=avx | FileCheck %s --check-prefixes=FAST,FAST_AVX
; RUN: llc < %s -fast-isel -fast-isel-abort=1 -mtriple=x86_64-apple-darwin10 -mattr=avx512f | FileCheck %s --check-prefixes=FAST,FAST_AVX

define zeroext i1 @fcmp_oeq(float %x, float %y) {
; SDAG-LABEL: fcmp_oeq:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    cmpeqss %xmm1, %xmm0
; SDAG-NEXT:    movd %xmm0, %eax
; SDAG-NEXT:    andl $1, %eax
; SDAG-NEXT:    ## kill: def $al killed $al killed $eax
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_oeq:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm1, %xmm0
; FAST_NOAVX-NEXT:    sete %al
; FAST_NOAVX-NEXT:    setnp %cl
; FAST_NOAVX-NEXT:    andb %al, %cl
; FAST_NOAVX-NEXT:    andb $1, %cl
; FAST_NOAVX-NEXT:    movzbl %cl, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_oeq:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm1, %xmm0
; FAST_AVX-NEXT:    sete %al
; FAST_AVX-NEXT:    setnp %cl
; FAST_AVX-NEXT:    andb %al, %cl
; FAST_AVX-NEXT:    andb $1, %cl
; FAST_AVX-NEXT:    movzbl %cl, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp oeq float %x, %y
  ret i1 %1
}

define zeroext i1 @fcmp_ogt(float %x, float %y) {
; SDAG-LABEL: fcmp_ogt:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    ucomiss %xmm1, %xmm0
; SDAG-NEXT:    seta %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_ogt:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm1, %xmm0
; FAST_NOAVX-NEXT:    seta %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_ogt:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm1, %xmm0
; FAST_AVX-NEXT:    seta %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ogt float %x, %y
  ret i1 %1
}

define zeroext i1 @fcmp_oge(float %x, float %y) {
; SDAG-LABEL: fcmp_oge:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    ucomiss %xmm1, %xmm0
; SDAG-NEXT:    setae %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_oge:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm1, %xmm0
; FAST_NOAVX-NEXT:    setae %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_oge:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm1, %xmm0
; FAST_AVX-NEXT:    setae %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp oge float %x, %y
  ret i1 %1
}

define zeroext i1 @fcmp_olt(float %x, float %y) {
; SDAG-LABEL: fcmp_olt:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    ucomiss %xmm0, %xmm1
; SDAG-NEXT:    seta %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_olt:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm0, %xmm1
; FAST_NOAVX-NEXT:    seta %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_olt:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm0, %xmm1
; FAST_AVX-NEXT:    seta %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp olt float %x, %y
  ret i1 %1
}

define zeroext i1 @fcmp_ole(float %x, float %y) {
; SDAG-LABEL: fcmp_ole:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    ucomiss %xmm0, %xmm1
; SDAG-NEXT:    setae %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_ole:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm0, %xmm1
; FAST_NOAVX-NEXT:    setae %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_ole:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm0, %xmm1
; FAST_AVX-NEXT:    setae %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ole float %x, %y
  ret i1 %1
}

define zeroext i1 @fcmp_one(float %x, float %y) {
; SDAG-LABEL: fcmp_one:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    ucomiss %xmm1, %xmm0
; SDAG-NEXT:    setne %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_one:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm1, %xmm0
; FAST_NOAVX-NEXT:    setne %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_one:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm1, %xmm0
; FAST_AVX-NEXT:    setne %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp one float %x, %y
  ret i1 %1
}

define zeroext i1 @fcmp_ord(float %x, float %y) {
; SDAG-LABEL: fcmp_ord:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    ucomiss %xmm1, %xmm0
; SDAG-NEXT:    setnp %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_ord:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm1, %xmm0
; FAST_NOAVX-NEXT:    setnp %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_ord:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm1, %xmm0
; FAST_AVX-NEXT:    setnp %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ord float %x, %y
  ret i1 %1
}

define zeroext i1 @fcmp_uno(float %x, float %y) {
; SDAG-LABEL: fcmp_uno:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    ucomiss %xmm1, %xmm0
; SDAG-NEXT:    setp %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_uno:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm1, %xmm0
; FAST_NOAVX-NEXT:    setp %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_uno:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm1, %xmm0
; FAST_AVX-NEXT:    setp %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp uno float %x, %y
  ret i1 %1
}

define zeroext i1 @fcmp_ueq(float %x, float %y) {
; SDAG-LABEL: fcmp_ueq:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    ucomiss %xmm1, %xmm0
; SDAG-NEXT:    sete %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_ueq:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm1, %xmm0
; FAST_NOAVX-NEXT:    sete %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_ueq:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm1, %xmm0
; FAST_AVX-NEXT:    sete %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ueq float %x, %y
  ret i1 %1
}

define zeroext i1 @fcmp_ugt(float %x, float %y) {
; SDAG-LABEL: fcmp_ugt:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    ucomiss %xmm0, %xmm1
; SDAG-NEXT:    setb %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_ugt:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm0, %xmm1
; FAST_NOAVX-NEXT:    setb %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_ugt:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm0, %xmm1
; FAST_AVX-NEXT:    setb %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ugt float %x, %y
  ret i1 %1
}

define zeroext i1 @fcmp_uge(float %x, float %y) {
; SDAG-LABEL: fcmp_uge:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    ucomiss %xmm0, %xmm1
; SDAG-NEXT:    setbe %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_uge:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm0, %xmm1
; FAST_NOAVX-NEXT:    setbe %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_uge:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm0, %xmm1
; FAST_AVX-NEXT:    setbe %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp uge float %x, %y
  ret i1 %1
}

define zeroext i1 @fcmp_ult(float %x, float %y) {
; SDAG-LABEL: fcmp_ult:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    ucomiss %xmm1, %xmm0
; SDAG-NEXT:    setb %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_ult:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm1, %xmm0
; FAST_NOAVX-NEXT:    setb %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_ult:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm1, %xmm0
; FAST_AVX-NEXT:    setb %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ult float %x, %y
  ret i1 %1
}

define zeroext i1 @fcmp_ule(float %x, float %y) {
; SDAG-LABEL: fcmp_ule:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    ucomiss %xmm1, %xmm0
; SDAG-NEXT:    setbe %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_ule:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm1, %xmm0
; FAST_NOAVX-NEXT:    setbe %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_ule:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm1, %xmm0
; FAST_AVX-NEXT:    setbe %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ule float %x, %y
  ret i1 %1
}

define zeroext i1 @fcmp_une(float %x, float %y) {
; SDAG-LABEL: fcmp_une:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    cmpneqss %xmm1, %xmm0
; SDAG-NEXT:    movd %xmm0, %eax
; SDAG-NEXT:    andl $1, %eax
; SDAG-NEXT:    ## kill: def $al killed $al killed $eax
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_une:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm1, %xmm0
; FAST_NOAVX-NEXT:    setne %al
; FAST_NOAVX-NEXT:    setp %cl
; FAST_NOAVX-NEXT:    orb %al, %cl
; FAST_NOAVX-NEXT:    andb $1, %cl
; FAST_NOAVX-NEXT:    movzbl %cl, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_une:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm1, %xmm0
; FAST_AVX-NEXT:    setne %al
; FAST_AVX-NEXT:    setp %cl
; FAST_AVX-NEXT:    orb %al, %cl
; FAST_AVX-NEXT:    andb $1, %cl
; FAST_AVX-NEXT:    movzbl %cl, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp une float %x, %y
  ret i1 %1
}

define zeroext i1 @icmp_eq(i32 %x, i32 %y) {
; SDAG-LABEL: icmp_eq:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    cmpl %esi, %edi
; SDAG-NEXT:    sete %al
; SDAG-NEXT:    retq
;
; FAST-LABEL: icmp_eq:
; FAST:       ## %bb.0:
; FAST-NEXT:    cmpl %esi, %edi
; FAST-NEXT:    sete %al
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %1 = icmp eq i32 %x, %y
  ret i1 %1
}

define zeroext i1 @icmp_ne(i32 %x, i32 %y) {
; SDAG-LABEL: icmp_ne:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    cmpl %esi, %edi
; SDAG-NEXT:    setne %al
; SDAG-NEXT:    retq
;
; FAST-LABEL: icmp_ne:
; FAST:       ## %bb.0:
; FAST-NEXT:    cmpl %esi, %edi
; FAST-NEXT:    setne %al
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %1 = icmp ne i32 %x, %y
  ret i1 %1
}

define zeroext i1 @icmp_ugt(i32 %x, i32 %y) {
; SDAG-LABEL: icmp_ugt:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    cmpl %esi, %edi
; SDAG-NEXT:    seta %al
; SDAG-NEXT:    retq
;
; FAST-LABEL: icmp_ugt:
; FAST:       ## %bb.0:
; FAST-NEXT:    cmpl %esi, %edi
; FAST-NEXT:    seta %al
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %1 = icmp ugt i32 %x, %y
  ret i1 %1
}

define zeroext i1 @icmp_uge(i32 %x, i32 %y) {
; SDAG-LABEL: icmp_uge:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    cmpl %esi, %edi
; SDAG-NEXT:    setae %al
; SDAG-NEXT:    retq
;
; FAST-LABEL: icmp_uge:
; FAST:       ## %bb.0:
; FAST-NEXT:    cmpl %esi, %edi
; FAST-NEXT:    setae %al
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %1 = icmp uge i32 %x, %y
  ret i1 %1
}

define zeroext i1 @icmp_ult(i32 %x, i32 %y) {
; SDAG-LABEL: icmp_ult:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    cmpl %esi, %edi
; SDAG-NEXT:    setb %al
; SDAG-NEXT:    retq
;
; FAST-LABEL: icmp_ult:
; FAST:       ## %bb.0:
; FAST-NEXT:    cmpl %esi, %edi
; FAST-NEXT:    setb %al
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %1 = icmp ult i32 %x, %y
  ret i1 %1
}

define zeroext i1 @icmp_ule(i32 %x, i32 %y) {
; SDAG-LABEL: icmp_ule:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    cmpl %esi, %edi
; SDAG-NEXT:    setbe %al
; SDAG-NEXT:    retq
;
; FAST-LABEL: icmp_ule:
; FAST:       ## %bb.0:
; FAST-NEXT:    cmpl %esi, %edi
; FAST-NEXT:    setbe %al
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %1 = icmp ule i32 %x, %y
  ret i1 %1
}

define zeroext i1 @icmp_sgt(i32 %x, i32 %y) {
; SDAG-LABEL: icmp_sgt:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    cmpl %esi, %edi
; SDAG-NEXT:    setg %al
; SDAG-NEXT:    retq
;
; FAST-LABEL: icmp_sgt:
; FAST:       ## %bb.0:
; FAST-NEXT:    cmpl %esi, %edi
; FAST-NEXT:    setg %al
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %1 = icmp sgt i32 %x, %y
  ret i1 %1
}

define zeroext i1 @icmp_sge(i32 %x, i32 %y) {
; SDAG-LABEL: icmp_sge:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    cmpl %esi, %edi
; SDAG-NEXT:    setge %al
; SDAG-NEXT:    retq
;
; FAST-LABEL: icmp_sge:
; FAST:       ## %bb.0:
; FAST-NEXT:    cmpl %esi, %edi
; FAST-NEXT:    setge %al
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %1 = icmp sge i32 %x, %y
  ret i1 %1
}

define zeroext i1 @icmp_slt(i32 %x, i32 %y) {
; SDAG-LABEL: icmp_slt:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    cmpl %esi, %edi
; SDAG-NEXT:    setl %al
; SDAG-NEXT:    retq
;
; FAST-LABEL: icmp_slt:
; FAST:       ## %bb.0:
; FAST-NEXT:    cmpl %esi, %edi
; FAST-NEXT:    setl %al
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %1 = icmp slt i32 %x, %y
  ret i1 %1
}

define zeroext i1 @icmp_sle(i32 %x, i32 %y) {
; SDAG-LABEL: icmp_sle:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    cmpl %esi, %edi
; SDAG-NEXT:    setle %al
; SDAG-NEXT:    retq
;
; FAST-LABEL: icmp_sle:
; FAST:       ## %bb.0:
; FAST-NEXT:    cmpl %esi, %edi
; FAST-NEXT:    setle %al
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %1 = icmp sle i32 %x, %y
  ret i1 %1
}

; Test cmp folding and condition optimization.
define zeroext i1 @fcmp_oeq2(float %x) {
; SDAG-LABEL: fcmp_oeq2:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    ucomiss %xmm0, %xmm0
; SDAG-NEXT:    setnp %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_oeq2:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm0, %xmm0
; FAST_NOAVX-NEXT:    setnp %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_oeq2:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm0, %xmm0
; FAST_AVX-NEXT:    setnp %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp oeq float %x, %x
  ret i1 %1
}

define zeroext i1 @fcmp_oeq3(float %x) {
; SDAG-LABEL: fcmp_oeq3:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    xorps %xmm1, %xmm1
; SDAG-NEXT:    cmpeqss %xmm0, %xmm1
; SDAG-NEXT:    movd %xmm1, %eax
; SDAG-NEXT:    andl $1, %eax
; SDAG-NEXT:    ## kill: def $al killed $al killed $eax
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_oeq3:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    xorps %xmm1, %xmm1
; FAST_NOAVX-NEXT:    ucomiss %xmm1, %xmm0
; FAST_NOAVX-NEXT:    sete %al
; FAST_NOAVX-NEXT:    setnp %cl
; FAST_NOAVX-NEXT:    andb %al, %cl
; FAST_NOAVX-NEXT:    andb $1, %cl
; FAST_NOAVX-NEXT:    movzbl %cl, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_oeq3:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; FAST_AVX-NEXT:    vucomiss %xmm1, %xmm0
; FAST_AVX-NEXT:    sete %al
; FAST_AVX-NEXT:    setnp %cl
; FAST_AVX-NEXT:    andb %al, %cl
; FAST_AVX-NEXT:    andb $1, %cl
; FAST_AVX-NEXT:    movzbl %cl, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp oeq float %x, 0.000000e+00
  ret i1 %1
}

define zeroext i1 @fcmp_ogt2(float %x) {
; SDAG-LABEL: fcmp_ogt2:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    xorl %eax, %eax
; SDAG-NEXT:    retq
;
; FAST-LABEL: fcmp_ogt2:
; FAST:       ## %bb.0:
; FAST-NEXT:    xorl %eax, %eax
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %1 = fcmp ogt float %x, %x
  ret i1 %1
}

define zeroext i1 @fcmp_ogt3(float %x) {
; SDAG-LABEL: fcmp_ogt3:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    xorps %xmm1, %xmm1
; SDAG-NEXT:    ucomiss %xmm1, %xmm0
; SDAG-NEXT:    seta %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_ogt3:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    xorps %xmm1, %xmm1
; FAST_NOAVX-NEXT:    ucomiss %xmm1, %xmm0
; FAST_NOAVX-NEXT:    seta %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_ogt3:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; FAST_AVX-NEXT:    vucomiss %xmm1, %xmm0
; FAST_AVX-NEXT:    seta %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ogt float %x, 0.000000e+00
  ret i1 %1
}

define zeroext i1 @fcmp_oge2(float %x) {
; SDAG-LABEL: fcmp_oge2:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    ucomiss %xmm0, %xmm0
; SDAG-NEXT:    setnp %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_oge2:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm0, %xmm0
; FAST_NOAVX-NEXT:    setnp %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_oge2:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm0, %xmm0
; FAST_AVX-NEXT:    setnp %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp oge float %x, %x
  ret i1 %1
}

define zeroext i1 @fcmp_oge3(float %x) {
; SDAG-LABEL: fcmp_oge3:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    xorps %xmm1, %xmm1
; SDAG-NEXT:    ucomiss %xmm1, %xmm0
; SDAG-NEXT:    setae %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_oge3:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    xorps %xmm1, %xmm1
; FAST_NOAVX-NEXT:    ucomiss %xmm1, %xmm0
; FAST_NOAVX-NEXT:    setae %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_oge3:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; FAST_AVX-NEXT:    vucomiss %xmm1, %xmm0
; FAST_AVX-NEXT:    setae %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp oge float %x, 0.000000e+00
  ret i1 %1
}

define zeroext i1 @fcmp_olt2(float %x) {
; SDAG-LABEL: fcmp_olt2:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    xorl %eax, %eax
; SDAG-NEXT:    retq
;
; FAST-LABEL: fcmp_olt2:
; FAST:       ## %bb.0:
; FAST-NEXT:    xorl %eax, %eax
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %1 = fcmp olt float %x, %x
  ret i1 %1
}

define zeroext i1 @fcmp_olt3(float %x) {
; SDAG-LABEL: fcmp_olt3:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    xorps %xmm1, %xmm1
; SDAG-NEXT:    ucomiss %xmm0, %xmm1
; SDAG-NEXT:    seta %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_olt3:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    xorps %xmm1, %xmm1
; FAST_NOAVX-NEXT:    ucomiss %xmm0, %xmm1
; FAST_NOAVX-NEXT:    seta %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_olt3:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; FAST_AVX-NEXT:    vucomiss %xmm0, %xmm1
; FAST_AVX-NEXT:    seta %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp olt float %x, 0.000000e+00
  ret i1 %1
}

define zeroext i1 @fcmp_ole2(float %x) {
; SDAG-LABEL: fcmp_ole2:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    ucomiss %xmm0, %xmm0
; SDAG-NEXT:    setnp %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_ole2:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm0, %xmm0
; FAST_NOAVX-NEXT:    setnp %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_ole2:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm0, %xmm0
; FAST_AVX-NEXT:    setnp %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ole float %x, %x
  ret i1 %1
}

define zeroext i1 @fcmp_ole3(float %x) {
; SDAG-LABEL: fcmp_ole3:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    xorps %xmm1, %xmm1
; SDAG-NEXT:    ucomiss %xmm0, %xmm1
; SDAG-NEXT:    setae %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_ole3:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    xorps %xmm1, %xmm1
; FAST_NOAVX-NEXT:    ucomiss %xmm0, %xmm1
; FAST_NOAVX-NEXT:    setae %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_ole3:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; FAST_AVX-NEXT:    vucomiss %xmm0, %xmm1
; FAST_AVX-NEXT:    setae %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ole float %x, 0.000000e+00
  ret i1 %1
}

define zeroext i1 @fcmp_one2(float %x) {
; SDAG-LABEL: fcmp_one2:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    xorl %eax, %eax
; SDAG-NEXT:    retq
;
; FAST-LABEL: fcmp_one2:
; FAST:       ## %bb.0:
; FAST-NEXT:    xorl %eax, %eax
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %1 = fcmp one float %x, %x
  ret i1 %1
}

define zeroext i1 @fcmp_one3(float %x) {
; SDAG-LABEL: fcmp_one3:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    xorps %xmm1, %xmm1
; SDAG-NEXT:    ucomiss %xmm1, %xmm0
; SDAG-NEXT:    setne %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_one3:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    xorps %xmm1, %xmm1
; FAST_NOAVX-NEXT:    ucomiss %xmm1, %xmm0
; FAST_NOAVX-NEXT:    setne %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_one3:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; FAST_AVX-NEXT:    vucomiss %xmm1, %xmm0
; FAST_AVX-NEXT:    setne %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp one float %x, 0.000000e+00
  ret i1 %1
}

define zeroext i1 @fcmp_ord2(float %x) {
; SDAG-LABEL: fcmp_ord2:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    ucomiss %xmm0, %xmm0
; SDAG-NEXT:    setnp %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_ord2:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm0, %xmm0
; FAST_NOAVX-NEXT:    setnp %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_ord2:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm0, %xmm0
; FAST_AVX-NEXT:    setnp %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ord float %x, %x
  ret i1 %1
}

define zeroext i1 @fcmp_ord3(float %x) {
; SDAG-LABEL: fcmp_ord3:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    ucomiss %xmm0, %xmm0
; SDAG-NEXT:    setnp %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_ord3:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm0, %xmm0
; FAST_NOAVX-NEXT:    setnp %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_ord3:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm0, %xmm0
; FAST_AVX-NEXT:    setnp %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ord float %x, 0.000000e+00
  ret i1 %1
}

define zeroext i1 @fcmp_uno2(float %x) {
; SDAG-LABEL: fcmp_uno2:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    ucomiss %xmm0, %xmm0
; SDAG-NEXT:    setp %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_uno2:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm0, %xmm0
; FAST_NOAVX-NEXT:    setp %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_uno2:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm0, %xmm0
; FAST_AVX-NEXT:    setp %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp uno float %x, %x
  ret i1 %1
}

define zeroext i1 @fcmp_uno3(float %x) {
; SDAG-LABEL: fcmp_uno3:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    ucomiss %xmm0, %xmm0
; SDAG-NEXT:    setp %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_uno3:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm0, %xmm0
; FAST_NOAVX-NEXT:    setp %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_uno3:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm0, %xmm0
; FAST_AVX-NEXT:    setp %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp uno float %x, 0.000000e+00
  ret i1 %1
}

define zeroext i1 @fcmp_ueq2(float %x) {
; SDAG-LABEL: fcmp_ueq2:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    movb $1, %al
; SDAG-NEXT:    retq
;
; FAST-LABEL: fcmp_ueq2:
; FAST:       ## %bb.0:
; FAST-NEXT:    movb $1, %al
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %1 = fcmp ueq float %x, %x
  ret i1 %1
}

define zeroext i1 @fcmp_ueq3(float %x) {
; SDAG-LABEL: fcmp_ueq3:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    xorps %xmm1, %xmm1
; SDAG-NEXT:    ucomiss %xmm1, %xmm0
; SDAG-NEXT:    sete %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_ueq3:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    xorps %xmm1, %xmm1
; FAST_NOAVX-NEXT:    ucomiss %xmm1, %xmm0
; FAST_NOAVX-NEXT:    sete %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_ueq3:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; FAST_AVX-NEXT:    vucomiss %xmm1, %xmm0
; FAST_AVX-NEXT:    sete %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ueq float %x, 0.000000e+00
  ret i1 %1
}

define zeroext i1 @fcmp_ugt2(float %x) {
; SDAG-LABEL: fcmp_ugt2:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    ucomiss %xmm0, %xmm0
; SDAG-NEXT:    setp %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_ugt2:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm0, %xmm0
; FAST_NOAVX-NEXT:    setp %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_ugt2:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm0, %xmm0
; FAST_AVX-NEXT:    setp %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ugt float %x, %x
  ret i1 %1
}

define zeroext i1 @fcmp_ugt3(float %x) {
; SDAG-LABEL: fcmp_ugt3:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    xorps %xmm1, %xmm1
; SDAG-NEXT:    ucomiss %xmm0, %xmm1
; SDAG-NEXT:    setb %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_ugt3:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    xorps %xmm1, %xmm1
; FAST_NOAVX-NEXT:    ucomiss %xmm0, %xmm1
; FAST_NOAVX-NEXT:    setb %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_ugt3:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; FAST_AVX-NEXT:    vucomiss %xmm0, %xmm1
; FAST_AVX-NEXT:    setb %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ugt float %x, 0.000000e+00
  ret i1 %1
}

define zeroext i1 @fcmp_uge2(float %x) {
; SDAG-LABEL: fcmp_uge2:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    movb $1, %al
; SDAG-NEXT:    retq
;
; FAST-LABEL: fcmp_uge2:
; FAST:       ## %bb.0:
; FAST-NEXT:    movb $1, %al
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %1 = fcmp uge float %x, %x
  ret i1 %1
}

define zeroext i1 @fcmp_uge3(float %x) {
; SDAG-LABEL: fcmp_uge3:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    xorps %xmm1, %xmm1
; SDAG-NEXT:    ucomiss %xmm0, %xmm1
; SDAG-NEXT:    setbe %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_uge3:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    xorps %xmm1, %xmm1
; FAST_NOAVX-NEXT:    ucomiss %xmm0, %xmm1
; FAST_NOAVX-NEXT:    setbe %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_uge3:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; FAST_AVX-NEXT:    vucomiss %xmm0, %xmm1
; FAST_AVX-NEXT:    setbe %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp uge float %x, 0.000000e+00
  ret i1 %1
}

define zeroext i1 @fcmp_ult2(float %x) {
; SDAG-LABEL: fcmp_ult2:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    ucomiss %xmm0, %xmm0
; SDAG-NEXT:    setp %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_ult2:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm0, %xmm0
; FAST_NOAVX-NEXT:    setp %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_ult2:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm0, %xmm0
; FAST_AVX-NEXT:    setp %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ult float %x, %x
  ret i1 %1
}

define zeroext i1 @fcmp_ult3(float %x) {
; SDAG-LABEL: fcmp_ult3:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    xorps %xmm1, %xmm1
; SDAG-NEXT:    ucomiss %xmm1, %xmm0
; SDAG-NEXT:    setb %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_ult3:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    xorps %xmm1, %xmm1
; FAST_NOAVX-NEXT:    ucomiss %xmm1, %xmm0
; FAST_NOAVX-NEXT:    setb %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_ult3:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; FAST_AVX-NEXT:    vucomiss %xmm1, %xmm0
; FAST_AVX-NEXT:    setb %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ult float %x, 0.000000e+00
  ret i1 %1
}

define zeroext i1 @fcmp_ule2(float %x) {
; SDAG-LABEL: fcmp_ule2:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    movb $1, %al
; SDAG-NEXT:    retq
;
; FAST-LABEL: fcmp_ule2:
; FAST:       ## %bb.0:
; FAST-NEXT:    movb $1, %al
; FAST-NEXT:    andb $1, %al
; FAST-NEXT:    movzbl %al, %eax
; FAST-NEXT:    retq
  %1 = fcmp ule float %x, %x
  ret i1 %1
}

define zeroext i1 @fcmp_ule3(float %x) {
; SDAG-LABEL: fcmp_ule3:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    xorps %xmm1, %xmm1
; SDAG-NEXT:    ucomiss %xmm1, %xmm0
; SDAG-NEXT:    setbe %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_ule3:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    xorps %xmm1, %xmm1
; FAST_NOAVX-NEXT:    ucomiss %xmm1, %xmm0
; FAST_NOAVX-NEXT:    setbe %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_ule3:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; FAST_AVX-NEXT:    vucomiss %xmm1, %xmm0
; FAST_AVX-NEXT:    setbe %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp ule float %x, 0.000000e+00
  ret i1 %1
}

define zeroext i1 @fcmp_une2(float %x) {
; SDAG-LABEL: fcmp_une2:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    ucomiss %xmm0, %xmm0
; SDAG-NEXT:    setp %al
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_une2:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    ucomiss %xmm0, %xmm0
; FAST_NOAVX-NEXT:    setp %al
; FAST_NOAVX-NEXT:    andb $1, %al
; FAST_NOAVX-NEXT:    movzbl %al, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_une2:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vucomiss %xmm0, %xmm0
; FAST_AVX-NEXT:    setp %al
; FAST_AVX-NEXT:    andb $1, %al
; FAST_AVX-NEXT:    movzbl %al, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp une float %x, %x
  ret i1 %1
}

define zeroext i1 @fcmp_une3(float %x) {
; SDAG-LABEL: fcmp_une3:
; SDAG:       ## %bb.0:
; SDAG-NEXT:    xorps %xmm1, %xmm1
; SDAG-NEXT:    cmpneqss %xmm0, %xmm1
; SDAG-NEXT:    movd %xmm1, %eax
; SDAG-NEXT:    andl $1, %eax
; SDAG-NEXT:    ## kill: def $al killed $al killed $eax
; SDAG-NEXT:    retq
;
; FAST_NOAVX-LABEL: fcmp_une3:
; FAST_NOAVX:       ## %bb.0:
; FAST_NOAVX-NEXT:    xorps %xmm1, %xmm1
; FAST_NOAVX-NEXT:    ucomiss %xmm1, %xmm0
; FAST_NOAVX-NEXT:    setne %al
; FAST_NOAVX-NEXT:    setp %cl
; FAST_NOAVX-NEXT:    orb %al, %cl
; FAST_NOAVX-NEXT:    andb $1, %cl
; FAST_NOAVX-NEXT:    movzbl %cl, %eax
; FAST_NOAVX-NEXT:    retq
;
; FAST_AVX-LABEL: fcmp_une3:
; FAST_AVX:       ## %bb.0:
; FAST_AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; FAST_AVX-NEXT:    vucomiss %xmm1, %xmm0
; FAST_AVX-NEXT:    setne %al
; FAST_AVX-NEXT:    setp %cl
; FAST_AVX-NEXT:    orb %al, %cl
; FAST_AVX-NEXT:    andb $1, %cl
; FAST_AVX-NEXT:    movzbl %cl, %eax
; FAST_AVX-NEXT:    retq
  %1 = fcmp une float %x, 0.000000e+00
  ret i1 %1
}