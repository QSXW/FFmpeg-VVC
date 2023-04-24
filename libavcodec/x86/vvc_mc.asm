; /*
; * Provide SIMD mc functions for VVC decoding
; * Copyright (c) 2013 Pierre-Edouard LEPERE
; *
; * This file is part of FFmpeg.
; *
; * FFmpeg is free software; you can redistribute it and/or
; * modify it under the terms of the GNU Lesser General Public
; * License as published by the Free Software Foundation; either
; * version 2.1 of the License, or (at your option) any later version.
; *
; * FFmpeg is distributed in the hope that it will be useful,
; * but WITHOUT ANY WARRANTY; without even the implied warranty of
; * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
; * Lesser General Public License for more details.
; *
; * You should have received a copy of the GNU Lesser General Public
; * License along with FFmpeg; if not, write to the Free Software
; * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
; */
%include "libavutil/x86/x86util.asm"

SECTION_RODATA 64

                    ; 1x, hpelIfIdx == 0, Table 27
pw_vvc_luma_filters dw  0, 0,   0, 64,  0,   0,  0,  0,
                    dw  0, 1,  -3, 63,  4,  -2,  1,  0,
                    dw -1, 2,  -5, 62,  8,  -3,  1,  0,
                    dw -1, 3,  -8, 60, 13,  -4,  1,  0,
                    dw -1, 4, -10, 58, 17,  -5,  1,  0,
                    dw -1, 4, -11, 52, 26,  -8,  3, -1,
                    dw -1, 3,  -9, 47, 31, -10,  4, -1,
                    dw -1, 4, -11, 45, 34, -10,  4, -1,
                    dw -1, 4, -11, 40, 40, -11,  4, -1,
                    dw -1, 4, -10, 34, 45, -11,  4, -1,
                    dw -1, 4, -10, 31, 47,  -9,  3, -1,
                    dw -1, 3,  -8, 26, 52, -11,  4, -1,
                    dw  0, 1,  -5, 17, 58, -10,  4, -1,
                    dw  0, 1,  -4, 13, 60,  -8,  3, -1,
                    dw  0, 1,  -3,  8, 62,  -5,  2, -1,
                    dw  0, 1,  -2,  4, 63,  -3,  1,  0,
                
                    ; 1x, hpelIfIdx == 1, Table 27
                    dw  0, 0,   0, 64,  0,   0,  0,  0,
                    dw  0, 1,  -3, 63,  4,  -2,  1,  0,
                    dw -1, 2,  -5, 62,  8,  -3,  1,  0,
                    dw -1, 3,  -8, 60, 13,  -4,  1,  0,
                    dw -1, 4, -10, 58, 17,  -5,  1,  0,
                    dw -1, 4, -11, 52, 26,  -8,  3, -1,
                    dw -1, 3,  -9, 47, 31, -10,  4, -1,
                    dw -1, 4, -11, 45, 34, -10,  4, -1,
                    dw  0, 3,   9, 20, 20,   9,  3,  0,
                    dw -1, 4, -10, 34, 45, -11,  4, -1,
                    dw -1, 4, -10, 31, 47,  -9,  3, -1,
                    dw -1, 3,  -8, 26, 52, -11,  4, -1,
                    dw  0, 1,  -5, 17, 58, -10,  4, -1,
                    dw  0, 1,  -4, 13, 60,  -8,  3, -1,
                    dw  0, 1,  -3,  8, 62,  -5,  2, -1,
                    dw  0, 1,  -2,  4, 63,  -3,  1,  0,
                
                    ; 1x, affine, Table 30
                    dw 0, 0,   0, 64,  0,   0,  0,  0,
                    dw 0, 1,  -3, 63,  4,  -2,  1,  0,
                    dw 0, 1,  -5, 62,  8,  -3,  1,  0,
                    dw 0, 2,  -8, 60, 13,  -4,  1,  0,
                    dw 0, 3, -10, 58, 17,  -5,  1,  0,
                    dw 0, 3, -11, 52, 26,  -8,  2,  0,
                    dw 0, 2,  -9, 47, 31, -10,  3,  0,
                    dw 0, 3, -11, 45, 34, -10,  3,  0,
                    dw 0, 3, -11, 40, 40, -11,  3,  0,
                    dw 0, 3, -10, 34, 45, -11,  3,  0,
                    dw 0, 3, -10, 31, 47,  -9,  2,  0,
                    dw 0, 2,  -8, 26, 52, -11,  3,  0,
                    dw 0, 1,  -5, 17, 58, -10,  3,  0,
                    dw 0, 1,  -4, 13, 60,  -8,  2,  0,
                    dw 0, 1,  -3,  8, 62,  -5,  1,  0,
                    dw 0, 1,  -2,  4, 63,  -3,  1,  0

