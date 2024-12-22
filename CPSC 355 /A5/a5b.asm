/*
 CPSC355-Assignment 5B
 Malik Zaman Dogar
 30222423
*/

// ------------------------------ EXTERNAL POINTER ARRAYS ------------------------------\\ 
    .data
month_m: .dword jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
prefix_m: .dword st, nd, rd, th, th, th, th, th, th, th, th, th, th, th, th, th, th, th, th, th, st, nd, rd, th, th, th, th, th, th, th, st

// ------------------------------ END EXTERNAL POINTER ARRAYS ------------------------------\\


// --------------------------------------- OUTPUTS------------------------------------------\\
    .text

output1: .string "%s %d%s, %d\n"
output2: .string "usage: a5b mm dd yyyy\n"

jan: .string "January"
feb: .string "February"
mar: .string "March"
apr: .string "April"
may: .string "May"
jun: .string "June"
jul: .string "July"
aug: .string "August"
sep: .string "September"
oct: .string "October"
nov: .string "November"
dec: .string "December"
st: .string "st"
nd: .string "nd"
rd: .string "rd"
th: .string "th"

//--------------------------------- END OF OUTPUTS --------------------------------\\



//------------------------------ MACROS -----------------------------\\
define(base_month_r, x22)
define(base_prefix_r, x23)
define(argc_r, w20)
define(argv_r, x21)
define(month, w24)
define(day, w25)
define(year, x26)
define(i_r, w19)  

// --------------------------- END DEFINING MACROS --------------------\\


    
//-----------------------------------------  MAIN --------------------------------------\\

.text
    .balign 4
    .global main                                       // globalize main
    

main:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    mov argc_r, w0                                    // The number of argumnets is stored argc_r
    mov argv_r, x1                                    // The arguments are stored in argv_r


    cmp argc_r, 4                                     // check argc_r != 4
    b.ne default                                      // branches to default output

    mov i_r, 1                                        // I_r = 1

    ldr x0, [argv_r, i_r, SXTW 3]                     // Second argument from argv_r is loaded to the register
    bl atoi                                           // Calls the atoi function
    mov month, w0                                     // Moves the argument to month

    cmp month, 0                                      // if month < 1
    b.lt default                                      // branches to error/default ouput

    cmp month, 12                                     // if month > 12
    b.gt default                                      // branches to error/default output

    mov i_r, 2                                        // i_r = 2
    ldr x0, [argv_r, i_r, SXTW 3]                     // third argument from argv_r is loaded to the register
    bl atoi                                           // Calls the atoi function
    mov day, w0                                       // Moves the argument to day

    cmp day, 0                                        // if day < 0
    b.lt default                                      // branches to error/default output

    cmp day, 31                                       // if day > 31
    b.gt default                                      // branches to error/default output

    mov i_r, 3                                        // i_r = 3
    ldr x0, [argv_r, i_r, SXTW 3]                     // fourth argument from argv_r is loaded to the register
    bl atoi                                           // Calls the atoi function
    mov year, x0                                      // Moves the argument to year

    cmp year, 0                                       // if year < 0
    b.lt default                                      // branches to error/default output

    adrp base_month_r, month_m                        // Sets 1st arg (external array month)
    add base_month_r, base_month_r, :lo12:month_m     // Sets 1st arg (low order bits)
    sub month, month, 1                               // month = month - 1

    adrp base_prefix_r, prefix_m                      // Sets 1st arg (external array prefix)
    add base_prefix_r, base_prefix_r, :lo12:prefix_m  // Sets 1st arg (low order bits)

    adrp x0, output1                                      // Sets up 1st arg
    add x0, x0, :lo12:output1                             // Sets up 1st arg (low order bits)

    ldr x1, [base_month_r, month, SXTW 3]             // Sets up 2nd arg 
    mov w2, day                                       // Sets up 3rd arg
    sub day, day, 1                                   // day = day - 1

    ldr x3, [base_prefix_r, day, SXTW 3]              // Sets up 4rd arg

    mov x4, year                                      // Sets up 5th arg
    bl printf                                         // Calls the print function

    b done                                            // Branches to done

default:
    adrp x0, output2                                    // Sets up 1st arg
    add x0, x0, :lo12:output2                           // Sets up 1st arg (low order bits)
    bl printf                                         // Calls the print function

done:
    ldp x29, x30, [sp], 16
    ret    
// ------------------------------ END MAIN --------------------------------\\

    

