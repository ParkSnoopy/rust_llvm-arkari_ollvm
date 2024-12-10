; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-eabi | FileCheck %s

;==--------------------------------------------------------------------------==
; Tests for MOV-immediate implemented with ORR-immediate.
;==--------------------------------------------------------------------------==

; 64-bit immed with 32-bit pattern size, rotated by 0.
define i64 @test64_32_rot0() nounwind {
; CHECK-LABEL: test64_32_rot0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #30064771079
; CHECK-NEXT:    ret
  ret i64 30064771079
}

; 64-bit immed with 32-bit pattern size, rotated by 2.
define i64 @test64_32_rot2() nounwind {
; CHECK-LABEL: test64_32_rot2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-4611686002321260541
; CHECK-NEXT:    ret
  ret i64 13835058071388291075
}

; 64-bit immed with 4-bit pattern size, rotated by 3.
define i64 @test64_4_rot3() nounwind {
; CHECK-LABEL: test64_4_rot3:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-1229782938247303442
; CHECK-NEXT:    ret
  ret i64 17216961135462248174
}

; 64-bit immed with 64-bit pattern size, many bits.
define i64 @test64_64_manybits() nounwind {
; CHECK-LABEL: test64_64_manybits:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #4503599627304960
; CHECK-NEXT:    ret
  ret i64 4503599627304960
}

; 64-bit immed with 64-bit pattern size, one bit.
define i64 @test64_64_onebit() nounwind {
; CHECK-LABEL: test64_64_onebit:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #274877906944
; CHECK-NEXT:    ret
  ret i64 274877906944
}

; 32-bit immed with 32-bit pattern size, rotated by 16.
define i32 @test32_32_rot16() nounwind {
; CHECK-LABEL: test32_32_rot16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w0, #16711680
; CHECK-NEXT:    ret
  ret i32 16711680
}

; 32-bit immed with 2-bit pattern size, rotated by 1.
define i32 @test32_2_rot1() nounwind {
; CHECK-LABEL: test32_2_rot1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w0, #-1431655766
; CHECK-NEXT:    ret
  ret i32 2863311530
}

;==--------------------------------------------------------------------------==
; Tests for MOVZ with MOVK.
;==--------------------------------------------------------------------------==

define i32 @movz() nounwind {
; CHECK-LABEL: movz:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w0, #5
; CHECK-NEXT:    ret
  ret i32 5
}

define i64 @movz_3movk() nounwind {
; CHECK-LABEL: movz_3movk:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #22136
; CHECK-NEXT:    movk x0, #43981, lsl #16
; CHECK-NEXT:    movk x0, #4660, lsl #32
; CHECK-NEXT:    movk x0, #5, lsl #48
; CHECK-NEXT:    ret
  ret i64 1427392313513592
}

define i64 @movz_movk_skip1() nounwind {
; CHECK-LABEL: movz_movk_skip1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #1126236160
; CHECK-NEXT:    movk x0, #5, lsl #32
; CHECK-NEXT:    ret
  ret i64 22601072640
}

define i64 @movz_skip1_movk() nounwind {
; CHECK-LABEL: movz_skip1_movk:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #4660
; CHECK-NEXT:    movk x0, #34388, lsl #32
; CHECK-NEXT:    ret
  ret i64 147695335379508
}

define i64 @orr_lsl_pattern() nounwind {
; CHECK-LABEL: orr_lsl_pattern:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-6148914691236517206
; CHECK-NEXT:    and x0, x0, #0x1fffffffe0
; CHECK-NEXT:    ret
  ret i64 45812984480
}

; FIXME: prefer "mov x0, #-16639; lsl x0, x0, #24"
define i64 @mvn_lsl_pattern() nounwind {
; CHECK-LABEL: mvn_lsl_pattern:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #16777216
; CHECK-NEXT:    movk x0, #65471, lsl #32
; CHECK-NEXT:    movk x0, #65535, lsl #48
; CHECK-NEXT:    ret
  ret i64 -279156097024
}

; FIXME: prefer "mov w0, #-63; movk x0, #17, lsl #32"
define i64 @mvn32_pattern_2() nounwind {
; CHECK-LABEL: mvn32_pattern_2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #65473
; CHECK-NEXT:    movk x0, #65535, lsl #16
; CHECK-NEXT:    movk x0, #17, lsl #32
; CHECK-NEXT:    ret
  ret i64 77309411265
}

