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
#include "state_configurable_timer.hpp"
#include "switch_matrix.hpp"
//#include "mbed.h"

extern uint16_t counter;

int main() {
//  DigitalOut output( P0_2 );
  switch_matrix matrix;
  matrix.bind_CTOUT_0_O( 0 );
  matrix.bind_CTOUT_1_O( 1 );
  matrix.bind_CTOUT_2_O( 3 );
  LPC_IOCON->PIO0_0 |= (1<<5);
  LPC_IOCON->PIO0_1 |= (1<<5);
  LPC_IOCON->PIO0_3 |= (1<<5);
  LPC_SYSCON->SYSAHBCLKCTRL |= (1 << 8);
  LPC_SYSCON->SYSAHBCLKCTRL |= (1 << 8);
  LPC_SCT->CTRL_L |= ((1<<3));
  state_configurable_timer timer;
  LPC_SCT->CTRL_L &= ~(1<<2);
  SysTick_Config(SystemCoreClock/20000 );
  for( uint32_t step = 0; ; ++step ) {
//    output.write( ( step >> 8 ) & 0x1u );
    for( int foo = 0; foo != 1000; ++foo );
  }
}
