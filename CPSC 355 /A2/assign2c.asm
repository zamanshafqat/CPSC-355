output_str: .string "original: 0x%08X    reversed: 0x%08X\n"
          .balign 4
           .global main

main:
       stp x29, x30, [sp, -16]!  // Save frame pointer and link register
       mov x29, sp               // set up new frame pointer

       // Macros
       define(x,w19)
       define(t1,w20)
       define(t2,w21)
       define(t3,w23)
       define(t4,w24)
       define(y,w22)



       mov x,0x01FF01FF          // Initialise variable
       // Reverse bits in the variale
       // Step 1
       and t1,x,0x55555555          // (x & 0x55555555)
       lsl t1,t1,1                  // (x & 0x55555555) << 1
       lsr t2,x,1                   // (x > 1)
       mov w26,0x55555555
       and t2,t2,w26         // (x > 1) &&  0x55555555
       orr y,t1,t2                  // y = t1|t2

       //step2
       and t1,y,0x33333333    // t1 = y & 0x33333333
       lsl t1,t1,2            // t1 = (y & 0x33333333) << 2
       lsr t2,y,2             // t2 = y >> 2
       and t2,t2,0x33333333   // t2 = (y >> 2) & 0x33333333
       orr y,t1,t2             // y = t1 | t2

       // step3
       and t1,y,0x0F0F0F0F     // y & 0x0f0f0f0f0f
       lsl t1,t1,4             // ( y & 0x0f0f0f0f0f) << 4
       lsr t2,y,4              //  y >> 4
       and t2,t2,0x0F0F0F0F    //  ( y >> 4)  & 0x0f0f0f0f0f
       orr y,t1,t2            // y = t1 | t2

       // Step 4
       lsl t1, y, 24            // t1 = y << 24
       and t2, y, 0xFF00       // t2 = y & 0xFF00
       lsl t2, t2, 8           // t2 = (y & 0xFF00) << 8
       lsr t3, y, 8            // t3 = (y >> 8)
       and t3, t3, 0xFF00     // t3 = (y >> 8) & 0xFF00
       lsr t4, y, #24          // t4 = y >> 24
       orr y, t1, t2            // y = t1 | t2
       orr y, y, t3          // y = y | t3
       orr y, y, t4           // y = y | t4


       adrp x0, output_str       // Load the address of output_str into x0
       add x0, x0, :lo12:output_str
       mov w1,x
       mov w2,y
       bl printf


exit:
        ldp x29, x30 , [sp], 16   // Restore frame pointer and link register
       ret                       // Return from the function