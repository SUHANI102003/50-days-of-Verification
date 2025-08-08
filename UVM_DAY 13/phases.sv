`include "uvm_macros.svh"
import uvm_pkg ::*;

//---------------------------------------------------------
//                 PHASES IN UVM
//---------------------------------------------------------
/*
1. PHASES IN UVM
2. TIME CONSUMING AND NON-TIME CONSUMING PHASES
3. USING PHASES
4. PHASE DEBUGGING
5. RAISE & DROP OBJECTION
6. DRAIN TIME
*/

/*
          PROCESSES IN VERIFICATION ENVIRONMENT
          
1. Configuring TB env
2. System reset
3. Applying stimulus to DUT
4. Comparing response with golden data
5. Generating Report
*/
// all of these processes are achieved by different phases

// we have 20 phases in total. not all are used. we will cover the most used ones.

// the phases where we want to add our implementation are the phases we need to override.

//--------------------------------------------------------
//            CLASSIFICATION OF PHASES
//--------------------------------------------------------
// 1. ON THE BASIS OF TIME
//---------------------------------------------------------
//    a. Time consuming    (task)  -- run_phase (12 categories)
//    b. Non-time comsuming  (function) -- construction_phase (4 categories) and cleanup_phase (4 categories)


//---------------------------------------------------------
// 2. ON THE BASIS OF OPERATION
//---------------------------------------------------------
// a. construction_phase 
//     1. build_phase (create object of class)
//     2. connect_phase (connection in TLM)
//     3. end_of_elaboration_phase (adjust hierarchy)
//     4. start_of_simulation
//---------------------------------------------------------

// b. run_phase
//     1. reset_phase (system reset) -- pre & post
//     2. configure_phase (var/array/mem initialize) -- pre & post
//     3. main_phase (generating stimulus + collecting response) -- pre & post
//     4. shutdowm_phase  -- pre & post
//---------------------------------------------------------

// c. cleanup_phase
//     collect & report data
//     check coverage goals achieved or not
//     1. extract
//     2. check
//     3. report
//     4. final
//---------------------------------------------------------

