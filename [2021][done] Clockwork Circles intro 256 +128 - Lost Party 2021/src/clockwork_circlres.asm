
;'Clockwork Circles' by GDC - 256 bytes intro for ZX Spectrum 128
;(c)2020-2021 MoNsTeR/GDC, Jakub Noniewicz, noniewicz.com, noniewicz.art.pl
;created 20200829
;updated 20200830
;updated 20210630

;todo:
;- all done!


SCRN	EQU	16384		;screen pixels mem
SSIZE	EQU	6144		;screen size

;ATTR	EQU	22528		;screen attr mem
;banked on 128 is here
ATTR	EQU	$c000+SSIZE	;screen attr mem

ASIZE	EQU	768		;attr size

VA	equ	$BF00		;var area (256 max)
CNT1	EQU	VA+0		;1
CNT2	EQU	VA+1		;1
CNT3	EQU	VA+2		;1

x1	EQU	VA+3		;1
y1	EQU	VA+4		;1
x2	EQU	VA+5		;1
y2	EQU	VA+6		;1
x3	EQU	VA+7		;1
y3	EQU	VA+8		;1

at_adr	EQU	VA+9		;24*2

SINSIZE	EQU	48		;sin tab size

;----------------------------------------------------
; MEM MAP:
;$8000	$80ff	256	code+data
;...
;$BF000	$BFFF	256	vars/data area
;$c000	$FFFF	?	dbl buffered screen

;----------------------------------------------------

	org	32768

init0

;note: no room for code to clear vars

	ld	bc, SINSIZE
	ld	de, sin_tab_cp
	ld	hl, sin_tab
	ldir				;extend sin tab for use as cos tab

;----------------------------------------------------
;generate table 24 pix ATTR addr word starts in at_adr

;precalc
	ld	hl, ATTR
	ld	ix, at_adr
	ld	b, 24
	ld	de, 32

pc1	ld	(ix+0), l
	ld	(ix+1), h
	inc	ix
	inc	ix
	add	hl, de
	djnz	pc1

;----------------------------------------------------

;Bits 0-2: RAM page (0-7) to map into memory at 0xc000.
;Bit 3: Select normal (0) or shadow (1) screen to be displayed. The normal screen is in bank 5, whilst the shadow screen is in bank 7.
;Bit 4: ROM select. ROM 0 is the 128k editor and menu system; ROM 1 contains 48K BASIC.
;Bit 5: If set, memory paging will be disabled and further output to this port will be ignored until the computer is reset.

;0xffff +--------+--------+--------+--------+--------+--------+--------+--------+
;       | Bank 0 | Bank 1 | Bank 2 | Bank 3 | Bank 4 | Bank 5 | Bank 6 | Bank 7 |
;       |        |        |(also at|        |        |(also at|        |        |
;       |        |        | 0x8000)|        |        | 0x4000)|        |        |
;       |        |        |        |        |        | screen |        | screen |
;0xc000 +--------+--------+--------+--------+--------+--------+--------+--------+

;----------------------------------------------------
; main loop

main
	ld	a, %00011101	;show shadow screen / write to normal screen
	; KW - added 4 bit to 1 -- always use ROM 1 (48k basic)
	call	bank_cls_draw
	ld	a, %00010111	    ;show normal screen / write to shadow screen
	; KW - added 4 bit to 1 -- always use ROM 1 (48k basic)
	call	bank_cls_draw
	jr	main

;----------------------------------------------------

bank_cls_draw

;bank
;	LD	A, ($5b5c)
;	and	%11110000
;	or	b
	ld	bc, $7ffd
;	DI
	LD	($5b5c), A	;must?!
	OUT	(C), A
;	EI

;acls
	halt			;placed here, after cls - lame flicker
	halt			;2nd needed for 48 sin table (was too fast)

	xor	a
	out	(254), a	;placed here, to spare one xor a call
	ld	bc, ASIZE-1
	ld	de, ATTR+1
	ld	hl, ATTR
	ld	(hl), a
	ldir

;draw_f
	ld	b, SINSIZE
	ld	d, a		;assume prev a=0

dlp	push	bc		;draw 3x circle at given pos with given color
	ld	e, b
	ld	ix, x1
;!	ld	a, %01010010
	call	drawer
	ld	(hl), %01010010
;!	ld	a, %01101101
	call	drawer		;for ix=x2
	ld	(hl), %01101101
;!	ld	a, %01110110
	call	drawer		;for ix=x3
	ld	(hl), %01110110
	pop	bc
	djnz	dlp

	ld	hl, CNT1	;next CNT2, CNT3
	push	hl

	call	mover
	ld	(x1), bc	;x=c, y=b
	call	mover
	ld	(x2), bc	;x=c, y=b
	call	mover
	ld	(x3), bc	;x=c, y=b

	pop	hl
;	ld	hl, CNT1	;assume CNT1/CNT2/CNT3 in such order

	inc	(hl)
	inc	hl
	inc	(hl)
	inc	(hl)
	inc	hl
	inc	(hl)
	inc	(hl)
	inc	(hl)

	ret

;----------------------------------------------------
;

drawer
;!	push	af
	ld	hl, sin_tab+SINSIZE/4	;sin as cos
	add	hl, de
	ld	c, (hl)
	ld	a, (ix+0)
	adc	a, c
	ld	c, a
	ld	hl, sin_tab
	add	hl, de
	ld	b, (hl)
	ld	a, (ix+1)
	adc	a, b
	ld	b, a
;!	pop	af
	inc	ix		;note: assume x1/y1/x2/y2/x3/y3 folloe in such order
	inc	ix

;	jr	putPix

;----------------------------------------------------
; put attr pixel, chk if in range
;in: bc = y, x / old: a = color

putPix	push	de
;!	push	af
;note chk removed for code size opt
;	ld	a, c
;	cp	32
;	jr	nc, nopix
	ld	a, b
;note chk removed for code size opt
;	cp	24
;	jr	nc, nopix
	sla	a
	ld	e, a
	xor	a
	ld	d, a
	ld	hl, at_adr
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ex	de, hl
	ld	b, a		; zero
	add	hl, bc
;!	pop	af
	pop	de
;!	ld	(hl), a
	ret

;nopix	pop	af
;	pop	de
;	ret

;----------------------------------------------------
;move circle center (also in circle)
;in: HL 8-bit counter addr
;out: b=y, c=x of center offset

mover	push	hl
	ld	a, (hl)

;	and	SINSIZE-1
	cp	SINSIZE
	jr	nz, movego
	xor	a
	ld	(hl), a

movego	ld	e, a
	ld	d, 0
	ld	hl, sin_tab+SINSIZE/4	;offset cos from sin
	add	hl, de
	ld	a, (hl)
	sbc	a, 16-4-4		;fix for sin reused as cos
	ld	c, a
	ld	hl, sin_tab
	add	hl, de
	ld	a, (hl)
	sbc	a, 12
	ld	b, a
	pop	hl
	inc	hl			;assume CNT1/CNT2/CNT3 follow
	ret

cde_end	equ $
code_len equ cde_end-init0

;----------------------------------------------------
; data

data_start

;note: do sin dodac 1/4 okresu zeby zlapac cos

sin_tab incbin "data/sin48-5.bin"
sin_tab_cp

data_end	equ	$
data_len	equ	data_end-data_start

;----------------------------------------------------

eof  equ $
total_len equ eof-init0

;### EOF
end init0
