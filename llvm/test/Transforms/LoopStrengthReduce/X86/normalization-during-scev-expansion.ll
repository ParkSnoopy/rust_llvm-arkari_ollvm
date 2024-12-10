; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 3
; RUN: opt -loop-reduce -S %s | FileCheck %s

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macos"

declare i1 @cond()

define ptr @test(ptr %dst, i64 %v4, i64 %v5, i64 %v6, i64 %v7)  {
; CHECK-LABEL: define ptr @test
; CHECK-SAME: (ptr [[DST:%.*]], i64 [[V4:%.*]], i64 [[V5:%.*]], i64 [[V6:%.*]], i64 [[V7:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = mul i64 [[V5]], [[V4]]
; CHECK-NEXT:    [[TMP1:%.*]] = shl i64 [[TMP0]], 4
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[V7]], [[V6]]
; CHECK-NEXT:    [[TMP3:%.*]] = shl i64 [[TMP2]], 3
; CHECK-NEXT:    [[TMP4:%.*]] = add i64 [[TMP3]], -8
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr i8, ptr [[DST]], i64 [[TMP4]]
; CHECK-NEXT:    [[TMP5:%.*]] = shl nsw i64 [[V5]], 3
; CHECK-NEXT:    [[TMP6:%.*]] = add i64 [[TMP5]], 8
; CHECK-NEXT:    [[TMP7:%.*]] = shl i64 [[V4]], 4
; CHECK-NEXT:    [[TMP8:%.*]] = add nuw nsw i64 [[TMP7]], 8
; CHECK-NEXT:    [[TMP9:%.*]] = mul i64 [[V5]], [[TMP8]]
; CHECK-NEXT:    [[TMP10:%.*]] = shl i64 [[V7]], 3
; CHECK-NEXT:    [[TMP11:%.*]] = shl i64 [[V6]], 3
; CHECK-NEXT:    [[TMP12:%.*]] = add i64 [[TMP10]], [[TMP11]]
; CHECK-NEXT:    [[TMP13:%.*]] = add i64 [[TMP12]], -8
; CHECK-NEXT:    [[SCEVGEP3:%.*]] = getelementptr i8, ptr [[DST]], i64 [[TMP13]]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[LSR_IV4:%.*]] = phi ptr [ [[SCEVGEP5:%.*]], [[LOOP]] ], [ [[SCEVGEP3]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[LSR_IV:%.*]] = phi ptr [ [[SCEVGEP1:%.*]], [[LOOP]] ], [ [[SCEVGEP]], [[ENTRY]] ]
; CHECK-NEXT:    [[SCEVGEP6:%.*]] = getelementptr i8, ptr [[LSR_IV4]], i64 [[TMP9]]
; CHECK-NEXT:    store i64 0, ptr [[SCEVGEP6]], align 8
; CHECK-NEXT:    [[C:%.*]] = call i1 @cond()
; CHECK-NEXT:    [[SCEVGEP1]] = getelementptr i8, ptr [[LSR_IV]], i64 [[TMP6]]
; CHECK-NEXT:    [[SCEVGEP2:%.*]] = getelementptr i8, ptr [[SCEVGEP1]], i64 [[TMP1]]
; CHECK-NEXT:    [[SCEVGEP5]] = getelementptr i8, ptr [[LSR_IV4]], i64 [[TMP6]]
; CHECK-NEXT:    br i1 [[C]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[RES:%.*]] = phi ptr [ [[SCEVGEP2]], [[LOOP]] ]
; CHECK-NEXT:    ret ptr [[RES]]
;
entry:
  %mul = mul nsw i64 %v5, %v4
  %add.ptr162 = getelementptr inbounds i64, ptr %dst, i64 %v6
  %add.ptr164 = getelementptr inbounds i64, ptr %add.ptr162, i64 %mul
  %add.ptr166 = getelementptr inbounds i64, ptr %add.ptr164, i64 %v7
  %add.ptr167 = getelementptr inbounds i64, ptr %add.ptr166, i64 -1
  %add.ptr249 = getelementptr inbounds i64, ptr %add.ptr167, i64 %mul
  br label %loop

loop:
  %iv = phi ptr [ %add.ptr249, %entry ], [ %iv.next, %loop ]
  %gep.iv.1 = getelementptr inbounds i64, ptr %iv, i64 %v5
  store i64 0, ptr %gep.iv.1, align 8
  %iv.next = getelementptr inbounds i64, ptr %gep.iv.1, i64 1
  %c = call i1 @cond()
  br i1 %c, label %exit, label %loop

exit:
  %res = phi ptr [ %iv.next, %loop ]
  ret ptr %res
}

define i32 @test_pr63678(i1 %c) {
; CHECK-LABEL: define i32 @test_pr63678
; CHECK-SAME: (i1 [[C:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_1_PREHEADER:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[TOBOOL1_NOT:%.*]] = icmp eq i32 [[LSR_IV_NEXT66:%.*]], 0
; CHECK-NEXT:    br label [[LOOP_1_PREHEADER]]
; CHECK:       loop.1.preheader:
; CHECK-NEXT:    [[IV_PH:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ 1, [[BB:%.*]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = sub i32 1, [[IV_PH]]
; CHECK-NEXT:    [[TMP1:%.*]] = add nsw i32 [[TMP0]], -1
; CHECK-NEXT:    br label [[LOOP_1:%.*]]
; CHECK:       loop.1:
; CHECK-NEXT:    [[LSR_IV:%.*]] = phi i32 [ [[TMP1]], [[LOOP_1_PREHEADER]] ], [ [[LSR_IV_NEXT:%.*]], [[LOOP_1]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT]] = add i32 [[LSR_IV]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_1_LOOP_2_CRIT_EDGE:%.*]], label [[LOOP_1]]
; CHECK:       loop.1.loop.2_crit_edge:
; CHECK-NEXT:    br label [[LOOP_2:%.*]]
; CHECK:       loop.2:
; CHECK-NEXT:    [[LSR_IV1:%.*]] = phi i32 [ [[LSR_IV_NEXT2:%.*]], [[LOOP_2]] ], [ [[LSR_IV]], [[LOOP_1_LOOP_2_CRIT_EDGE]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT2]] = add i32 [[LSR_IV1]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_3_PREHEADER:%.*]], label [[LOOP_2]]
; CHECK:       loop.3.preheader:
; CHECK-NEXT:    br label [[LOOP_3:%.*]]
; CHECK:       loop.3:
; CHECK-NEXT:    [[LSR_IV3:%.*]] = phi i32 [ [[LSR_IV1]], [[LOOP_3_PREHEADER]] ], [ [[LSR_IV_NEXT4:%.*]], [[LOOP_3]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT4]] = add i32 [[LSR_IV3]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_4_PREHEADER:%.*]], label [[LOOP_3]]
; CHECK:       loop.4.preheader:
; CHECK-NEXT:    br label [[LOOP_4:%.*]]
; CHECK:       loop.4:
; CHECK-NEXT:    [[LSR_IV5:%.*]] = phi i32 [ [[LSR_IV3]], [[LOOP_4_PREHEADER]] ], [ [[LSR_IV_NEXT6:%.*]], [[LOOP_4]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT6]] = add i32 [[LSR_IV5]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_5_PREHEADER:%.*]], label [[LOOP_4]]
; CHECK:       loop.5.preheader:
; CHECK-NEXT:    br label [[LOOP_5:%.*]]
; CHECK:       loop.5:
; CHECK-NEXT:    [[LSR_IV7:%.*]] = phi i32 [ [[LSR_IV5]], [[LOOP_5_PREHEADER]] ], [ [[LSR_IV_NEXT8:%.*]], [[LOOP_5]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT8]] = add i32 [[LSR_IV7]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_6_PREHEADER:%.*]], label [[LOOP_5]]
; CHECK:       loop.6.preheader:
; CHECK-NEXT:    br label [[LOOP_6:%.*]]
; CHECK:       loop.6:
; CHECK-NEXT:    [[LSR_IV9:%.*]] = phi i32 [ [[LSR_IV7]], [[LOOP_6_PREHEADER]] ], [ [[LSR_IV_NEXT10:%.*]], [[LOOP_6]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT10]] = add i32 [[LSR_IV9]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_135_PREHEADER:%.*]], label [[LOOP_6]]
; CHECK:       loop.135.preheader:
; CHECK-NEXT:    br label [[LOOP_135:%.*]]
; CHECK:       loop.135:
; CHECK-NEXT:    [[LSR_IV11:%.*]] = phi i32 [ [[LSR_IV9]], [[LOOP_135_PREHEADER]] ], [ [[LSR_IV_NEXT12:%.*]], [[LOOP_135]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT12]] = add i32 [[LSR_IV11]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_1_1_PREHEADER:%.*]], label [[LOOP_135]]
; CHECK:       loop.1.1.preheader:
; CHECK-NEXT:    br label [[LOOP_1_1:%.*]]
; CHECK:       loop.1.1:
; CHECK-NEXT:    [[LSR_IV13:%.*]] = phi i32 [ [[LSR_IV11]], [[LOOP_1_1_PREHEADER]] ], [ [[LSR_IV_NEXT14:%.*]], [[LOOP_1_1]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT14]] = add i32 [[LSR_IV13]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_2_1_PREHEADER:%.*]], label [[LOOP_1_1]]
; CHECK:       loop.2.1.preheader:
; CHECK-NEXT:    br label [[LOOP_2_1:%.*]]
; CHECK:       loop.2.1:
; CHECK-NEXT:    [[LSR_IV15:%.*]] = phi i32 [ [[LSR_IV13]], [[LOOP_2_1_PREHEADER]] ], [ [[LSR_IV_NEXT16:%.*]], [[LOOP_2_1]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT16]] = add i32 [[LSR_IV15]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_3_1_PREHEADER:%.*]], label [[LOOP_2_1]]
; CHECK:       loop.3.1.preheader:
; CHECK-NEXT:    br label [[LOOP_3_1:%.*]]
; CHECK:       loop.3.1:
; CHECK-NEXT:    [[LSR_IV17:%.*]] = phi i32 [ [[LSR_IV15]], [[LOOP_3_1_PREHEADER]] ], [ [[LSR_IV_NEXT18:%.*]], [[LOOP_3_1]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT18]] = add i32 [[LSR_IV17]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_4_1_PREHEADER:%.*]], label [[LOOP_3_1]]
; CHECK:       loop.4.1.preheader:
; CHECK-NEXT:    br label [[LOOP_4_1:%.*]]
; CHECK:       loop.4.1:
; CHECK-NEXT:    [[LSR_IV19:%.*]] = phi i32 [ [[LSR_IV17]], [[LOOP_4_1_PREHEADER]] ], [ [[LSR_IV_NEXT20:%.*]], [[LOOP_4_1]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT20]] = add i32 [[LSR_IV19]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_5_1_PREHEADER:%.*]], label [[LOOP_4_1]]
; CHECK:       loop.5.1.preheader:
; CHECK-NEXT:    br label [[LOOP_5_1:%.*]]
; CHECK:       loop.5.1:
; CHECK-NEXT:    [[LSR_IV21:%.*]] = phi i32 [ [[LSR_IV19]], [[LOOP_5_1_PREHEADER]] ], [ [[LSR_IV_NEXT22:%.*]], [[LOOP_5_1]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT22]] = add i32 [[LSR_IV21]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_6_1_PREHEADER:%.*]], label [[LOOP_5_1]]
; CHECK:       loop.6.1.preheader:
; CHECK-NEXT:    br label [[LOOP_6_1:%.*]]
; CHECK:       loop.6.1:
; CHECK-NEXT:    [[LSR_IV23:%.*]] = phi i32 [ [[LSR_IV21]], [[LOOP_6_1_PREHEADER]] ], [ [[LSR_IV_NEXT24:%.*]], [[LOOP_6_1]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT24]] = add i32 [[LSR_IV23]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_241_PREHEADER:%.*]], label [[LOOP_6_1]]
; CHECK:       loop.241.preheader:
; CHECK-NEXT:    br label [[LOOP_241:%.*]]
; CHECK:       loop.241:
; CHECK-NEXT:    [[LSR_IV25:%.*]] = phi i32 [ [[LSR_IV23]], [[LOOP_241_PREHEADER]] ], [ [[LSR_IV_NEXT26:%.*]], [[LOOP_241]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT26]] = add i32 [[LSR_IV25]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_1_2_PREHEADER:%.*]], label [[LOOP_241]]
; CHECK:       loop.1.2.preheader:
; CHECK-NEXT:    br label [[LOOP_1_2:%.*]]
; CHECK:       loop.1.2:
; CHECK-NEXT:    [[LSR_IV27:%.*]] = phi i32 [ [[LSR_IV25]], [[LOOP_1_2_PREHEADER]] ], [ [[LSR_IV_NEXT28:%.*]], [[LOOP_1_2]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT28]] = add i32 [[LSR_IV27]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_2_2_PREHEADER:%.*]], label [[LOOP_1_2]]
; CHECK:       loop.2.2.preheader:
; CHECK-NEXT:    br label [[LOOP_2_2:%.*]]
; CHECK:       loop.2.2:
; CHECK-NEXT:    [[LSR_IV29:%.*]] = phi i32 [ [[LSR_IV27]], [[LOOP_2_2_PREHEADER]] ], [ [[LSR_IV_NEXT30:%.*]], [[LOOP_2_2]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT30]] = add i32 [[LSR_IV29]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_3_2_PREHEADER:%.*]], label [[LOOP_2_2]]
; CHECK:       loop.3.2.preheader:
; CHECK-NEXT:    br label [[LOOP_3_2:%.*]]
; CHECK:       loop.3.2:
; CHECK-NEXT:    [[LSR_IV31:%.*]] = phi i32 [ [[LSR_IV29]], [[LOOP_3_2_PREHEADER]] ], [ [[LSR_IV_NEXT32:%.*]], [[LOOP_3_2]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT32]] = add i32 [[LSR_IV31]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_4_2_PREHEADER:%.*]], label [[LOOP_3_2]]
; CHECK:       loop.4.2.preheader:
; CHECK-NEXT:    br label [[LOOP_4_2:%.*]]
; CHECK:       loop.4.2:
; CHECK-NEXT:    [[LSR_IV33:%.*]] = phi i32 [ [[LSR_IV31]], [[LOOP_4_2_PREHEADER]] ], [ [[LSR_IV_NEXT34:%.*]], [[LOOP_4_2]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT34]] = add i32 [[LSR_IV33]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_5_2_PREHEADER:%.*]], label [[LOOP_4_2]]
; CHECK:       loop.5.2.preheader:
; CHECK-NEXT:    br label [[LOOP_5_2:%.*]]
; CHECK:       loop.5.2:
; CHECK-NEXT:    [[LSR_IV35:%.*]] = phi i32 [ [[LSR_IV33]], [[LOOP_5_2_PREHEADER]] ], [ [[LSR_IV_NEXT36:%.*]], [[LOOP_5_2]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT36]] = add i32 [[LSR_IV35]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_6_2_PREHEADER:%.*]], label [[LOOP_5_2]]
; CHECK:       loop.6.2.preheader:
; CHECK-NEXT:    br label [[LOOP_6_2:%.*]]
; CHECK:       loop.6.2:
; CHECK-NEXT:    [[LSR_IV37:%.*]] = phi i32 [ [[LSR_IV35]], [[LOOP_6_2_PREHEADER]] ], [ [[LSR_IV_NEXT38:%.*]], [[LOOP_6_2]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT38]] = add i32 [[LSR_IV37]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_347_PREHEADER:%.*]], label [[LOOP_6_2]]
; CHECK:       loop.347.preheader:
; CHECK-NEXT:    br label [[LOOP_347:%.*]]
; CHECK:       loop.347:
; CHECK-NEXT:    [[LSR_IV39:%.*]] = phi i32 [ [[LSR_IV37]], [[LOOP_347_PREHEADER]] ], [ [[LSR_IV_NEXT40:%.*]], [[LOOP_347]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT40]] = add i32 [[LSR_IV39]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_1_3_PREHEADER:%.*]], label [[LOOP_347]]
; CHECK:       loop.1.3.preheader:
; CHECK-NEXT:    br label [[LOOP_1_3:%.*]]
; CHECK:       loop.1.3:
; CHECK-NEXT:    [[LSR_IV41:%.*]] = phi i32 [ [[LSR_IV39]], [[LOOP_1_3_PREHEADER]] ], [ [[LSR_IV_NEXT42:%.*]], [[LOOP_1_3]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT42]] = add i32 [[LSR_IV41]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_2_3_PREHEADER:%.*]], label [[LOOP_1_3]]
; CHECK:       loop.2.3.preheader:
; CHECK-NEXT:    br label [[LOOP_2_3:%.*]]
; CHECK:       loop.2.3:
; CHECK-NEXT:    [[LSR_IV43:%.*]] = phi i32 [ [[LSR_IV41]], [[LOOP_2_3_PREHEADER]] ], [ [[LSR_IV_NEXT44:%.*]], [[LOOP_2_3]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT44]] = add i32 [[LSR_IV43]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_3_3_PREHEADER:%.*]], label [[LOOP_2_3]]
; CHECK:       loop.3.3.preheader:
; CHECK-NEXT:    br label [[LOOP_3_3:%.*]]
; CHECK:       loop.3.3:
; CHECK-NEXT:    [[LSR_IV45:%.*]] = phi i32 [ [[LSR_IV43]], [[LOOP_3_3_PREHEADER]] ], [ [[LSR_IV_NEXT46:%.*]], [[LOOP_3_3]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT46]] = add i32 [[LSR_IV45]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_4_3_PREHEADER:%.*]], label [[LOOP_3_3]]
; CHECK:       loop.4.3.preheader:
; CHECK-NEXT:    br label [[LOOP_4_3:%.*]]
; CHECK:       loop.4.3:
; CHECK-NEXT:    [[LSR_IV47:%.*]] = phi i32 [ [[LSR_IV45]], [[LOOP_4_3_PREHEADER]] ], [ [[LSR_IV_NEXT48:%.*]], [[LOOP_4_3]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT48]] = add i32 [[LSR_IV47]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_5_3_PREHEADER:%.*]], label [[LOOP_4_3]]
; CHECK:       loop.5.3.preheader:
; CHECK-NEXT:    br label [[LOOP_5_3:%.*]]
; CHECK:       loop.5.3:
; CHECK-NEXT:    [[LSR_IV49:%.*]] = phi i32 [ [[LSR_IV47]], [[LOOP_5_3_PREHEADER]] ], [ [[LSR_IV_NEXT50:%.*]], [[LOOP_5_3]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT50]] = add i32 [[LSR_IV49]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_6_3_PREHEADER:%.*]], label [[LOOP_5_3]]
; CHECK:       loop.6.3.preheader:
; CHECK-NEXT:    br label [[LOOP_6_3:%.*]]
; CHECK:       loop.6.3:
; CHECK-NEXT:    [[LSR_IV51:%.*]] = phi i32 [ [[LSR_IV49]], [[LOOP_6_3_PREHEADER]] ], [ [[LSR_IV_NEXT52:%.*]], [[LOOP_6_3]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT52]] = add i32 [[LSR_IV51]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_453_PREHEADER:%.*]], label [[LOOP_6_3]]
; CHECK:       loop.453.preheader:
; CHECK-NEXT:    br label [[LOOP_453:%.*]]
; CHECK:       loop.453:
; CHECK-NEXT:    [[LSR_IV53:%.*]] = phi i32 [ [[LSR_IV51]], [[LOOP_453_PREHEADER]] ], [ [[LSR_IV_NEXT54:%.*]], [[LOOP_453]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT54]] = add i32 [[LSR_IV53]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_1_4_PREHEADER:%.*]], label [[LOOP_453]]
; CHECK:       loop.1.4.preheader:
; CHECK-NEXT:    br label [[LOOP_1_4:%.*]]
; CHECK:       loop.1.4:
; CHECK-NEXT:    [[LSR_IV55:%.*]] = phi i32 [ [[LSR_IV53]], [[LOOP_1_4_PREHEADER]] ], [ [[LSR_IV_NEXT56:%.*]], [[LOOP_1_4]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT56]] = add i32 [[LSR_IV55]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_2_4_PREHEADER:%.*]], label [[LOOP_1_4]]
; CHECK:       loop.2.4.preheader:
; CHECK-NEXT:    br label [[LOOP_2_4:%.*]]
; CHECK:       loop.2.4:
; CHECK-NEXT:    [[LSR_IV57:%.*]] = phi i32 [ [[LSR_IV55]], [[LOOP_2_4_PREHEADER]] ], [ [[LSR_IV_NEXT58:%.*]], [[LOOP_2_4]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT58]] = add i32 [[LSR_IV57]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_3_4_PREHEADER:%.*]], label [[LOOP_2_4]]
; CHECK:       loop.3.4.preheader:
; CHECK-NEXT:    br label [[LOOP_3_4:%.*]]
; CHECK:       loop.3.4:
; CHECK-NEXT:    [[LSR_IV59:%.*]] = phi i32 [ [[LSR_IV57]], [[LOOP_3_4_PREHEADER]] ], [ [[LSR_IV_NEXT60:%.*]], [[LOOP_3_4]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT60]] = add i32 [[LSR_IV59]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_4_4_PREHEADER:%.*]], label [[LOOP_3_4]]
; CHECK:       loop.4.4.preheader:
; CHECK-NEXT:    br label [[LOOP_4_4:%.*]]
; CHECK:       loop.4.4:
; CHECK-NEXT:    [[LSR_IV61:%.*]] = phi i32 [ [[LSR_IV59]], [[LOOP_4_4_PREHEADER]] ], [ [[LSR_IV_NEXT62:%.*]], [[LOOP_4_4]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT62]] = add i32 [[LSR_IV61]], -1
; CHECK-NEXT:    br i1 false, label [[LOOP_5_4_PREHEADER:%.*]], label [[LOOP_4_4]]
; CHECK:       loop.5.4.preheader:
; CHECK-NEXT:    br label [[LOOP_5_4:%.*]]
; CHECK:       loop.5.4:
; CHECK-NEXT:    [[LSR_IV63:%.*]] = phi i32 [ [[LSR_IV61]], [[LOOP_5_4_PREHEADER]] ], [ [[LSR_IV_NEXT64:%.*]], [[LOOP_5_4]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT64]] = add i32 [[LSR_IV63]], 1
; CHECK-NEXT:    br i1 false, label [[LOOP_6_4_PREHEADER:%.*]], label [[LOOP_5_4]]
; CHECK:       loop.6.4.preheader:
; CHECK-NEXT:    br label [[LOOP_6_4:%.*]]
; CHECK:       loop.6.4:
; CHECK-NEXT:    [[LSR_IV65:%.*]] = phi i32 [ [[LSR_IV63]], [[LOOP_6_4_PREHEADER]] ], [ [[LSR_IV_NEXT66]], [[LOOP_6_4]] ]
; CHECK-NEXT:    [[LSR_IV_NEXT66]] = add i32 [[LSR_IV65]], 1
; CHECK-NEXT:    br label [[LOOP_6_4]]
;
entry:
  br label %loop.1

