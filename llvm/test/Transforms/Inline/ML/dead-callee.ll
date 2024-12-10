; REQUIRES: llvm_inliner_model_autogenerated
; RUN: opt -passes=inliner-ml-advisor-release -S < %s | FileCheck %s

; Check that our accounting works when a function in a non-trivial SCC is dead.

; CHECK: define void @f
; CHECK-NOT: @g

define void @f() {
    call void @g()
    ret void
}

define internal void @g() {
    call void @f()
    ret void
}