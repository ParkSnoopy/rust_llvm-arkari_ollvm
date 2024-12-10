; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mattr=+sve -force-streaming-compatible-sve  < %s | FileCheck %s
; RUN: llc -mattr=+sme -force-streaming-compatible-sve  < %s | FileCheck %s

target triple = "aarch64-unknown-linux-gnu"

;
; SMAX
;

define <8 x i8> @smax_v8i8(<8 x i8> %op1, <8 x i8> %op2) {
; CHECK-LABEL: smax_v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl8
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    smax z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %res = call <8 x i8> @llvm.smax.v8i8(<8 x i8> %op1, <8 x i8> %op2)
  ret <8 x i8> %res
}

define <16 x i8> @smax_v16i8(<16 x i8> %op1, <16 x i8> %op2) {
; CHECK-LABEL: smax_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl16
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    smax z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %res = call <16 x i8> @llvm.smax.v16i8(<16 x i8> %op1, <16 x i8> %op2)
  ret <16 x i8> %res
}

define void @smax_v32i8(ptr %a, ptr %b) {
; CHECK-LABEL: smax_v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl16
; CHECK-NEXT:    ldp q0, q3, [x1]
; CHECK-NEXT:    ldp q1, q2, [x0]
; CHECK-NEXT:    smax z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    movprfx z1, z2
; CHECK-NEXT:    smax z1.b, p0/m, z1.b, z3.b
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i8>, ptr %a
  %op2 = load <32 x i8>, ptr %b
  %res = call <32 x i8> @llvm.smax.v32i8(<32 x i8> %op1, <32 x i8> %op2)
  store <32 x i8> %res, ptr %a
  ret void
}

define <4 x i16> @smax_v4i16(<4 x i16> %op1, <4 x i16> %op2) {
; CHECK-LABEL: smax_v4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl4
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    smax z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %res = call <4 x i16> @llvm.smax.v4i16(<4 x i16> %op1, <4 x i16> %op2)
  ret <4 x i16> %res
}

define <8 x i16> @smax_v8i16(<8 x i16> %op1, <8 x i16> %op2) {
; CHECK-LABEL: smax_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl8
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    smax z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %res = call <8 x i16> @llvm.smax.v8i16(<8 x i16> %op1, <8 x i16> %op2)
  ret <8 x i16> %res
}

define void @smax_v16i16(ptr %a, ptr %b) {
; CHECK-LABEL: smax_v16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl8
; CHECK-NEXT:    ldp q0, q3, [x1]
; CHECK-NEXT:    ldp q1, q2, [x0]
; CHECK-NEXT:    smax z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    movprfx z1, z2
; CHECK-NEXT:    smax z1.h, p0/m, z1.h, z3.h
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i16>, ptr %a
  %op2 = load <16 x i16>, ptr %b
  %res = call <16 x i16> @llvm.smax.v16i16(<16 x i16> %op1, <16 x i16> %op2)
  store <16 x i16> %res, ptr %a
  ret void
}

define <2 x i32> @smax_v2i32(<2 x i32> %op1, <2 x i32> %op2) {
; CHECK-LABEL: smax_v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl2
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    smax z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %res = call <2 x i32> @llvm.smax.v2i32(<2 x i32> %op1, <2 x i32> %op2)
  ret <2 x i32> %res
}

define <4 x i32> @smax_v4i32(<4 x i32> %op1, <4 x i32> %op2) {
; CHECK-LABEL: smax_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl4
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    smax z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %res = call <4 x i32> @llvm.smax.v4i32(<4 x i32> %op1, <4 x i32> %op2)
  ret <4 x i32> %res
}

