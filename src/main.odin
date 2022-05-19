package main

import "core:os"
import "core:fmt"

WIDTH :: 80
HEIGHT :: 25

main :: proc() {
    if len(os.args) != 2 {
        fmt.println("Usage: bf [filename]")
    }
    comptime_errors(file_data)
    program: [WIDTH][HEIGHT]byte
    assemble_program(file_data, &program)
    run_program(program)
}