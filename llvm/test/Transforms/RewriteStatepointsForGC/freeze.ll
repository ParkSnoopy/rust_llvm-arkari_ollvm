; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=rewrite-statepoints-for-gc < %s | FileCheck %s

declare void @hoge()

define ptr addrspace(1) @testVector(<3 x ptr addrspace(1)> %arg) gc "statepoint-example" {
; CHECK-LABEL: @testVector(
; CHECK-NEXT:    [[A:%.*]] = freeze <3 x ptr addrspace(1)> [[ARG:%.*]]
; CHECK-NEXT:    [[BASE_EE:%.*]] = extractelement <3 x ptr addrspace(1)> [[ARG]], i64 2, !is_base_value !0
; CHECK-NEXT:    [[B:%.*]] = extractelement <3 x ptr addrspace(1)> [[A]], i64 2
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, ptr, i32, i32, ...) @llvm.experimental.gc.statepoint.p0(i64 2882400000, i32 0, ptr elementtype(void ()) @hoge, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(ptr addrspace(1) [[B]], ptr addrspace(1) [[BASE_EE]]) ]
; CHECK-NEXT:    [[B_RELOCATED:%.*]] = call coldcc ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token [[STATEPOINT_TOKEN]], i32 1, i32 0)
; CHECK-NEXT:    [[BASE_EE_RELOCATED:%.*]] = call coldcc ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token [[STATEPOINT_TOKEN]], i32 1, i32 1)
; CHECK-NEXT:    ret ptr addrspace(1) [[B_RELOCATED]]
;
  %a = freeze <3 x ptr addrspace(1)> %arg
  %b = extractelement <3 x ptr addrspace(1)> %a, i64 2
  call void @hoge() ["deopt"()]
  ret ptr addrspace(1) %b
}

define ptr addrspace(1) @testScalar(ptr addrspace(1) %arg) gc "statepoint-example" {
; CHECK-LABEL: @testScalar(
; CHECK-NEXT:    [[A:%.*]] = freeze ptr addrspace(1) [[ARG:%.*]]
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, ptr, i32, i32, ...) @llvm.experimental.gc.statepoint.p0(i64 2882400000, i32 0, ptr elementtype(void ()) @hoge, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(ptr addrspace(1) [[A]], ptr addrspace(1) [[ARG]]) ]
; CHECK-NEXT:    [[A_RELOCATED:%.*]] = call coldcc ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token [[STATEPOINT_TOKEN]], i32 1, i32 0)
; CHECK-NEXT:    [[ARG_RELOCATED:%.*]] = call coldcc ptr addrspace(1) @llvm.experimental.gc.relocate.p1(token [[STATEPOINT_TOKEN]], i32 1, i32 1)
; CHECK-NEXT:    ret ptr addrspace(1) [[A_RELOCATED]]
;
  %a = freeze ptr addrspace(1) %arg
  call void @hoge() ["deopt"()]
  ret ptr addrspace(1) %a
}