define void @smax_v8i32(ptr %a, ptr %b) {
; CHECK-LABEL: smax_v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl4
; CHECK-NEXT:    ldp q0, q3, [x1]
; CHECK-NEXT:    ldp q1, q2, [x0]
; CHECK-NEXT:    smax z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    movprfx z1, z2
; CHECK-NEXT:    smax z1.s, p0/m, z1.s, z3.s
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load <8 x i32>, ptr %a
  %op2 = load <8 x i32>, ptr %b
  %res = call <8 x i32> @llvm.smax.v8i32(<8 x i32> %op1, <8 x i32> %op2)
  store <8 x i32> %res, ptr %a
  ret void
}

; Vector i64 max are not legal for NEON so use SVE when available.
define <1 x i64> @smax_v1i64(<1 x i64> %op1, <1 x i64> %op2) {
; CHECK-LABEL: smax_v1i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl1
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    smax z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %res = call <1 x i64> @llvm.smax.v1i64(<1 x i64> %op1, <1 x i64> %op2)
  ret <1 x i64> %res
}

; Vector i64 max are not legal for NEON so use SVE when available.
define <2 x i64> @smax_v2i64(<2 x i64> %op1, <2 x i64> %op2) {
; CHECK-LABEL: smax_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl2
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    smax z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %res = call <2 x i64> @llvm.smax.v2i64(<2 x i64> %op1, <2 x i64> %op2)
  ret <2 x i64> %res
}

define void @smax_v4i64(ptr %a, ptr %b) {
; CHECK-LABEL: smax_v4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl2
; CHECK-NEXT:    ldp q0, q3, [x1]
; CHECK-NEXT:    ldp q1, q2, [x0]
; CHECK-NEXT:    smax z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    movprfx z1, z2
; CHECK-NEXT:    smax z1.d, p0/m, z1.d, z3.d
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load <4 x i64>, ptr %a
  %op2 = load <4 x i64>, ptr %b
  %res = call <4 x i64> @llvm.smax.v4i64(<4 x i64> %op1, <4 x i64> %op2)
  store <4 x i64> %res, ptr %a
  ret void
}

;
; SMIN
;

define <8 x i8> @smin_v8i8(<8 x i8> %op1, <8 x i8> %op2) {
; CHECK-LABEL: smin_v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl8
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    smin z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %res = call <8 x i8> @llvm.smin.v8i8(<8 x i8> %op1, <8 x i8> %op2)
  ret <8 x i8> %res
}

define <16 x i8> @smin_v16i8(<16 x i8> %op1, <16 x i8> %op2) {
; CHECK-LABEL: smin_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl16
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    smin z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %res = call <16 x i8> @llvm.smin.v16i8(<16 x i8> %op1, <16 x i8> %op2)
  ret <16 x i8> %res
}

define void @smin_v32i8(ptr %a, ptr %b) {
; CHECK-LABEL: smin_v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl16
; CHECK-NEXT:    ldp q0, q3, [x1]
; CHECK-NEXT:    ldp q1, q2, [x0]
; CHECK-NEXT:    smin z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    movprfx z1, z2
; CHECK-NEXT:    smin z1.b, p0/m, z1.b, z3.b
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i8>, ptr %a
  %op2 = load <32 x i8>, ptr %b
  %res = call <32 x i8> @llvm.smin.v32i8(<32 x i8> %op1, <32 x i8> %op2)
  store <32 x i8> %res, ptr %a
  ret void
}

define <4 x i16> @smin_v4i16(<4 x i16> %op1, <4 x i16> %op2) {
; CHECK-LABEL: smin_v4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl4
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    smin z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %res = call <4 x i16> @llvm.smin.v4i16(<4 x i16> %op1, <4 x i16> %op2)
  ret <4 x i16> %res
}

define <8 x i16> @smin_v8i16(<8 x i16> %op1, <8 x i16> %op2) {
; CHECK-LABEL: smin_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl8
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    smin z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %res = call <8 x i16> @llvm.smin.v8i16(<8 x i16> %op1, <8 x i16> %op2)
  ret <8 x i16> %res
}

