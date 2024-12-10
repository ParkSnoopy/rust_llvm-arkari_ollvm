; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=+sse    | FileCheck %s -check-prefixes=SSE,SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=+sse4.1 | FileCheck %s -check-prefixes=SSE,SSE4
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=+avx  | FileCheck %s -check-prefixes=AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=+avx2 | FileCheck %s -check-prefixes=AVX,AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mcpu=x86-64-v4 | FileCheck %s -check-prefixes=AVX,AVX512

; Verify that each of the following test cases is folded into a single
; instruction which performs a blend operation.

define <2 x i64> @test1(<2 x i64> %a, <2 x i64> %b) {
; SSE2-LABEL: test1:
; SSE2:       # %bb.0:
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test1:
; SSE4:       # %bb.0:
; SSE4-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; SSE4-NEXT:    retq
;
; AVX-LABEL: test1:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; AVX-NEXT:    retq
  %shuf1 = shufflevector <2 x i64> %a, <2 x i64> zeroinitializer, <2 x i32><i32 0, i32 2>
  %shuf2 = shufflevector <2 x i64> %b, <2 x i64> zeroinitializer, <2 x i32><i32 2, i32 1>
  %or = or <2 x i64> %shuf1, %shuf2
  ret <2 x i64> %or
}


define <4 x i32> @test2(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: test2:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test2:
; SSE4:       # %bb.0:
; SSE4-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; SSE4-NEXT:    retq
;
; AVX-LABEL: test2:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> zeroinitializer, <4 x i32><i32 4, i32 4, i32 2, i32 3>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> zeroinitializer, <4 x i32><i32 0, i32 1, i32 4, i32 4>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}


define <2 x i64> @test3(<2 x i64> %a, <2 x i64> %b) {
; SSE2-LABEL: test3:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test3:
; SSE4:       # %bb.0:
; SSE4-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; SSE4-NEXT:    retq
;
; AVX-LABEL: test3:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX-NEXT:    retq
  %shuf1 = shufflevector <2 x i64> %a, <2 x i64> zeroinitializer, <2 x i32><i32 2, i32 1>
  %shuf2 = shufflevector <2 x i64> %b, <2 x i64> zeroinitializer, <2 x i32><i32 0, i32 2>
  %or = or <2 x i64> %shuf1, %shuf2
  ret <2 x i64> %or
}


