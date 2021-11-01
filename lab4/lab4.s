        .globl binary_search
        
binary_search:

        //preloop value assignment
        mov r4, #0              //StartIndex
        sub r9, r2, #1          //
        str r9, r5              //EndIndex
        mov r6, lsr r5, #1      //MiddleIndex
        mvn r7, #0              //KeyIndex
        str #1, r8              //NumIters

Loop:   
        cmp r7, NEG #0          //condition for while loop to continue
        bne Exit                //go to exit if startIndex != -1
        
        cmp r4, r5              //compare startindex and endindex
        bgt Exit                //go to exit if start > end

        ldr r9, [r0, r6]        //load numbers[middleIndex] to r9
        cmp r9, r1              //compare r9 with key
        bgt Front               //search the front if r9 > key
        blt Back                //search the back if r9 < key
        str r1, r7              //if equal, assign keyIndex = middleIndex

Front:                          //front branch
        sub r12, r6, #1
        str r12, r5

Back:                           //back branch
        add r12, r6, #1
        str r12, r4

        ldr r10, NEG r8         //save negative of numIter as r10
        str r10, [r0, r6]       //save numbers[middleIndex] as r10

        sub r11, r5, r4         //endIndex - startIndex
        add r9, lsr r11, #1     //startIndex + (r11)/2
        str r9, r6              //save r9 as middle index

        add r8, r8, #1          //increment numIter
        
        B   Loop
Exit:   
        str r7, r0              //return keyIndex


        