define void @smin_v16i16(ptr %a, ptr %b) {
; CHECK-LABEL: smin_v16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl8
; CHECK-NEXT:    ldp q0, q3, [x1]
; CHECK-NEXT:    ldp q1, q2, [x0]
; CHECK-NEXT:    smin z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    movprfx z1, z2
; CHECK-NEXT:    smin z1.h, p0/m, z1.h, z3.h
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i16>, ptr %a
  %op2 = load <16 x i16>, ptr %b
  %res = call <16 x i16> @llvm.smin.v16i16(<16 x i16> %op1, <16 x i16> %op2)
  store <16 x i16> %res, ptr %a
  ret void
}

define <2 x i32> @smin_v2i32(<2 x i32> %op1, <2 x i32> %op2) {
; CHECK-LABEL: smin_v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl2
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    smin z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %res = call <2 x i32> @llvm.smin.v2i32(<2 x i32> %op1, <2 x i32> %op2)
  ret <2 x i32> %res
}

define <4 x i32> @smin_v4i32(<4 x i32> %op1, <4 x i32> %op2) {
; CHECK-LABEL: smin_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl4
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    smin z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %res = call <4 x i32> @llvm.smin.v4i32(<4 x i32> %op1, <4 x i32> %op2)
  ret <4 x i32> %res
}

define void @smin_v8i32(ptr %a, ptr %b) {
; CHECK-LABEL: smin_v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl4
; CHECK-NEXT:    ldp q0, q3, [x1]
; CHECK-NEXT:    ldp q1, q2, [x0]
; CHECK-NEXT:    smin z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    movprfx z1, z2
; CHECK-NEXT:    smin z1.s, p0/m, z1.s, z3.s
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load <8 x i32>, ptr %a
  %op2 = load <8 x i32>, ptr %b
  %res = call <8 x i32> @llvm.smin.v8i32(<8 x i32> %op1, <8 x i32> %op2)
  store <8 x i32> %res, ptr %a
  ret void
}

; Vector i64 min are not legal for NEON so use SVE when available.
define <1 x i64> @smin_v1i64(<1 x i64> %op1, <1 x i64> %op2) {
; CHECK-LABEL: smin_v1i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl1
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    smin z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %res = call <1 x i64> @llvm.smin.v1i64(<1 x i64> %op1, <1 x i64> %op2)
  ret <1 x i64> %res
}

; Vector i64 min are not legal for NEON so use SVE when available.
define <2 x i64> @smin_v2i64(<2 x i64> %op1, <2 x i64> %op2) {
; CHECK-LABEL: smin_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl2
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    smin z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %res = call <2 x i64> @llvm.smin.v2i64(<2 x i64> %op1, <2 x i64> %op2)
  ret <2 x i64> %res
}

define void @smin_v4i64(ptr %a, ptr %b) {
; CHECK-LABEL: smin_v4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl2
; CHECK-NEXT:    ldp q0, q3, [x1]
; CHECK-NEXT:    ldp q1, q2, [x0]
; CHECK-NEXT:    smin z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    movprfx z1, z2
; CHECK-NEXT:    smin z1.d, p0/m, z1.d, z3.d
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load <4 x i64>, ptr %a
  %op2 = load <4 x i64>, ptr %b
  %res = call <4 x i64> @llvm.smin.v4i64(<4 x i64> %op1, <4 x i64> %op2)
  store <4 x i64> %res, ptr %a
  ret void
}

;
; UMAX
;

define <8 x i8> @umax_v8i8(<8 x i8> %op1, <8 x i8> %op2) {
; CHECK-LABEL: umax_v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl8
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    umax z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %res = call <8 x i8> @llvm.umax.v8i8(<8 x i8> %op1, <8 x i8> %op2)
  ret <8 x i8> %res
}

define <16 x i8> @umax_v16i8(<16 x i8> %op1, <16 x i8> %op2) {
; CHECK-LABEL: umax_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl16
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    umax z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %res = call <16 x i8> @llvm.umax.v16i8(<16 x i8> %op1, <16 x i8> %op2)
  ret <16 x i8> %res
}

