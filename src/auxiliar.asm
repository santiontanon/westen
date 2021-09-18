;-----------------------------------------------
; From: http://www.z80st.es/downloads/code/ (author: Konamiman)
; GETSLOT:  constructs the SLOT value to then call ENSALT
; input:
; a: slot
; output:
; a: value for ENSALT
GETSLOT:    
    and #03             ; Proteccion, nos aseguramos de que el valor esta en 0-3
    ld  c,a             ; c = slot de la pagina
    ld  b,0             ; bc = slot de la pagina
    ld  hl,#fcc1        ; Tabla de slots expandidos
    add hl,bc           ; hl -> variable que indica si este slot esta expandido
    ld  a,(hl)          ; Tomamos el valor
    and #80             ; Si el bit mas alto es cero...
    jr  z,GETSLOT_EXIT            ; ...nos vamos a @@EXIT
    ; --- El slot esta expandido ---
    or  c               ; Slot basico en el lugar adecuado
    ld  c,a             ; Guardamos el valor en c
    inc hl              ; Incrementamos hl una...
    inc hl              ; ...dos...
    inc hl              ; ...tres...
    inc hl              ; ...cuatro veces
    ld  a,(hl)              ; a = valor del registro de subslot del slot donde estamos
    and #0C             ; Nos quedamos con el valor donde esta nuestro cartucho
GETSLOT_EXIT:     
    or  c               ; Slot extendido/basico en su lugar
    ret                 ; Volvemos

;-----------------------------------------------
; From: http://www.z80st.es/downloads/code/
; SETPAGES32K:  BIOS-ROM-YY-ZZ   -> BIOS-ROM-ROM-ZZ (SITUA PAGINA 2)
SETPAGES32K:    ; --- Posiciona las paginas de un megarom o un 32K ---
    ld  a,RET_OPCODE        ; Codigo de RET
    ld  (SETPAGES32K_NOPRET),a            ; Modificamos la siguiente instruccion si estamos en RAM
SETPAGES32K_NOPRET:   
    nop                     ; No hacemos nada si no estamos en RAM
    ; --- Si llegamos aqui no estamos en RAM, hay que posicionar la pagina ---
    call RSLREG             ; Leemos el contenido del registro de seleccion de slots
    rrca                    ; Rotamos a la derecha...
    rrca                    ; ...dos veces
    call GETSLOT            ; Obtenemos el slot de la pagina 1 ($4000-$BFFF)
    ld (ROM_slot),a         ; santi: I added this to the routine, so we can easily call methods later from page 1
    ld  h,#80               ; Seleccionamos pagina 2 ($8000-$BFFF)
    jp  ENASLT              ; Posicionamos la pagina 2 y volvemos


;-----------------------------------------------
; Calls a function from page 1
; input:
; ix: function to call from page 1
; call_from_page1:
;     ld a,(ROM_slot)
;     ld iyh,a    ; slot #
;     jp CALSLT


;-----------------------------------------------
; - hl: ptr to the page1 zx0 data
; - de: target address to decompress to
decompress_from_page1:
    ld a,(ROM_slot)
    ld iyh,a    ; slot #
    ld ix,decompress_from_page1_internal
    ld (decompress_from_page1_argument1),hl
    ld (decompress_from_page1_argument2),de
    call CALSLT
    ei
    ret


;-----------------------------------------------
; - hl: ptr to the page1 zx0 data
; - de: target address to decompress to
; - bc: size of the compressed data
; decompress_from_page1_via_RAM:
;     ld a,(ROM_slot)
;     ld iyh,a    ; slot #
;     ld ix,copy_from_page1
;     ld (decompress_from_page1_argument1),hl
;     ld (decompress_from_page1_argument2),bc
;     push de
;         call CALSLT
;         ei
;     pop de
;     ld hl,page1_decompression_buffer
;     jp dzx0_standard


;-----------------------------------------------
; source: https://www.msx.org/forum/development/msx-development/how-0?page=0
; returns 1 in a and clears z flag if vdp is 60Hz
; size: 27 bytes
CheckIf60Hz:
    di
    in      a,(#99)
    nop
    nop
    nop
vdpSync:
    in      a,(#99)
    and     #80
    jr      z,vdpSync
    
    ld      hl,#900
vdpLoop:
    dec     hl
    ld      a,h
    or      l
    jr      nz,vdpLoop
    
    in      a,(#99)
    rlca
    and     1
    ei
    ret


;-----------------------------------------------
; waits a given number of "halts"
; b - number of halts
wait_b_halts:
    halt
    djnz wait_b_halts
    ret


;-----------------------------------------------
; hl: memory to clear
; bc: bytes to clear-1
clear_memory:
    xor a
clear_memory_a:
    ld d,h
    ld e,l
    inc de
    ld (hl),a
    ldir
    ret

