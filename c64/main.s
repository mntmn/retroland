;
; File generated by cc65 v 2.15 - Git d34edf8
;
	.fopt		compiler,"cc65 v 2.15 - Git d34edf8"
	.setcpu		"6502"
	.smart		on
	.autoimport	on
	.case		on
	.debuginfo	off
	.importzp	sp, sreg, regsave, regbank
	.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
	.macpack	longbranch
	.forceimport	__STARTUP__
	.import		_cbm_k_chkin
	.import		_cbm_k_getin
	.import		_cbm_k_open
	.import		_cbm_k_setlfs
	.import		_cbm_k_setnam
	.import		_TILES
	.export		_screen
	.export		_colormap
	.export		_vic_banksel
	.export		_vic_font
	.export		_vic_border
	.export		_vic_bg
	.export		_copy_tiles
	.export		_map
	.export		_rand_map
	.export		_paint_tile
	.export		_paint_map
	.export		_recv_tile
	.export		_init_serial
	.export		_main

.segment	"DATA"

_screen:
	.word	$0400
_colormap:
	.word	$D800
_vic_banksel:
	.word	$D018
_vic_font:
	.word	$3800
_vic_border:
	.word	$D020
_vic_bg:
	.word	$D021

.segment	"BSS"

_map:
	.res	240,$00

