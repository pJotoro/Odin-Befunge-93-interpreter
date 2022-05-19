package main

import "core:os"
import "core:fmt"
import "core:slice"
import "core:strings"
import "core:unicode"

comptime_errors :: proc(file_data: []byte) {
    width := 0
    height := 0
    max_width := 0
    had_error: bool
    for c in file_data {
        if c == '\t' do width += 4
        else if c == '\n' {
            if width > max_width do max_width = width
            width = 0
            height += 1
        }
        else do width += 1
    }
    if max_width > 0 {
        if max_width > WIDTH {
            fmt.println("Width must be 80 at most.")
            had_error = true
        }
    }
    else if width > WIDTH {
        fmt.println("Width must be 80 at most.")
        had_error = true
    }
    if height > HEIGHT {
        fmt.println("Height must be 25 at most.")
        had_error = true
    }
    if had_error do os.exit(-1)
}