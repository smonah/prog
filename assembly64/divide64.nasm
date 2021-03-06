section .data			; Sezione contenente dati inizializzati

section .bss			; Sezione contenente dati non inizializzati

section .text			; Sezione contenente il codice macchina

global divide

divide:
		; ------------------------------------------------------------
		; Sequenza di ingresso nella funzione
		; ------------------------------------------------------------
		push	rbp		; salva il Base Pointer
		mov	rbp, rsp	; il Base Pointer punta al Record di Attivazione corrente
		push	rax		; salva i registri generali
		push	rdx


		;--------------------------------
		;PARAMETRI
		;--------------------------------

;extern void divide( MATRIX dividendo, float divisore, int dim);

		;rdi (r6) = indirizzo di partenza dell'array dest, dividendo
		;xmm0     = divisore poiché è floating
		;rsi (r5) = dim

		shufps xmm0, xmm0, 0x0          ;copio il valore val su tutto xmm0
		vperm2f128 ymm0,ymm0,ymm0,0     ;copio il valore in xmm0 su tutto ymm0

		mov rax, rdi				;in rax ho l'indirizzo di destinazione
		mov rdx, rsi				;in rdx ho la dimensione
												;in ymm0 ho il valore duplicato da dividere

for_128:

    cmp rdx, 128	       ; Confronto n*m < 8 ?
    jl for_16               ; Se edx è strettamente minore di 8, gestisco il residuo

                ;Loop Unrolling 1: 8 valori
		vmovaps ymm1,[rax]      ; copio i primi 8 valori di dest in ymm0
		vdivps  ymm1,ymm0       ; aggiungo a ymm0 i primi 8 valori di source
		vmovaps [rax],ymm1      ; ricopio la somma dei primi 8 valori di dest e source in dest

                ;Loop Unrolling 2: 8 valori
		vmovaps ymm1,[rax+32]      ; copio i secondi 8 valori di dest in ymm0
		vdivps  ymm1,ymm0      ; aggiungo a ymm0 i secondi 8 valori di source
		vmovaps [rax+32],ymm1      ; ricopio la somma dei secondi 8 valori di dest e source in dest

                ;Loop Unrolling 3: 8 valori
		vmovaps ymm1,[rax+64]      ; copio i terzi 8 valori di dest in ymm0
		vdivps  ymm1,ymm0          ; aggiungo a ymm0 i terzi 8 valori di source
		vmovaps [rax+64],ymm1      ; ricopio la somma dei terzi 8 valori di dest e source in dest

                ;Loop Unrolling 4: 8 valori
		vmovaps ymm1,[rax+96]      ; copio i quarti 8 valori di dest in ymm0
		vdivps  ymm1,ymm0          ; aggiungo a ymm0 i quarti 8 valori di source
		vmovaps [rax+96],ymm1      ; ricopio la somma dei quarti 8 valori di dest e source in dest

                ;Loop Unrolling 5: 8 valori
		vmovaps ymm1,[rax+128]      ; copio i quinti 8 valori di dest in ymm0
		vdivps  ymm1,ymm0       ; aggiungo a ymm0 i quinti 8 valori di source
		vmovaps [rax+128],ymm1      ; ricopio la somma dei quinti 8 valori di dest e source in dest

                ;Loop Unrolling 6: 8 valori
		vmovaps ymm1,[rax+160]      ; copio i sesti 8 valori di dest in ymm0
		vdivps  ymm1,ymm0      ; aggiungo a ymm0 i sesti 8 valori di source
		vmovaps [rax+160],ymm1      ; ricopio la somma dei sesti 8 valori di dest e source in dest

                ;Loop Unrolling 7: 8 valori
		vmovaps ymm1,[rax+192]      ; copio i settimi 8 valori di dest in ymm0
		vdivps  ymm1,ymm0          ; aggiungo a ymm0 i settimi 8 valori di source
		vmovaps [rax+192],ymm1      ; ricopio la somma dei settimi 8 valori di dest e source in dest

                ;Loop Unrolling 8: 8 valori
		vmovaps ymm1,[rax+224]      ; copio i ottavi 8 valori di dest in ymm0
		vdivps  ymm1,ymm0          ; aggiungo a ymm0 gli ottavi 8 valori di source
		vmovaps [rax+224],ymm1      ; ricopio la somma degli ottavi 8 valori di dest e source in dest

                ;Loop Unrolling 1: 8 valori
		vmovaps ymm1,[rax+256]      ; copio i primi 8 valori di dest in ymm0
		vdivps  ymm1,ymm0       ; aggiungo a ymm0 i primi 8 valori di source
		vmovaps [rax+256],ymm1      ; ricopio la somma dei primi 8 valori di dest e source in dest

                ;Loop Unrolling 2: 8 valori
		vmovaps ymm1,[rax+288]      ; copio i secondi 8 valori di dest in ymm0
		vdivps  ymm1,ymm0      ; aggiungo a ymm0 i secondi 8 valori di source
		vmovaps [rax+288],ymm1      ; ricopio la somma dei secondi 8 valori di dest e source in dest

                ;Loop Unrolling 3: 8 valori
		vmovaps ymm1,[rax+320]      ; copio i terzi 8 valori di dest in ymm0
		vdivps  ymm1,ymm0          ; aggiungo a ymm0 i terzi 8 valori di source
		vmovaps [rax+320],ymm1      ; ricopio la somma dei terzi 8 valori di dest e source in dest

                ;Loop Unrolling 4: 8 valori
		vmovaps ymm1,[rax+352]      ; copio i quarti 8 valori di dest in ymm0
		vdivps  ymm1,ymm0          ; aggiungo a ymm0 i quarti 8 valori di source
		vmovaps [rax+352],ymm1      ; ricopio la somma dei quarti 8 valori di dest e source in dest

                ;Loop Unrolling 5: 8 valori
		vmovaps ymm1,[rax+384]      ; copio i quinti 8 valori di dest in ymm0
		vdivps  ymm1,ymm0       ; aggiungo a ymm0 i quinti 8 valori di source
		vmovaps [rax+384],ymm1      ; ricopio la somma dei quinti 8 valori di dest e source in dest

                ;Loop Unrolling 6: 8 valori
		vmovaps ymm1,[rax+416]      ; copio i sesti 8 valori di dest in ymm0
		vdivps  ymm1,ymm0      ; aggiungo a ymm0 i sesti 8 valori di source
		vmovaps [rax+416],ymm1      ; ricopio la somma dei sesti 8 valori di dest e source in dest

                ;Loop Unrolling 7: 8 valori
		vmovaps ymm1,[rax+448]      ; copio i settimi 8 valori di dest in ymm0
		vdivps  ymm1,ymm0          ; aggiungo a ymm0 i settimi 8 valori di source
		vmovaps [rax+448],ymm1      ; ricopio la somma dei settimi 8 valori di dest e source in dest

                ;Loop Unrolling 8: 8 valori
		vmovaps ymm1,[rax+480]      ; copio i ottavi 8 valori di dest in ymm0
		vdivps  ymm1,ymm0          ; aggiungo a ymm0 gli ottavi 8 valori di source
		vmovaps [rax+480],ymm1      ; ricopio la somma degli ottavi 8 valori di dest e source in dest


    sub rdx, 128            ;sottraggo i 128 elementi già presi
		add rax, 512           ;mi sposto di 128 elementi (512 posizioni)

		jmp for_128


