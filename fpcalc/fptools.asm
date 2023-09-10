
;FP tools
;(c)2023 MoNsTeR/GDC, Jakub Noniewicz, noniewicz.com
;created 20230907
;updated 20230908, 09, 10

;todo:
;- ?

;note: buf5 ds 5 must be declared

;----------------------------------------------------
; FP tools

; mul A*BC/1000

mulABC	push	hl

	push	bc
	push	af
	ld	bc, 1000
	call	STACK_BC
	pop	af
	call	STACK_A
	pop	bc
	call	STACK_BC	;bc = fp const * 100

	rst	$28
	db	FP_mult
	db	FP_exchange
	db	FP_div
	db	FP_end_calc

	call	to5

	pop	hl
	ret

;---

; mul -A*BC/1000

mulABCn	push	hl

	push	bc
	push	af
	ld	bc, 1000
	call	STACK_BC
	pop	af
	call	STACK_A
	pop	bc
	call	STACK_BC	;bc = fp const * 100

	rst	$28
	db	FP_mult
	db	FP_exchange
	db	FP_div
	db	FP_neg
	db	FP_end_calc

	call	to5

	pop	hl
	ret

;---

to5	ld	hl, buf5
to5x	push	hl
	call	STK_FETCH
	pop	hl
	ld	(hl), a
	inc	hl
	ld	(hl), e
	inc	hl
	ld	(hl), d
	inc	hl
	ld	(hl), c
	inc	hl
	ld	(hl), b
	ret

;---

fr5	ld	hl, buf5
fr5x	ld	a, (hl)
	inc	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	jp	STK_STORE

;---

ld5	ld	hl, buf5
ld5x	ld	bc, 5
	ldir
	ret

;---

PRFP	call	PRINT_FP
	ld	a, 13
	rst	16
	ret

;----------------------------------------------------
; rnd (almost like in ROM)

RANDOMIZE
	ld	a, r
	ld	c, a
	ld	h, 0
	ld	l, a
	ld	b, (hl)
	ld ($5C76), bc
	ret

SRND	LD	BC,($5C76)      ; fetch system variable SEED
	CALL	STACK_BC

	RST	28H             ;; FP-CALC           ;s.
	db	$A1             ;;stk-one            ;s,1.
	db	$0F             ;;addition           ;s+1.
	db	$34             ;;stk-data           ;
	db	$37             ;;Exponent: $87, Bytes: 1
	db	$16             ;;(+00,+00,+00)      ;s+1,75.
	db	$04             ;;multiply           ;(s+1)*75 = v
	db	$34             ;;stk-data           ;v.
	db	$80             ;;Bytes: 3
	db	$41             ;;Exponent $91
	db	$00,$00,$80     ;;(+00)              ;v,65537.
	db	$32             ;;n-mod-m            ;remainder, result.
	db	$02             ;;delete             ;remainder.
	db	$A1             ;;stk-one            ;remainder, 1.
	db	$03             ;;subtract           ;remainder - 1. = rnd
	db	$31             ;;duplicate          ;rnd,rnd.
	db	$38             ;;end-calc

	CALL	FP_TO_BC
	LD	($5C76), BC      ; store in SEED for next starting point
	LD	A, (HL)          ; fetch exponent
	AND	A                ; is it zero ?
	JR	Z, L2625         ; forward if so to S-RND-END

	SUB	$10              ; reduce exponent by 2^16
	LD	(HL), A          ; place back

L2625	jp	to5

;----------------------------------------------------

include "zxfpconsts.asm"

;### EOF