;==--------------------------------------------------------------------------==
; Tests for MOVN with MOVK.
;==--------------------------------------------------------------------------==

define i64 @movn() nounwind {
; CHECK-LABEL: movn:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-42
; CHECK-NEXT:    ret
  ret i64 -42
}

define i64 @movn_skip1_movk() nounwind {
; CHECK-LABEL: movn_skip1_movk:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-60876
; CHECK-NEXT:    movk x0, #65494, lsl #32
; CHECK-NEXT:    ret
  ret i64 -176093720012
}

;==--------------------------------------------------------------------------==
; Tests for ORR with MOVK.
;==--------------------------------------------------------------------------==
; rdar://14987673

define i64 @orr_movk1() nounwind {
; CHECK-LABEL: orr_movk1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #72056494543077120
; CHECK-NEXT:    movk x0, #57005, lsl #16
; CHECK-NEXT:    ret
  ret i64 72056498262245120
}

define i64 @orr_movk2() nounwind {
; CHECK-LABEL: orr_movk2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #72056494543077120
; CHECK-NEXT:    movk x0, #57005, lsl #48
; CHECK-NEXT:    ret
  ret i64 -2400982650836746496
}

define i64 @orr_movk3() nounwind {
; CHECK-LABEL: orr_movk3:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #72056494543077120
; CHECK-NEXT:    movk x0, #57005, lsl #32
; CHECK-NEXT:    ret
  ret i64 72020953688702720
}

define i64 @orr_movk4() nounwind {
; CHECK-LABEL: orr_movk4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #72056494543077120
; CHECK-NEXT:    movk x0, #57005
; CHECK-NEXT:    ret
  ret i64 72056494543068845
}

; rdar://14987618
define i64 @orr_movk5() nounwind {
; CHECK-LABEL: orr_movk5:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-71777214294589696
; CHECK-NEXT:    movk x0, #57005, lsl #16
; CHECK-NEXT:    ret
  ret i64 -71777214836900096
}

define i64 @orr_movk6() nounwind {
; CHECK-LABEL: orr_movk6:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-71777214294589696
; CHECK-NEXT:    movk x0, #57005, lsl #16
; CHECK-NEXT:    movk x0, #57005, lsl #48
; CHECK-NEXT:    ret
  ret i64 -2400982647117578496
}

define i64 @orr_movk7() nounwind {
; CHECK-LABEL: orr_movk7:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-71777214294589696
; CHECK-NEXT:    movk x0, #57005, lsl #48
; CHECK-NEXT:    ret
  ret i64 -2400982646575268096
}

define i64 @orr_movk8() nounwind {
; CHECK-LABEL: orr_movk8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-71777214294589696
; CHECK-NEXT:    movk x0, #57005
; CHECK-NEXT:    movk x0, #57005, lsl #48
; CHECK-NEXT:    ret
  ret i64 -2400982646575276371
}

; rdar://14987715
define i64 @orr_movk9() nounwind {
; CHECK-LABEL: orr_movk9:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #1152921435887370240
; CHECK-NEXT:    movk x0, #65280
; CHECK-NEXT:    movk x0, #57005, lsl #16
; CHECK-NEXT:    ret
  ret i64 1152921439623315200
}

define i64 @orr_movk10() nounwind {
; CHECK-LABEL: orr_movk10:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #1152921504606846720
; CHECK-NEXT:    movk x0, #57005, lsl #16
; CHECK-NEXT:    ret
  ret i64 1152921504047824640
}

define i64 @orr_movk11() nounwind {
; CHECK-LABEL: orr_movk11:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-65281
; CHECK-NEXT:    movk x0, #57005, lsl #16
; CHECK-NEXT:    movk x0, #65520, lsl #48
; CHECK-NEXT:    ret
  ret i64 -4222125209747201
}

define i64 @orr_movk12() nounwind {
; CHECK-LABEL: orr_movk12:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-4503599627370241
; CHECK-NEXT:    movk x0, #57005, lsl #32
; CHECK-NEXT:    ret
  ret i64 -4258765016661761
}