define void @umax_v32i8(ptr %a, ptr %b) {
; CHECK-LABEL: umax_v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl16
; CHECK-NEXT:    ldp q0, q3, [x1]
; CHECK-NEXT:    ldp q1, q2, [x0]
; CHECK-NEXT:    umax z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    movprfx z1, z2
; CHECK-NEXT:    umax z1.b, p0/m, z1.b, z3.b
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i8>, ptr %a
  %op2 = load <32 x i8>, ptr %b
  %res = call <32 x i8> @llvm.umax.v32i8(<32 x i8> %op1, <32 x i8> %op2)
  store <32 x i8> %res, ptr %a
  ret void
}

define <4 x i16> @umax_v4i16(<4 x i16> %op1, <4 x i16> %op2) {
; CHECK-LABEL: umax_v4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl4
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    umax z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %res = call <4 x i16> @llvm.umax.v4i16(<4 x i16> %op1, <4 x i16> %op2)
  ret <4 x i16> %res
}

define <8 x i16> @umax_v8i16(<8 x i16> %op1, <8 x i16> %op2) {
; CHECK-LABEL: umax_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl8
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    umax z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %res = call <8 x i16> @llvm.umax.v8i16(<8 x i16> %op1, <8 x i16> %op2)
  ret <8 x i16> %res
}

define void @umax_v16i16(ptr %a, ptr %b) {
; CHECK-LABEL: umax_v16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl8
; CHECK-NEXT:    ldp q0, q3, [x1]
; CHECK-NEXT:    ldp q1, q2, [x0]
; CHECK-NEXT:    umax z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    movprfx z1, z2
; CHECK-NEXT:    umax z1.h, p0/m, z1.h, z3.h
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i16>, ptr %a
  %op2 = load <16 x i16>, ptr %b
  %res = call <16 x i16> @llvm.umax.v16i16(<16 x i16> %op1, <16 x i16> %op2)
  store <16 x i16> %res, ptr %a
  ret void
}

define <2 x i32> @umax_v2i32(<2 x i32> %op1, <2 x i32> %op2) {
; CHECK-LABEL: umax_v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl2
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    umax z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %res = call <2 x i32> @llvm.umax.v2i32(<2 x i32> %op1, <2 x i32> %op2)
  ret <2 x i32> %res
}

define <4 x i32> @umax_v4i32(<4 x i32> %op1, <4 x i32> %op2) {
; CHECK-LABEL: umax_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl4
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    umax z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %res = call <4 x i32> @llvm.umax.v4i32(<4 x i32> %op1, <4 x i32> %op2)
  ret <4 x i32> %res
}

define void @umax_v8i32(ptr %a, ptr %b) {
; CHECK-LABEL: umax_v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl4
; CHECK-NEXT:    ldp q0, q3, [x1]
; CHECK-NEXT:    ldp q1, q2, [x0]
; CHECK-NEXT:    umax z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    movprfx z1, z2
; CHECK-NEXT:    umax z1.s, p0/m, z1.s, z3.s
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load <8 x i32>, ptr %a
  %op2 = load <8 x i32>, ptr %b
  %res = call <8 x i32> @llvm.umax.v8i32(<8 x i32> %op1, <8 x i32> %op2)
  store <8 x i32> %res, ptr %a
  ret void
}

; Vector i64 max are not legal for NEON so use SVE when available.
define <1 x i64> @umax_v1i64(<1 x i64> %op1, <1 x i64> %op2) {
; CHECK-LABEL: umax_v1i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl1
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    umax z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %res = call <1 x i64> @llvm.umax.v1i64(<1 x i64> %op1, <1 x i64> %op2)
  ret <1 x i64> %res
}