bb:
  %tobool1.not = icmp eq i32 %d.4.6.4, 0
  br label %loop.1

loop.1:
  %iv = phi i32 [ %iv.next, %loop.1 ], [ 1, %bb ], [ 0, %entry ]
  %iv.next = add i32 %iv, 1
  br i1 false, label %loop.1.loop.2_crit_edge, label %loop.1

loop.1.loop.2_crit_edge:
  br label %loop.2

loop.2:
  %iv58 = phi i32 [ %iv.next59, %loop.2 ], [ %iv, %loop.1.loop.2_crit_edge ]
  %iv.next59 = add i32 %iv58, 1
  br i1 false, label %loop.3, label %loop.2

loop.3:
  %iv60 = phi i32 [ %iv.next61, %loop.3 ], [ %iv58, %loop.2 ]
  %iv.next61 = add i32 %iv60, 1
  br i1 false, label %loop.4, label %loop.3

loop.4:
  %iv62 = phi i32 [ %iv.next63, %loop.4 ], [ %iv60, %loop.3 ]
  %iv.next63 = add i32 %iv62, 1
  br i1 false, label %loop.5, label %loop.4

loop.5:
  %iv64 = phi i32 [ %iv.next65, %loop.5 ], [ %iv62, %loop.4 ]
  %iv.next65 = add i32 %iv64, 1
  br i1 false, label %loop.6, label %loop.5

