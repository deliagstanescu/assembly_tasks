## Stanescu Delia-Georgiana

# Task 1:
Se iau din stack parametrii functiei (lungimea vectorului si primul nod). Se cauta pe rand fiecare
numar de la 1 la n in vector (mergand din element in element in vector pana elementul curent are
campul val egal cu valoarea cautata). Odata ce a fost gasit elementul se verifica daca este primul
(cel cu valoarea 1), prin a vedea daca pointerul prev (retinut in edx) e null. Daca este primul
element acesta nu trebuie legat de nimic de dinainte, deci pur si simplu prev devine elementul
curent. In schimb, daca prev nu e null, prev->next devine pointer la elementul gasit. Apoi se 
readuce pointerul vectorului la inceputul acestuia pt cautarea urmatorului numar, iar, daca nu
au fost gasite toate deja, se reia cautarea pentru valoarea urmatoare. La final se face o
trecere finala prin vector pentru a gasi elementul cu valoarea 1, care este de fapt headul listei
si trebuie returnat.

# Task 2:
Functia get_words trece prin stringul dat caracter cu caracter pana gaseste un separator pe care
il inlocuieste cu '\0', astfel marcand finalul cuvantului, iar adresele inceputului cuvantului sunt
salvate in words.
Functia sort pune in stiva functia de comparare compare si parametrii, apeland qsort. Functia 
compare primeste pointeri la cele doua stringuri (asa trebuie pt qsort), le ia valorile si le
determina lungimile (apeland strlen). Daca len(s1)>len(s2) se returneaza 1, iar invers -1. Daca
cele 2 lungimi sunt egale se returneaza valoarea apelului strcmp(s1, s2).

# Task 3:
Se iau de pe stiva parametrii si se verifica daca n < K, caz in care se returneaza 0; daca n = K
se returneaza 1, iar pt n > K se trece prin toate numerele de la n-K la n-1, calculand kfib(nr, K)
si adunandu-l la suma. La final suma se pune in registrul eax pt a fi returnata.

# Task 4:
Check_palindrome: pentru fiecare caracter al cuvantului se verifica daca str[i]=str[len-i-1] (adica
fix proprietatea de palindrom). Daca exista vreun indice pentru care nu se respecta aceasta
proprietate inseamna ca nu este palindrom deci se returneaza 0, altfel daca se ajunge la finalul
cuvantului se returneaza 1.
Composite_palindrome: Alocam spatiu pe heap pentru 2 siruri de caractere: sirul concatenat
provizoriu si sirul cu palindromul final, si punem null in ele. Exista 2^len-1 modalitati de a
crea subsiruri valide cu len cuvinte, iar din moment ce len=15 (si 2^15-1=32767) m-a dus cu gandul
la a trece prin toate numerele de la 1 la 2^15-1, fiecare avand reprezentarea in binar corespunzand
unor seturi de cuvinte. Spre exemplu, 10000...0 ar insemna primul cuvant, 1100...0 ar insemna 
subsirul format din primele 2 cuvinte etc. Apoi luam fiecare bit in parte de la cel mai din stanga
la cel mai din dreapta pt a verifica daca se afla in subsirul curent (astfel parcurgem de la bitul
len-1 la 0, iar cuvintele aferente sunt str[len-bit-1]). Fiecare cuvant gasit se concateneaza, iar
dupa verificarea tuturor numerelor se verifica daca sirul este palindrom. Daca nu, se trece la 
urmatoarea varianta de subsir; daca da, se calculeaza lungimile pt acesta dar si pentru rezultatul
anterior (cel mai bun palindrom de pana atunci), iar daca lungimea este mai mare pentru sirul nou
se copiaza in rezultat. Daca au aceeasi lungime se verifica daca sirul nou este mai mic 
lexicografic, caz in care se copiaza in rezultat. Se repeta pana se verifica toate variantele
de subsiruri posibile. (la apelarea functiilor de prelucrare a stringurilor am observat ca modifica
valorile din unii registrii asa ca am dat extra pushuri si popuri la acestea pentru a le salva 
valorile)

