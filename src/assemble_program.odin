package main

assemble_program :: proc(file_data: []byte, program: ^[WIDTH][HEIGHT]byte) {
    x := 0
    y := 0
    for c in file_data {
        switch c {
            case '\n':
                x = 0
                y += 1
            case '\r', '\b', '\v':
            case '\t':
                program^[x][y] = ' '
                program^[x+1][y] = ' '
                program^[x+2][y] = ' '
                program^[x+3][y] = ' '
                x += 4
            case:
                program^[x][y] = c
                x += 1
        }
    }
}