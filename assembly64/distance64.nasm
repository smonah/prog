section .data			; Sezione contenente dati inizializzati

section .bss			; Sezione contenente dati non inizializzati

section .text			; Sezione contenente il codice macchina

;TESTATA

global distance

distance:
		; ------------------------------------------------------------
		; Sequenza di ingresso nella funzione
		; ------------------------------------------------------------
		push	rbp				; salva il Base Pointer
		mov		rbp, rsp	; il Base Pointer punta al Record di Attivazione corrente
		push	rax				; salva i registri generali
		push	rcx


		;--------------------------------
		;PARAMETRI
		;--------------------------------

		;rdi (r6) = indirizzo di partenza dell'array x1
		;rsi (r5) = indirizzo di partenza dell'array x2
		;rdx (r5) = dimensione n degli array x ed y

;		extern float distance(VECTOR x1,VECTOR x2,int d);
		;--------------------------------
		;ESECUZIONE
		;---------------------------------

		mov rax,rdi ; metto in rax l'indirizzo di partenza di x1
		mov rcx,rsi ; metto in rcx l'indirizzo di partenza di x2
		;la dimensione n dei vettori si trova già in rdx

		vxorps	ymm2, ymm2 ; azzero ymm2 dove metterò la somma

for_128:
		cmp rdx, 128	    ; Confronto edx < 32 ?
  	jl for_16      ; Se edx è strettamente minore di 32, gestisco il residuo

		;Loop Unrolling 1: 8 valori
		vmovaps ymm0, [rax]    ; in ymm0 metto i primi 8 valori di x1
		vmovaps ymm1, [rcx]    ; in ymm1 metto i primi 8 valori di x2

		vsubps ymm0, ymm1      ; ymm0 = ymm0-ymm1  (x1-x2)  diff = x1[i]-x2[i];
		vmulps ymm0, ymm0      ; ymm0 = ymm0*ymm0           diff*diff;
		vaddps ymm2, ymm0      ; ymm2 = ymm2+ymm0           sum += diff*diff

		;Loop Unrolling 2: 8 valori
		vmovaps ymm0, [rax+32]    ; in ymm0 metto i secondi 8 valori di x1
		vmovaps ymm1, [rcx+32]    ; in ymm1 metto i secondi 8 valori di x2

		vsubps ymm0, ymm1      ; ymm0 = ymm0-ymm1  (x1-x2)  diff = x1[i]-x2[i];
		vmulps ymm0, ymm0      ; ymm0 = ymm0*ymm0           diff*diff;
		vaddps ymm2, ymm0      ; ymm2 = ymm2+ymm0           sum += diff*diff

		;Loop Unrolling 3: 8 valori
		vmovaps ymm0, [rax+64]    ; in ymm0 metto i terzi 8 valori di x1
		vmovaps ymm1, [rcx+64]    ; in ymm1 metto i terzi 8 valori di x2

		vsubps ymm0, ymm1      ; ymm0 = ymm0-ymm1  (x1-x2)  diff = x1[i]-x2[i];
		vmulps ymm0, ymm0      ; ymm0 = ymm0*ymm0           diff*diff;
		vaddps ymm2, ymm0      ; ymm2 = ymm2+ymm0           sum += diff*diff

		;Loop Unrolling 4: 4 valori
		vmovaps ymm0, [rax+96]    ; in ymm0 metto i quarti 8 valori di x1
		vmovaps ymm1, [rcx+96]   ; in ymm1 metto i quarti 8 valori di x2

		vsubps ymm0, ymm1      ; ymm0 = ymm0-ymm1  (x1-x2)  diff = x1[i]-x2[i];
		vmulps ymm0, ymm0      ; ymm0 = ymm0*ymm0           diff*diff;
		vaddps ymm2, ymm0      ; ymm2 = ymm2+ymm0           sum += diff*diff

		;Loop Unrolling 5: 8 valori
		vmovaps ymm0, [rax+128]    ; in ymm0 metto i primi 8 valori di x1
		vmovaps ymm1, [rcx+128]    ; in ymm1 metto i primi 8 valori di x2

		vsubps ymm0, ymm1      ; ymm0 = ymm0-ymm1  (x1-x2)  diff = x1[i]-x2[i];
		vmulps ymm0, ymm0      ; ymm0 = ymm0*ymm0           diff*diff;
		vaddps ymm2, ymm0      ; ymm2 = ymm2+ymm0           sum += diff*diff

		;Loop Unrolling 6: 8 valori
		vmovaps ymm0, [rax+160]    ; in ymm0 metto i secondi 8 valori di x1
		vmovaps ymm1, [rcx+160]    ; in ymm1 metto i secondi 8 valori di x2

		vsubps ymm0, ymm1      ; ymm0 = ymm0-ymm1  (x1-x2)  diff = x1[i]-x2[i];
		vmulps ymm0, ymm0      ; ymm0 = ymm0*ymm0           diff*diff;
		vaddps ymm2, ymm0      ; ymm2 = ymm2+ymm0           sum += diff*diff

		;Loop Unrolling 7: 8 valori
		vmovaps ymm0, [rax+192]    ; in ymm0 metto i terzi 8 valori di x1
		vmovaps ymm1, [rcx+192]    ; in ymm1 metto i terzi 8 valori di x2

		vsubps ymm0, ymm1      ; ymm0 = ymm0-ymm1  (x1-x2)  diff = x1[i]-x2[i];
		vmulps ymm0, ymm0      ; ymm0 = ymm0*ymm0           diff*diff;
		vaddps ymm2, ymm0      ; ymm2 = ymm2+ymm0           sum += diff*diff

		;Loop Unrolling 8: 8 valori
		vmovaps ymm0, [rax+224]    ; in ymm0 metto i quarti 8 valori di x1
		vmovaps ymm1, [rcx+224]   ; in ymm1 metto i quarti 8 valori di x2

		vsubps ymm0, ymm1      ; ymm0 = ymm0-ymm1  (x1-x2)  diff = x1[i]-x2[i];
		vmulps ymm0, ymm0      ; ymm0 = ymm0*ymm0           diff*diff;
		vaddps ymm2, ymm0      ; ymm2 = ymm2+ymm0           sum += diff*diff

		;Loop Unrolling 9: 8 valori
		vmovaps ymm0, [rax+256]    ; in ymm0 metto i primi 8 valori di x1
		vmovaps ymm1, [rcx+256]    ; in ymm1 metto i primi 8 valori di x2

		vsubps ymm0, ymm1      ; ymm0 = ymm0-ymm1  (x1-x2)  diff = x1[i]-x2[i];
		vmulps ymm0, ymm0      ; ymm0 = ymm0*ymm0           diff*diff;
		vaddps ymm2, ymm0      ; ymm2 = ymm2+ymm0           sum += diff*diff

		;Loop Unrolling 10: 8 valori
		vmovaps ymm0, [rax+288]    ; in ymm0 metto i secondi 8 valori di x1
		vmovaps ymm1, [rcx+288]    ; in ymm1 metto i secondi 8 valori di x2

		vsubps ymm0, ymm1      ; ymm0 = ymm0-ymm1  (x1-x2)  diff = x1[i]-x2[i];
		vmulps ymm0, ymm0      ; ymm0 = ymm0*ymm0           diff*diff;
		vaddps ymm2, ymm0      ; ymm2 = ymm2+ymm0           sum += diff*diff

		;Loop Unrolling 11: 8 valori
		vmovaps ymm0, [rax+320]    ; in ymm0 metto i terzi 8 valori di x1
		vmovaps ymm1, [rcx+320]    ; in ymm1 metto i terzi 8 valori di x2

		vsubps ymm0, ymm1      ; ymm0 = ymm0-ymm1  (x1-x2)  diff = x1[i]-x2[i];
		vmulps ymm0, ymm0      ; ymm0 = ymm0*ymm0           diff*diff;
		vaddps ymm2, ymm0      ; ymm2 = ymm2+ymm0           sum += diff*diff

		;Loop Unrolling 12: 4 valori
		vmovaps ymm0, [rax+352]    ; in ymm0 metto i quarti 8 valori di x1
		vmovaps ymm1, [rcx+352]   ; in ymm1 metto i quarti 8 valori di x2

		vsubps ymm0, ymm1      ; ymm0 = ymm0-ymm1  (x1-x2)  diff = x1[i]-x2[i];
		vmulps ymm0, ymm0      ; ymm0 = ymm0*ymm0           diff*diff;
		vaddps ymm2, ymm0      ; ymm2 = ymm2+ymm0           sum += diff*diff

		;Loop Unrolling 13: 8 valori
		vmovaps ymm0, [rax+384]    ; in ymm0 metto i primi 8 valori di x1
		vmovaps ymm1, [rcx+384]    ; in ymm1 metto i primi 8 valori di x2

		vsubps ymm0, ymm1      ; ymm0 = ymm0-ymm1  (x1-x2)  diff = x1[i]-x2[i];
		vmulps ymm0, ymm0      ; ymm0 = ymm0*ymm0           diff*diff;
		vaddps ymm2, ymm0      ; ymm2 = ymm2+ymm0           sum += diff*diff

		;Loop Unrolling 14: 8 valori
		vmovaps ymm0, [rax+416]    ; in ymm0 metto i secondi 8 valori di x1
		vmovaps ymm1, [rcx+416]    ; in ymm1 metto i secondi 8 valori di x2

		vsubps ymm0, ymm1      ; ymm0 = ymm0-ymm1  (x1-x2)  diff = x1[i]-x2[i];
		vmulps ymm0, ymm0      ; ymm0 = ymm0*ymm0           diff*diff;
		vaddps ymm2, ymm0      ; ymm2 = ymm2+ymm0           sum += diff*diff

		;Loop Unrolling 15: 8 valori
		vmovaps ymm0, [rax+448]    ; in ymm0 metto i terzi 8 valori di x1
		vmovaps ymm1, [rcx+448]    ; in ymm1 metto i terzi 8 valori di x2

		vsubps ymm0, ymm1      ; ymm0 = ymm0-ymm1  (x1-x2)  diff = x1[i]-x2[i];
		vmulps ymm0, ymm0      ; ymm0 = ymm0*ymm0           diff*diff;
		vaddps ymm2, ymm0      ; ymm2 = ymm2+ymm0           sum += diff*diff

		;Loop Unrolling 16: 8 valori
		vmovaps ymm0, [rax+480]    ; in ymm0 metto i quarti 8 valori di x1
		vmovaps ymm1, [rcx+480]   ; in ymm1 metto i quarti 8 valori di x2

		vsubps ymm0, ymm1      ; ymm0 = ymm0-ymm1  (x1-x2)  diff = x1[i]-x2[i];
		vmulps ymm0, ymm0      ; ymm0 = ymm0*ymm0           diff*diff;
		vaddps ymm2, ymm0      ; ymm2 = ymm2+ymm0           sum += diff*diff


		sub rdx, 128      ;sottraggo i 128 elementi già presi
		add rax, 512     ;mi sposto di 128 elementi (512 posizioni)
		add rcx, 512

		jmp for_128   ; Se edx è più grande o uguale a 32, salto al for


