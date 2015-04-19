    .data
array:   .word  0:12        # array of 12 integers

    .text
        li   $8, 4          # $8 is the index, and variable x
        la   $9, array      # $9 is the base address of the array
        mul  $10, $8, 4     # $10 is the offset
        add  $11, $10, $9   # $11 is the address of array[4]
        li   $12, -23       # $12 is the value -23, to be put in array[4]
        sw   $12, ($11)
        