output_str: .string "X:%d  Y:%d  & Current Minimum: X:%d,Y:%d \n"
           .balign 4
           .global main

main:
       stp x29, x30, [sp, -16]!  // Save frame pointer and link register
       mov x29, sp               // set up new frame pointer

      mov x19,-11               // Initialize x19 with -11




// macros


     define(x_sqr,x22)       // xsqr part of equation
     define(x,x21)          // x part of equation
     define(y,x20)         // y value of equation for each x value
     define(default_min,x26)
     define(currentMin_x,x27)        // stores current x min
     define(currentMin_y,x28)        // stores current y min





     mov x23,-333              // coefficient of x2
     mov x24,-74               // coefficient of x
     mov x25,6                 // coefficient of x4
     mov x26,50000           // default minimum y
     mov x27,0        // stores current x min
     mov x28,0        // stores current y min


     b test        // optimised version of the loop

top:                                     // top of the loop

       mov x,x19               // Copy x19 to x21
       mul y,x19,x19           // x20 = x19 * x19
       mov x_sqr,x20               // Copy x20 to x22
       mul y,y,x19           // x20 = x20 * x19
       mul y,y,x19           // x20 = x20 * x19
       mul y,y,x25           // multiplying coef of x4






    //------------------ Making program efficient by Madd

      madd y,x_sqr,x23,y       // adding -333x^2 to 6x^4 and storing as y
      madd y,x,x24,y           // adding -74x to 6x^4 and storing as y
      sub y,y,#23           // x20 = x20 - 23  subtracting the constant from 6x^4 and storing as y







     //-------------------




     // to find the current minimum of y
       cmp y,x26
       b.ge  else
       mov default_min,y
       mov currentMin_x,x19
       mov currentMin_y,y





else:



       adrp x0, output_str       // Load the address of output_str into x0
       add x0, x0, :lo12:output_str

       mov x1, x19               // Move x19 into x1 for printf
       mov x2, y              // Move x20 into x2 for printf
       mov x3, currentMin_x
       mov x4, currentMin_y

       bl printf                 // Call printf

       add x19,x19,#1            // Increment x19

test:
       cmp x19,10         // Compare x19 with 9
       b.lt top                // If x19 <= 9, branch to top


       ldp x29, x30 , [sp], 16   // Restore frame pointer and link register
       ret                       // Return from the function