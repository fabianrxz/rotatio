section .data
    filename db 'radio.txt', 0
    buffer db 10          ; Buffer para almacenar el número leído
    num     dd 0          ; Variable para almacenar el número leído

section .bss
    fd      resd 1        ; Descriptor de archivo

section .text
    global _start

_start:
    ; Abrir el archivo
    mov eax, 5           ; syscall para open
    mov ebx, filename    ; puntero al nombre del archivo
    mov ecx, 0           ; modo de apertura (O_RDONLY)
    int 0x80             ; realizar la llamada al sistema

    ; Comprobar errores al abrir el archivo
    cmp eax, -1
    je  error_exit

    ; Asignar el descriptor de archivo a fd
    mov [fd], eax

    ; Leer el número del archivo
    mov eax, 3           ; syscall para read
    mov ebx, [fd]        ; descriptor de archivo
    mov ecx, buffer      ; puntero al búfer
    mov edx, 10          ; número de bytes a leer
    int 0x80             ; realizar la llamada al sistema

    ; Convertir la cadena a un número
    mov eax, buffer      ; puntero al búfer
    call atoi            ; función para convertir la cadena a un número
    mov [num], eax       ; almacenar el número en la variable

    ; Realizar operaciones con el número (agrega tu lógica aquí)
    mov eax, 4
    mov ebx, 1
    mov ecx, num
    mov edx, 8
    int 0x80

    ; Cerrar el archivo
    mov eax, 6           ; syscall para close
    mov ebx, [fd]        ; descriptor de archivo
    int 0x80             ; realizar la llamada al sistema

    ; Salir del programa
    mov eax, 1           ; syscall para exit
    xor ebx, ebx         ; código de salida 0
    int 0x80             ; realizar la llamada al sistema

error_exit:
    ; Manejar error al abrir el archivo (agrega tu lógica aquí)

; Función para convertir una cadena a un número entero
; Entrada: eax = puntero al inicio de la cadena
; Salida: eax = número entero
atoi:
    xor ebx, ebx         ; Inicializar el resultado en ebx
    xor ecx, ecx         ; Inicializar el índice en ecx

convert_loop:
    movzx edx, byte [eax + ecx] ; Cargar el siguiente carácter de la cadena en edx
    cmp edx, 0           ; ¿Fin de la cadena?
    je  convert_done

    sub edx, '0'         ; Convertir de carácter a dígito
    imul ebx, ebx, 10    ; Multiplicar el resultado actual por 10
    add ebx, edx         ; Sumar el dígito al resultado
    inc ecx              ; Mover al siguiente carácter
    jmp convert_loop

convert_done:
    mov eax, ebx         ; El resultado está en ebx
    ret
