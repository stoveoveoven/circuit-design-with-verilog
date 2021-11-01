        .globl binary_search
binary_search:
        mov r4, #0 // startindex
        sub r5, r2,#1 // endindex
        mov r6, r5,lsr #1 // middleindex
        mov r7, #-1 // keyindex
        mov r8, #1 // numiters

loop:
        cmp r4,r5
        bgt Exit // first if cond, if startindex big then break

        ldr r9,[r0,r6, lsl #2] // get number at middle index
        cmp r9,r1
        bgt Front // if the number in middle is bigger than key check front
        blt Back // if the number in the middle is less than key check back

        mov r7, r6 // else number at middle is the key
	b Exit
Front:
        sub r5,r6,#1 // reassign endindex
        b helper
Back:
        add r4,r6,#1 // reassign startindex
        b helper
helper:
        rsb r9, r8,#0 // negative numiters
        str r9,[r0,r6,LSL #2] // store the neg iter at middleindex because aesthetic
        sub r10,r5,r4 // helper calc
        add r6,r4,r10,LSR #1 // redefine middle index
        add r8,r8,#1 // increment
        b loop
Exit:
        rsb r9, r8,#0 // negative numiters
        str r9,[r0,r6,LSL #2] // store the neg iter at middleindex because aesthetic
        mov r0,r7 // set r0 to key as well
        mov pc, lr // necessary snippet