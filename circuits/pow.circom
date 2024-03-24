pragma circom 2.0.0;
include "circomlib/circuits/bitify.circom";

template Pow(N) {
  signal input base;
  signal input power;
  signal output out;

  signal pow[N];
  pow[0] <== base;
  for (var i = 1; i < N; i++) {
    // base^2, base^4, base^8, ...
    pow[i] <== pow[i - 1] * pow[i - 1];
  }

  component n2_power = Num2Bits(N);
  n2_power.in <== power;

  signal res_p[N];
  signal res[N];
  // Decide on n2_power.out[i]
  // 0 --> 1
  // 1 --> pi * b^2i
  res_p[0] <== n2_power.out[0] * (pow[0] - 1) + 1;
  res[0] <== res_p[0];
  for (var i = 1; i < N; i++) {
      res_p[i] <== (n2_power.out[i] * (pow[i] - 1)) + 1;
      res[i] <== res[i - 1] * res_p[i];
  }

  out <== res[N - 1];
}