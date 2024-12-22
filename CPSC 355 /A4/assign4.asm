// File: assign3.asm
// Author: Malik Zaman Dogar
// Date: 31-Oct-2024

        // Define macros
        define(FALSE, 0)
        define(TRUE, 1)
        define(result, w24)

// Prinf statement 
output1: .string "Box %s origin = (%d, %d)  width = %d  height = %d  area = %d\n"
output2: .string "Initial box values:\n"
output3: .string "Changed box values:\n"

first:          .string "first"                                                                 // "first" print statement
second:         .string "second"                                                                // "second" print statement
                .balign 4

// STRUCT EQUATES

        // EQUATES FOR POINT
        xPoint_s = 0                                                                    // offset of xPoint_s from base of struct point
        yPoint_s = 4                                                                    // offset of yPoint_s from base of struct point
        point_size = 8                                                                  // size of struct point
        // END STRUCT POINT

        // EQUATES FOR DIMENSION
        width_s = 0                                                                     // offset of wDim_s from  base of struct dimension
        height_s = 4                                                                    // offset of lDim_s from base of struct dimension
        dim_size = 8                                                                    // szie of struct dimension
        // END STRUCT DIMENSION

        // EQUATES FOR BOX
        box_origin = 0                                                              // offset of "point" within struct "box"
        box_size = 8                                                                // initialize the size of the box
        box_area = 16                                                               // area of the struct box
        // END STRUCT BOX

// END STRUCT EQUATES

    alloc = -(16 + 8) & -16                                             // define total memory allocation
    dealloc = -alloc
    box_s = 16
    first_s = 16                                                        // offset of box_1
    second_s = 36                                                       // offset of box_2

// newbox Struct Method

newBox:

    stp x29,x30,[sp,alloc]!
    mov x29, sp

        // Initialize box variables
        mov w1, 0                                                       // register w1 --> holds 0
        str w1, [x29, box_s + box_origin + xPoint_s]                    // storing w1 back into the stack

        mov w2, 0                                                       // register w2 --> holds 0
        str w2, [x29, box_s + box_origin + yPoint_s]                    // storing w2 back into the stack

        mov w3, 1                                                       // register w3 --> holds 1
        str w3, [x29, box_s + box_size + width_s]                       // storing w3 back into the stack

        mov w4, 1                                                       // register w4 --> holds 1
        str w4, [x29, box_s + box_size + height_s]                      // storing w3 back into the stack

        mul w5,w3,w4                                                    // b.area = b.size.width*b.size.height
        str w5,[x29,box_s + box_area]                                   // storing w5 into the stack
        // return b to main
        ldr w9,[x29,box_s + box_origin + xPoint_s]                      // load box point x into w9
        str w9,[x8,box_origin + xPoint_s]                               // store w9 as box point x

        ldr w9,[x29,box_s + box_origin + yPoint_s]                      // load box point y into w9
        str w9,[x8,box_origin + yPoint_s]                               // store w9 as box point y

        ldr w9,[x29,box_s + box_size + width_s]                         // load box width into w9
        str w9,[x8,box_size + width_s]                                  // store w9 as box dim width

        ldr w9,[x29,box_s + box_size + height_s]                        // load box height into w9
        str w9,[x8,box_size + height_s]                                 // store w9 as box dim height

        ldr w9,[x29, box_s + box_area]                                  // load box area into w9
        str w9,[x8,box_area]                                            // store w9 as box area

        ldp x29, x30, [sp], dealloc                                     // De-allocate the subroutine memory
        ret                                                             // Return to caller

move:
        stp x29, x30, [sp, -16]!                                                            // Allocate 16 bytes of memory from the frame record
        mov x29, sp                                                                         // Set x29 to the value of sp

        // b.origin.x += deltaX
        ldr w9, [x0, box_origin + xPoint_s]                                                 // load current box X value
        add w9, w9, w1                                                                      // add w9 and w1 and store in w9
        str w9, [x0, box_origin + xPoint_s]                                                 // store new box X value


        // b.origin.x += deltaX
        ldr w10, [x0, box_origin + yPoint_s]                                                 // load current box Y value
        add w10, w10, w2                                                                     // add w10 and w2 and store in w10
        str w10, [x0, box_origin + yPoint_s]                                                 // store new box y value


        ldp x29, x30, [sp], 16                                                              // De-allocate the subroutine memory
        ret                                                                                 // return to caller

expand:
        stp x29, x30, [sp, -16]!                                // Allocate 16 bytes of memory from the frame record
        mov x29, sp                                             // Set x29 to the value of sp

        // b.szie.width *= factor
        ldr w9,[x0,box_size + width_s]                          // load width from the stack
    mul w9,w9,w1                                                // multiply width by factor
        str w9,[x0,box_size + width_s]                          // store into stack again

        // b.szie.height *= factor
        ldr w10,[x0,box_size + height_s]                        // load width from the stack
    mul w10,w10,w1                                              // multiply height by factor
        str w10,[x0,box_size + height_s]                        // load into stack again

        //b.area = b.size.width * b.size.height
        ldr w11,[x0,box_area]                                   // load box area from stack
        mul w11,w10,w9                                          // find the area
        str w11,[x0,box_area]                                   // store area into stack again

        ldp x29, x30, [sp], 16                                  // De-allocate the subroutine memory
        ret                                                     // return to caller