; Vector i64 max are not legal for NEON so use SVE when available.
define <2 x i64> @umax_v2i64(<2 x i64> %op1, <2 x i64> %op2) {
; CHECK-LABEL: umax_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl2
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    umax z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %res = call <2 x i64> @llvm.umax.v2i64(<2 x i64> %op1, <2 x i64> %op2)
  ret <2 x i64> %res
}

define void @umax_v4i64(ptr %a, ptr %b) {
; CHECK-LABEL: umax_v4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl2
; CHECK-NEXT:    ldp q0, q3, [x1]
; CHECK-NEXT:    ldp q1, q2, [x0]
; CHECK-NEXT:    umax z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    movprfx z1, z2
; CHECK-NEXT:    umax z1.d, p0/m, z1.d, z3.d
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load <4 x i64>, ptr %a
  %op2 = load <4 x i64>, ptr %b
  %res = call <4 x i64> @llvm.umax.v4i64(<4 x i64> %op1, <4 x i64> %op2)
  store <4 x i64> %res, ptr %a
  ret void
}

;
; UMIN
;

define <8 x i8> @umin_v8i8(<8 x i8> %op1, <8 x i8> %op2) {
; CHECK-LABEL: umin_v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl8
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    umin z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %res = call <8 x i8> @llvm.umin.v8i8(<8 x i8> %op1, <8 x i8> %op2)
  ret <8 x i8> %res
}

define <16 x i8> @umin_v16i8(<16 x i8> %op1, <16 x i8> %op2) {
; CHECK-LABEL: umin_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl16
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    umin z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %res = call <16 x i8> @llvm.umin.v16i8(<16 x i8> %op1, <16 x i8> %op2)
  ret <16 x i8> %res
}

define void @umin_v32i8(ptr %a, ptr %b) {
; CHECK-LABEL: umin_v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.b, vl16
; CHECK-NEXT:    ldp q0, q3, [x1]
; CHECK-NEXT:    ldp q1, q2, [x0]
; CHECK-NEXT:    umin z0.b, p0/m, z0.b, z1.b
; CHECK-NEXT:    movprfx z1, z2
; CHECK-NEXT:    umin z1.b, p0/m, z1.b, z3.b
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load <32 x i8>, ptr %a
  %op2 = load <32 x i8>, ptr %b
  %res = call <32 x i8> @llvm.umin.v32i8(<32 x i8> %op1, <32 x i8> %op2)
  store <32 x i8> %res, ptr %a
  ret void
}

define <4 x i16> @umin_v4i16(<4 x i16> %op1, <4 x i16> %op2) {
; CHECK-LABEL: umin_v4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl4
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    umin z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %res = call <4 x i16> @llvm.umin.v4i16(<4 x i16> %op1, <4 x i16> %op2)
  ret <4 x i16> %res
}

define <8 x i16> @umin_v8i16(<8 x i16> %op1, <8 x i16> %op2) {
; CHECK-LABEL: umin_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl8
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    umin z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %res = call <8 x i16> @llvm.umin.v8i16(<8 x i16> %op1, <8 x i16> %op2)
  ret <8 x i16> %res
}

define void @umin_v16i16(ptr %a, ptr %b) {
; CHECK-LABEL: umin_v16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.h, vl8
; CHECK-NEXT:    ldp q0, q3, [x1]
; CHECK-NEXT:    ldp q1, q2, [x0]
; CHECK-NEXT:    umin z0.h, p0/m, z0.h, z1.h
; CHECK-NEXT:    movprfx z1, z2
; CHECK-NEXT:    umin z1.h, p0/m, z1.h, z3.h
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load <16 x i16>, ptr %a
  %op2 = load <16 x i16>, ptr %b
  %res = call <16 x i16> @llvm.umin.v16i16(<16 x i16> %op1, <16 x i16> %op2)
  store <16 x i16> %res, ptr %a
  ret void
}