loop.6:
  %iv66 = phi i32 [ %iv.next67, %loop.6 ], [ %iv64, %loop.5 ]
  %iv.next67 = add i32 %iv66, 1
  br i1 false, label %loop.135, label %loop.6

loop.135:
  %iv68 = phi i32 [ %iv.next69, %loop.135 ], [ %iv66, %loop.6 ]
  %iv.next69 = add i32 %iv68, 1
  br i1 false, label %loop.1.1, label %loop.135

loop.1.1:
  %iv70 = phi i32 [ %iv.next71, %loop.1.1 ], [ %iv68, %loop.135 ]
  %iv.next71 = add i32 %iv70, 1
  br i1 false, label %loop.2.1, label %loop.1.1

loop.2.1:
  %iv72 = phi i32 [ %iv.next73, %loop.2.1 ], [ %iv70, %loop.1.1 ]
  %iv.next73 = add i32 %iv72, 1
  br i1 false, label %loop.3.1, label %loop.2.1

loop.3.1:
  %iv74 = phi i32 [ %iv.next75, %loop.3.1 ], [ %iv72, %loop.2.1 ]
  %iv.next75 = add i32 %iv74, 1
  br i1 false, label %loop.4.1, label %loop.3.1

loop.4.1:
  %iv76 = phi i32 [ %iv.next77, %loop.4.1 ], [ %iv74, %loop.3.1 ]
  %iv.next77 = add i32 %iv76, 1
  br i1 false, label %loop.5.1, label %loop.4.1

