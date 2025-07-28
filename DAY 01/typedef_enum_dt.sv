/*
--------------------------------
typedef
--------------------------------
In typedef a type name can be given so that the same type can be used in many places.
*/

module typedef_enum_dt;
  
  typedef enum {
  	MONDAY,
  	TUESDAY,
  	WEDNESDAY,
    THURSDAY,
  	FRIDAY,
  	SATURDAY,
    SUNDAY} week_e ;
  
  	week_e day;  //declare week type day variable
  
  initial begin
    
    day = day.first(); //assign first day in variable day
    $display("\nfirst day name = %s  and its value is = %0d",day.name,day);

    day = day.last();  //assign last day in variable day
    $display("\nlast day name = %s  and its value is = %0d",day.name,day);

    day = WEDNESDAY;  // assign wednesday in day
    day = day.next(); // assign the next day after wednesday
    $display("\n next day name after wednesday  = %s  and its value is = %0d",day.name,day);

    day = WEDNESDAY;
    day = day.prev();  //assign the previous day befor wednesday
    $display("\n previous day name befor wednesday  = %s  and its value is = %0d",day.name,day);

    $display("\n current day name = %s  and its value is = %0d",day.name(),day);

    $display("\n total number of days in week type is = %0d\n",day.num());
 
  end
  
  
  
endmodule
