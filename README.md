Project: FPGA-controlled Slot Machine
Contributors: Riley Becker, Shayne Gonzales, Owen Cornog, Nick Ferrari
Due Date: 12/8/25

Parts:
 - 1 Ice 40 FPGA
 - 2 10k ohm resistors
 - 2 push buttons
 - 1 VGA and 1 DB15 vga port

File Logic
- Top.sv contains all the other files instantiated inside a top module
- Top.pcf contains the input and output signals
- fsm.sv contains a state machine for the reset, moving images, and result-screen states
- lfsr.sv contains a linear feedback shift register meant for randomizing the images that appear on screen at the start of the program
- newImage.py and imagegen.py contain a python script that translates the image pixels into ROM files to display on the FPGA