define <2 x i32> @umin_v2i32(<2 x i32> %op1, <2 x i32> %op2) {
; CHECK-LABEL: umin_v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl2
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    umin z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %res = call <2 x i32> @llvm.umin.v2i32(<2 x i32> %op1, <2 x i32> %op2)
  ret <2 x i32> %res
}

define <4 x i32> @umin_v4i32(<4 x i32> %op1, <4 x i32> %op2) {
; CHECK-LABEL: umin_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl4
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    umin z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %res = call <4 x i32> @llvm.umin.v4i32(<4 x i32> %op1, <4 x i32> %op2)
  ret <4 x i32> %res
}

define void @umin_v8i32(ptr %a, ptr %b) {
; CHECK-LABEL: umin_v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.s, vl4
; CHECK-NEXT:    ldp q0, q3, [x1]
; CHECK-NEXT:    ldp q1, q2, [x0]
; CHECK-NEXT:    umin z0.s, p0/m, z0.s, z1.s
; CHECK-NEXT:    movprfx z1, z2
; CHECK-NEXT:    umin z1.s, p0/m, z1.s, z3.s
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load <8 x i32>, ptr %a
  %op2 = load <8 x i32>, ptr %b
  %res = call <8 x i32> @llvm.umin.v8i32(<8 x i32> %op1, <8 x i32> %op2)
  store <8 x i32> %res, ptr %a
  ret void
}

; Vector i64 min are not legal for NEON so use SVE when available.
define <1 x i64> @umin_v1i64(<1 x i64> %op1, <1 x i64> %op2) {
; CHECK-LABEL: umin_v1i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl1
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    umin z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %res = call <1 x i64> @llvm.umin.v1i64(<1 x i64> %op1, <1 x i64> %op2)
  ret <1 x i64> %res
}

; Vector i64 min are not legal for NEON so use SVE when available.
define <2 x i64> @umin_v2i64(<2 x i64> %op1, <2 x i64> %op2) {
; CHECK-LABEL: umin_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl2
; CHECK-NEXT:    // kill: def $q0 killed $q0 def $z0
; CHECK-NEXT:    // kill: def $q1 killed $q1 def $z1
; CHECK-NEXT:    umin z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %res = call <2 x i64> @llvm.umin.v2i64(<2 x i64> %op1, <2 x i64> %op2)
  ret <2 x i64> %res
}

define void @umin_v4i64(ptr %a, ptr %b) {
; CHECK-LABEL: umin_v4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p0.d, vl2
; CHECK-NEXT:    ldp q0, q3, [x1]
; CHECK-NEXT:    ldp q1, q2, [x0]
; CHECK-NEXT:    umin z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT:    movprfx z1, z2
; CHECK-NEXT:    umin z1.d, p0/m, z1.d, z3.d
; CHECK-NEXT:    stp q0, q1, [x0]
; CHECK-NEXT:    ret
  %op1 = load <4 x i64>, ptr %a
  %op2 = load <4 x i64>, ptr %b
  %res = call <4 x i64> @llvm.umin.v4i64(<4 x i64> %op1, <4 x i64> %op2)
  store <4 x i64> %res, ptr %a
  ret void
}

declare <8 x i8> @llvm.smin.v8i8(<8 x i8>, <8 x i8>)
declare <16 x i8> @llvm.smin.v16i8(<16 x i8>, <16 x i8>)
declare <32 x i8> @llvm.smin.v32i8(<32 x i8>, <32 x i8>)
declare <4 x i16> @llvm.smin.v4i16(<4 x i16>, <4 x i16>)
declare <8 x i16> @llvm.smin.v8i16(<8 x i16>, <8 x i16>)
declare <16 x i16> @llvm.smin.v16i16(<16 x i16>, <16 x i16>)
declare <2 x i32> @llvm.smin.v2i32(<2 x i32>, <2 x i32>)
declare <4 x i32> @llvm.smin.v4i32(<4 x i32>, <4 x i32>)
declare <8 x i32> @llvm.smin.v8i32(<8 x i32>, <8 x i32>)
declare <1 x i64> @llvm.smin.v1i64(<1 x i64>, <1 x i64>)
declare <2 x i64> @llvm.smin.v2i64(<2 x i64>, <2 x i64>)
declare <4 x i64> @llvm.smin.v4i64(<4 x i64>, <4 x i64>)

