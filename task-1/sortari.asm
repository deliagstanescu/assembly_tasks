section .text
global sort

    struc node
        .val: resd 1
        .next: resd 1
    endstruc 

;   struct node {
;    int val;
;    struct node* next;
;   };

;; struct node* sort(int n, struct node* node);
;   The function will link the nodes in the array
;   in ascending order and will return the address
;   of the new found head of the list
; @params:
;   n -> the number of nodes in the array
;   node -> a pointer to the beginning in the array
;   @returns:
;   the address of the head of the sorted list
sort:
; create a new stack frame
    enter 0,0
    push esi
    push edi
    push ebx 
    push ecx

    ;la ebp+8 pe stack se gaseste primul parametru al functiei (n)
    mov ecx, [ebp+8]
    ;la ebp+12 pe stack se gaseste al doilea parametru al functiei (vectorul)
    mov esi, [ebp+12]

    ;nodul prev
    xor edx, edx
    xor ebx, ebx

elem:
    ;numarul pe care il caut
    inc ebx 
    ;contorul in vector
    xor edi, edi 

loop:
    cmp ebx, dword [esi+node.val]
    je found
    add esi, node_size
    inc edi
    cmp edi, ecx
    jl loop

found:
    test edx, edx
    ;nu e headul listei deci trebuie legat de prev
    jnz updatenext
    jmp nextval

updatenext:
    push ecx
    lea ecx, [esi]
    mov [edx+node.next], ecx
    pop ecx

nextval:
    lea edx, [esi]
    ;la ebp+12 pe stack se gaseste al doilea parametru al functiei (vectorul)
    mov esi, [ebp+12]
    cmp ebx, ecx
    jl elem
    ;pt ultimul nod nextul va fi null, adica 0
    mov dword [edx+node.next], 0

findhead:
    xor eax, eax
    mov eax, [esi+node.val]
    ;vedem daca am gasit elementul cu val 1, adica headul
    cmp eax, 1
    je done
    add esi, node_size
    jmp findhead

done:
    lea eax, [esi]
    pop ecx
    pop ebx
    pop edi
    pop esi
    leave
    ret

