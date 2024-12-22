// File: assign3.asm
// Author: Malik Zaman Dogar
// Date: 22-Oct-2024



output_str_1: .string "v[%d]: %d\n"
output_str_2: .string "\nSorted array:\n"

// Macros
define(size, 90)
define(offset_v,x20)
define(offset_v_2,x23)
define(v_base,x19)
define(v_index,x22)

// equates
i_size = 4
j_size = 4
v_size = 320     // 80*4
alloc = -(16 +80 *4) & -16
dealloc = -alloc



     .balign 4
     .global main


main:
       stp x29, x30, [sp, alloc]!  // Save frame pointer and link register
       mov x29, sp                 // set up new frame pointer

       mov v_index,0               // Initialize the index for the array
       add x28,x24,-1              // Prepare for outer loop termination condition
       add v_base,x29,16           // Set the base address of the array in stack



loop1:                             // initialising with random values

      cmp v_index,size             // Compare current index with array size
      b.eq loop_out                // If equal, exit the loop

      bl rand                      // Call random number generator
      and w25,w0,0x1FF             // Limit the random number to 0-511
      lsl offset_v,v_index,2       // Calculate the offset for the current index
      str w25,[v_base,offset_v]    // Store the random value in the array


      adrp x0,output_str_1         // Load the address of the output format string
      add x0,x0, :lo12:output_str_1 // Add the low 12 bits to get the full address
      mov x1,v_index               // Move the current index to the first argument
      mov w2, w25                  // Move the random value to the second argument
      bl printf                    // Print the current index and value

      add x22,x22,1                // Increment the index for the next iteration
      b loop1                      // Repeat the loop

loop_out:                          // outer loop for sorting

      add v_index,v_index,-1       // Decrement the index to set up for sorting
      mov x24,0                    // Reset inner loop index
      cmp v_index,-1               // Check if we have processed all elements
      b.eq text_output             // If all processed, jump to output

in_loop:                           // innner loop for sorting

      cmp x24,v_index              // Compare inner index with the outer index
      b.gt loop_out                // If greater, exit the inner loop

      lsl offset_v,x24,2           // Calculate offset for the current inner index

      ldr w26,[v_base,offset_v]    // Load current value
      add offset_v_2,offset_v,4    // Calculate the offset for the next value
      ldr w27,[v_base,offset_v_2]  // Load the next value

      add x24,x24,1                // Increment the inner index

      cmp w26,w27                  // Compare the two values
      b.ge in_loop                 // If the current is greater or equal, continue sorting

      // Swap values if needed

      str w27,[v_base,offset_v]    // Store the next value at current index
      str w26,[v_base,offset_v_2]  // Store the current value at the next index
      b in_loop

text_output:                       // Label for outputting the sorted array

      mov v_index,0
      adrp x0,output_str_2
      add x0,x0, :lo12:output_str_2
      bl printf

text_loop:                        // Loop for printing the sorted array

      lsl offset_v,x22,2          // Calculate offset for the current index
      ldr w25,[v_base,offset_v]   // Load the value at the current index


      // Outputing the array
      
      adrp x0,output_str_1
      add x0,x0, :lo12:output_str_1
      mov x1,x22
      mov w2,w25
      bl printf

      add x22,x22,1               // Increment index for next element
      cmp x22,size                // Compare index with the array size
      b.lt text_loop              // If less than size, continue the output loop


exit:
        ldp x29, x30 , [sp], dealloc   // Restore frame pointer and link register
        ret                            // Return from the function
        