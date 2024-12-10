; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --mtriple=loongarch32 --mattr=+d < %s | FileCheck %s --check-prefix=LA32
; RUN: llc --mtriple=loongarch64 --mattr=+d < %s | FileCheck %s --check-prefix=LA64

;; Check the $fcc* register is spilled before funtion call and then reloaded.
declare void @foo()

define i1 @load_store_fcc_reg(float %a, i1 %c) {
; LA32-LABEL: load_store_fcc_reg:
; LA32:       # %bb.0:
; LA32-NEXT:    addi.w $sp, $sp, -32
; LA32-NEXT:    .cfi_def_cfa_offset 32
; LA32-NEXT:    st.w $ra, $sp, 28 # 4-byte Folded Spill
; LA32-NEXT:    st.w $fp, $sp, 24 # 4-byte Folded Spill
; LA32-NEXT:    fst.d $fs0, $sp, 16 # 8-byte Folded Spill
; LA32-NEXT:    fst.d $fs1, $sp, 8 # 8-byte Folded Spill
; LA32-NEXT:    .cfi_offset 1, -4
; LA32-NEXT:    .cfi_offset 22, -8
; LA32-NEXT:    .cfi_offset 56, -16
; LA32-NEXT:    .cfi_offset 57, -24
; LA32-NEXT:    move $fp, $a0
; LA32-NEXT:    fmov.s $fs0, $fa0
; LA32-NEXT:    movgr2fr.w $fs1, $zero
; LA32-NEXT:    fcmp.cult.s $fcc0, $fs1, $fa0
; LA32-NEXT:    movcf2gr $a0, $fcc0
; LA32-NEXT:    st.w $a0, $sp, 4
; LA32-NEXT:    bl %plt(foo)
; LA32-NEXT:    ld.w $a0, $sp, 4
; LA32-NEXT:    movgr2cf $fcc0, $a0
; LA32-NEXT:    bcnez $fcc0, .LBB0_2
; LA32-NEXT:  # %bb.1: # %if.then
; LA32-NEXT:    move $a0, $fp
; LA32-NEXT:    b .LBB0_3
; LA32-NEXT:  .LBB0_2: # %if.else
; LA32-NEXT:    fcmp.cle.s $fcc0, $fs0, $fs1
; LA32-NEXT:    movcf2gr $a0, $fcc0
; LA32-NEXT:  .LBB0_3: # %if.then
; LA32-NEXT:    fld.d $fs1, $sp, 8 # 8-byte Folded Reload
; LA32-NEXT:    fld.d $fs0, $sp, 16 # 8-byte Folded Reload
; LA32-NEXT:    ld.w $fp, $sp, 24 # 4-byte Folded Reload
; LA32-NEXT:    ld.w $ra, $sp, 28 # 4-byte Folded Reload
; LA32-NEXT:    addi.w $sp, $sp, 32
; LA32-NEXT:    ret
;
; LA64-LABEL: load_store_fcc_reg:
; LA64:       # %bb.0:
; LA64-NEXT:    addi.d $sp, $sp, -48
; LA64-NEXT:    .cfi_def_cfa_offset 48
; LA64-NEXT:    st.d $ra, $sp, 40 # 8-byte Folded Spill
; LA64-NEXT:    st.d $fp, $sp, 32 # 8-byte Folded Spill
; LA64-NEXT:    fst.d $fs0, $sp, 24 # 8-byte Folded Spill
; LA64-NEXT:    fst.d $fs1, $sp, 16 # 8-byte Folded Spill
; LA64-NEXT:    .cfi_offset 1, -8
; LA64-NEXT:    .cfi_offset 22, -16
; LA64-NEXT:    .cfi_offset 56, -24
; LA64-NEXT:    .cfi_offset 57, -32
; LA64-NEXT:    move $fp, $a0
; LA64-NEXT:    fmov.s $fs0, $fa0
; LA64-NEXT:    movgr2fr.w $fs1, $zero
; LA64-NEXT:    fcmp.cult.s $fcc0, $fs1, $fa0
; LA64-NEXT:    movcf2gr $a0, $fcc0
; LA64-NEXT:    st.d $a0, $sp, 8
; LA64-NEXT:    bl %plt(foo)
; LA64-NEXT:    ld.d $a0, $sp, 8
; LA64-NEXT:    movgr2cf $fcc0, $a0
; LA64-NEXT:    bcnez $fcc0, .LBB0_2
; LA64-NEXT:  # %bb.1: # %if.then
; LA64-NEXT:    move $a0, $fp
; LA64-NEXT:    b .LBB0_3
; LA64-NEXT:  .LBB0_2: # %if.else
; LA64-NEXT:    fcmp.cle.s $fcc0, $fs0, $fs1
; LA64-NEXT:    movcf2gr $a0, $fcc0
; LA64-NEXT:  .LBB0_3: # %if.then
; LA64-NEXT:    fld.d $fs1, $sp, 16 # 8-byte Folded Reload
; LA64-NEXT:    fld.d $fs0, $sp, 24 # 8-byte Folded Reload
; LA64-NEXT:    ld.d $fp, $sp, 32 # 8-byte Folded Reload
; LA64-NEXT:    ld.d $ra, $sp, 40 # 8-byte Folded Reload
; LA64-NEXT:    addi.d $sp, $sp, 48
; LA64-NEXT:    ret
  %cmp = fcmp ole float %a, 0.000000e+00
  call void @foo()
  br i1 %cmp, label %if.then, label %if.else

if.then:
  ret i1 %c

if.else:
  ret i1 %cmp
}