; ---------------------------------------------------------------
; void __near__ copy_tiles (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_copy_tiles: near

.segment	"CODE"

	jsr     decsp2
	ldx     #$00
	lda     #$00
	ldy     #$00
	jsr     staxysp
L000D:	ldy     #$01
	jsr     ldaxysp
	cmp     #$00
	txa
	sbc     #$08
	bvc     L0014
	eor     #$80
L0014:	asl     a
	lda     #$00
	ldx     #$00
	rol     a
	jne     L0010
	jmp     L000E
L0010:	lda     _vic_font
	ldx     _vic_font+1
	jsr     pushax
	ldy     #$03
	jsr     ldaxysp
	jsr     tosaddax
	jsr     pushax
	lda     #<(_TILES)
	ldx     #>(_TILES)
	ldy     #$02
	clc
	adc     (sp),y
	pha
	txa
	iny
	adc     (sp),y
	tax
	pla
	ldy     #$00
	jsr     ldauidx
	ldy     #$00
	jsr     staspidx
	ldy     #$01
	jsr     ldaxysp
	sta     regsave
	stx     regsave+1
	jsr     incax1
	ldy     #$00
	jsr     staxysp
	lda     regsave
	ldx     regsave+1
	jmp     L000D
L000E:	jsr     incsp2
	rts

.endproc

; ---------------------------------------------------------------
; void __near__ rand_map (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_rand_map: near

.segment	"CODE"

	jsr     decsp2
	ldx     #$00
	lda     #$00
	ldy     #$00
	jsr     staxysp
L001C:	ldy     #$01
	jsr     ldaxysp
	cmp     #$F0
	txa
	sbc     #$00
	bvc     L0023
	eor     #$80
L0023:	asl     a
	lda     #$00
	ldx     #$00
	rol     a
	jne     L001F
	jmp     L001D
L001F:	lda     #<(_map)
	ldx     #>(_map)
	ldy     #$00
	clc
	adc     (sp),y
	pha
	txa
	iny
	adc     (sp),y
	tax
	pla
	jsr     pushax
	ldx     #$00
	lda     #$02
	ldy     #$00
	jsr     staspidx
	ldy     #$01
	jsr     ldaxysp
	sta     regsave
	stx     regsave+1
	jsr     incax1
	ldy     #$00
	jsr     staxysp
	lda     regsave
	ldx     regsave+1
	jmp     L001C
L001D:	ldx     #$00
	lda     #$00
	sta     _map+42
	ldx     #$00
	lda     #$00
	sta     _map+44
	ldx     #$00
	lda     #$00
	sta     _map+64
	ldx     #$00
	lda     #$01
	sta     _map+106
	ldx     #$00
	lda     #$01
	sta     _map+126
	ldx     #$00
	lda     #$01
	sta     _map+127
	ldx     #$00
	lda     #$01
	sta     _map+146
	ldx     #$00
	lda     #$11
	sta     _map+128
	ldx     #$00
	lda     #$11
	sta     _map+147
	ldx     #$00
	lda     #$10
	sta     _map+156
	jsr     incsp2
	rts

.endproc

; ---------------------------------------------------------------
; void __near__ paint_tile (int, int)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_paint_tile: near

.segment	"CODE"

	jsr     pushax
	ldy     #$0C
	jsr     subysp
	ldy     #$0D
	jsr     ldaxysp
	jsr     pushax
	ldx     #$00
	lda     #$14
	jsr     tosmulax
	jsr     pushax
	ldy     #$11
	jsr     ldaxysp
	jsr     tosaddax
	ldy     #$04
	jsr     staxysp
	lda     #<(_map)
	ldx     #>(_map)
	ldy     #$04
	clc
	adc     (sp),y
	pha
	txa
	iny
	adc     (sp),y
	tax
	pla
	ldy     #$00
	jsr     ldauidx
	ldx     #$00
	ldy     #$00
	jsr     staxysp
	ldy     #$01
	jsr     ldaxysp
	jsr     asrax4
	ldy     #$06
	jsr     staxysp
	ldy     #$01
	jsr     ldaxysp
	ldx     #$00
	and     #$0F
	jsr     aslax1
	ldy     #$08
	jsr     staxysp
	ldy     #$07
	jsr     ldaxysp
	jsr     aslax4
	jsr     aslax1
	jsr     pushax
	ldy     #$0B
	jsr     ldaxysp
	jsr     tosaddax
	ldy     #$02
	jsr     staxysp
	ldy     #$0F
	jsr     ldaxysp
	jsr     aslax1
	jsr     pushax
	ldy     #$0F
	jsr     ldaxysp
	jsr     aslax1
	jsr     pushax
	ldx     #$00
	lda     #$28
	jsr     tosmulax
	jsr     tosaddax
	ldy     #$0A
	jsr     staxysp
	lda     _screen
	ldx     _screen+1
	jsr     pushax
	ldy     #$0D
	jsr     ldaxysp
	jsr     tosaddax
	jsr     pushax
	ldy     #$04
	ldx     #$00
	lda     (sp),y
	ldy     #$00
	jsr     staspidx
	lda     _screen
	ldx     _screen+1
	jsr     pushax
	ldy     #$0D
	jsr     ldaxysp
	jsr     incax1
	jsr     tosaddax
	jsr     pushax
	ldy     #$05
	jsr     ldaxysp
	jsr     incax1
	ldx     #$00
	ldy     #$00
	jsr     staspidx
	lda     _screen
	ldx     _screen+1
	jsr     pushax
	ldy     #$0D
	jsr     ldaxysp
	ldy     #$28
	jsr     incaxy
	jsr     tosaddax
	jsr     pushax
	ldy     #$05
	jsr     ldaxysp
	ldy     #$10
	jsr     incaxy
	ldx     #$00
	ldy     #$00
	jsr     staspidx
	lda     _screen
	ldx     _screen+1
	jsr     pushax
	ldy     #$0D
	jsr     ldaxysp
	ldy     #$29
	jsr     incaxy
	jsr     tosaddax
	jsr     pushax
	ldy     #$05
	jsr     ldaxysp
	ldy     #$11
	jsr     incaxy
	ldx     #$00
	ldy     #$00
	jsr     staspidx
	lda     _colormap
	ldx     _colormap+1
	jsr     pushax
	ldy     #$0D
	jsr     ldaxysp
	jsr     tosaddax
	jsr     pushax
	ldy     #$02
	ldx     #$00
	lda     (sp),y
	ldy     #$00
	jsr     staspidx
	lda     _colormap
	ldx     _colormap+1
	jsr     pushax
	ldy     #$0D
	jsr     ldaxysp
	jsr     incax1
	jsr     tosaddax
	jsr     pushax
	ldy     #$02
	ldx     #$00
	lda     (sp),y
	ldy     #$00
	jsr     staspidx
	lda     _colormap
	ldx     _colormap+1
	jsr     pushax
	ldy     #$0D
	jsr     ldaxysp
	ldy     #$28
	jsr     incaxy
	jsr     tosaddax
	jsr     pushax
	ldy     #$02
	ldx     #$00
	lda     (sp),y
	ldy     #$00
	jsr     staspidx
	lda     _colormap
	ldx     _colormap+1
	jsr     pushax
	ldy     #$0D
	jsr     ldaxysp
	ldy     #$29
	jsr     incaxy
	jsr     tosaddax
	jsr     pushax
	ldy     #$02
	ldx     #$00
	lda     (sp),y
	ldy     #$00
	jsr     staspidx
	ldy     #$10
	jsr     addysp
	rts

.endproc

; ---------------------------------------------------------------
; void __near__ paint_map (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_paint_map: near

.segment	"CODE"

	ldy     #$10
	jsr     subysp
	ldx     #$00
	lda     #$00
	ldy     #$04
	jsr     staxysp
	ldx     #$00
	lda     #$00
	ldy     #$0A
	jsr     staxysp
	ldx     #$00
	lda     #$00
	ldy     #$0C
	jsr     staxysp
L0075:	ldy     #$0D
	jsr     ldaxysp
	cmp     #$18
	txa
	sbc     #$00
	bvc     L007C
	eor     #$80
L007C:	asl     a
	lda     #$00
	ldx     #$00
	rol     a
	jne     L0078
	jmp     L0076
L0078:	ldx     #$00
	lda     #$00
	ldy     #$0E
	jsr     staxysp
L007F:	ldy     #$0F
	jsr     ldaxysp
	cmp     #$28
	txa
	sbc     #$00
	bvc     L0086
	eor     #$80
L0086:	asl     a
	lda     #$00
	ldx     #$00
	rol     a
	jne     L0082
	jmp     L0080
L0082:	lda     #<(_map)
	ldx     #>(_map)
	ldy     #$04
	clc
	adc     (sp),y
	pha
	txa
	iny
	adc     (sp),y
	tax
	pla
	ldy     #$00
	jsr     ldauidx
	ldx     #$00
	ldy     #$00
	jsr     staxysp
	lda     #<(_map)
	ldx     #>(_map)
	ldy     #$04
	clc
	adc     (sp),y
	pha
	txa
	iny
	adc     (sp),y
	tax
	pla
	ldy     #$00
	jsr     ldauidx
	jsr     shrax4
	ldy     #$06
	jsr     staxysp
	lda     #<(_map)
	ldx     #>(_map)
	ldy     #$04
	clc
	adc     (sp),y
	pha
	txa
	iny
	adc     (sp),y
	tax
	pla
	ldy     #$00
	jsr     ldauidx
	ldx     #$00
	and     #$0F
	jsr     shlax1
	ldy     #$08
	jsr     staxysp
	ldy     #$07
	jsr     ldaxysp
	jsr     aslax4
	jsr     aslax1
	jsr     pushax
	ldy     #$0B
	jsr     ldaxysp
	jsr     tosaddax
	ldy     #$02
	jsr     staxysp
	lda     _screen
	ldx     _screen+1
	jsr     pushax
	ldy     #$0D
	jsr     ldaxysp
	jsr     tosaddax
	jsr     pushax
	ldy     #$04
	ldx     #$00
	lda     (sp),y
	ldy     #$00
	jsr     staspidx
	lda     _screen
	ldx     _screen+1
	jsr     pushax
	ldy     #$0D
	jsr     ldaxysp
	jsr     incax1
	jsr     tosaddax
	jsr     pushax
	ldy     #$05
	jsr     ldaxysp
	jsr     incax1
	ldx     #$00
	ldy     #$00
	jsr     staspidx
	lda     _screen
	ldx     _screen+1
	jsr     pushax
	ldy     #$0D
	jsr     ldaxysp
	ldy     #$28
	jsr     incaxy
	jsr     tosaddax
	jsr     pushax
	ldy     #$05
	jsr     ldaxysp
	ldy     #$10
	jsr     incaxy
	ldx     #$00
	ldy     #$00
	jsr     staspidx
	lda     _screen
	ldx     _screen+1
	jsr     pushax
	ldy     #$0D
	jsr     ldaxysp
	ldy     #$29
	jsr     incaxy
	jsr     tosaddax
	jsr     pushax
	ldy     #$05
	jsr     ldaxysp
	ldy     #$11
	jsr     incaxy
	ldx     #$00
	ldy     #$00
	jsr     staspidx
	ldy     #$0A
	ldx     #$00
	lda     #$02
	jsr     addeqysp
	ldy     #$05
	jsr     ldaxysp
	sta     regsave
	stx     regsave+1
	jsr     incax1
	ldy     #$04
	jsr     staxysp
	lda     regsave
	ldx     regsave+1
	ldy     #$0E
	ldx     #$00
	lda     #$02
	jsr     addeqysp
	jmp     L007F
L0080:	ldy     #$0A
	ldx     #$00
	lda     #$28
	jsr     addeqysp
	ldy     #$0C
	ldx     #$00
	lda     #$02
	jsr     addeqysp
	jmp     L0075
L0076:	ldx     #$00
	lda     #$00
	ldy     #$0E
	jsr     staxysp
L00A6:	ldy     #$0F
	jsr     ldaxysp
	cmp     #$28
	txa
	sbc     #$00
	bvc     L00AD
	eor     #$80
L00AD:	asl     a
	lda     #$00
	ldx     #$00
	rol     a
	jne     L00A9
	jmp     L00A7
L00A9:	lda     _screen
	ldx     _screen+1
	jsr     pushax
	ldy     #$0D
	jsr     ldaxysp
	jsr     pushax
	ldy     #$13
	jsr     ldaxysp
	jsr     tosaddax
	jsr     tosaddax
	jsr     pushax
	ldx     #$00
	lda     #$FF
	ldy     #$00
	jsr     staspidx
	ldy     #$0F
	jsr     ldaxysp
	sta     regsave
	stx     regsave+1
	jsr     incax1
	ldy     #$0E
	jsr     staxysp
	lda     regsave
	ldx     regsave+1
	jmp     L00A6
L00A7:	ldy     #$10
	jsr     addysp
	rts

.endproc

; ---------------------------------------------------------------
; unsigned char __near__ recv_tile (int, int)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_recv_tile: near

.segment	"CODE"

	jsr     pushax
	jsr     _cbm_k_getin
	jsr     pusha
	ldy     #$00
	lda     (sp),y
	jeq     L00B4
	ldy     #$02
	jsr     ldaxysp
	jsr     pushax
	ldx     #$00
	lda     #$14
	jsr     tosmulax
	jsr     pushax
	ldy     #$06
	jsr     ldaxysp
	jsr     tosaddax
	clc
	adc     #<(_map)
	tay
	txa
	adc     #>(_map)
	tax
	tya
	jsr     pushax
	ldy     #$02
	ldx     #$00
	lda     (sp),y
	jsr     decax1
	ldx     #$00
	ldy     #$00
	jsr     staspidx
	ldy     #$04
	jsr     ldaxysp
	jsr     pushax
	ldy     #$04
	jsr     ldaxysp
	jsr     _paint_tile
L00B4:	ldy     #$00
	ldx     #$00
	lda     (sp),y
	jmp     L00B2
L00B2:	jsr     incsp5
	rts

.endproc

; ---------------------------------------------------------------
; void __near__ init_serial (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_init_serial: near

.segment	"RODATA"

L00BF:
	.byte	$08
	.byte	$A1
	.byte	$00

.segment	"CODE"

	jsr     decsp3
	ldy     #$02
L00C3:	lda     L00BF,y
	sta     (sp),y
	dey
	bpl     L00C3
	lda     #$02
	jsr     pusha
	lda     #$02
	jsr     pusha
	lda     #$00
	jsr     _cbm_k_setlfs
	lda     sp
	ldx     sp+1
	jsr     _cbm_k_setnam
	jsr     _cbm_k_open
	lda     #$02
	jsr     _cbm_k_chkin
	lda     _screen
	ldx     _screen+1
	jsr     pushax
	ldx     #$00
	lda     #$D3
	ldy     #$00
	jsr     staspidx
	jsr     incsp3
	rts

.endproc

; ---------------------------------------------------------------
; int __near__ main (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_main: near

.segment	"CODE"

	jsr     decsp4
	lda     _vic_border
	ldx     _vic_border+1
	jsr     pushax
	ldx     #$00
	lda     #$01
	ldy     #$00
	jsr     staspidx
	jsr     _init_serial
	lda     _vic_border
	ldx     _vic_border+1
	jsr     pushax
	ldx     #$00
	lda     #$00
	ldy     #$00
	jsr     staspidx
	lda     _vic_bg
	ldx     _vic_bg+1
	jsr     pushax
	ldx     #$00
	lda     #$00
	ldy     #$00
	jsr     staspidx
	lda     _vic_banksel
	ldx     _vic_banksel+1
	jsr     pushax
	lda     _vic_banksel
	ldx     _vic_banksel+1
	ldy     #$00
	jsr     ldauidx
	ora     #$0E
	ldx     #$00
	ldy     #$00
	jsr     staspidx
	jsr     _copy_tiles
	ldx     #$00
	lda     #$00
	ldy     #$02
	jsr     staxysp
	ldx     #$00
	lda     #$00
	ldy     #$00
	jsr     staxysp
	jmp     L00E1
L00DF:	ldy     #$03
	jsr     ldaxysp
	jsr     pushax
	ldy     #$03
	jsr     ldaxysp
	jsr     _recv_tile
	jsr     pusha
	ldy     #$00
	lda     (sp),y
	jeq     L00EF
	ldy     #$04
	jsr     ldaxysp
	sta     regsave
	stx     regsave+1
	jsr     incax1
	ldy     #$03
	jsr     staxysp
	lda     regsave
	ldx     regsave+1
	ldy     #$04
	jsr     ldaxysp
	cmp     #$14
	txa
	sbc     #$00
	bvs     L00EB
	eor     #$80
L00EB:	asl     a
	lda     #$00
	ldx     #$00
	rol     a
	jeq     L00E9
	ldx     #$00
	lda     #$00
	ldy     #$03
	jsr     staxysp
	ldy     #$02
	jsr     ldaxysp
	sta     regsave
	stx     regsave+1
	jsr     incax1
	ldy     #$01
	jsr     staxysp
	lda     regsave
	ldx     regsave+1
L00E9:	ldy     #$02
	jsr     ldaxysp
	cmp     #$0C
	txa
	sbc     #$00
	bvs     L00F1
	eor     #$80
L00F1:	asl     a
	lda     #$00
	ldx     #$00
	rol     a
	jeq     L00EF
	ldx     #$00
	lda     #$00
	ldy     #$01
	jsr     staxysp
L00EF:	jsr     incsp1
L00E1:	jmp     L00DF
	ldx     #$00
	lda     #$00
	jmp     L00D0
L00D0:	jsr     incsp4
	rts

.endproc