define <4 x i32> @test4(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: test4:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movss {{.*#+}} xmm1 = xmm0[0],xmm1[1,2,3]
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test4:
; SSE4:       # %bb.0:
; SSE4-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; SSE4-NEXT:    retq
;
; AVX-LABEL: test4:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; AVX-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> zeroinitializer, <4 x i32><i32 0, i32 4, i32 4, i32 4>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> zeroinitializer, <4 x i32><i32 4, i32 1, i32 2, i32 3>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}


define <4 x i32> @test5(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: test5:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movss {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test5:
; SSE4:       # %bb.0:
; SSE4-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; SSE4-NEXT:    retq
;
; AVX-LABEL: test5:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; AVX-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> zeroinitializer, <4 x i32><i32 4, i32 1, i32 2, i32 3>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> zeroinitializer, <4 x i32><i32 0, i32 4, i32 4, i32 4>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}


define <4 x i32> @test6(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: test6:
; SSE2:       # %bb.0:
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test6:
; SSE4:       # %bb.0:
; SSE4-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; SSE4-NEXT:    retq
;
; AVX-LABEL: test6:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; AVX-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> zeroinitializer, <4 x i32><i32 0, i32 1, i32 4, i32 4>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> zeroinitializer, <4 x i32><i32 4, i32 4, i32 2, i32 3>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}


define <4 x i32> @test7(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: test7:
; SSE2:       # %bb.0:
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test7:
; SSE4:       # %bb.0:
; SSE4-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; SSE4-NEXT:    retq
;
; AVX-LABEL: test7:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; AVX-NEXT:    retq
  %and1 = and <4 x i32> %a, <i32 -1, i32 -1, i32 0, i32 0>
  %and2 = and <4 x i32> %b, <i32 0, i32 0, i32 -1, i32 -1>
  %or = or <4 x i32> %and1, %and2
  ret <4 x i32> %or
}


define <2 x i64> @test8(<2 x i64> %a, <2 x i64> %b) {
; SSE2-LABEL: test8:
; SSE2:       # %bb.0:
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test8:
; SSE4:       # %bb.0:
; SSE4-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; SSE4-NEXT:    retq
;
; AVX-LABEL: test8:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; AVX-NEXT:    retq
  %and1 = and <2 x i64> %a, <i64 -1, i64 0>
  %and2 = and <2 x i64> %b, <i64 0, i64 -1>
  %or = or <2 x i64> %and1, %and2
  ret <2 x i64> %or
}


define <4 x i32> @test9(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: test9:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test9:
; SSE4:       # %bb.0:
; SSE4-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; SSE4-NEXT:    retq
;
; AVX-LABEL: test9:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX-NEXT:    retq
  %and1 = and <4 x i32> %a, <i32 0, i32 0, i32 -1, i32 -1>
  %and2 = and <4 x i32> %b, <i32 -1, i32 -1, i32 0, i32 0>
  %or = or <4 x i32> %and1, %and2
  ret <4 x i32> %or
}


define <2 x i64> @test10(<2 x i64> %a, <2 x i64> %b) {
; SSE2-LABEL: test10:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test10:
; SSE4:       # %bb.0:
; SSE4-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; SSE4-NEXT:    retq
;
; AVX-LABEL: test10:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX-NEXT:    retq
  %and1 = and <2 x i64> %a, <i64 0, i64 -1>
  %and2 = and <2 x i64> %b, <i64 -1, i64 0>
  %or = or <2 x i64> %and1, %and2
  ret <2 x i64> %or
}


define <4 x i32> @test11(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: test11:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movss {{.*#+}} xmm1 = xmm0[0],xmm1[1,2,3]
; SSE2-NEXT:    movaps %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test11:
; SSE4:       # %bb.0:
; SSE4-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; SSE4-NEXT:    retq
;
; AVX-LABEL: test11:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; AVX-NEXT:    retq
  %and1 = and <4 x i32> %a, <i32 -1, i32 0, i32 0, i32 0>
  %and2 = and <4 x i32> %b, <i32 0, i32 -1, i32 -1, i32 -1>
  %or = or <4 x i32> %and1, %and2
  ret <4 x i32> %or
}


define <4 x i32> @test12(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: test12:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movss {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test12:
; SSE4:       # %bb.0:
; SSE4-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; SSE4-NEXT:    retq
;
; AVX-LABEL: test12:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; AVX-NEXT:    retq
  %and1 = and <4 x i32> %a, <i32 0, i32 -1, i32 -1, i32 -1>
  %and2 = and <4 x i32> %b, <i32 -1, i32 0, i32 0, i32 0>
  %or = or <4 x i32> %and1, %and2
  ret <4 x i32> %or
}


; Verify that the following test cases are folded into single shuffles.

define <4 x i32> @test13(<4 x i32> %a, <4 x i32> %b) {
; SSE-LABEL: test13:
; SSE:       # %bb.0:
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1],xmm1[2,3]
; SSE-NEXT:    retq
;
; AVX-LABEL: test13:
; AVX:       # %bb.0:
; AVX-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[1,1],xmm1[2,3]
; AVX-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> zeroinitializer, <4 x i32><i32 1, i32 1, i32 4, i32 4>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> zeroinitializer, <4 x i32><i32 4, i32 4, i32 2, i32 3>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}


define <2 x i64> @test14(<2 x i64> %a, <2 x i64> %b) {
; SSE-LABEL: test14:
; SSE:       # %bb.0:
; SSE-NEXT:    movlhps {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; SSE-NEXT:    retq
;
; AVX-LABEL: test14:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovlhps {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX-NEXT:    retq
  %shuf1 = shufflevector <2 x i64> %a, <2 x i64> zeroinitializer, <2 x i32><i32 0, i32 2>
  %shuf2 = shufflevector <2 x i64> %b, <2 x i64> zeroinitializer, <2 x i32><i32 2, i32 0>
  %or = or <2 x i64> %shuf1, %shuf2
  ret <2 x i64> %or
}


define <4 x i32> @test15(<4 x i32> %a, <4 x i32> %b) {
; SSE-LABEL: test15:
; SSE:       # %bb.0:
; SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[2,1],xmm0[2,1]
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test15:
; AVX:       # %bb.0:
; AVX-NEXT:    vshufps {{.*#+}} xmm0 = xmm1[2,1],xmm0[2,1]
; AVX-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> zeroinitializer, <4 x i32><i32 4, i32 4, i32 2, i32 1>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> zeroinitializer, <4 x i32><i32 2, i32 1, i32 4, i32 4>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}


define <2 x i64> @test16(<2 x i64> %a, <2 x i64> %b) {
; SSE-LABEL: test16:
; SSE:       # %bb.0:
; SSE-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test16:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovlhps {{.*#+}} xmm0 = xmm1[0],xmm0[0]
; AVX-NEXT:    retq
  %shuf1 = shufflevector <2 x i64> %a, <2 x i64> zeroinitializer, <2 x i32><i32 2, i32 0>
  %shuf2 = shufflevector <2 x i64> %b, <2 x i64> zeroinitializer, <2 x i32><i32 0, i32 2>
  %or = or <2 x i64> %shuf1, %shuf2
  ret <2 x i64> %or
}


; Verify that the dag-combiner does not fold a OR of two shuffles into a single
; shuffle instruction when the shuffle indexes are not compatible.

define <4 x i32> @test17(<4 x i32> %a, <4 x i32> %b) {
; SSE-LABEL: test17:
; SSE:       # %bb.0:
; SSE-NEXT:    psllq $32, %xmm0
; SSE-NEXT:    movq {{.*#+}} xmm1 = xmm1[0],zero
; SSE-NEXT:    por %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test17:
; AVX:       # %bb.0:
; AVX-NEXT:    vpsllq $32, %xmm0, %xmm0
; AVX-NEXT:    vmovq {{.*#+}} xmm1 = xmm1[0],zero
; AVX-NEXT:    vpor %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> zeroinitializer, <4 x i32><i32 4, i32 0, i32 4, i32 2>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> zeroinitializer, <4 x i32><i32 0, i32 1, i32 4, i32 4>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}


define <4 x i32> @test18(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: test18:
; SSE2:       # %bb.0:
; SSE2-NEXT:    xorps %xmm2, %xmm2
; SSE2-NEXT:    xorps %xmm3, %xmm3
; SSE2-NEXT:    movss {{.*#+}} xmm3 = xmm0[0],xmm3[1,2,3]
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm3[1,0,1,1]
; SSE2-NEXT:    movss {{.*#+}} xmm2 = xmm1[0],xmm2[1,2,3]
; SSE2-NEXT:    orps %xmm0, %xmm2
; SSE2-NEXT:    movaps %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test18:
; SSE4:       # %bb.0:
; SSE4-NEXT:    pxor %xmm2, %xmm2
; SSE4-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3,4,5,6,7]
; SSE4-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,0,1,1]
; SSE4-NEXT:    pblendw {{.*#+}} xmm2 = xmm1[0,1],xmm2[2,3,4,5,6,7]
; SSE4-NEXT:    por %xmm0, %xmm2
; SSE4-NEXT:    movdqa %xmm2, %xmm0
; SSE4-NEXT:    retq
;
; AVX1-LABEL: test18:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0],xmm2[1,2,3]
; AVX1-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[1,0,1,1]
; AVX1-NEXT:    vblendps {{.*#+}} xmm1 = xmm1[0],xmm2[1,2,3]
; AVX1-NEXT:    vorps %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test18:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; AVX2-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0],xmm2[1,2,3]
; AVX2-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[1,0,1,1]
; AVX2-NEXT:    vblendps {{.*#+}} xmm1 = xmm1[0],xmm2[1,2,3]
; AVX2-NEXT:    vorps %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test18:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpshufb {{.*#+}} xmm0 = zero,zero,zero,zero,xmm0[0,1,2,3],zero,zero,zero,zero,zero,zero,zero,zero
; AVX512-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX512-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1],xmm2[2,3,4,5,6,7]
; AVX512-NEXT:    vpor %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> zeroinitializer, <4 x i32><i32 4, i32 0, i32 4, i32 4>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> zeroinitializer, <4 x i32><i32 0, i32 4, i32 4, i32 4>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}


define <4 x i32> @test19(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: test19:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,3,2,3]
; SSE2-NEXT:    pxor %xmm2, %xmm2
; SSE2-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1]
; SSE2-NEXT:    movdqa %xmm1, %xmm0
; SSE2-NEXT:    pslldq {{.*#+}} xmm0 = zero,zero,zero,zero,zero,zero,zero,zero,xmm0[0,1,2,3,4,5,6,7]
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[2,0],xmm1[2,2]
; SSE2-NEXT:    orps %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test19:
; SSE4:       # %bb.0:
; SSE4-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[0,0,2,3]
; SSE4-NEXT:    pxor %xmm3, %xmm3
; SSE4-NEXT:    pblendw {{.*#+}} xmm2 = xmm3[0,1],xmm2[2,3],xmm3[4,5],xmm2[6,7]
; SSE4-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[0,1,2,2]
; SSE4-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm3[2,3],xmm0[4,5,6,7]
; SSE4-NEXT:    por %xmm2, %xmm0
; SSE4-NEXT:    retq
;
; AVX1-LABEL: test19:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[0,0,2,3]
; AVX1-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vblendps {{.*#+}} xmm0 = xmm2[0],xmm0[1],xmm2[2],xmm0[3]
; AVX1-NEXT:    vshufps {{.*#+}} xmm1 = xmm1[0,1,2,2]
; AVX1-NEXT:    vblendps {{.*#+}} xmm1 = xmm1[0],xmm2[1],xmm1[2,3]
; AVX1-NEXT:    vorps %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test19:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[0,0,2,3]
; AVX2-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; AVX2-NEXT:    vblendps {{.*#+}} xmm0 = xmm2[0],xmm0[1],xmm2[2],xmm0[3]
; AVX2-NEXT:    vshufps {{.*#+}} xmm1 = xmm1[0,1,2,2]
; AVX2-NEXT:    vblendps {{.*#+}} xmm1 = xmm1[0],xmm2[1],xmm1[2,3]
; AVX2-NEXT:    vorps %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test19:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpshufb {{.*#+}} xmm0 = zero,zero,zero,zero,xmm0[0,1,2,3],zero,zero,zero,zero,xmm0[12,13,14,15]
; AVX512-NEXT:    vpshufb {{.*#+}} xmm1 = xmm1[0,1,2,3],zero,zero,zero,zero,xmm1[8,9,10,11,8,9,10,11]
; AVX512-NEXT:    vpor %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> zeroinitializer, <4 x i32><i32 4, i32 0, i32 4, i32 3>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> zeroinitializer, <4 x i32><i32 0, i32 4, i32 2, i32 2>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}


define <2 x i64> @test20(<2 x i64> %a, <2 x i64> %b) {
; SSE-LABEL: test20:
; SSE:       # %bb.0:
; SSE-NEXT:    por %xmm1, %xmm0
; SSE-NEXT:    movq {{.*#+}} xmm0 = xmm0[0],zero
; SSE-NEXT:    retq
;
; AVX-LABEL: test20:
; AVX:       # %bb.0:
; AVX-NEXT:    vpor %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovq {{.*#+}} xmm0 = xmm0[0],zero
; AVX-NEXT:    retq
  %shuf1 = shufflevector <2 x i64> %a, <2 x i64> zeroinitializer, <2 x i32><i32 0, i32 2>
  %shuf2 = shufflevector <2 x i64> %b, <2 x i64> zeroinitializer, <2 x i32><i32 0, i32 2>
  %or = or <2 x i64> %shuf1, %shuf2
  ret <2 x i64> %or
}


define <2 x i64> @test21(<2 x i64> %a, <2 x i64> %b) {
; SSE-LABEL: test21:
; SSE:       # %bb.0:
; SSE-NEXT:    por %xmm1, %xmm0
; SSE-NEXT:    pslldq {{.*#+}} xmm0 = zero,zero,zero,zero,zero,zero,zero,zero,xmm0[0,1,2,3,4,5,6,7]
; SSE-NEXT:    retq
;
; AVX1-LABEL: test21:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpor %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpslldq {{.*#+}} xmm0 = zero,zero,zero,zero,zero,zero,zero,zero,xmm0[0,1,2,3,4,5,6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test21:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpor %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpslldq {{.*#+}} xmm0 = zero,zero,zero,zero,zero,zero,zero,zero,xmm0[0,1,2,3,4,5,6,7]
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test21:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vorpd %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vpslldq {{.*#+}} xmm0 = zero,zero,zero,zero,zero,zero,zero,zero,xmm0[0,1,2,3,4,5,6,7]
; AVX512-NEXT:    retq
  %shuf1 = shufflevector <2 x i64> %a, <2 x i64> zeroinitializer, <2 x i32><i32 2, i32 0>
  %shuf2 = shufflevector <2 x i64> %b, <2 x i64> zeroinitializer, <2 x i32><i32 2, i32 0>
  %or = or <2 x i64> %shuf1, %shuf2
  ret <2 x i64> %or
}


; Verify that the dag-combiner keeps the correct domain for float/double vectors
; bitcast to use the mask-or blend combine.

define <2 x double> @test22(<2 x double> %a0, <2 x double> %a1) {
; SSE2-LABEL: test22:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test22:
; SSE4:       # %bb.0:
; SSE4-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; SSE4-NEXT:    retq
;
; AVX-LABEL: test22:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX-NEXT:    retq
  %bc1 = bitcast <2 x double> %a0 to <2 x i64>
  %bc2 = bitcast <2 x double> %a1 to <2 x i64>
  %and1 = and <2 x i64> %bc1, <i64 0, i64 -1>
  %and2 = and <2 x i64> %bc2, <i64 -1, i64 0>
  %or = or <2 x i64> %and1, %and2
  %bc3 = bitcast <2 x i64> %or to <2 x double>
  ret <2 x double> %bc3
}


define <4 x float> @test23(<4 x float> %a0, <4 x float> %a1) {
; SSE2-LABEL: test23:
; SSE2:       # %bb.0:
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,2],xmm1[0,3]
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[2,0,1,3]
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test23:
; SSE4:       # %bb.0:
; SSE4-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0],xmm0[1,2],xmm1[3]
; SSE4-NEXT:    retq
;
; AVX-LABEL: test23:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0],xmm0[1,2],xmm1[3]
; AVX-NEXT:    retq
  %bc1 = bitcast <4 x float> %a0 to <4 x i32>
  %bc2 = bitcast <4 x float> %a1 to <4 x i32>
  %and1 = and <4 x i32> %bc1, <i32 0, i32 -1, i32 -1, i32 0>
  %and2 = and <4 x i32> %bc2, <i32 -1, i32 0, i32 0, i32 -1>
  %or = or <4 x i32> %and1, %and2
  %bc3 = bitcast <4 x i32> %or to <4 x float>
  ret <4 x float> %bc3
}


define <4 x float> @test24(<4 x float> %a0, <4 x float> %a1) {
; SSE2-LABEL: test24:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test24:
; SSE4:       # %bb.0:
; SSE4-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; SSE4-NEXT:    retq
;
; AVX-LABEL: test24:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX-NEXT:    retq
  %bc1 = bitcast <4 x float> %a0 to <2 x i64>
  %bc2 = bitcast <4 x float> %a1 to <2 x i64>
  %and1 = and <2 x i64> %bc1, <i64 0, i64 -1>
  %and2 = and <2 x i64> %bc2, <i64 -1, i64 0>
  %or = or <2 x i64> %and1, %and2
  %bc3 = bitcast <2 x i64> %or to <4 x float>
  ret <4 x float> %bc3
}


define <4 x float> @test25(<4 x float> %a0) {
; SSE2-LABEL: test25:
; SSE2:       # %bb.0:
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,2],mem[0,3]
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[2,0,1,3]
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test25:
; SSE4:       # %bb.0:
; SSE4-NEXT:    blendps {{.*#+}} xmm0 = mem[0],xmm0[1,2],mem[3]
; SSE4-NEXT:    retq
;
; AVX1-LABEL: test25:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vblendps {{.*#+}} xmm0 = mem[0],xmm0[1,2],mem[3]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test25:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vbroadcastss {{.*#+}} xmm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; AVX2-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0],xmm0[1,2],xmm1[3]
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test25:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vbroadcastss {{.*#+}} xmm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; AVX512-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0],xmm0[1,2],xmm1[3]
; AVX512-NEXT:    retq
  %bc1 = bitcast <4 x float> %a0 to <4 x i32>
  %bc2 = bitcast <4 x float> <float 1.0, float 1.0, float 1.0, float 1.0> to <4 x i32>
  %and1 = and <4 x i32> %bc1, <i32 0, i32 -1, i32 -1, i32 0>
  %and2 = and <4 x i32> %bc2, <i32 -1, i32 0, i32 0, i32 -1>
  %or = or <4 x i32> %and1, %and2
  %bc3 = bitcast <4 x i32> %or to <4 x float>
  ret <4 x float> %bc3
}


; Verify that the DAGCombiner doesn't crash in the attempt to check if a shuffle
; with illegal type has a legal mask. Method 'isShuffleMaskLegal' only knows how to
; handle legal vector value types.
define <4 x i8> @test_crash(<4 x i8> %a, <4 x i8> %b) {
; SSE2-LABEL: test_crash:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movaps {{.*#+}} xmm2 = [65535,0,65535,65535,65535,65535,65535,65535]
; SSE2-NEXT:    andps %xmm2, %xmm1
; SSE2-NEXT:    andnps %xmm0, %xmm2
; SSE2-NEXT:    orps %xmm1, %xmm2
; SSE2-NEXT:    movaps %xmm2, %xmm0
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test_crash:
; SSE4:       # %bb.0:
; SSE4-NEXT:    pblendw {{.*#+}} xmm0 = xmm1[0],xmm0[1],xmm1[2,3,4,5,6,7]
; SSE4-NEXT:    retq
;
; AVX-LABEL: test_crash:
; AVX:       # %bb.0:
; AVX-NEXT:    vpblendw {{.*#+}} xmm0 = xmm1[0],xmm0[1],xmm1[2,3,4,5,6,7]
; AVX-NEXT:    retq
  %shuf1 = shufflevector <4 x i8> %a, <4 x i8> zeroinitializer, <4 x i32><i32 4, i32 4, i32 2, i32 3>
  %shuf2 = shufflevector <4 x i8> %b, <4 x i8> zeroinitializer, <4 x i32><i32 0, i32 1, i32 4, i32 4>
  %or = or <4 x i8> %shuf1, %shuf2
  ret <4 x i8> %or
}

; Verify that we can fold regardless of which operand is the zeroinitializer

define <4 x i32> @test2b(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: test2b:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test2b:
; SSE4:       # %bb.0:
; SSE4-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; SSE4-NEXT:    retq
;
; AVX-LABEL: test2b:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> zeroinitializer, <4 x i32> %a, <4 x i32><i32 0, i32 0, i32 6, i32 7>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> zeroinitializer, <4 x i32><i32 0, i32 1, i32 4, i32 4>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}

define <4 x i32> @test2c(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: test2c:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test2c:
; SSE4:       # %bb.0:
; SSE4-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; SSE4-NEXT:    retq
;
; AVX-LABEL: test2c:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> zeroinitializer, <4 x i32> %a, <4 x i32><i32 0, i32 0, i32 6, i32 7>
  %shuf2 = shufflevector <4 x i32> zeroinitializer, <4 x i32> %b, <4 x i32><i32 4, i32 5, i32 0, i32 0>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}


define <4 x i32> @test2d(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: test2d:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test2d:
; SSE4:       # %bb.0:
; SSE4-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; SSE4-NEXT:    retq
;
; AVX-LABEL: test2d:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> zeroinitializer, <4 x i32><i32 4, i32 4, i32 2, i32 3>
  %shuf2 = shufflevector <4 x i32> zeroinitializer, <4 x i32> %b, <4 x i32><i32 4, i32 5, i32 0, i32 0>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}

; Make sure we can have an undef where an index pointing to the zero vector should be

define <4 x i32> @test2e(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: test2e:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test2e:
; SSE4:       # %bb.0:
; SSE4-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; SSE4-NEXT:    retq
;
; AVX-LABEL: test2e:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>, <4 x i32><i32 undef, i32 4, i32 2, i32 3>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>, <4 x i32><i32 0, i32 1, i32 4, i32 4>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}

define <4 x i32> @test2f(<4 x i32> %a, <4 x i32> %b) {
; SSE2-LABEL: test2f:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = xmm1[0],xmm0[1]
; SSE2-NEXT:    retq
;
; SSE4-LABEL: test2f:
; SSE4:       # %bb.0:
; SSE4-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; SSE4-NEXT:    retq
;
; AVX-LABEL: test2f:
; AVX:       # %bb.0:
; AVX-NEXT:    vblendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; AVX-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>, <4 x i32><i32 4, i32 4, i32 2, i32 3>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>, <4 x i32><i32 undef, i32 1, i32 4, i32 4>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}

; (or (and X, c1), c2) -> (and (or X, c2), c1|c2) iff (c1 & c2) != 0

define <2 x i64> @or_and_v2i64(<2 x i64> %a0) {
; SSE-LABEL: or_and_v2i64:
; SSE:       # %bb.0:
; SSE-NEXT:    orps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: or_and_v2i64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: or_and_v2i64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX2-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: or_and_v2i64:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpbroadcastq {{.*#+}} xmm1 = [7,7]
; AVX512-NEXT:    vpternlogq $200, {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to2}, %xmm1, %xmm0
; AVX512-NEXT:    retq
  %1 = and <2 x i64> %a0, <i64 7, i64 7>
  %2 = or <2 x i64> %1, <i64 3, i64 3>
  ret <2 x i64> %2
}

define <4 x i32> @or_and_v4i32(<4 x i32> %a0) {
; SSE-LABEL: or_and_v4i32:
; SSE:       # %bb.0:
; SSE-NEXT:    orps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: or_and_v4i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: or_and_v4i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX2-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: or_and_v4i32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpmovsxbd {{.*#+}} xmm1 = [3,3,15,7]
; AVX512-NEXT:    vpternlogd $200, {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm0
; AVX512-NEXT:    retq
  %1 = and <4 x i32> %a0, <i32 1, i32 3, i32 5, i32 7>
  %2 = or <4 x i32> %1, <i32 3, i32 2, i32 15, i32 2>
  ret <4 x i32> %2
}

; If all masked bits are going to be set, that's a constant fold.

define <4 x i32> @or_and_v4i32_fold(<4 x i32> %a0) {
; SSE-LABEL: or_and_v4i32_fold:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps {{.*#+}} xmm0 = [3,3,3,3]
; SSE-NEXT:    retq
;
; AVX-LABEL: or_and_v4i32_fold:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastss {{.*#+}} xmm0 = [3,3,3,3]
; AVX-NEXT:    retq
  %1 = and <4 x i32> %a0, <i32 1, i32 1, i32 1, i32 1>
  %2 = or <4 x i32> %1, <i32 3, i32 3, i32 3, i32 3>
  ret <4 x i32> %2
}