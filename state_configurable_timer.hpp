/********************************************************************************
 * Copyright (c) 2013 Naomasa Matsubayashi
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * ******************************************************************************/

#include "LPC8xx.h"

class state_configurable_timer {
  public:
    state_configurable_timer() {
      LPC_SCT->CONFIG = (LPC_SCT->CONFIG & ~0x00060001) | 0x00000000; /* SPLIT */
      /* MATCH/CAPTURE registers */
      LPC_SCT->REGMODE_L = 0x0000;         /* L: 2x MATCH, 0x CAPTURE, 3 unused */
      LPC_SCT->REGMODE_H = 0x0000;             /* H: 0x MATCH, 0x CAPTURE, 5 unused */
      LPC_SCT->MATCH_L[0] = 32768;             /* MATCH0 */
      LPC_SCT->MATCHREL_L[0] = 32768;
      LPC_SCT->MATCH_L[1] = 16384;             /* MATCH1 */
      LPC_SCT->MATCHREL_L[1] = 16384;
      /* OUTPUT registers */
      LPC_SCT->OUT[0].SET = 0x00000001;        /* Output_pin_0 */
      LPC_SCT->OUT[0].CLR = 0x00000002;
      /* Unused outputs must not be affected by any event */
      LPC_SCT->OUT[1].SET = 0;
      LPC_SCT->OUT[1].CLR = 0;
      LPC_SCT->OUT[2].SET = 0;
      LPC_SCT->OUT[2].CLR = 0;
      LPC_SCT->OUT[3].SET = 0;
      LPC_SCT->OUT[3].CLR = 0;
      /* Conflict resolution register */
      /* EVENT registers */
      LPC_SCT->EVENT[0].CTRL = 0x00005000;     /* L: --> state L_ENTRY */
      LPC_SCT->EVENT[0].STATE = 0x00000001;
      LPC_SCT->EVENT[1].CTRL = 0x00005001;     /* L: --> state L_ENTRY */
      LPC_SCT->EVENT[1].STATE = 0x00000001;
      /* Unused events must not have any effect */
      LPC_SCT->EVENT[2].STATE = 0;
      LPC_SCT->EVENT[3].STATE = 0;
      LPC_SCT->EVENT[4].STATE = 0;
      LPC_SCT->EVENT[5].STATE = 0;
      /* STATE registers */
      LPC_SCT->STATE_L = 0;
      LPC_SCT->STATE_H = 0; /* implicit value */
      /* state names assignment: */
      /* State L 0: L_ENTRY */
      /* CORE registers */
      LPC_SCT->START_L = 0x0000;
      LPC_SCT->STOP_L =  0x0000;
      LPC_SCT->HALT_L =  0x0000;
      LPC_SCT->LIMIT_L = 0x0001;
      LPC_SCT->START_H = 0x0000;
      LPC_SCT->STOP_H =  0x0000;
      LPC_SCT->HALT_H =  0x0000;
      LPC_SCT->LIMIT_H = 0x0000;
      LPC_SCT->EVEN =    0x00000000;  
    }
};