define i64 @orr_movk13() nounwind {
; CHECK-LABEL: orr_movk13:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #17592169267200
; CHECK-NEXT:    movk x0, #57005
; CHECK-NEXT:    movk x0, #57005, lsl #48
; CHECK-NEXT:    ret
  ret i64 -2401245434149282131
}

; rdar://13944082
define i64 @g() nounwind {
; CHECK-LABEL: g:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov x0, #2
; CHECK-NEXT:    movk x0, #65535, lsl #48
; CHECK-NEXT:    ret
entry:
  ret i64 -281474976710654
}

define i64 @orr_movk14() nounwind {
; CHECK-LABEL: orr_movk14:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-549755813888
; CHECK-NEXT:    movk x0, #2048, lsl #16
; CHECK-NEXT:    ret
  ret i64 -549621596160
}

define i64 @orr_movk15() nounwind {
; CHECK-LABEL: orr_movk15:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #549755813887
; CHECK-NEXT:    movk x0, #63487, lsl #16
; CHECK-NEXT:    ret
  ret i64 549621596159
}

define i64 @orr_movk16() nounwind {
; CHECK-LABEL: orr_movk16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #2147483646
; CHECK-NEXT:    orr x0, x0, #0x7fffe0007fffe0
; CHECK-NEXT:    ret
  ret i64 36028661727494142
}

define i64 @orr_movk17() nounwind {
; CHECK-LABEL: orr_movk17:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-1099511627776
; CHECK-NEXT:    movk x0, #65280, lsl #16
; CHECK-NEXT:    ret
  ret i64 -1095233437696
}

define i64 @orr_movk18() nounwind {
; CHECK-LABEL: orr_movk18:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #137438887936
; CHECK-NEXT:    movk x0, #65473
; CHECK-NEXT:    ret
  ret i64 137438953409
}

define i64 @orr_and() nounwind {
; CHECK-LABEL: orr_and:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #72340172838076673
; CHECK-NEXT:    and x0, x0, #0xffffffffff00
; CHECK-NEXT:    ret
  ret i64 1103823438080
}

; FIXME: prefer "mov w0, #-1431655766; movk x0, #9, lsl #32"
define i64 @movn_movk() nounwind {
; CHECK-LABEL: movn_movk:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #43690
; CHECK-NEXT:    movk x0, #43690, lsl #16
; CHECK-NEXT:    movk x0, #9, lsl #32
; CHECK-NEXT:    ret
  ret i64 41518017194
}

; FIXME: prefer "mov w0, #-13690; orr x0, x0, #0x1111111111111111"
define i64 @movn_orr() nounwind {
; CHECK-LABEL: movn_orr:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-51847
; CHECK-NEXT:    movk x0, #4369, lsl #32
; CHECK-NEXT:    movk x0, #4369, lsl #48
; CHECK-NEXT:    ret
  ret i64 1229782942255887737
}

; FIXME: prefer "mov w0, #-305397761; eor x0, x0, #0x3333333333333333"
define i64 @movn_eor() nounwind {
; CHECK-LABEL: movn_eor:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #3689348814741910323
; CHECK-NEXT:    movk x0, #52428
; CHECK-NEXT:    movk x0, #8455, lsl #16
; CHECK-NEXT:    ret
  ret i64 3689348814437076172
}

define i64 @orr_orr_64() nounwind {
; CHECK-LABEL: orr_orr_64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #536866816
; CHECK-NEXT:    orr x0, x0, #0x3fff800000000000
; CHECK-NEXT:    ret
  ret i64 4611545281475899392
}

define i64 @orr_orr_32() nounwind {
; CHECK-LABEL: orr_orr_32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #558551907040256
; CHECK-NEXT:    orr x0, x0, #0x1c001c001c001c00
; CHECK-NEXT:    ret
  ret i64 2018171185438784512
}

define i64 @orr_orr_16() nounwind {
; CHECK-LABEL: orr_orr_16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #1152939097061330944
; CHECK-NEXT:    orr x0, x0, #0x1000100010001
; CHECK-NEXT:    ret
  ret i64 1153220576333074433
}

define i64 @orr_orr_8() nounwind {
; CHECK-LABEL: orr_orr_8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #144680345676153346
; CHECK-NEXT:    orr x0, x0, #0x1818181818181818
; CHECK-NEXT:    ret
  ret i64 1880844493789993498
}

