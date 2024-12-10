; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py UTC_ARGS: --version 2
; RUN: opt < %s -disable-output "-passes=print<scalar-evolution>" 2>&1 | FileCheck %s

@.str = private unnamed_addr constant [3 x i8] c"%x\00", align 1

define dso_local i32 @test_loop(ptr nocapture noundef readonly %x) {
; CHECK-LABEL: 'test_loop'
; CHECK-NEXT:  Classifying expressions for: @test_loop
; CHECK-NEXT:    %i.03 = phi i64 [ 1, %entry ], [ %inc, %for.body ]
; CHECK-NEXT:    --> {1,+,1}<nuw><nsw><%for.body> U: [1,10) S: [1,10) Exits: 9 LoopDispositions: { %for.body: Computable }
; CHECK-NEXT:    %conv = shl nuw nsw i64 %i.03, 32
; CHECK-NEXT:    --> {4294967296,+,4294967296}<nuw><nsw><%for.body> U: [4294967296,38654705665) S: [4294967296,38654705665) Exits: 38654705664 LoopDispositions: { %for.body: Computable }
; CHECK-NEXT:    %sext = add nsw i64 %conv, -4294967296
; CHECK-NEXT:    --> {0,+,4294967296}<nuw><nsw><%for.body> U: [0,34359738369) S: [0,34359738369) Exits: 34359738368 LoopDispositions: { %for.body: Computable }
; CHECK-NEXT:    %idxprom = ashr exact i64 %sext, 32
; CHECK-NEXT:    --> {0,+,1}<nuw><nsw><%for.body> U: [0,9) S: [0,9) Exits: 8 LoopDispositions: { %for.body: Computable }
; CHECK-NEXT:    %arrayidx = getelementptr inbounds i32, ptr %x, i64 %idxprom
; CHECK-NEXT:    --> {%x,+,4}<nuw><%for.body> U: full-set S: full-set Exits: (32 + %x) LoopDispositions: { %for.body: Computable }
; CHECK-NEXT:    %0 = load i32, ptr %arrayidx, align 4
; CHECK-NEXT:    --> %0 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %for.body: Variant }
; CHECK-NEXT:    %call = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i32 noundef %0)
; CHECK-NEXT:    --> %call U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %for.body: Variant }
; CHECK-NEXT:    %inc = add nuw nsw i64 %i.03, 1
; CHECK-NEXT:    --> {2,+,1}<nuw><nsw><%for.body> U: [2,11) S: [2,11) Exits: 10 LoopDispositions: { %for.body: Computable }
; CHECK-NEXT:  Determining loop execution counts for: @test_loop
; CHECK-NEXT:  Loop %for.body: backedge-taken count is 8
; CHECK-NEXT:  Loop %for.body: constant max backedge-taken count is 8
; CHECK-NEXT:  Loop %for.body: symbolic max backedge-taken count is 8
; CHECK-NEXT:  Loop %for.body: Predicated backedge-taken count is 8
; CHECK-NEXT:   Predicates:
; CHECK-NEXT:  Loop %for.body: Trip multiple is 9
;
entry:
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body
  ret i32 0

for.body:                                         ; preds = %entry, %for.body
  %i.03 = phi i64 [ 1, %entry ], [ %inc, %for.body ]
  %conv = shl nuw nsw i64 %i.03, 32
  %sext = add nsw i64 %conv, -4294967296
  %idxprom = ashr exact i64 %sext, 32
  %arrayidx = getelementptr inbounds i32, ptr %x, i64 %idxprom
  %0 = load i32, ptr %arrayidx, align 4
  %call = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i32 noundef %0)
  %inc = add nuw nsw i64 %i.03, 1
  %exitcond.not = icmp eq i64 %inc, 10
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body
}

declare noundef i32 @printf(ptr nocapture noundef readonly, ...)