printBox:
    stp x29, x30, [sp, -32]!                                    // Allocate 16 bytes of memory from the frame record
        mov x29, sp                                             // Set x29 to the value of sp
        mov x19, x0                                             // setting x19 to the value of x0

        adrp x0,output1                                         // set first print statement
        add x0,x0, :lo12:output1                                // initialize the print statement
        mov w1, w1                                              // set variables needed to print
        ldr w2,[x19,box_origin + xPoint_s]                      // load current box X value in w2
        ldr w3,[x19,box_origin + yPoint_s]                      // load current box Y value in w3
        ldr w4,[x19,box_size+ width_s]                          // load current box width in w4
        ldr w5,[x19,box_size + height_s]                        // load current box height into w5
        ldr w6,[x19,box_area]                                   //load the box area into w6
        bl printf

        ldp x29, x30, [sp], 32                                  // De-allocate the subroutine memory
        ret                                                     // return to caller

equal:
    stp x29, x30, [sp, -32]!                                    // Allocate 16 bytes of memory from the frame record
        mov x29, sp                                             // Set x29 to the value of sp

        mov result,FALSE                                        // set result false
        ldr w9,[x0,box_origin + xPoint_s]                       // loading x of b1 
        ldr w10,[x0,box_origin + yPoint_s]                      // loading y of b1
        ldr w11,[x0,box_size + width_s]                         // loading width of b1
        ldr w12,[x0,box_size + height_s]                        // loading height of b1 

        ldr w13,[x1,box_origin + xPoint_s]                      // loading x of b1 
        ldr w14,[x1,box_origin + yPoint_s]                      // loading y of b1
        ldr w15,[x1,box_size + width_s]                         // loading width of b1
        ldr w27,[x1,box_size + height_s]                        // loading height of b1 

        cmp w9, w13                                                                                 // compare w9 and w13
        b.ne next                                                                                   // if w9 != w13 branch to next

        cmp w10, w14                                                                                // compare w10 and w14
        b.ne next                                                                                   // if w10 != w14 then branch to next

        cmp w11, w15                                                                                // compare w11 and w15
        b.ne next                                                                                   // if w11 and w15 are not equal, branch to next

        cmp w12, w27                                                                                // compare w11 and w15
        b.ne next                                                                                   // if w12 and w27 are not equal, branch to next

        mov result, TRUE                                                                            // move TRUE into result
        mov w0, result                                                                              // output/return w0 into main
        bl end                                                                                      // branch to end 

next:
    mov w0, result                                                                                  // output/return w0 into main
        bl end                                                                                      // branch to end

end:

        ldp x29, x30, [sp], 32                                                                      // De-allocate the subroutine memory
        ret                                                                                         // return to caller


        //-------------- MAIN ---------------\\
        .global main

main:
    stp x29, x30, [sp, alloc]!                                      // allocating space in the stack
        mov x29, sp                                                 // setting the value of sp to x29

        add x8, x29, first_s                                        // add x29 and first_s and store in x8
        bl newBox                                                   // create a new box by branching to newbox

        add x8, x29, second_s                                       // add x29 and second_s and store in x8
        bl newBox                                                   // create a new box by branching to newbox
        //Printing initial values
        adrp x0,output2                                             // set print function
        add x0,x0, :lo12:output2                                    // initialize print function                                
        bl printf                                                   // call print function

        // Pass argument to print1Box
        add x0,x29,first_s
        ldr w1, =first
        bl printBox

        // Pass argument to print2Box
        add x0,x29,second_s
        ldr w1, =second
        bl printBox

        // Pass arguments into equal to get TRUE or FALSE
        add x0,x29,first_s
        add x1, x29, second_s
        bl equal
        cmp w0, TRUE
        b.ne else

        add x0, x29, first_s
        mov w1, -5
        mov w2, 7
        bl move

        // Pass arguments to expand to change second cuboid values
        add x0, x29, second_s
        mov w1, 3
        bl expand

else:           // Print modified values
        adrp x0, output3                                                                        // set third print statement
        add x0, x0, :lo12:output3                                                               // initilize the statement
        bl printf                                                                               // print

        // Print modified values of first Cuboid
        add x0, x29, first_s                                                                    // add x29 and first_s and store in x0
        ldr w1, =first                                                                          // load =first into w1
        bl printBox                                                                             // bl printBox

        // Print mdoified values of second Cuboid
        add x0, x29, second_s                                                                    // add x29 and second_s and store in x0
        ldr w1, =second                                                                          // load =second into w1
        bl printBox                                                                              // bl printBox

        mov w0, 0                                                                               // mov w0,0
        ldp x29, x30, [sp], dealloc                                                             // allocate space in stack
        ret

f