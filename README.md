![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# Densely Packed Decimal Encoder/Decoder

## How it works

This project converts between three formats for representing values from 0 to 999:

* Binary, wherein decimal values 0-999 are encoded respectively as 10-bit binary values 0000000000-1111100111.
* [Binary-Coded Decimal (BCD)](https://en.wikipedia.org/wiki/Binary-coded_decimal), wherein each decimal digit 0-9 is encoded separately as a 4-bit binary value 0000-1001.
* [Densely-Packed Decimal (DPD)](https://en.wikipedia.org/wiki/Densely_packed_decimal), a compressed form of BCD which only occupies 10 bits.

## Inputting binary format
1. Set `/WE` and `/OE` (dedicated inputs 7 and 6) HIGH.
2. Set `DPD` and `BCD` (dedicated inputs 5 and 4) LOW.
3. Set dedicated inputs 1 and 0 and bidirectional pins 7 down to 0 to the 10 bits of the binary representation.
4. Set `/WE` LOW and pulse `CLK`.

## Inputting BCD format
1. Set `/WE` and `/OE` (dedicated inputs 7 and 6) HIGH.
2. Set `DPD` (dedicated input 5) LOW and `BCD` (dedicated input 4) HIGH.
3. Set dedicated inputs 3 down to 0 and bidirectional pins 7 down to 0 to the 12 bits of the BCD representation.
4. Set `/WE` LOW and pulse `CLK`.

## Inputting DPD format
1. Set `/WE` and `/OE` (dedicated inputs 7 and 6) HIGH.
2. Set `DPD` (dedicated input 5) HIGH and `BCD` (dedicated input 4) LOW.
3. Set dedicated inputs 1 and 0 and bidirectional pins 7 down to 0 to the 10 bits of the DPD representation.
4. Set `/WE` LOW and pulse `CLK`.

## Outputting binary format
1. Set `/WE` (dedicated input 7) HIGH and `/OE` (dedicated input 6) LOW.
2. Set `DPD` and `BCD` (dedicated inputs 5 and 4) LOW.
3. Read the binary representation from dedicated outputs 1 and 0 and bidirectional pins 7 down to 0.

## Outputting BCD format
1. Set `/WE` (dedicated input 7) HIGH and `/OE` (dedicated input 6) LOW.
2. Set `DPD` (dedicated input 5) LOW and `BCD` (dedicated input 4) HIGH.
3. Read the BCD representation from dedicated outputs 3 down to 0 and bidirectional pins 7 down to 0.

## Outputting DPD format
1. Set `/WE` (dedicated input 7) HIGH and `/OE` (dedicated input 6) LOW.
2. Set `DPD` (dedicated input 5) HIGH and `BCD` (dedicated input 4) LOW.
3. Read the DPD representation from dedicated outputs 1 and 0 and bidirectional pins 7 down to 0.

## How to test

The `test.py` file tests conversion in all directions.

## External hardware

Whatever input and output devices you want.

## What is Tiny Tapeout?

Tiny Tapeout is an educational project that aims to make it easier and cheaper than ever to get your digital and analog designs manufactured on a real chip.

To learn more and get started, visit https://tinytapeout.com.

## Resources

- [FAQ](https://tinytapeout.com/faq/)
- [Digital design lessons](https://tinytapeout.com/digital_design/)
- [Learn how semiconductors work](https://tinytapeout.com/siliwiz/)
- [Join the community](https://tinytapeout.com/discord)
- [Build your design locally](https://www.tinytapeout.com/guides/local-hardening/)
