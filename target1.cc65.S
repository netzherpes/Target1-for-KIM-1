
;*****************************
;* Target 1 Column           *
;*                           *
;* (c) Fer Weber             *
;* Kim Kenner 1979           *
;*****************************
         .setcpu "6502"
SEGPTR   =       $00
DIGPTR   =       $01
SPEED    =       $02
SEG1     =       $03
SEGOF1   =       $04
SEG2     =       $05
SEGOF2   =       $06
SEG3     =       $07
SEGOF3   =       $08
MESPT1   =       $09
MESPT2   =       $0a
MESPT3   =       $0b
MESPT4   =       $0c
MESPT5   =       $0d
CODEST   =       $0e
REPEAT   =       $0f
LOOPCO   =       $11
PADD     =       $1741
SBD      =       $1742
KEYIN    =       $1f40
GETKEY   =       $1f6a

         .org    $0200
start:   cld
         lda     #$00
         sta     SEGOF1
         sta     SEGOF2
         sta     SEGOF3
         lda     #$03
         sta     SEGPTR
         lda     #$03
         sta     REPEAT
         lda     #$80
         sta     SPEED
         lda     #$81
         sta     SEG1
         lda     #$c1
         sta     SEG2
         lda     #$c9
         sta     SEG3
         lda     #$3b
         sta     MESPT1
         lda     #$41
         sta     MESPT2
         lda     #$47
         sta     MESPT3
         lda     #$4d
         sta     MESPT4
         lda     #$53
         sta     MESPT5
startc:  lda     #$07
         sta     DIGPTR
contin:  inc     DIGPTR
         inc     DIGPTR
         lda     DIGPTR
         cmp     #$15
         beq     startc
toshow:  ldx     SEGPTR
         lda     SEGPTR,x
         sta     CODEST
liteup:  jsr     show
         lda     #$00
         sta     SBD
         jmp     anykey

show:    lda     #$7f
         sta     PADD
         lda     DIGPTR
         sta     SBD
         lda     CODEST
         sta     PADD-1
         ldy     #$20
loop:    dey
         bne     loop
         rts

pause:   ldx     #$80
loop1:   ldy     #$ff
loop2:   dey
         bne     loop2
         dex
         bne     loop1
         rts

anykey:  jsr     KEYIN
         jsr     GETKEY
         cmp     #$15
         bne     gokey
nokey:   dec     SPEED
         bne     liteup
         lda     #$80
         sta     SPEED
         lda     SEGPTR
         lsr     A
         bcc     nexdig
         inc     SEGPTR
         jmp     toshow

nexdig:  dec     SEGPTR
         jmp     contin

gokey:   cmp     #$13
         bne     key3
         jsr     pause
         jmp     start

key3:    cmp     #$03
         bne     illkey
         jsr     pause
         lda     DIGPTR
         cmp     #$0f
         bne     miss
         lda     SEGPTR
         cmp     #$03
         beq     win
         cmp     #$05
         beq     hit
         cmp     #$07
         beq     hit
miss:    lda     SEGPTR
         pha
         ldx     MESPT1
         jsr     messho
missco:  pla
         sta     SEGPTR
         inc     SEGPTR
         inc     SEGPTR
         lda     SEGPTR
         cmp     #$09
         beq     lose
         cmp     #$0a
         beq     lose
         jmp     startc

lose:    ldx     MESPT5
         jsr     messho
         dec     REPEAT
         bne     lose
         jsr     pause
         jmp     start

illkey:  lda     SEGPTR
         pha
         ldx     MESPT3
         jsr     messho
         jsr     pause
         jmp     missco

hit:     lda     SEGPTR
         pha
         ldx     MESPT2
         jsr     messho
         pla
         sta     SEGPTR
         dec     SEGPTR
         jsr     pause
         jmp     startc

win:     ldx     MESPT4
         jsr     messho
segcode: dec     REPEAT
         bne     win
         jmp     start

messho:  lda     #$80
         sta     LOOPCO
digsta:  lda     #$07
         sta     DIGPTR
segsta:  lda     segcode,x
         sta     CODEST
         inc     DIGPTR
         inc     DIGPTR
         lda     DIGPTR
         cmp     #$15
         beq     xzero
srshow:  jsr     show
         lda     #$00
         sta     PADD-1
         inx
         jmp     segsta

xzero:   dex
         dex
         dex
         dex
         dex
         dex
         dec     LOOPCO
         bne     again
         jsr     pause
         rts

again:   jmp     digsta

         .byte   $b7
         .byte   $bf
         .byte   $80
         .byte   $f4
         .byte   $86
         .byte   $f8
         .byte   $80
         .byte   $f4
         .byte   $86
         .byte   $f8
         .byte   $80
         .byte   $80
         .byte   $f1
         .byte   $bf
         .byte   $be
         .byte   $b8
         .byte   $80
         .byte   $80
         .byte   $f6
         .byte   $9c
         .byte   $d0
         .byte   $d0
         .byte   $f7
         .byte   $ee
         .byte   $ed
         .byte   $f8
         .byte   $9c
         .byte   $f3
         .byte   $84
         .byte   $de
