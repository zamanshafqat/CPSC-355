// Date: Dec 02, 2022
// Author: Malik Zaman Dogar
// File: a6a.asm


//-------------------------------Macros----------------------------\\
define(my_fd, w19)
define(my_bytes, x20)
define(my_buffer, x21)
define(my_cmdarg, w18)
define(my_valarg, x22)

buffer_size = 8                                  // Size of the buffer in bytes
alloc = -(16 + buffer_size) & -16                // Memory allocation
buffer_offset = 16                               // Offset for the buffer

//-------------------------------End Of Macros----------------------------\\


//------------------------------- String Statement---------------------------\\

label: .string "Input:\t\tSin(x):\t\tCos(x)\n" 
value: .string "%13.10f\t%13.10f  \t%13.10f\n"
err_msg: .string "Error occurred. File not found.\n"
usage_err: .string "Usage error! Format: ./a6 file.bin\n"

//----------------------------End of String Statments--------------------------\\


zero_val: .double 0r0.00                        // Zero constant
min_val:    .double 0r1.0e-10                   // Minimum value for comparison
ninety: .double 0r90.0                          // Value representing 90
pi_half: .double 0r1.57079632679489661923       // Half of pi


eqtn    .req d19                                 // Equation register (x/y)
expnd   .req d20                                 // Expansion of the term
expo    .req d21                                 // Exponent register
numer   .req d22                                 // Numerator register
fact    .req d23                                 // Factorial register
inc     .req d24                                 // Increment register

    fp .req x29
    lr .req x30

    .global main
    .balign 4
//-------------------------------Main-------------------------------------\\

main:

    stp fp, lr, [sp, alloc]!                    // Allocate memory on the stack
    mov fp, sp                                  // Set the frame pointer

    mov my_cmdarg, w0                           // Move w0 into my_cmd
	mov my_valarg, x1                           // Move x1 into my_val

    cmp my_cmdarg, 2                            // Check if the command line argument is 2
    b.ne usage_error_func                       // If not, jump to the usage error handler

    adrp x0, label                              // Prepare to print the label string
    add x0, x0, :lo12:label 
    bl printf                                   // Print the label

    mov w0, -100                                // Placeholder argument
    ldr x1, [my_valarg, 8]                      // Load command-line argument into x1
    mov w2, 0                                   // Read-only argument
    mov w3, 0                                   // Unused argument
    mov w8, 56                                  // Openat system call
    svc 0                                       // System call
    mov my_fd, w0                               // Store file descriptor in my_fd

    cmp my_fd, 0                                // Check if file opened successfully
    b.ge file_opened_success                     // If yes, proceed to the next step

    adrp x0, err_msg                            // Load error message address
    add x0, x0, :lo12:err_msg
    bl printf                                   // Print the error message

    mov w0, -1                                  // Set return code to -1
    b exit                                      // Jump to exit

//-------------------------------End Of Main-------------------------------------\\

file_opened_success:

    add my_buffer, fp, buffer_offset            // Calculate buffer address


//---------------------------------Reading Inputs----------------------------------\\

read_inputs:

    mov w0, my_fd                               // Set w0 to file descriptor
    mov x1, my_buffer                           // Load buffer address into x1
    mov w2, buffer_size                         // Set buffer size in w2
    mov x8, 63                                  // Read system call
    svc 0                                       // System call

    mov my_bytes, x0                            // Store the number of bytes read

    cmp my_bytes, buffer_size                   // Compare bytes read to buffer size
    b.ne file_complete                          // If not equal, jump to file_complete

    adrp x10, zero_val                          // Load zero constant
    add x10, x10, :lo12:zero_val                // Format
    ldr d13, [x10]                              // Load zero into d13

    adrp x10, pi_half                           // Load half-pi constant
    add x10, x10, :lo12:pi_half                 // Format
    ldr d14, [x10]                              // Load pi_half into d14

    adrp x10, ninety                            // Load ninety constant
    add x10, x10, :lo12:ninety
    ldr d15, [x10]                              // Load ninety into d15

    fcmp d0, d13                                // Compare input with 0
    b.lt read_inputs                            // If less, loop again

    fcmp d0, d15                                // Compare input with 90
    b.gt read_inputs                            // If greater, loop again

    ldr d0, [my_buffer]                         // Load value into d0
    bl sin_function                             // Call sin function
    fmov d1, d0                                 // Save result to d1

    ldr d0, [my_buffer]                         // Load value into d0
    bl cos_function                             // Call cos function
    fmov d2, d0                                 // Save result to d2

    adrp x0, value                              // Load print format string
    add x0, x0, :lo12:value
    ldr d0, [my_buffer]                         // Load the input value
    bl printf                                   // Print the results

    b read_inputs                               // Loop back for next input

//---------------------------------End Of Reading Inputs----------------------------------\\

