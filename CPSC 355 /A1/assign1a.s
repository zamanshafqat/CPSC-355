output_str: .string "X:%d  Y:%d  & Current Minimum: X:%d,Y:%d \n"
           .balign 4
           .global main

main:
       stp x29, x30, [sp, -16]!  // Save frame pointer and link register
       mov x29, sp               // set up new frame pointer
     
      mov x19,-11               // Initialize x19 with -11






     mov x23,-333              // coefficient of x2
     mov x24,-74               // coefficient of x
     mov x25,6                 // coefficient of x4
     mov x26,50000
     mov x27,0        // stores current x min
     mov x28,0        // stores current y min



loop1:  cmp x19,10                // Compare x19 with 9
       b.ge done                 // If x19 >= 9, branch to done




       mov x21,x19               // Copy x19 to x20
       mul x20,x19,x19           // x20 = x19 * x19
       mov x22,x20               // Copy x20 to x22
       mul x20,x20,x19           // x20 = x20 * x19
       mul x20,x20,x19           // x20 = x20 * x19
       mul x20,x20,x25           // multiplying coef of x4





      mul x22,x22,x23           //multiplying coef of x2   
      mul x21,x21,x24           //multiplying coef of x




       add x20,x20,x22           // x20 = x20 + x22  adding all the coef of x2 to x4
       add x20,x20,x21           // x20 = x20 + x21 adding all the coef of x to x4
       sub x20,x20,#23           // x20 = x20 - 23  subtracting the constant from x4



       cmp x20,x26
       b.ge  done2
       mov x26,x20
       mov x27,x19
       mov x28,x20


done2:


       adrp x0, output_str       // Load the address of output_str into x0
       add x0, x0, :lo12:output_str

       mov x1, x19               // Move x19 into x1 for printf
       mov x2, x20               // Move x20 into x2 for printf
       mov x3, x27
       mov x4, x28

       bl printf                 // Call printf

       add x19,x19,#1            // Increment x19
       b loop1                   // Repeat loop1

done:
       ldp x29, x30 , [sp], 16   // Restore frame pointer and link register
       ret                       // Return from the function