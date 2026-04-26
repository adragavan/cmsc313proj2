# double.s
# Assemble: gcc -o double double.s -no-pie

    .section .data
prompt:     .ascii "The double is: "
prompt_len = . - prompt

    .section .bss
    .lcomm  input_buf, 32

    .section .text
    .globl  main
main:
    # ---- 1. Read stdin ----
    movq    $0,         %rax
    movq    $0,         %rdi
    leaq    input_buf,  %rsi
    movq    $32,        %rdx
    syscall

    # ---- 2. Parse decimal string -> integer in %rbx ----
    leaq    input_buf,  %rsi
    xorq    %rbx,       %rbx
.parse:
    movzbq  (%rsi),     %rax
    cmpb    $48,        %al
    jl      .parse_done
    cmpb    $57,        %al
    jg      .parse_done
    subq    $48,        %rax
    imulq   $10,        %rbx
    addq    %rax,       %rbx
    incq    %rsi
    jmp     .parse
.parse_done:

    # ---- 3. Double ----
    shlq    $1,         %rbx

    # ---- 4. Integer -> ASCII on stack ----
    
    subq    $24,        %rsp
    movb    $10,        22(%rsp)

    leaq    22(%rsp),   %rdi

    movq    %rbx,       %rax
    testq   %rax,       %rax
    jnz     .itoa
    decq    %rdi
    movb    $48,        (%rdi)
    jmp     .itoa_done

.itoa:
    testq   %rax,       %rax
    jz      .itoa_done
    xorq    %rdx,       %rdx
    movq    $10,        %rcx
    divq    %rcx                    # rdx = digit
    addb    $48,        %dl
    decq    %rdi                    # move left BEFORE storing
    movb    %dl,        (%rdi)
    jmp     .itoa

.itoa_done:


    leaq    23(%rsp),   %rcx
    movq    %rcx,       %rdx
    subq    %rdi,       %rdx

    movq    %rdi,       %r12        # save start
    movq    %rdx,       %r13        # save length

    # ---- 5. Print prompt ----
    movq    $1,         %rax
    movq    $1,         %rdi
    leaq    prompt,     %rsi
    movq    $prompt_len,%rdx
    syscall

    # ---- 6. Print number + newline ----
    movq    $1,         %rax
    movq    $1,         %rdi
    movq    %r12,       %rsi
    movq    %r13,       %rdx
    syscall

    # ---- 7. Exit ----
    addq    $24,        %rsp
    movq    $60,        %rax
    xorq    %rdi,       %rdi
    syscall
