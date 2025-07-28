/*
-----------------------------------
              enum
----------------------------------
1.Enumerated data types defines a set of named values.
2.An enumerated type is stored as type ‘int’ unless specified as something else.
3.This type automatically gives a unique value to every name in the list.
4.Values default to the ‘int’ type starting at 0 and then incrementing by 1.
5.If a value is not specified for a name, it gets the value of the previous name in the list incremented by 1.
*/

module tb;
//-------------------------------------------------------------------------------------------------
/*
   enum {RED=3, YELLOW, GREEN=6} light_1; // RED = 3, YELOW = 4, GREEN = 6
  
  enum {RED=3, YELLOW, GREEN=4} light_2; // RED = 3, YELOW = 4, GREEN = 4  // ERROR, 2 names have same value assigned
  
  enum bit[1:0] {RED, YELLOW, GREEN} light_3; // RED = 00, YELOW = 01, GREEN = 10 // bit type
  
  enum {RED[4]} light_4;                     // RED[0] = 0, RED[1] = 1, RED[2] = 2, RED[3] = 3
  
  enum {RED[3] = 5} light_5;                  // RED0 = 5, RED1 = 6, RED2 = 7
  
  enum {WHITE[3:5] = 4} light_6;                // WHITE3 = 4, WHITE4 = 5, WHITE5 = 6
  
  enum {1WAY, 2TIMES, SIXPACK=6} e_formula; 		// Compilation error on 1WAY, 2TIMES // cannot start name with number
*/ 
  
//---------------------------------------------------------------------------------------------------
// Enumeration methods
//---------------------------------------------------------------------------------------------------
/*
  enum {
  	MONDAY,
  	TUESDAY,
  	WEDNESDAY,
    THURSDAY,
  	FRIDAY,
  	SATURDAY,
  	SUNDAY} days;
  
  initial begin
    days = days.first;  // returns the value of the first member of the enumeration
 
    $display("Number of elements in days is: %0d", days.num);
    $display("");
    
    for (int i=0; i<7; i++) begin
      $display("Name of the day is: %0s and its default value is: %0d", days.name,days);
      days = days.next; //returns the value of next member of the enumeration
    end
  end
*/
//-------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------
  
  enum {GREEN, YELLOW, RED, BLUE} colors;

	initial begin
      colors color;

      // Assign current value of color to YELLOW
      color = YELLOW;

      $display ("color.first() = %0d", color.first());  // First value is GREEN = 0
      $display ("color.last()  = %0d", color.last());	// Last value is BLUE = 3
      $display ("color.next()  = %0d", color.next()); 	// Next value is RED = 2
      $display ("color.prev()  = %0d", color.prev()); 	// Previous value is GREEN = 0
      $display ("color.num()   = %0d", color.num()); 	// Total number of enum = 4
      $display ("color.name()  = %s" , color.name()); 	// Name of the current enum
    end
 
  
  
  
endmodule
