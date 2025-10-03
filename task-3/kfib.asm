section .text
global kfib
extern printf

;const int kfib(int n, int K);
kfib:
    ; create a new stack frame
    enter 0,0
    push esi
    push edi
    push ebx
    ;esi=n
    mov esi, [ebp+8]
    ;edi=K
    mov edi, [ebp+12]

    ;n<K deci returnam 0
    cmp esi, edi
    jl zero
    ;n=K deci returnam 1
    cmp esi, edi 
    je one
    ;in edx vom calcula suma
    xor edx, edx 
    xor eax, eax
    ;ebx=n-K
    mov ebx, esi
    sub ebx, edi 
loop:
    cmp ebx, esi
    je doneloop

    ;salvam valoarea lui edx ca sa nu se schimbe din cauza apelului kfib
    push edx
    push edi
    push ebx
    call kfib
    ;eliberam din stiva cei 2 parametri
    add esp, 8
    pop edx
    add edx, eax

    inc ebx
    jmp loop
zero:
    ;in cazul n<k se returneaza 0
    mov eax, 0
    xor edx, edx
    jmp done
one:
    ;n=k deci se returneaza 1
    mov eax, 1
    xor edx, edx
    jmp done
doneloop:
    mov eax, edx
done:
    pop ebx
    pop edi
    pop esi
    leave
    ret