pw_vvc_iter_shuffle_index_half dw  0,  1,
                               dw  1,  2,
                               dw  2,  3,
                               dw  3,  4,
                               dw  4,  5,
                               dw  5,  6,
                               dw  6,  7,
                               dw  7,  8,
                               dw 16, 17,
                               dw 17, 18,
                               dw 18, 19,
                               dw 19, 20,
                               dw 20, 21,
                               dw 21, 22,
                               dw 22, 23,
                               dw 23, 24,
     
                               dw  2,  3,
                               dw  3,  4,
                               dw  4,  5,
                               dw  5,  6,
                               dw  6,  7,
                               dw  7,  8,
                               dw  8,  9,
                               dw  9, 10,
                               dw 18, 19,
                               dw 19, 20,
                               dw 20, 21,
                               dw 21, 22,
                               dw 22, 23,
                               dw 23, 24,
                               dw 24, 25,
                               dw 25, 26,
     
                               dw  4,  5,
                               dw  5,  6,
                               dw  6,  7,
                               dw  7,  8,
                               dw  8,  9,
                               dw  9, 10,
                               dw 10, 11,
                               dw 11, 12,
                               dw 20, 21,
                               dw 21, 22,
                               dw 22, 23,
                               dw 23, 24,
                               dw 24, 25,
                               dw 25, 26,
                               dw 26, 27,
                               dw 27, 28,
     
                               dw  6,  7,
                               dw  7,  8,
                               dw  8,  9,
                               dw  9, 10,
                               dw 10, 11,
                               dw 11, 12,
                               dw 12, 13,
                               dw 13, 14,
                               dw 22, 23,
                               dw 23, 24,
                               dw 24, 25,
                               dw 25, 26,
                               dw 26, 27,
                               dw 27, 28,
                               dw 28, 29,
                               dw 29, 30

pw_vvc_iter_shuffle_index_half_4 times 2 dw  0,  1, 1,  2,  2,  3,  3,  4, 16, 17, 17, 18, 18, 19, 19, 20,
                                 times 2 dw  2,  3, 3,  4,  4,  5,  5,  6, 18, 19, 19, 20, 20, 21, 21, 22,
                                 times 2 dw  4,  5, 5,  6,  6,  7,  7,  8, 20, 21, 21, 22, 22, 23, 23, 24,
                                 times 2 dw  6,  7, 7,  8,  8,  9,  9, 10, 22, 23, 23, 24, 24, 25, 25, 26,

pq_vvc_iter_shuffle_index dq 0, 1, 4, 5, 2, 3, 6, 7

SECTION .text

%macro H_COMPUTE_8 6
    vpermw      m16,  m0, m%1
    vpermw      m17,  m1, m%1
    vpermw      m18,  m2, m%1
    vpermw      m19,  m3, m%1
    vpxor       m%1, m%1, m%1
    vpxor       m20, m20, m20
    vpdpwssd    m%1, m16, m%2
    vpdpwssd    m20, m17, m%3
    vpdpwssd    m%1, m18, m%4
    vpdpwssd    m20, m19, m%5
    vpaddd      m%1, m%1, m20
    vpsrad      m%1, %6
%endmacro

%macro H_COMPUTE_H8_10 1
H_COMPUTE_8 %1, 4, 5, 6, 7, 2
%endmacro

%macro H_COMPUTE_V8_10 1
H_COMPUTE_8 %1, 24, 25, 26, 27, 6
%endmacro