loop.5.1:
  %iv78 = phi i32 [ %iv.next79, %loop.5.1 ], [ %iv76, %loop.4.1 ]
  %iv.next79 = add i32 %iv78, 1
  br i1 false, label %loop.6.1, label %loop.5.1

loop.6.1:
  %iv80 = phi i32 [ %iv.next81, %loop.6.1 ], [ %iv78, %loop.5.1 ]
  %iv.next81 = add i32 %iv80, 1
  br i1 false, label %loop.241, label %loop.6.1

loop.241:
  %iv82 = phi i32 [ %iv.next83, %loop.241 ], [ %iv80, %loop.6.1 ]
  %iv.next83 = add i32 %iv82, 1
  br i1 false, label %loop.1.2, label %loop.241

loop.1.2:
  %iv84 = phi i32 [ %iv.next85, %loop.1.2 ], [ %iv82, %loop.241 ]
  %iv.next85 = add i32 %iv84, 1
  br i1 false, label %loop.2.2, label %loop.1.2

loop.2.2:
  %iv86 = phi i32 [ %iv.next87, %loop.2.2 ], [ %iv84, %loop.1.2 ]
  %iv.next87 = add i32 %iv86, 1
  br i1 false, label %loop.3.2, label %loop.2.2

loop.3.2:
  %iv88 = phi i32 [ %iv.next89, %loop.3.2 ], [ %iv86, %loop.2.2 ]
  %iv.next89 = add i32 %iv88, 1
  br i1 false, label %loop.4.2, label %loop.3.2

