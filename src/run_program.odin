// TODO(pJotoro): Add getting input.

package main

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:math/rand"
import "core:math"
import "core:time"
//import "core:c/libc"

run_program :: proc(_program: [WIDTH][HEIGHT]byte) {
    program := _program
    x := 0
    y := 0
    Direction :: enum {
        Left,
        Right,
        Up,
        Down,
    }
    direction := Direction.Right
    c := program[x][y]
    Stack_Data :: struct #raw_union {
        i: int,
        b: byte,
    }
    stack: [dynamic]Stack_Data
    inside_string: bool
    for c != '@' {
        if !inside_string {
            switch c {
                case ' ':

                case '+':
                    if len(stack) >= 2 {
                        num2 := pop(&stack)
                        num1 := pop(&stack)
                        append(&stack, Stack_Data{i = num1.i + num2.i})
                    }
                    else do append(&stack, Stack_Data{i = 0})
                case '-':
                    if len(stack) >= 2 {
                        num2 := pop(&stack)
                        num1 := pop(&stack)
                        append(&stack, Stack_Data{i = num1.i - num2.i})
                    }
                    else do append(&stack, Stack_Data{i = 0})
                case '*':
                    if len(stack) >= 2 {
                        num2 := pop(&stack)
                        num1 := pop(&stack)
                        append(&stack, Stack_Data{i = num1.i * num2.i})
                    }
                    else do append(&stack, Stack_Data{i = 0})
                case '/':
                    if len(stack) >= 2 {
                        num2 := pop(&stack)
                        num1 := pop(&stack)
                        append(&stack, Stack_Data{i = num1.i / num2.i})
                    }
                    else do append(&stack, Stack_Data{i = 0})
                case '%':
                    if len(stack) >= 2 {
                        num2 := pop(&stack)
                        num1 := pop(&stack)
                        append(&stack, Stack_Data{i = num1.i % num2.i})
                    }
                    else do append(&stack, Stack_Data{i = 0})
                case '!':
                    if len(stack) >= 1 {
                        data := pop(&stack)
                        if data.i <= 0 do append(&stack, Stack_Data{i = 0})
                        else do append(&stack, Stack_Data{i = 1})
                    }
                    else do append(&stack, Stack_Data{i = 0})
                case '`':
                    if len(stack) >= 2 {
                        num2 := pop(&stack)
                        num1 := pop(&stack)
                        append(&stack, Stack_Data{i = int(num1.i > num2.i)})
                    }
                    else do append(&stack, Stack_Data{i = 0})
                case '>':
                    direction = .Right
                case '<':
                    direction = .Left
                case '^':
                    direction = .Up
                case 'v':
                    direction = .Down
                case '?':
                    r := math.floor(rand.float64_range(0, 3))
                    switch r {
                        case 0:
                            direction = .Left
                        case 1:
                            direction = .Right
                        case 2:
                            direction = .Up
                        case 3:
                            direction = .Down
                    }
                case '_':
                    num := pop(&stack)
                    if num.i > 0 do direction = .Left
                    else do direction = .Right
                case '|':
                    num := pop(&stack)
                    if num.i > 0 do direction = .Up
                    else do direction = .Down
                case '\"':
                    inside_string = true
                case ':':
                    append(&stack, stack[len(stack)-1])
                case '\\':
                    v2 := pop(&stack)
                    v1 := pop(&stack)
                    append(&stack, v2, v1)
                case '$':
                    pop(&stack)
                case '.':
                    if len(stack) >= 1 {
                        num := pop(&stack)
                        fmt.print(num.i)
                    }
                case ',':
                    if len(stack) >= 1 {
                        char := pop(&stack)
                        fmt.print(strings.clone_from_bytes([]byte{char.b}))
                    }
                case '#':
                    switch direction {
                        case .Left:
                            x -= 1
                            if x < 0 do x = WIDTH - 1
                        case .Right:
                            x += 1
                            if x >= WIDTH do x = 0
                        case .Up:
                            y -= 1
                            if y < 0 do y = HEIGHT - 1
                        case .Down:
                            y += 1
                            if y >= HEIGHT do y = 0
                    }
                case 'g':
                    y := pop(&stack)
                    x := pop(&stack)
                    append(&stack, Stack_Data{b = program[x.i][y.i]})
                    program[x.i][y.i] = 0
                case 'p':
                    y := pop(&stack)
                    x := pop(&stack)
                    v := pop(&stack)
                    program[x.i][y.i] = v.b
                case '&':
                    buf := make([]u8, 1024)
                    defer delete(buf)
                    input := get_input(buf)
                    n, ok := strconv.parse_int(input)
                    if !ok do append(&stack, Stack_Data{i = 0})
                    else do append(&stack, Stack_Data{i = n})
                case '~':
                    buf := make([]u8, 1024)
                    defer delete(buf)
                    input := get_input(buf)
                    if len(input) > 0 {
                        for input_character in transmute([]byte)input {
                            append(&stack, Stack_Data{b = input_character})
                        }
                    }
                    else do append(&stack, Stack_Data{})
                case:
                    s := strings.clone_from_bytes([]byte{c}, context.temp_allocator)
                    n, ok := strconv.parse_int(s)
                    if ok do append(&stack, Stack_Data{i = n})
                    else {
                        fmt.printf("Unknown instruction '%v' used.\n", c)
                        os.exit(-1)
                    }
            }
        }
        else {
            if c == '\"' do inside_string = false
            else do append(&stack, Stack_Data{b = c})
        }
        
        switch direction {
            case .Left:
                x -= 1
                if x < 0 do x = WIDTH - 1
            case .Right:
                x += 1
                if x >= WIDTH do x = 0
            case .Up:
                y -= 1
                if y < 0 do y = HEIGHT - 1
            case .Down:
                y += 1
                if y >= HEIGHT do y = 0
        }
        c = program[x][y]
    }
    fmt.println("\nProgram ended successfully.")
}

get_input :: proc(buf: []byte) -> string {
    fmt.println("\nEnter a number.")
    fmt.printf("> ")

    read_size, read_err := os.read(os.stdin, buf[:])

    // Strip CR/NL
    input := strings.trim_suffix(string(buf[:read_size]), "\r\n")
    read_size = len(input)

    // Quit if empty input
    if read_size == 0 {
        return {}
    }

    switch read_err {
    case 0, 6:
        return input
    case:
        // Error
        return {}
    }

    return {}
}