declare <8 x i8> @llvm.smax.v8i8(<8 x i8>, <8 x i8>)
declare <16 x i8> @llvm.smax.v16i8(<16 x i8>, <16 x i8>)
declare <32 x i8> @llvm.smax.v32i8(<32 x i8>, <32 x i8>)
declare <4 x i16> @llvm.smax.v4i16(<4 x i16>, <4 x i16>)
declare <8 x i16> @llvm.smax.v8i16(<8 x i16>, <8 x i16>)
declare <16 x i16> @llvm.smax.v16i16(<16 x i16>, <16 x i16>)
declare <2 x i32> @llvm.smax.v2i32(<2 x i32>, <2 x i32>)
declare <4 x i32> @llvm.smax.v4i32(<4 x i32>, <4 x i32>)
declare <8 x i32> @llvm.smax.v8i32(<8 x i32>, <8 x i32>)
declare <1 x i64> @llvm.smax.v1i64(<1 x i64>, <1 x i64>)
declare <2 x i64> @llvm.smax.v2i64(<2 x i64>, <2 x i64>)
declare <4 x i64> @llvm.smax.v4i64(<4 x i64>, <4 x i64>)

declare <8 x i8> @llvm.umin.v8i8(<8 x i8>, <8 x i8>)
declare <16 x i8> @llvm.umin.v16i8(<16 x i8>, <16 x i8>)
declare <32 x i8> @llvm.umin.v32i8(<32 x i8>, <32 x i8>)
declare <4 x i16> @llvm.umin.v4i16(<4 x i16>, <4 x i16>)
declare <8 x i16> @llvm.umin.v8i16(<8 x i16>, <8 x i16>)
declare <16 x i16> @llvm.umin.v16i16(<16 x i16>, <16 x i16>)
declare <2 x i32> @llvm.umin.v2i32(<2 x i32>, <2 x i32>)
declare <4 x i32> @llvm.umin.v4i32(<4 x i32>, <4 x i32>)
declare <8 x i32> @llvm.umin.v8i32(<8 x i32>, <8 x i32>)
declare <1 x i64> @llvm.umin.v1i64(<1 x i64>, <1 x i64>)
declare <2 x i64> @llvm.umin.v2i64(<2 x i64>, <2 x i64>)
declare <4 x i64> @llvm.umin.v4i64(<4 x i64>, <4 x i64>)

declare <8 x i8> @llvm.umax.v8i8(<8 x i8>, <8 x i8>)
declare <16 x i8> @llvm.umax.v16i8(<16 x i8>, <16 x i8>)
declare <32 x i8> @llvm.umax.v32i8(<32 x i8>, <32 x i8>)
declare <4 x i16> @llvm.umax.v4i16(<4 x i16>, <4 x i16>)
declare <8 x i16> @llvm.umax.v8i16(<8 x i16>, <8 x i16>)
declare <16 x i16> @llvm.umax.v16i16(<16 x i16>, <16 x i16>)
declare <2 x i32> @llvm.umax.v2i32(<2 x i32>, <2 x i32>)
declare <4 x i32> @llvm.umax.v4i32(<4 x i32>, <4 x i32>)
declare <8 x i32> @llvm.umax.v8i32(<8 x i32>, <8 x i32>)
declare <1 x i64> @llvm.umax.v1i64(<1 x i64>, <1 x i64>)
declare <2 x i64> @llvm.umax.v2i64(<2 x i64>, <2 x i64>)
declare <4 x i64> @llvm.umax.v4i64(<4 x i64>, <4 x i64>)