loop.4.2:
  %iv90 = phi i32 [ %iv.next91, %loop.4.2 ], [ %iv88, %loop.3.2 ]
  %iv.next91 = add i32 %iv90, 1
  br i1 false, label %loop.5.2, label %loop.4.2

loop.5.2:
  %iv92 = phi i32 [ %iv.next93, %loop.5.2 ], [ %iv90, %loop.4.2 ]
  %iv.next93 = add i32 %iv92, 1
  br i1 false, label %loop.6.2, label %loop.5.2

loop.6.2:
  %iv94 = phi i32 [ %iv.next95, %loop.6.2 ], [ %iv92, %loop.5.2 ]
  %iv.next95 = add i32 %iv94, 1
  br i1 false, label %loop.347, label %loop.6.2

loop.347:
  %iv96 = phi i32 [ %iv.next97, %loop.347 ], [ %iv94, %loop.6.2 ]
  %iv.next97 = add i32 %iv96, 1
  br i1 false, label %loop.1.3, label %loop.347

loop.1.3:
  %iv98 = phi i32 [ %iv.next99, %loop.1.3 ], [ %iv96, %loop.347 ]
  %iv.next99 = add i32 %iv98, 1
  br i1 false, label %loop.2.3, label %loop.1.3

loop.2.3:
  %iv100 = phi i32 [ %iv.next101, %loop.2.3 ], [ %iv98, %loop.1.3 ]
  %iv.next101 = add i32 %iv100, 1
  br i1 false, label %loop.3.3, label %loop.2.3