file_complete:

    mov w0, my_fd                               // Set w0 to file descriptor
    mov x8, 57                                  // Close system call
    svc 0                                       // System call
    mov w0, 0                                   // Return code 0
    b exit                                      // Exit program

usage_error_func:

    adrp x0, usage_err                          // Load usage error message
    add x0, x0, :lo12:usage_err
    bl printf                                   // Print usage error message

exit:

    ldp fp, lr, [sp], -alloc                    // Deallocate memory
    ret                                         // Return from main


   .balign 4
    .global cos_function

//----------------------------------- COS FUNCTION----------------------------------------\\    

cos_function:

    stp fp, lr, [sp, -16]!                     // Save frame pointer and link register
    mov fp, sp                                 // Update the frame pointer

    fdiv d13, d14, d15                         // Convert degrees to radians (pi/90)

    fmul d0, d0, d13                           // Multiply input by the radian conversion factor

    adrp x10, min_val                          // Load the minimum threshold value
    add x10, x10, :lo12:min_val
    ldr d5, [x10]                              // Store the minimum in d5

    fmov d12, d0                               // Copy input to d12
    fmul d12, d12, d12                         // Calculate x^2 and store in d12

    fmov numer, d12                            // Initialize numerator as x^2
    fmov fact, 2.0                             // Start factorial at 2
    fmov expo, 2.0                             // Start exponent at 2
    fmov inc, 1.0                              // Set increment to 1
    fmov expnd, 1.0                            // Start expansion at 1

//----------------------------------- END OF COS FUNCTION----------------------------------------\\

//----------------------------------- COS-LOOP---------------------------------------------------\\

cos_loop:

    fneg numer, numer                           // Flip the numerator's sign

    fdiv eqtn, numer, fact                      // Divide numerator by factorial

    fmul numer, numer, d12                      // Multiply numerator by x^2

    /** Factorial Updates **/
    fadd expo, expo, inc                        // Increment exponent
    fmul fact, fact, expo                       // Update factorial with new exponent

    fadd expo, expo, inc                        // Increment exponent again
    fmul fact, fact, expo                       // Update factorial with new exponent

    fadd expnd, expnd, eqtn                     // Add the term to the expansion

    fabs eqtn, eqtn                             // Get the absolute value of the equation
    fcmp eqtn, d5                               // Compare the equation with the minimum threshold
    b.ge cos_loop                               // Repeat loop if above the threshold

    fmov d0, expnd                              // Store the final result in d0

    ldp fp, lr, [sp], 16                        // Deallocate stack memory
    ret                                         // Return to caller


    .balign 4
    .global sin_function

//----------------------------------- END OF COS-LOOP----------------------------------------\\

//----------------------------------- SIN FUNCTION----------------------------------------\\

sin_function:

    stp fp, lr, [sp, -16]!                      // Save frame pointer and link register
    mov fp, sp                                  // Update the frame pointer

    fdiv d13, d14, d15                          // Convert degrees to radians (pi/90)

    fmul d0, d0, d13                            // Multiply input by the radian conversion factor

    adrp x10, min_val                           // Load the minimum threshold value
    add x10, x10, :lo12:min_val
    ldr d5, [x10]                               // Store the minimum in d5

    fmov d12, d0                                // Copy input to d12
    fmul d12, d12, d12                          // Calculate x^2 and store in d12

    fmov numer, d0                              // Initialize numerator as input value
    fmov fact, 1.0                              // Initialize factorial to 1
    fmov expo, 1.0                              // Start exponent at 1
    fmov inc, 1.0                               // Set increment to 1
    fmov expnd, numer                           // Begin expansion with the numerator
    fdiv eqtn, numer, fact                      // Equation = numerator / factorial

    b sin_loop                                  // Branch to the sin loop

//----------------------------------- END OF SIN FUNCTION----------------------------------------\\


//----------------------------------- SIN-LOOP---------------------------------------------------\\

sin_loop:

    fneg numer, numer                           // Flip the sign of the numerator
    
    fmul numer, numer, d12                      // Multiply numerator by x^2

    /** Factorial Calculation **/
    fadd expo, expo, inc                        // Increment exponent
    fmul fact, fact, expo                       // Multiply factorial by exponent

    fadd expo, expo, inc                        // Increment exponent again
    fmul fact, fact, expo                       // Multiply factorial by new exponent

    fdiv eqtn, numer, fact                      // Divide numerator by factorial

    fadd expnd, expnd, eqtn                     // Add current term to the expansion
 
    fabs eqtn, eqtn                             // Get the absolute value of the equation
    fcmp eqtn, d5                               // Compare the equation with the minimum threshold
    b.ge sin_loop                               // Loop back if the value is greater than the minimum

    fmov d0, expnd                              // Move final result of expansion into d0
    
    ldp fp, lr, [sp], 16                        // Deallocate stack memory
    ret                                         // Return to caller

//----------------------------------- END OF SIN-LOOP----------------------------------------\\


