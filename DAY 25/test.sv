`timescale 1ns / 1ps
// Module Name: test
// Description: 


//--------------------------------------------------
//             TRANSACTION
//----------------------------------------------------
class transaction;
    rand bit rd_en_i, wr_en_i;
    rand bit [7:0] wr_data_i;
    bit [7:0] rd_data_o;
    bit full_o, empty_o;
    
    constraint wr_rd {
        rd_en_i != wr_en_i;
        wr_en_i dist {0:/ 50, 1:/ 50};
        rd_en_i dist {0:/ 50, 1:/ 50};
    }
    
    constraint data_c {
        wr_data_i > 1; 
        wr_data_i < 5;
    }
    
    function void display(input string tag);
        $display("[%0s] : wr_en_i : %0d \t rd_en_i : %0d \t wr_data_i : %0d \t rd_data_o : %0d \t full_o : %0d \t empty_o : %0d",
                 tag, wr_en_i, rd_en_i, wr_data_i, rd_data_o, full_o, empty_o);
    endfunction
    
    function transaction copy();  // deep copy
        copy = new();
        copy.wr_en_i = this.wr_en_i;
        copy.rd_en_i = this.rd_en_i;
        copy.wr_data_i = this.wr_data_i;
        copy.rd_data_o = this.rd_data_o;
        copy.full_o = this.full_o;
        copy.empty_o = this.empty_o;
    endfunction
endclass

//--------------------------------------------------
//             GENERATOR
//---------------------------------------------------
class generator;
    transaction tr;
    mailbox #(transaction) mbx;
    
    int count = 0;
    
    event next;  // when to send next transaction
    event done;  // conveys completion of requested no. of transaction
    
    function new(mailbox #(transaction) mbx);
    this.mbx = mbx; 
    tr = new();
    endfunction
    
    task run();
        
        repeat(count)
            begin
                assert(tr.randomize()) else 
                    $error("Randomization failed");
                
                mbx.put(tr.copy);
                tr.display("GEN");
                @(next);
            end
            
            ->done;
    endtask
endclass

//----------------------------------------------------
//                      DRIVER
//-----------------------------------------------------
class driver;
    virtual fifo_if fif;
    mailbox #(transaction) mbx;
    transaction datac;
    
    event next;
    
    function new(mailbox #(transaction) mbx);
    this.mbx = mbx; 
    endfunction
    
    // reset DUT
    task reset();
        fif.rst_n <= 1'b0;
        fif.rd_en_i <= 1'b0;
        fif.wr_en_i <= 1'b0;
        fif.wr_data_i <= 0;
        repeat(5)@(posedge fif.clk_i);
        fif.rst_n <= 1'b1;
        $display("[DRV] : DUT Reset Done");
        $display("------------------------------------------------");
        
    endtask
    
    
    // applying random stimulus to dut
    task run();
        forever begin
        mbx.get(datac);
        datac.display("DRV");
        
        fif.rd_en_i <= datac.rd_en_i;
        fif.wr_en_i <= datac.wr_en_i;
        fif.wr_data_i <= datac.wr_data_i;
        repeat(2)@(posedge fif.clk_i);
        ->next;
        end
    endtask
endclass

//--------------------------------------------
//               MONITOR
//---------------------------------------------
class monitor;
    virtual fifo_if fif;
    mailbox #(transaction) mbx;
    transaction tr;
    
    function new(mailbox #(transaction) mbx);
    this.mbx = mbx; 
    endfunction
    
    task run();
        tr = new();
        
        forever begin
            repeat(2)@(posedge fif.clk_i);
            tr.wr_en_i = fif.wr_en_i;
            tr.rd_en_i = fif.rd_en_i;
            tr.wr_data_i = fif.wr_data_i;
            tr.full_o = fif.full_o;
            tr.empty_o = fif.empty_o;
            tr.rd_data_o = fif.rd_data_o;
            
            mbx.put(tr);
            tr.display("MON");
        end
    endtask
endclass

//----------------------------------------------------
//                 SCOREBOARD
//----------------------------------------------------
class scoreboard;
    mailbox #(transaction) mbx;
    event next;
    transaction tr;
    
    bit [7:0] din[$];
    bit [7:0] temp;
    
    function new(mailbox #(transaction) mbx);
    this.mbx = mbx; 
    endfunction
    
    task run();
        forever begin
        mbx.get(tr);
        tr.display("SCO");
        
        if(tr.wr_en_i == 1'b1)
            begin
                if(tr.full_o == 1'b0)
                    begin                   
                    din.push_front(tr.wr_data_i);
                    $display("[SCO] : DATA STORED IN QUEUE :%0d", tr.wr_data_i);
                    end
                else 
                    $display("FIFO IS FULL");
            end
            $display("------------------------------------------------------------");
            
            if(tr.rd_en_i == 1'b1)
            begin
                if(tr.empty_o == 1'b0)
                begin
                    temp = din.pop_back();             
                  
                  if(tr.rd_data_o == temp)
                    $display("[SCO] : DATA MATCH");
                    else 
                        $error("DATA MISMATCH");
                                       
                end
                
                else 
                    $display("FIFO IS EMPTY");
            end
            $display("------------------------------------------------------------");
            
            ->next;
         end
    endtask
   
endclass

//-----------------------------------------------------
//                ENVIRONMENT
//-----------------------------------------------------
class environment;
    generator gen;
    driver drv;
    monitor mon;
    scoreboard sco;
    
    mailbox #(transaction) gdmbx;  // gen to drv
    mailbox #(transaction) msmbx; // mon to sco
    
    event nextgs;
    
    virtual fifo_if fif;
    
    function new(virtual fifo_if fif);
        gdmbx = new();
        gen = new(gdmbx);
        drv = new(gdmbx);
        
        msmbx = new();
        mon = new(msmbx);
        sco = new(msmbx);
        
        this.fif = fif;
        
        drv.fif = this.fif;
        mon.fif = this.fif;
        
        gen.next = nextgs;
        sco.next = nextgs;
    endfunction
    
    task pre_test();
        drv.reset();
    endtask
    
    task test();
        fork
            gen.run();
            drv.run();
            mon.run();
            sco.run();
        join_any
    endtask
    
    task post_test();
        wait(gen.done.triggered);
        $finish;
    endtask
    
   task run();
    pre_test();
    test();
    post_test();
  endtask
  
endclass

module test();
 fifo_if fif();
    // Instantiate FIFO
    synchronous_fifo dut (
        .clk_i(fif.clk_i),
        .rst_n(fif.rst_n),
        .wr_en_i(fif.wr_en_i),
        .rd_en_i(fif.rd_en_i),
        .wr_data_i(fif.wr_data_i),
        .rd_data_o(fif.rd_data_o),
        .full_o(fif.full_o),
        .empty_o(fif.empty_o)       
    );
    
    initial begin
    fif.clk_i <= 0;
    end
    
    always #10 fif.clk_i <= ~fif.clk_i;
    
    environment env;
    
    initial begin
        #5;
        env = new(fif);
        env.gen.count = 10;
        #5;
        env.run();
    end
    
    
endmodule
