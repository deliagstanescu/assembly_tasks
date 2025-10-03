section .text
global check_palindrome
global composite_palindrome
extern strcat, strlen, strcmp, strcpy, malloc, free, printf
;const int check_palindrome(const char * const str, const int len);
check_palindrome:
    ; create a new stack frame
    enter 0, 0
    push edi
    push esi
    push ebx

    ;edi=str
    mov edi, [ebp+8]
    ;esi=len
    mov esi, [ebp+12]

    ;presupunem direct ca str e palindrom
    mov eax, 1
    xor ecx, ecx
loop:
    xor edx, edx
    cmp ecx, esi
    je done
    mov dl, byte [edi+ecx]
    ;ebx=len-ecx-1
    mov ebx, esi
    sub ebx, ecx
    dec ebx
    mov dh, byte [edi+ebx]
    cmp dl, dh
    jne notpal
    inc ecx
    jmp loop
notpal:
    ;str nu e palindrom deci returnam 0
    mov eax, 0
done:
    pop ebx
    pop esi
    pop edi
    leave
    ret

;char * const composite_palindrome(const char * const * const strs, const int len);
composite_palindrome:
    ; create a new stack frame
    enter 0, 0
    push edi
    push esi
    push ebx
    push ecx
    push edx
    ;rezervam spatiu pt cele 2 stringuri
    sub esp, 8
    ;ebp-24 sirul in care facem concatenarile
    ;ebp-28 sirul rezultat

    ;edi=strs
    mov edi, [ebp+8]
    ;esi=len
    mov esi, [ebp+12]

    ;lg maxima este 15 cuv * 10 caractere + 1 null = 151
    push 151
    call malloc
    ;eliberam parametrul
    add esp, 4
    ;ebp-24 sirul in care facem concatenarile
    mov [ebp-24], eax

    xor eax, eax
    ;lg maxima este 15 cuv * 10 caractere + 1 null = 151
    push 151
    call malloc
    ;eliberam parametrul
    add esp, 4
    ;ebp-28 sirul rezultat
    mov [ebp-28], eax
    xor eax, eax

    ;concatenarea
    mov eax, [ebp-24]
    ;punem null in sir
    mov byte [eax], 0
    ;rezultatul
    mov eax, [ebp-28]
    ;punem null in sir
    mov byte [eax], 0

    ;sunt 2^len-1 subsiruri/posibilitati de concatenare
    mov ecx, esi
    ;ebx=1<<len
    mov ebx, 1
    shl ebx, cl
    xor ecx, ecx
    ;folosim edi ca si contor, accesam direct strs cand avem nevoie
    mov edi, 1
loopconcat:
    cmp edi, ebx
    je end
    ;concatenarea
    mov eax, [ebp-24]
    ;punem null in sirul initial ca sa putem concatena
    mov byte [eax], 0
    ;edx=len-1
    mov edx, [ebp+12]
    dec edx
concat:
    ;am ajuns la final
    cmp edx, 0
    jl checkstring

    push ebx
    xor ebx, ebx
    xor ecx, ecx
    mov ecx, edx
    ;ebx=1<<edx
    mov ebx, 1
    shl ebx, cl
    test edi, ebx
    jz skipword
    pop ebx

    ;punem temporar strs in ecx si strs[len-edx-1] in esi
    xor eax, eax
    xor esi, esi
    xor ecx, ecx
    ;ecx=strs
    mov ecx, [ebp+8]
    ;eax=len-edx-1
    mov eax, [ebp+12]
    sub eax, edx
    dec eax
    ;esi=pointer la cuvantul strs[len-edx-1]
    mov esi, [ecx+4*eax]

    push ebx
    push edx
    ;concatenarea
    mov eax, [ebp-24]
    push esi
    push eax
    call strcat
    ;eliberam parametrii
    add esp, 8
    pop edx
    pop ebx

    dec edx
    jmp concat
skipword:
    pop ebx
    dec edx
    jmp concat
checkstring:
    ;lungimea concatenarii actuale
    xor eax, eax
    xor edx, edx
    ;concatenarea
    mov edx, [ebp-24]
    push ebx
    push edi
    push edx
    call strlen
    ;eliberam parametrul
    add esp, 4
    pop edi
    pop ebx
    xor edx, edx
    mov edx, eax

    xor eax, eax
    xor esi, esi
    ;concatenarea
    mov esi, [ebp-24]
    push ebx
    push edx
    push esi
    call check_palindrome
    ;eliberam parametri
    add esp, 8
    pop ebx
    ;nu e palindrom
    cmp eax, 0
    je nextconcat

    ;lungimea concatenarii actuale
    xor eax, eax
    xor edx, edx
    ;concatenarea
    mov edx, [ebp-24]
    push ebx
    push edi
    push edx
    call strlen
    ;eliberam parametri
    add esp, 4
    pop edi
    pop ebx
    mov edx, eax

    ;lungimea rezultatului pana acum
    xor eax, eax
    xor ecx, ecx
    ;rezultatul
    mov ecx, [ebp-28]
    push ebx
    push edx
    push edi
    push ecx
    call strlen
    ;eliberam parametrul
    add esp, 4
    pop edi
    pop edx
    pop ebx
    mov ecx, eax

    cmp edx, ecx
    jl nextconcat
    cmp edx, ecx
    jg newstring

    ;au aceeasi lungime
    xor esi, esi
    xor edx, edx
    ;sirul in care facem concatenarile
    mov esi, [ebp-24]
    ;rezultatul
    mov edx, [ebp-28]
    push edx
    push esi
    call strcmp
    ;eliberam parametri
    add esp, 8
    ;concatenarea e lexicografic >=rezultatul
    cmp eax, 0
    jge nextconcat
newstring:
    xor esi, esi
    xor edx, edx
    ;concatenarea
    mov esi, [ebp-24]
    ;rezultatul
    mov edx, [ebp-28]
    push ebx
    push edi
    push esi
    push edx
    call strcpy
    ;eliberam parametri
    add esp, 8
    pop edi
    pop ebx

nextconcat:
    inc edi
    jmp loopconcat

end:
    ;returnam rezultatul
    mov eax, [ebp-28]
    ;eliberam parametrii
    add esp, 8
    pop edx
    pop ecx
    pop ebx
    pop esi
    pop edi
    leave
    ret
