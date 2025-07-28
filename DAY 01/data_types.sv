/*
--------------------------
 4-state (0,1,x,z)
--------------------------
 reg
 wire
 logic  -- replacement of reg and wire 
 integer        //32 bits signed
 real           //64 bits
 time           //64 bits
 
 --------------------------------------------
 2-state (0,1) [ALL HAVE 0 AS DEFAULT VALUE]
 --------------------------------------------
 bit    //unsigned
 byte         //8bits signed
 shortint   //16 bits
 int         //32 bits
 longint     //64 bits
 */

module data_types;
  
  logic [2:0] logic_data_type;
  integer integer_dt;
  real real_dt;
  time time_dt;
  bit [3:0] bit_dt;
  byte byte_dt;
  shortint shortint_dt;
  int int_dt;
  longint longint_dt;
  
  initial begin 
    $display("----------------------------------------------------------------");
    $display("Default value of logic is: %b", logic_data_type);
    logic_data_type=3'b101;
    $display("value of logic after initialization is: %b", logic_data_type);
    $display("----------------------------------------------------------------");
    
    $display("Default value of integer is: %0d", integer_dt);
    integer_dt = 6786543;
    $display("value of integer after initialization is: %0d", integer_dt);
    $display("----------------------------------------------------------------");
    
    $display("Default value of real is: %0d", real_dt);
    real_dt = 6786.543;
    $display("value of real after initialization is: %0d", real_dt);
    $display("----------------------------------------------------------------");
    
    $display("Default value of time is: %0t", time_dt);
    time_dt = $time;
    $display("value of time after initialization is: %0t",time_dt);
    $display("----------------------------------------------------------------");
    
    bit_dt = 4'b10x0; // x = 0 = default
    $display("value of bit after initialization is: %b", bit_dt);
    $display("----------------------------------------------------------------");
    
    byte_dt = 8'b00001001;
    $display("value of byte after initialization is: %b", byte_dt);
    $display("----------------------------------------------------------------");
    
    shortint_dt = -56;
    $display("value of shortint after initialization is: %0d", shortint_dt);
    $display("----------------------------------------------------------------");
    
    int_dt = -678;
    $display("value of int after initialization is: %0d", int_dt);
    $display("----------------------------------------------------------------");
    
    longint_dt = 6798768;
    $display("value of longint after initialization is: %0d", longint_dt);
    $display("----------------------------------------------------------------");
  end
  
endmodule