for_16:
		cmp rdx, 16	    ; Confronto edx < 4 ? salta al for_remainder
		jl for_remain     ; Se mancano meno di 4 elementi vai alla gestione residuo

		;Loop Unrolling 1: 8 valori
		vmovaps ymm0, [rax]    ; in xmm0 metto gli ultimi <4 valori di x1
		vmovaps ymm1, [rcx]    ; in xmm1 metto gli ultimi <4 valori di x2

		vsubps ymm0, ymm1      ; xmm0 = xmm0-xmm1  (x1-x2)  diff = x1[i]-x2[i];
		vmulps ymm0, ymm0      ; xmm0 = xmm0*xmm0           diff*diff;
		vaddps ymm2, ymm0      ; xmm2 = xmm2+xmm0           sum += diff*diff

		;Loop Unrolling 2: 8 valori
		vmovaps ymm0, [rax+32]    ; in xmm0 metto gli ultimi <4 valori di x1
		vmovaps ymm1, [rcx+32]    ; in xmm1 metto gli ultimi <4 valori di x2

		vsubps ymm0, ymm1      ; xmm0 = xmm0-xmm1  (x1-x2)  diff = x1[i]-x2[i];
		vmulps ymm0, ymm0      ; xmm0 = xmm0*xmm0           diff*diff;
		vaddps ymm2, ymm0      ; xmm2 = xmm2+xmm0           sum += diff*diff

		sub rdx, 16         ;sottraggo 4 elementi già presi
		add rax, 64     ;mi sposto di 4 elementi (16 posizioni)
		add rcx, 64

		jmp for_16    ; salto incondizionato tanto la condizione la vedo dopo


