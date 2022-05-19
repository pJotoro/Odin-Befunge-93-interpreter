# Odin-Befunge-93-interpreter

NOTE(pJotoro): Getting input is not yet supported because of a bug with core:c/libc where attempting to use C procedures causes unresolved symbol errors.

// NOTE(pJotoro): If you want your Befunge-93 program to work I recommend NEVER using tabs or vertical tabs since I hard coded tabs to be converted to four spaces, and because I skip vertical tabs altogether. That might result in some unpredictable behavior, but I couldn't figure out a way around it.

// NOTE(pJotoro): Strings in Odin are utf8 instead of ascii. If you try to print out a newline or whatever in your Befunge-93 program, you will have to use utf8 character numbers instead of ascii numbers.
