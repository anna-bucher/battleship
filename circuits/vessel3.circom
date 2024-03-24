pragma circom 2.0.0;
include "./pow.circom";
include "circomlib/circuits/mux1.circom";
include "circomlib/circuits/bitify.circom";
include "circomlib/circuits/comparators.circom";

// FIRST VERSION WITH A 3x3 grid
template Vessel3() {
  signal input v;
  signal input po;
  signal input pv;

  // CHECK that v is max 9 bits
  component n2_v = Num2Bits(9); // grid size => 9 
  n2_v.in <== v;

  // CHECK po in {0,1,2}
  component n2_po = Num2Bits(2);
  n2_po.in <== po;
  component lt_po = LessThan(2);
  lt_po.in[0] <== po;
  lt_po.in[1] <== 4;
  lt_po.out === 1;

  // CHECK pv in {0,1}
  component n2_pv = Num2Bits(1);
  n2_pv.in <== pv; 

  // Decide orientation
  component is0_pv = IsZero();
  is0_pv.in <== pv;

  // CHECK that v contains a valid 3 square vessel
  component mux1 = Mux1();
  mux1.s <== is0_pv.out;  
  // Horizontal vessel case (vessel at bottom-right)
  // 000000111 = 7
  // 7 << 3 * po == v
  component h_pow = Pow(9);
  h_pow.base <== 2;
  h_pow.power <== 3 * po;
  mux1.c[1] <== 7 * h_pow.out - v;
  // Vertical vessel case (at bottom-right, smallest bit)
  // 001001001 = 73
  // 73 << po == v
  component v_pow = Pow(9);
  v_pow.base <== 2;
  v_pow.power <== po;
  mux1.c[0] <== 73 * v_pow.out - v;

  // CHECK vessel value v
  0 === mux1.out;
}