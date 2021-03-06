
section .data			; Sezione contenente dati inizializzati

section .bss			; Sezione contenente dati non inizializzati

section .text			; Sezione contenente il codice macchina

global memset_float

memset_float:
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

		;rdi (r6) = array
		;rsi (r5) = dim
		;xmm0 = val

		mov rax,rdi 	                ;metto in rax l'indirizzo di partenza dell'array
		mov rdx,rsi                     ;metto in rbx la dimensione dell'array
    shufps xmm0, xmm0, 0x0          ;copio il valore val su tutto xmm0
		vperm2f128 ymm0,ymm0,ymm0,0     ;copio il valore in xmm0 su tutto ymm0

for_128:

		cmp rdx, 128	       ; Confronto n*m < 8 ?
		jl for_32               ; Se edx è strettamente minore di 8, gestisco il residuo

		vmovaps [rax], ymm0     ; copio nei primi 8 valori dell'array il valore val
		vmovaps [rax+32], ymm0  ; copio nei secondi 8 valori dell'array il valore val
		vmovaps [rax+64], ymm0  ; copio nei terzi 8 valori dell'array il valore val
		vmovaps [rax+96], ymm0  ; copio nei quarti 8 valori dell'array il valore val
		vmovaps [rax+128], ymm0  ; copio nei quinti 8 valori dell'array il valore val
		vmovaps [rax+160], ymm0  ; copio nei sesti 8 valori dell'array il valore val
		vmovaps [rax+192], ymm0  ; copio nei settimi 8 valori dell'array il valore val
		vmovaps [rax+224], ymm0  ; copio nei ottavi 8 valori dell'array il valore val

		;ripeto

		vmovaps [rax+256], ymm0     ; copio nei primi 8 valori dell'array il valore val
		vmovaps [rax+288], ymm0  ; copio nei secondi 8 valori dell'array il valore val
		vmovaps [rax+320], ymm0  ; copio nei terzi 8 valori dell'array il valore val
		vmovaps [rax+352], ymm0  ; copio nei quarti 8 valori dell'array il valore val
		vmovaps [rax+384], ymm0  ; copio nei quinti 8 valori dell'array il valore val
		vmovaps [rax+416], ymm0  ; copio nei sesti 8 valori dell'array il valore val
		vmovaps [rax+448], ymm0  ; copio nei settimi 8 valori dell'array il valore val
		vmovaps [rax+480], ymm0  ; copio nei ottavi 8 valori dell'array il valore val

		sub rdx, 128            ;sottraggo i 128 elementi già presi
		add rax, 512           ;mi sposto di 128 elementi (512 posizioni)

		jmp for_128


for_32:

		cmp rdx, 32	       ; Confronto n*m < 8 ?
		jl for_8               ; Se edx è strettamente minore di 8, gestisco il residuo

		vmovaps [rax], ymm0     ; copio nei primi 8 valori dell'array il valore val
		vmovaps [rax+32], ymm0  ; copio nei secondi 8 valori dell'array il valore val
		vmovaps [rax+64], ymm0  ; copio nei terzi 8 valori dell'array il valore val
		vmovaps [rax+96], ymm0  ; copio nei quarti 8 valori dell'array il valore val

		sub rdx, 32            ;sottraggo i 32 elementi già presi
		add rax, 128           ;mi sposto di 32 elementi (128 posizioni)

		jmp for_32


for_8:
		cmp rdx, 8	       ; Confronto n*m < 8  ? salta al for4
		jl for_4               ; Se mancano meno di 8 elementi vai alla gestione residuo

		vmovaps [rax], ymm0    ; copio nei primi 8 valori dell'array il valore val

		sub rdx, 8             ;sottraggo gli 8 elementi già presi
		add rax, 32            ;mi sposto di 8 elementi (32 posizioni)

		jmp for_8              ; salto incondizionato tanto la condizione la vedo dopo

for_4:
		cmp rdx, 4	       ; Confronto n*m < 4 ? salta al residuo
  	jl for_remain          ; Se mancano meno di 4 elementi vai alla gestione residuo

		vmovaps [rax], xmm0     ; copio nei primi 4 valori dell'array il valore val

		sub rdx, 4             ;sottraggo i 4 elementi già presi
		add rax, 16            ;mi sposto di 4 elementi (16 posizioni)

		jmp for_4              ; salto incondizionato tanto la condizione la vedo dopo

for_remain:

		cmp rdx, 0	     ; n*m == 0? fine
		je end

 		vmovss [rax], xmm0    ; copio negli ultimi 4 valori dell'array il valore val

		dec rdx              ;sottraggo 1 elementi già preso
		add rax, 4           ;mi sposto di 1 elemento (4 posizioni)

		jmp for_remain       ; salto incondizionato tanto la condizione la vedo dopo

end:


    ; ------------------------------------------------------------
		; Sequenza di uscita dalla funzione
		; ------------------------------------------------------------

		pop	rdx
		pop	rax
		mov	rsp, rbp	; ripristina lo Stack Pointer
		pop	rbp		; ripristina il Base Pointer
		ret			; torna alla funzione C chiamante
