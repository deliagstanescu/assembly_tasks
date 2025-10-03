section .text
global sort
global get_words
global compare
extern strlen
extern strcmp
extern qsort

compare:
    ; create a new stack frame
    enter 0,0
    push esi
    push edi
    push ebx
    push edx

    ;primul cuvant
    mov eax, [ebp+8]
    mov esi, [eax]
    ;al doilea cuvant
    mov eax, [ebp+12]
    mov edi, [eax]

    xor ebx, ebx
    push esi
    call strlen
    mov ebx, eax
    ;elibereaza de pe stiva argumentul
    add esp, 4

    xor eax, eax
    push edi
    call strlen
    mov edx, eax
    ;elibereaza de pe stiva argumentul
    add esp, 4
    cmp ebx, edx
    jl first
    cmp ebx, edx
    jg second

    xor eax, eax
    push edi
    push esi
    call strcmp
    ;elibereaza de pe stiva argumentele
    add esp, 8
    jmp cmpdone
first:
    ;returnam -1
    mov eax, -1
    jmp cmpdone
second:
    ;returnam 1
    mov eax, 1
cmpdone:
    pop edx
    pop ebx
    pop edi
    pop esi
    leave
    ret

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    ; create a new stack frame
    enter 0,0
    push compare
    ;size
    push dword [ebp+16]
    ;number_of_words
    push dword [ebp+12]
    ;words
    push dword [ebp+8]
    call qsort
    ;elibereaza de pe stiva argumentele
    add esp, 16
    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    ; create a new stack frame
    enter 0,0
    push esi
    push edi
    push ecx
    push ebx

    ;punem in esi s
    mov esi, [ebp+8]
    ;punem in edi words
    mov edi, [ebp+12]
    ;punem in ecx nr de cuvinte
    mov ecx, [ebp+16]

    xor ebx, ebx
loop:
    mov al, byte [esi]
    ;am dat de null
    cmp al, 0
    je done

    cmp al, ' '
    je nextword
    cmp al, ','
    je nextword
    cmp al, '.'
    je nextword
    ;'\n' are codul ascii 10
    cmp al, 10 
    je nextword

    ;asociaza la cuv curent pointerul la acesta
    mov [edi+4*ebx], esi
    inc ebx

nextchar:
    mov al, byte [esi]
    ;am dat de null
    cmp al, 0
    je endofword
    cmp al, ' '
    je endofword
    cmp al, ','
    je endofword
    cmp al, '.'
    je endofword
    ;'\n' are codul ascii 10
    cmp al, 10
    je endofword
    inc esi
    jmp nextchar
endofword:
    ;punem '\0' de la finalul cuvantului
    mov byte [esi], 0
    inc esi
    jmp loop
nextword:
    inc esi
    jmp loop
done:
    pop ebx
    pop ecx
    pop edi
    pop esi
    leave
    ret