loop.3.3:
  %iv102 = phi i32 [ %iv.next103, %loop.3.3 ], [ %iv100, %loop.2.3 ]
  %iv.next103 = add i32 %iv102, 1
  br i1 false, label %loop.4.3, label %loop.3.3

loop.4.3:
  %iv104 = phi i32 [ %iv.next105, %loop.4.3 ], [ %iv102, %loop.3.3 ]
  %iv.next105 = add i32 %iv104, 1
  br i1 false, label %loop.5.3, label %loop.4.3

loop.5.3:
  %iv106 = phi i32 [ %iv.next107, %loop.5.3 ], [ %iv104, %loop.4.3 ]
  %iv.next107 = add i32 %iv106, 1
  br i1 false, label %loop.6.3, label %loop.5.3

loop.6.3:
  %iv108 = phi i32 [ %iv.next109, %loop.6.3 ], [ %iv106, %loop.5.3 ]
  %iv.next109 = add i32 %iv108, 1
  br i1 false, label %loop.453, label %loop.6.3

loop.453:
  %iv110 = phi i32 [ %iv.next111, %loop.453 ], [ %iv108, %loop.6.3 ]
  %iv.next111 = add i32 %iv110, 1
  br i1 false, label %loop.1.4, label %loop.453

loop.1.4:
  %iv112 = phi i32 [ %iv.next113, %loop.1.4 ], [ %iv110, %loop.453 ]
  %iv.next113 = add i32 %iv112, 1
  br i1 false, label %loop.2.4, label %loop.1.4

