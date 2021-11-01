        .globl binary_search
        
binary_search:

        //preloop value assignment
        mov r4, #0              //StartIndex
        sub r9, r2, #1            //
        str r9, r5               //EndIndex
        mov r6, lsr r5, #1       //MiddleIndex
        mvn r7, #0              //KeyIndex
        str #1, r8               //NumIters

        ldr r10, NEG #0
Loop:   cmp r7, NEG #0          //condition for while loop to continue
        bne Exit                //go to exit if startIndex != -1
        
        cmp r4, r5
        bne Exit

        ldr r9, [r0, r6]
        cmp r9, r1
        str r1, r7

        cmpge 

        B Loop
Exit:   


        