for_16:

    cmp rdx, 16	       ; Confronto n*m < 8 ?
		jl for_remain               ; Se edx è strettamente minore di 8, gestisco il residuo


    ;Loop Unrolling 1: 8 valori
		vmovaps ymm1,[rax]      ; copio i primi 8 valori di dest in ymm0
		vdivps  ymm1,ymm0       ; aggiungo a ymm0 i primi 8 valori di source
		vmovaps [rax],ymm1      ; ricopio la somma dei primi 8 valori di dest e source in dest

    ;Loop Unrolling 2: 8 valori
		vmovaps ymm1,[rax+32]      ; copio i secondi 8 valori di dest in ymm0
		vdivps  ymm1,ymm0      ; aggiungo a ymm0 i secondi 8 valori di source
		vmovaps [rax+32],ymm1      ; ricopio la somma dei secondi 8 valori di dest e source in dest


    sub rdx, 16            ;sottraggo i 32 elementi già presi
		add rax, 64           ;mi sposto di 32 elementi (128 posizioni)

		jmp for_16


for_remain:
	cmp rdx, 0	    ; edx == 0? fine
	je end

	vmovss xmm1, [rax]    ; xmm0 = tmp[i*d_star]
	vdivss xmm1, xmm0     ; xmm0 = xmm0/cont[i]   ;tmp[centroide*d_star]/cont[i]
	vmovss [rax], xmm1    ; centroids[(i+g*k)*d_star] = xmm0

	dec rdx         ;sottraggo 1 elementi già preso
	add rax, 4     ;mi sposto di 1 elemento (4 posizioni)

	jmp for_remain    ; salto incondizionato tanto la condizione la vedo dopo


end:

    ; ------------------------------------------------------------
		; Sequenza di uscita dalla funzione
		; ------------------------------------------------------------

		pop	rdx
		pop	rax
		mov	rsp, rbp	; ripristina lo Stack Pointer
		pop	rbp		; ripristina il Base Pointer
		ret			; torna alla funzione C chiamante