for_remain:
		cmp rdx, 0	    ; edx == 0? fine
		je end

		movss xmm0, [rax]    ; in xmm0 metto gli ultimi <4 valori di x1
		movss xmm1, [rcx]    ; in xmm1 metto gli ultimi <4 valori di x2

		subss xmm0, xmm1      ; xmm0 = xmm0-xmm1  (x1-x2)  diff = x1[i]-x2[i];
		mulss xmm0, xmm0      ; xmm0 = xmm0*xmm0           diff*diff;
		addss xmm2, xmm0      ; xmm2 = xmm2+xmm0           sum += diff*diff

		dec rdx         ;sottraggo 1 elementi già preso
		add rax, 4      ;mi sposto di 1 elemento (4 posizioni)
		add rcx, 4

		jmp for_remain    ; salto incondizionato tanto la condizione la vedo dopo

end:
																					  	;ymm2= [y1|y2|y3|y4|y5|y6|y7|y8]
																						  ;	   			A1    A2    B1    B2
		vhaddps ymm2,ymm2     ; prima riduzione   ymm2= [A1|A2|A1|A2|B1|B2|B1|B2]
                                    ;      					A1+A2=A3    B1+B2=B3
		vhaddps ymm2,ymm2     ; seconda riduzione ymm2=	[A3|A3|A3|A3|B3|B3|B3|B3]
		vperm2f128 ymm0,ymm2,ymm2,1 ;             ymm0= [X |X |X |X |A3|A3|A3|A3]
		addss xmm0,xmm2      ; A3+B3 finisce in testa a xmm0 (verrà quindi ritornato in uscita)


    ; ------------------------------------------------------------
		; Sequenza di uscita dalla funzione
		; ------------------------------------------------------------

		pop	rcx
		pop	rax
		mov	rsp, rbp	; ripristina lo Stack Pointer
		pop	rbp		; ripristina il Base Pointer
		ret			; torna alla funzione C chiamante