%macro H_COMPUTE_4 3
    vpermw       m15, m0, m%2
    vpermw       m14, m0, m%1
    vinserti64x4 m14, m14, ym15, 1

    vpermw       m16, m1, m%2
    vpermw       m15, m1, m%1
    vinserti64x4 m15, m15, ym16, 1

    vpermw       m17, m2, m%2
    vpermw       m16, m2, m%1
    vinserti64x4 m16, m16, ym17, 1

    vpermw       m18, m3, m%2
    vpermw       m17, m3, m%1
    vinserti64x4 m17, m17, ym18, 1

    vpxor        m%1,  m%1, m%1
    vpxor        m%2,  m%2, m%2
    vpdpwssd     m%1,  m14, m4
    vpdpwssd     m%2,  m15, m5
    vpdpwssd     m%1,  m16, m6
    vpdpwssd     m%2,  m17, m7

    vpaddd       m%1, m%1, m%2
    vpsrad       m%1, %3
%endmacro

;
; static void FUNC(put_vvc_luma_hv)(int16_t *dst, const uint8_t *_src, const ptrdiff_t _src_stride,
; const int height, const intptr_t mx, const intptr_t my, const int width,
;   const int hf_idx, const int vf_idx)
; 
%macro VVC_PUT_VVC_LUMA_HV_AVX512ICL 1
cglobal vvc_put_vvc_luma_hv_%1, 9, 12, 32, dst, src, srcstride, height, mx, my, width, hf_idx, vf_idx, r3src, _src, x
%define MAX_PB_SIZE 128*2

    sal          hf_idxq, 4
    lea          hf_idxq, [hf_idxq + mxq]
    sal          hf_idxq, 4
    lea           r3srcq, [pw_vvc_luma_filters]
    vpbroadcastd      m4, [r3srcq + hf_idxq + 0 * 4]
    vpbroadcastd      m5, [r3srcq + hf_idxq + 1 * 4]
    vpbroadcastd      m6, [r3srcq + hf_idxq + 2 * 4]
    vpbroadcastd      m7, [r3srcq + hf_idxq + 3 * 4]

    cmp          heightd, 4
    jne              .hv8
    cmp           widthd, 4
    jne              .hv8
    mova             m0, [pw_vvc_iter_shuffle_index_half_4 + 0 * 64]
    mova             m1, [pw_vvc_iter_shuffle_index_half_4 + 1 * 64]
    mova             m2, [pw_vvc_iter_shuffle_index_half_4 + 2 * 64]
    mova             m3, [pw_vvc_iter_shuffle_index_half_4 + 3 * 64]

    lea           r3srcq, [srcstrideq * 3]
    sub             srcq, 6
    sub             srcq, r3srcq
    movu             ym8, [srcq                 ]
    movu             ym9, [srcq + srcstrideq * 1]
    movu            ym10, [srcq + srcstrideq * 2]
    movu            ym11, [srcq + r3srcq        ]

    movu            ym12, [srcq + srcstrideq * 4]
    
    lea             srcq, [srcq + r3srcq]
    movu            ym13, [srcq + srcstrideq * 2]
    
    lea             srcq, [srcq + r3srcq]
    movu            ym14, [srcq                 ]
    movu            ym15, [srcq + srcstrideq * 1]
    vinserti64x4      m8,  m8, ym12, 1
    vinserti64x4      m9,  m9, ym13, 1
    vinserti64x4     m10, m10, ym14, 1
    vinserti64x4     m11, m11, ym15, 1
    vpxor            m13, m13, m13
    movu            ym12, [srcq + srcstrideq * 2]
    movu            ym13, [srcq + r3srcq        ]
    movu            ym14, [srcq + srcstrideq * 4]
    vinserti64x4     m12, m12, ym14, 1

    H_COMPUTE_4  8,  9, 2
    H_COMPUTE_4 10, 11, 2
    H_COMPUTE_4 12, 13, 2

    vpackusdw     m8, m8, m10
    vpmovdw     ym12, m12

    vextracti64x4 ym9, m8, 1  
    vpunpcklwd    ym10, ym8, ym9
    vpunpckhwd    ym11, ym8, ym9
    vpunpckldq    ym8, ym10, ym11
    vpunpckhdq    ym9, ym10, ym11

    vextracti32x4 xm13, ym12, 1
    vpunpcklwd    xm10, xm12, xm13
    vpunpckhwd    xm11, xm12, xm13
    vpunpckldq    xm12, xm10, xm11
    vpunpckhdq    xm13, xm10, xm11
    
    vextracti64x2 xm10, ym8, 1
    vextracti64x2 xm11, ym9, 1
    vinserti32x4   ym8, xm12, 1
    vinserti32x4   ym9, xm13, 1
    vpunpcklqdq   ym14, ym8, ym10
    vpunpckhqdq    ym8, ym8, ym10
    vpunpcklqdq   ym10, ym9, ym11
    vpunpckhqdq    ym9, ym9, ym11
    
    vinserti64x4    m9, m8, ym9, 1
    vinserti64x4    m8, m14, ym10, 1

    sal          vf_idxq, 4
    lea          vf_idxq, [vf_idxq + myq]
    sal          vf_idxq, 4
    lea           r3srcq, pw_vvc_luma_filters
    vpbroadcastd      m4, [r3srcq + vf_idxq + 0 * 4]
    vpbroadcastd      m5, [r3srcq + vf_idxq + 1 * 4]
    vpbroadcastd      m6, [r3srcq + vf_idxq + 2 * 4]
    vpbroadcastd      m7, [r3srcq + vf_idxq + 3 * 4]

    H_COMPUTE_4        8, 9, 6
    vpmovdw          ym8, m8
    vextracti64x2    xm9, ym8, 1
    vpunpcklwd      xm10, xm8, xm9
    vpunpckhwd      xm11, xm8, xm9
    vpunpckldq       xm8, xm10, xm11
    vpunpckhdq       xm9, xm10, xm11

    psrldq xm10, xm8, 8
    psrldq xm11, xm9, 8

    movq [dstq + MAX_PB_SIZE * 0], xm8
    movq [dstq + MAX_PB_SIZE * 1], xm10
    movq [dstq + MAX_PB_SIZE * 2], xm9
    movq [dstq + MAX_PB_SIZE * 3], xm11

    RET

