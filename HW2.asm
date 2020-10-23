;Dzhaparov Emirkhan
; 8 -variant
; A[i]>5 ? B[i] = A[i]+5 : A[i]<-5 ? B[i] = A[i] -5 :B[i] = 0
format PE console
entry start

include 'win32a.inc'

;--------------------------------------------------------------------------
section '.data' data readable writable
        strVecBFill db 'vector B has been filled',10,0
        strVecSize   db 'size of vector? ', 0
        strIncorSize db 'Incorrect size of vector = %d', 10, 0
        strVecElemI  db '[%d]? ', 0
        strScanInt   db '%d', 0
        strSumValue  db 'Summa = %d', 10, 0
        strVecElemOut  db '[%d] = %d', 10, 0
        strVecBElemOut db '[%d] =',10,0
        strVecBElem db '%d',10,0
        strA db 'add',10,0
        strS db 'sub',10,0
        strZ db 'zero',10,0
        zero dd 0
        vec_size     dd 0
        sum          dd 0
        i            dd ?
        tmp          dd ?
        tmpStack     dd ?
        vec          rd 100
        vecB         rd 100
        tmpB         dd ?
;--------------------------------------------------------------------------
section '.code' code readable executable
start:
; 1) vector input
        call VectorInput
; 2) get vector sum
        call VectorB
; 4) test vector out
        call VectorOut
finish:
        call [getch]

        push 0
        call [ExitProcess]

;--------------------------------------------------------------------------
VectorInput:
        push strVecSize
        call [printf]
        add esp, 4

        push vec_size
        push strScanInt
        call [scanf]
        add esp, 8

        mov eax, [vec_size]
        cmp eax, 0
        jg  getVector
; fail size
        push vec_size
        push strIncorSize

        call [printf]
        call[getch]
        push 0
        call [ExitProcess]
; else continue...
getVector:
        xor ecx, ecx            ; ecx = 0
        mov ebx, vec            ; ebx = &vec
getVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        jge endInputVector       ; to end of loop

        ; input element
        mov [i], ecx
        push ecx
        push strVecElemI
        call [printf]
        add esp, 8

        push ebx
        push strScanInt
        call [scanf]
        add esp, 8

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp getVecLoop
endInputVector:
        ret
;--------------------------------------------------------------------------

VectorB:
        push strVecBFill
        call [printf]
        add esp, 4

        xor ecx,ecx
        mov ebx, vec
VectorBFill:
        mov [tmp],ebx
        cmp ecx , [vec_size]
        jge EndVectorB

        mov [i],ecx
        push ecx
        push strVecBElemOut
        call [printf]
        add esp,8
        mov [tmpB], ebx
        mov edx, [tmpB]

        cmp edx, 5
        jg PlusFive

        cmp edx,-5
        jl MinusFive

        push strZ
        call [printf]
        add esp,4
        mov edx, 0
        push edx
        call [printf]
        add esp, 4
        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx,4
        jmp VectorBFill
PlusFive:
        add edx, 5
        push dword edx
        push strVecBElem
        call [printf]
        add esp, 8
        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx,4
        jmp VectorBFill
MinusFive:
        sub edx, 5
         push edx
        call [printf]
        add esp, 4
        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx,4
        jmp VectorBFill

EndVectorB:
        ret
;--------------------------------------------------------------------------
VectorOut:
        mov [tmpStack], esp
        xor ecx, ecx            ; ecx = 0
        mov ebx, vec            ; ebx = &vec
putVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        je endOutputVector      ; to end of loop
        mov [i], ecx

        ; output element
        push dword [ebx]
        push ecx
        push strVecElemOut
        call [printf]

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putVecLoop
endOutputVector:
        mov esp, [tmpStack]
        ret
;-------------------------------third act - including HeapApi--------------------------
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'
