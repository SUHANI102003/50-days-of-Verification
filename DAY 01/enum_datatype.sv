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
endmodule
