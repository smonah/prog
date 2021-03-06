section .data			; Sezione contenente dati inizializzati

section .bss			; Sezione contenente dati non inizializzati

section .text			; Sezione contenente il codice macchina

;Loop Unrolling 128,64, 16, 4, 1
;TESTATA

;________________________Funzione________________________
;float objective_function(int n,int m, MATRIX distances_from_centroids)
global objective_function      ; rende la funzione visibile all’esterno

; Posizione dei parametri nel Recordi di Attivazione della funzione
; (i primi 8 bytes sono occupati dall’indirizzo di ritorno e da EBP)
n     equ   8     ; intero a 32 bit rappresenta il numero di punti
m   	equ   12    ; intero a 32 bit rappresenta il numero di gruppi
dist  equ   16    ; puntatore a distances_from_centroids

objective_function:
;------------------salva i parametri base------------------
    push    ebp       ; salva il Base Pointer
    mov     ebp, esp  ; il Base Pointer punta al Record di Attivazione corrente
;    push    ebx       ; salva i registri da preservare,
;		 push    ecx
;    push    esi
;    push    edi
		pushad


;---------lettura dei parametri dal Recordi di Attivazione---------
		mov     ebx, [ebp+n]       ;in ebx ho il numero di punti
		mov     ecx, [ebp+m]   		 ;in ecx ho il numero di gruppi
		mov 	  edx, [ebp+dist]    ;in edx ho l'indirizzo di partenza di distances_from_centroids

		xorps xmm0, xmm0          ;azzero xmm0 dove terrò la somma

		imul ebx, ecx		;ebx = n*m cioè num_punti*num_gruppi

;jmp for_remain



for_64:
    cmp ebx, 64	    ; Confronto n*m < 64 ?
    jl for_16    ; Se edx è strettamente minore di 64, gestisco il residuo

		addps xmm0, [edx]		  ;sum += distances_from_centroids 0...4
		addps xmm0, [edx+16]
    addps xmm0, [edx+32]
		addps xmm0, [edx+48]
    addps xmm0, [edx+64]
		addps xmm0, [edx+80]
    addps xmm0, [edx+96]
		addps xmm0, [edx+112]
    addps xmm0, [edx+128]
		addps xmm0, [edx+144]
    addps xmm0, [edx+160]
		addps xmm0, [edx+176]
    addps xmm0, [edx+192]
		addps xmm0, [edx+208]
    addps xmm0, [edx+224]
		addps xmm0, [edx+240]

    sub ebx, 64      ;sottraggo i 64 elementi già presi
    add edx, 256     ;mi sposto di 64 elementi

	  jmp for_64       ; Se edx è più grande o uguale a 8, salto al for



for_16:
    cmp ebx, 16	    ; Confronto n*m < 16 ?
    jl for_4    ; Se edx è strettamente minore di 16, gestisco il residuo

		addps xmm0, [edx]		  ;sum += distances_from_centroids 0...4
		addps xmm0, [edx+16]
    addps xmm0, [edx+32]
		addps xmm0, [edx+48]

    sub ebx, 16      ;sottraggo i 8 elementi già presi
    add edx, 64     ;mi sposto di 8 elementi (32 posizioni)

	  jmp for_16       ; Se edx è più grande o uguale a 8, salto al for

for_4:

;    jmp end

    cmp ebx, 4	    ; Confronto n*m < 4 ? salta al residuo
	  jl for_remain  ; Se mancano meno di 4 elementi vai alla gestione residuo

		addps xmm0, [edx]		  ;sum += distances_from_centroids 0...4

    sub ebx, 4      ;sottraggo i 4 elementi già presi
    add edx, 16     ;mi sposto di 4 elementi (16 posizioni)

    jmp for_4       ; Se edx è più grande o uguale a 8, salto al for

for_remain:
    cmp ebx, 0	    ; n*m == 0? fine
    je end

    addps xmm0, [edx]    ; in xmm0 metto gli ultimi <4 valori di x1

    dec ebx         ;sottraggo 1 elementi già preso
    add edx, 4     ;mi sposto di 1 elemento (4 posizioni)

	  jmp for_remain    ; salto incondizionato tanto la condizione la vedo dopo

end:
    haddps xmm0, xmm0     ;sommo i primi due valori del registro
    haddps xmm0, xmm0     ;sommo i secondi due valori del registro

    sqrtps xmm0, xmm0     ;radice quadrata della funzione obiettivo
    sub esp, 4            ;sposo nel registro in cima allo stack FPU il risultato
    movss [esp], xmm0     ;al fine di prenderlo da c
    fld dword [esp]
    add esp, 4


;------------------ripristina i parametri base------------------
		popad
;    pop   edi       ; ripristina i registri da preservare
;    pop   esi
;		pop		ecx
;    pop   ebx
    mov   esp, ebp  ; ripristina lo Stack Pointer
    pop   ebp       ; ripristina il Base Pointer
    ret             ; ritorna alla funzione chiamante
