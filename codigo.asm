section .data
    filename db 'radio.txt', 0
    buffer db 10   ; buffer
    file_descriptor dd 0
    number db 10   ; array para almacenar el número leído

section .text
    global _start

_start:
    ; Abre el archivo
    mov eax, 5               ; Número de la llamada al sistema para abrir un archivo
    mov ebx, filename        ; Puntero al nombre del archivo
    mov ecx, 0               ; Modo de apertura (0 para lectura)
    int 0x80                 ; Interrupción para llamar al sistema

    ; Guarda el descriptor de archivo devuelto
    mov [file_descriptor], eax

    ; Lee el número del archivo
    mov eax, 3               ; Número de la llamada al sistema para leer desde un archivo
    mov ebx, [file_descriptor]
    mov ecx, number          ; Puntero al array para almacenar el número
    mov edx, 10              ; Tamaño del buffer
    int 0x80                 ; Interrupción para llamar al sistema

    ; Realiza cálculos con el número leído (aquí puedes agregar tus operaciones)
    ; ...

    ; Muestra el resultado por consola
    mov eax, 4               ; Número de la llamada al sistema para escribir en la consola
    mov ebx, 1               ; Descriptor de archivo estándar para salida (1 para stdout)
    mov ecx, number          ; Puntero a la matriz que contiene el número leído
    mov edx, 10              ; Tamaño del buffer
    int 0x80                 ; Interrupción para llamar al sistema

    ; Cierra el archivo
    mov eax, 6               ; Número de la llamada al sistema para cerrar un archivo
    mov ebx, [file_descriptor]
    int 0x80                 ; Interrupción para llamar al sistema

    ; Salir del programa
    mov eax, 1               ; Número de la llamada al sistema para salir
    xor ebx, ebx             ; Código de salida 0
    int 0x80                 ; Interrupción para llamar al sistema
