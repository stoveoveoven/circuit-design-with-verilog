        .globl binary_search
        
binary_search:

        //preloop value assignment
        mov r4, #0              //StartIndex
        sub r9 r2 #1            //
        str r9 r5               //EndIndex
        mov r6, r5 LSR #1       //MiddleIndex
        mvn r7, #0              //KeyIndex
        str #1 r8               //NumIters

        ldr 
Loop:   CMP r7, NEG #0
        bne Exit


        B Loop
Exit:   


        