define i64 @orr_64_orr_8() nounwind {
; CHECK-LABEL: orr_64_orr_8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x0, #-6148914691236517206
; CHECK-NEXT:    orr x0, x0, #0xfffff0000000000
; CHECK-NEXT:    ret
  ret i64 -5764607889538110806
}

define i64 @orr_2_eor_16() nounwind {
; CHECK-LABEL: orr_2_eor_16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov  x0, #6148914691236517205
; CHECK-NEXT:    eor  x0, x0, #0x3000300030003000
; CHECK-NEXT:    ret
  ret i64 7301853788297848149
}

define i64 @orr_2_eor_32() nounwind {
; CHECK-LABEL: orr_2_eor_32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov  x0, #6148914691236517205
; CHECK-NEXT:    eor  x0, x0, #0x1fffc0001fffc0
; CHECK-NEXT:    ret
  ret i64 6145912199858268821
}

define i64 @orr_2_eor_64() nounwind {
; CHECK-LABEL: orr_2_eor_64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov  x0, #6148914691236517205
; CHECK-NEXT:    eor  x0, x0, #0x1fffffffffc00
; CHECK-NEXT:    ret
  ret i64 6148727041252043093
}

define i64 @orr_4_eor_8() nounwind {
; CHECK-LABEL: orr_4_eor_8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov  x0, #2459565876494606882
; CHECK-NEXT:    eor  x0, x0, #0x8f8f8f8f8f8f8f8f
; CHECK-NEXT:    ret
  ret i64 12514849900987264429
}

define i64 @orr_4_eor_16() nounwind {
; CHECK-LABEL: orr_4_eor_16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov  x0, #4919131752989213764
; CHECK-NEXT:    eor  x0, x0, #0xf00ff00ff00ff00f
; CHECK-NEXT:    ret
  ret i64 12991675787320734795
}

define i64 @orr_4_eor_32() nounwind {
; CHECK-LABEL: orr_4_eor_32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov  x0, #4919131752989213764
; CHECK-NEXT:    eor  x0, x0, #0x1ff800001ff80000
; CHECK-NEXT:    ret
  ret i64 6610233413460575300
}

define i64 @orr_4_eor_64() nounwind {
; CHECK-LABEL: orr_4_eor_64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov  x0, #1229782938247303441
; CHECK-NEXT:    eor  x0, x0, #0xfff80000000
; CHECK-NEXT:    ret
  ret i64 1229798183233720593
}

define i64 @orr_8_eor_16() nounwind {
; CHECK-LABEL: orr_8_eor_16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov  x0, #3472328296227680304
; CHECK-NEXT:    eor  x0, x0, #0x1f801f801f801f80
; CHECK-NEXT:    ret
  ret i64 3436298949444513712
}

define i64 @orr_8_eor_32() nounwind {
; CHECK-LABEL: orr_8_eor_32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov  x0, #1157442765409226768
; CHECK-NEXT:    eor  x0, x0, #0xffff8001ffff8001
; CHECK-NEXT:    ret
  ret i64 17289195901212921873
}

define i64 @orr_8_eor_64() nounwind {
; CHECK-LABEL: orr_8_eor_64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov  x0, #3472328296227680304
; CHECK-NEXT:    eor  x0, x0, #0x3ffffffff00000
; CHECK-NEXT:    ret
  ret i64 3463215129921859632
}

define i64 @orr_16_eor_32() nounwind {
; CHECK-LABEL: orr_16_eor_32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov  x0, #1143931760365539296
; CHECK-NEXT:    eor  x0, x0, #0xffff0001ffff0001
; CHECK-NEXT:    ret
  ret i64 17302565756451360737
}

define i64 @orr_16_eor_64() nounwind {
; CHECK-LABEL: orr_16_eor_64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov  x0, #9214505439794855904
; CHECK-NEXT:    eor  x0, x0, #0xfe000
; CHECK-NEXT:    ret
  ret i64 9214505439795847136
}

define i64 @orr_32_eor_64() nounwind {
; CHECK-LABEL: orr_32_eor_64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov  x0, #1030792151280
; CHECK-NEXT:    eor  x0, x0, #0xffff8000003fffff
; CHECK-NEXT:    ret
  ret i64 18446604367017541391
}