.hv8:
    mova            m23, [pq_vvc_iter_shuffle_index]
    sal          vf_idxq, 4
    lea          vf_idxq, [vf_idxq + myq]
    sal          vf_idxq, 4
    lea           r3srcq, pw_vvc_luma_filters
    vpbroadcastd     m24, [r3srcq + vf_idxq + 0 * 4]
    vpbroadcastd     m25, [r3srcq + vf_idxq + 1 * 4]
    vpbroadcastd     m26, [r3srcq + vf_idxq + 2 * 4]
    vpbroadcastd     m27, [r3srcq + vf_idxq + 3 * 4]

    mova             m0, [pw_vvc_iter_shuffle_index_half + 0 * 64]
    mova             m1, [pw_vvc_iter_shuffle_index_half + 1 * 64]
    mova             m2, [pw_vvc_iter_shuffle_index_half + 2 * 64]
    mova             m3, [pw_vvc_iter_shuffle_index_half + 3 * 64]

    mov _srcq, srcq

.loop_h8:
    mov               xq, widthq
.loop_v8:
    mov             srcq, _srcq
    lea           r3srcq, [srcstrideq * 3]
    sub             srcq, 6
    sub             srcq, r3srcq
    movu             ym8, [srcq                 ]
    movu             ym9, [srcq + srcstrideq * 1]
    movu            ym10, [srcq + srcstrideq * 2]
    movu            ym11, [srcq + r3srcq        ]

    movu            ym12, [srcq + srcstrideq * 4]
    
    lea             srcq, [srcq + r3srcq        ]
    movu            ym13, [srcq + srcstrideq * 2]
    
    lea             srcq, [srcq + r3srcq        ]
    movu            ym14, [srcq                 ]
    movu            ym15, [srcq + srcstrideq * 1]

    vpxor            m22, m22, m22
    movu            ym16, [srcq + srcstrideq * 2]
    movu            ym17, [srcq + r3srcq        ]
    movu            ym18, [srcq + srcstrideq * 4]
    lea             srcq, [srcq + r3srcq        ]
    movu            ym19, [srcq + srcstrideq * 2]
    lea             srcq, [srcq + r3srcq        ]
    movu            ym20, [srcq                 ]
    movu            ym21, [srcq + srcstrideq * 1]
    movu            ym22, [srcq + srcstrideq * 2]
    vinserti64x4      m8,  m8, ym16, 1
    vinserti64x4      m9,  m9, ym17, 1
    vinserti64x4     m10, m10, ym18, 1
    vinserti64x4     m11, m11, ym19, 1
    vinserti64x4     m12, m12, ym20, 1
    vinserti64x4     m13, m13, ym21, 1
    vinserti64x4     m14, m14, ym22, 1

