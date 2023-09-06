
; ZX Spectrum Floating point consts and (some) ROM routines

;upd: 20230905

; based on
; https://zxpress.ru/article.php?id=6609&lng=eng
; ready to use in Pasmo

STK_DIGIT	EQU	$2D22	;Accumulator value = digit in ASCII -> stack
STACK_A		EQU	$2D28	;A -> stack
STACK_BC	EQU	$2D2B	;BC -> stack
FP_TO_BC	EQU	$2DA2	;stack -> BC
STK_STORE	EQU	$2AB1	;A, E, D, C, B -> stack in 5-byte internal format, just send string parameters (in this case A = 0);
STK_FETCH	EQU	$2BF1	;
PRINT_FP	EQU	$2DE3	;

FP_jump_true	EQU	$00	;	jump true
FP_exchange	EQU	$01	;	exchange
FP_delete	EQU	$02	;	delete
FP_subtract	EQU	$03	;	subtract (subtraction; X-Y)
FP_mult		EQU	$04	;	mult (multiplication; X * Y)
FP_div		EQU	$05	;	div (division; Y / X)
FP_to_power	EQU	$06	;	to-power (exponentiation; X ^ Y)
FP_or		EQU	$07	;	or
FP_no		EQU	$08	;	no-'-no
FP_no_l_eq	EQU	$09	;	no-l-eq
FP_no_gr_eq	EQU	$0A	;	no-gr-eq
FP_nos_eql	EQU	$0B	;	nos-eql
FP_no_gtr	EQU	$0C	;	no-gtr
FP_no_less	EQU	$0D	;	no-less
;! FP_nos_eql	EQU	$0E	;	nos-eql
FP_add		EQU	$0F	;	add (addition; X + Y)
FP_str		EQU	$10	;	str-'-no
FP_str_l_eq	EQU	$11	;	str-l-eq
FP_str_gr_eq	EQU	$12	;	str-gr-eq
FP_strs_negl	EQU	$13	;	strs-negl
FP_str_gtr	EQU	$14	;	str-gtr
FP_str_less	EQU	$15	;	str-less
;! FP_str_gtr	EQU	$16	;	str-gtr
FP_strs_add	EQU	$17	;	strs-add
FP_val_s	EQU	$18	;	val $ (recursion, only through the fp-calc-2)
FP_usr_s	EQU	$19	;	usr-s
FP_read_in	EQU	$1A	;	read-in
FP_neg		EQU	$1B	;	neg
FP_code		EQU	$1C	;	code
FP_val		EQU	$1D	;	val (recursion, only through the fp-calc-2)
FP_len		EQU	$1E	;	len
FP_sin		EQU	$1F	;	sin
FP_cos		EQU	$20	;	cos
FP_tan		EQU	$21	;	tan
FP_asn		EQU	$22	;	asn
FP_acs		EQU	$23	;	acs
FP_atn		EQU	$24	;	atn
FP_ln		EQU	$25	;	ln
FP_exp		EQU	$26	;	exp
FP_int		EQU	$27	;	int
FP_sqr		EQU	$28	;	sqr
FP_sgn		EQU	$29	;	sgn
FP_abs		EQU	$2A	;	abs
FP_peek		EQU	$2B	;	peek
FP_int05	EQU	$2C	;	int (Y +0.5)
FP_user_no	EQU	$2D	;	user-no
FP_str_s	EQU	$2E	;	str $
FP_chr		EQU	$2F	;	chr $
FP_not		EQU	$30	;	not
FP_duplicate	EQU	$31	;	duplicate
FP_jump		EQU	$33	;	jump
FP_stk_data	EQU	$34	;	stk-data
FP_djnz		EQU	$35	;	djnz
FP_less_0	EQU	$36	;	less-0
FP_greater_0	EQU	$37	;	greater-0
FP_end_calc	EQU	$38	;	end-calc (completion of the work with a calculator)
FP_get_argt	EQU	$39	;	get-argt
FP_trunc	EQU	$3A	;	trunc
FP_fp_calc_2	EQU	$3B	;	fp-calc-2 (secondary call calculator)
FP_e_to_fp	EQU	$3C	;	e-to-fp
FP_restack	EQU	$3D	;	restack (Y integer -> Y in the floating form)
FP_series_2006	EQU	$86	;and beyond	;	series-2006
FP_0		EQU	$A0	;	0 (constant, entering the stack constant)
FP_1		EQU	$A1	;	1
FP_02_sty	EQU	$A2	;	02-sty
FP_PI_2		EQU	$A3	;	PI / 2
FP_st_mem_0	EQU	$C0	;and more	;	st-mem-0
FP_get_mem_0	EQU	$E0	;and more	;	get-mem-0