loop.2.4:
  %iv114 = phi i32 [ %iv.next115, %loop.2.4 ], [ %iv112, %loop.1.4 ]
  %iv.next115 = add i32 %iv114, 1
  br i1 false, label %loop.3.4, label %loop.2.4

loop.3.4:
  %iv116 = phi i32 [ %iv.next117, %loop.3.4 ], [ %iv114, %loop.2.4 ]
  %iv.next117 = add i32 %iv116, 1
  br i1 false, label %loop.4.4, label %loop.3.4

loop.4.4:
  %iv118 = phi i32 [ %iv.next119, %loop.4.4 ], [ %iv116, %loop.3.4 ]
  %iv.next119 = add i32 %iv118, 1
  br i1 false, label %loop.5.4, label %loop.4.4

loop.5.4:
  %iv120 = phi i32 [ %iv.next121, %loop.5.4 ], [ %iv118, %loop.4.4 ]
  %iv.next121 = add i32 %iv120, -1
  br i1 false, label %loop.6.4, label %loop.5.4

loop.6.4:
  %d.4.6.4 = phi i32 [ %dec.6.4, %loop.6.4 ], [ %iv.next121, %loop.5.4 ]
  %dec.6.4 = add i32 %d.4.6.4, -1
  br label %loop.6.4
}