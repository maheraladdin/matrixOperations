.model small
.386
.data
eRows db 'enter number of rows "equations" [2:8]: ','$'
rows db ?
eColumns db 'enter number of columns "variables [2:8] and value" [1:9]: ','$'
columns db ? 
matrix dw 72 dup(?)
.stack 64
.code
    main proc far
        .startup
        
        ; print eRows
        lea dx,eRows
        call printStr
        
        ; read number of rows
        call readNum
        sub al,30h
        mov rows,al
        
        ; new line
        call nl
        
        ; print eColumns
        lea dx,eColumns
        call printStr
        
        ; read number of columns
        call readNum
        sub al,30h
        mov columns,al
        
        ; new line
        call nl
        
        ; check if columns !== rows + 1
        mov bl,rows
        inc bl
        cmp bl,columns
        jne notUnique
        
        ; enter unique augmented matrix
        call enterUniqueAugmentedMatrix
        
        ; print number of elements in matrix
        call nl
        call printMatrix
        
        ; example of swaping row 1 with row 2
        ;lea si,matrix ; si ==> store the first row start address
        ;mov di,si
        ;push dx
        ;movzx dx,columns
        ;add di,dx     ; di ==> store the second row start address
        ;pop dx
        ;call swapRows
        
        ;call printMatrix
        
        
        
        ;example of divide row 1 by 2
        ;lea si,matrix   ; si ==> store the first row start address
       ;mov dl,2        ; dl ==> store the value to be divided on
       ;call divRow
        
       ;call printMatrix
        
        
        ; example of multibly row 1 by 2 then add it to row 2
        lea si,matrix   ; si ==> store the first row start address
        mov di,si
        push dx
        movzx dx,columns
        add di,dx       ; di ==> store the second row start address
        pop dx
        mov dl,2        ; dl ==> store the value to be multiply by
        call MulThenaddRowToAnotherRow
        
        
        call printMatrix
        
        
        notUnique:
        .exit
    main endp
    
    ; new line
    nl proc near
        mov dl,10
        mov ah,02h
        int 21h
        ret
    nl endp
    
    ; print vertical tab
    tab proc near
        mov dl,9
        mov ah,02h
        int 21h
        ret
    tab endp
    
    ; print string start address stored in dx
    printStr proc near
        mov ah,09h
        int 21h
        ret
    printStr endp
    
    ; print char from dl
    printChar proc near
        mov ah,02h
        int 21h
        ret
    printChar endp
    
    ; read char with displaying it and store it in al
    readNum proc near
        mov ah,01h
        int 21h
        ret
    readNum endp
    
    enterUniqueAugmentedMatrix proc near
        
        lea si,matrix ; ==> index
        mov cl,0 ; ==> rows
        loopOverRows:
        mov ch,0 ; ==> columns
        loopOverColumns:
        
        ; print X
        mov dl,'X'
        call printChar
        
        ; print row number 
        mov dl,cl
        inc dl
        add dl,30h
        call printChar
        
        ; print column number
        mov dl,ch
        inc dl
        add dl,30h
        call printChar
        
        ; print colon ':'
        mov dl,':'
        call printChar
        
        ; print space
        mov dl,' '
        call printChar
        
        ;read number [0,9]
        call readNum
        mov [si],al
        
        ; new line
        call nl
        
        ; increament column number for next loop
        inc ch 
        
        ; increament index number for next loop
        inc si
        
        ; check if you reach the last column or not
        cmp ch,columns
        jne loopOverColumns
        
        ; increament row number for next loop
        inc cl
        
        ; check if you reach the last row or not
        cmp cl,rows
        jne loopOverRows
    
        ret
    enterUniqueAugmentedMatrix endp
    
    ; this will return the number of elements inside dl
    numElem proc near
        mov al,rows
        mov ah,columns
        mul ah
        mov dx,ax
        mov dh,0
        ret
    numElem endp
    
    ; bl include column number
    ; cx include number of elements in the matrix to loop over it
    ; si include address of element
    printMatrix proc near
        call nl
        call numElem
        movzx cx,dl
        lea si,matrix
        a:
            ; print element
            mov dl,[si]
            call printChar
            inc si
            
            ; print elements in matrix shape
            
            ; store number of columns in bl
            mov bl,columns
            
            ; divide number of loops in cx by number of columns
            mov ax,cx
            dec ax
            div bl
            
            ; check if reminder equals zero then no tab ,and print new line ,otherwise print tab
            cmp ah,0
            jz noTAb
            
            call tab
            
            jmp noNewLine
            
            noTab:
            
            call nl
            
            noNewLine:
            
        loop a
        call nl
        ret
    printMatrix endp
    
    ; si includes source row start address
    ; di includes distenation row start address 
    ; dl includes mul value
    MulThenaddRowToAnotherRow proc near
        push cx
        push dx
        push ax
        mov cl,columns
        addRow:
        mov dh,[si]
        sub dh,30h
        mov al,dh
        imul dl
        mov dh,al
        add [di],dh
        inc si
        inc di
        loop addRow
        pop ax
        pop dx
        pop cx
        ret
    MulThenaddRowToAnotherRow endp
   
    ; put row to be dividied start address in si
    ; put the value which devide in dl
    divRow proc near
        push cx
        push ax
        mov cl,columns
        divide:
            movzx ax,[si]
            sub ax,30h
            idiv dl
            add al,30h
            mov [si],al
            inc si
        loop divide
        pop ax
        pop cx
        ret
    divRow endp
    
    ; put source row start address in si
    ; put distenation row start address in di
    swapRows proc near
        push cx
        push ax
        push si
        push di    
        push bx
        push dx
    
        mov cl,columns
        swap:
        mov al,[si]
        mov bl, [di]
        xchg al,bl
        mov [si],al
        mov [di],bl
        inc si
        inc di
        loop swap
        
        pop dx
        pop bx
        pop di
        pop si
        pop ax
        pop cx
        ret
    swapRows endp
    
    
end main