%assign %%i 8
%rep 8
    H_COMPUTE_H8_10 %%i
%assign %%i %%i+1
%endrep

    vpackusdw         m8,  m8, m12
    vpackusdw         m9,  m9, m13
    vpackusdw        m10, m10, m14
    vpackusdw        m11, m11, m15
  
    vpunpcklwd       m12,  m8, m9
    vpunpckhwd       m13,  m8, m9
    vpunpcklwd       m14, m10, m11
    vpunpckhwd       m15, m10, m11
     
    vpunpckldq        m8, m12, m14
    vpunpckhdq        m9, m12, m14
    vpunpckldq       m10, m13, m15
    vpunpckhdq       m11, m13, m15
 
    vpunpcklqdq      m12, m8, m10
    vpunpckhqdq      m13, m8, m10
    vpunpcklqdq      m14, m9, m11
    vpunpckhqdq      m15, m9, m11

    vpermq            m8, m23, m12
    vpermq            m9, m23, m13
    vpermq           m10, m23, m14
    vpermq           m11, m23, m15

%assign %%i 8
%rep 4
    H_COMPUTE_V8_10 %%i
%assign %%i %%i+1
%endrep

    vpackusdw m8, m8, m10
    vpackusdw m9, m9, m11

    vpunpcklwd     m10,  m8, m9
    vpunpckhwd     m11,  m8, m9
    vpunpckldq      m8, m10, m11
    vpunpckhdq      m9, m10, m11
    
    vextracti64x4 ym10, m8, 1
    vextracti64x4 ym11, m9, 1

    vpunpcklqdq   ym12, ym8, ym10
    vpunpckhqdq   ym13, ym8, ym10
    vpunpcklqdq   ym14, ym9, ym11
    vpunpckhqdq   ym15, ym9, ym11

    movu          [dstq + MAX_PB_SIZE * 0], xm12
    movu          [dstq + MAX_PB_SIZE * 1], xm13
    movu          [dstq + MAX_PB_SIZE * 2], xm14
    movu          [dstq + MAX_PB_SIZE * 3], xm15
    vextracti32x4 [dstq + MAX_PB_SIZE * 4], ym12, 1
    vextracti32x4 [dstq + MAX_PB_SIZE * 5], ym13, 1
    vextracti32x4 [dstq + MAX_PB_SIZE * 6], ym14, 1
    vextracti32x4 [dstq + MAX_PB_SIZE * 7], ym15, 1
 
    lea         _srcq, [_srcq + 16]
    lea          dstq, [ dstq + 16]
    sub            xq, 8
    jnz  .loop_v8

    lea        r3srcq, [widthq * 2]
    lea         _srcq, [_srcq + srcstrideq*8]
    sub         _srcq, r3srcq
    lea          dstq, [dstq + MAX_PB_SIZE*8]
    sub          dstq, r3srcq
    sub       heightq, 8
    jnz  .loop_h8

    RET
%endmacro

%if ARCH_X86_64
%if HAVE_AVX512ICL_EXTERNAL

INIT_ZMM avx512icl
VVC_PUT_VVC_LUMA_HV_AVX512ICL 10

%endif
%endif
