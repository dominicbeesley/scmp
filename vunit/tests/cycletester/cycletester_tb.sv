// You do not need to worry about adding vunit_defines.svh to your
// include path, VUnit will automatically do that for you if VUnit is
// correctly installed (and your python run-script is correct).
`include "vunit_defines.svh"

module tb_example;

   localparam cpu_clk_period = 125;
   localparam progname = "../../../../../asm/test/nop_test_0001.hd";
   localparam dumpname = "./dump.bin"; // this will be loaded at location 0001

   
   bit [7:0] mem [65535:0] = '{default :'0};


   logic cpu_rst_n = 1'b0;
   logic cpu_clk = 1'b0;
   logic [7:0] cpu_D_i;
   logic cpu_sb_i = 1'b0;
   logic cpu_sa_i = 1'b0;
   logic [11:0] cpu_addr;
   logic [7:0] cpu_D_o;
   logic [7:0] cpu_D_o_delay;
   logic cpu_f0;
   logic cpu_f1;
   logic cpu_f2;
   logic sin;
   logic sout;

   logic cpu_ADS_n;
   logic cpu_RD_n;
   logic cpu_WR_n;
   

   logic [3:0] cpu_addr_hi;
   logic cpu_s_r;  
   logic cpu_s_i;  
   logic cpu_s_d;  
   logic cpu_s_h;  




   `TEST_SUITE begin
      // Note: Do not place any code here (unless you are debugging
      // VUnit internals).

      `TEST_SUITE_SETUP begin
         // Here you will typically place things that are common to
         // all tests, such as asserting the reset signal and starting
         // the clock(s).
         $display("Running test suite setup code");
      end

 

      `TEST_CASE_SETUP begin
         // By default VUnit will run each test separately. However,
         // advanced users may want to run tests consecutively rather
         // than in separate instances of the HDL-simulator. In that
         // case the code placed in a TEST_CASE_SETUP block should
         // restore the unit under test to the state expected by the
         // test cases below. In many cases this block would only
         // assert/deassert the reset signal for a couple of
         // clock-cycles.
         //
         // When trying out VUnit for the first time this section
         // should probably be left empty.
         $display("Running test case setup code");
      end

      `TEST_CASE("run cycle counter") begin
         integer f_o, op;
         byte dat;
         byte ctl;

         $readmemh(progname, mem, 1);
         f_o = $fopen(dumpname, "wb");

         fork
            begin
               for (op = 0; op < 256; op = op + 1) begin

                  cpu_rst_n <= 1'b0;
                  #20us;

                  // setup test prog
                  mem[1] = 8;
                  mem[2] = 8;
                  mem[3] = 8;
                  mem[4] = 8;
                  mem[5] = op[7:0];

                  cpu_rst_n <= 1'b1;

                  @(posedge cpu_clk);

                  #20us;

                  @(posedge cpu_clk);

               end
            end
            begin
               while(1) begin
                  
                  @(posedge cpu_clk)
                  begin

                     if (!cpu_RD_n) begin
                        dat = cpu_D_i;
                     end else if (!cpu_ADS_n || !cpu_WR_n) begin
                        dat = cpu_D_o;
                     end else begin
                        dat = 'b11111111;
                     end
                     
                     ctl = { 1'b1, cpu_rst_n, cpu_s_i, cpu_sb_i, cpu_sa_i, 1'b0, cpu_ADS_n, 1'b1 };

                     $fwrite(f_o, "%c%c", dat, ctl);
                  end

               end
            end
         join_any

         $fclose(f_o);


      end

      `TEST_CASE_CLEANUP begin
         // This section will run after the end of a test case. In
         // many cases this section will not be needed.
         $display("Cleaning up after a test case");
      end

      `TEST_SUITE_CLEANUP begin
         // This section will run last before the TEST_SUITE block
         // exits. In many cases this section will not be needed.
         $display("Cleaning up after running the complete test suite");
      end
   end;

   // The watchdog macro is optional, but recommended. If present, it
   // must not be placed inside any initial or always-block.
   `WATCHDOG(10000ms);


   always begin
      #(cpu_clk_period / 2 * 1ns);
      cpu_clk <= ! cpu_clk;
   end

   scmp cpu
   (
      .rst_n(cpu_rst_n),
      .clk(cpu_clk),
      .D_i(cpu_D_i),
      .sb(cpu_sb_i),
      .sa(cpu_sa_i),
      .addr(cpu_addr),
      .D_o(cpu_D_o),
      .f0(cpu_f0),
      .f1(cpu_f1),
      .f2(cpu_f2),
      .sin(sin),
      .sout(sout),

      .ADS_n(cpu_ADS_n),
      .RD_n(cpu_RD_n),
      .WR_n(cpu_WR_n)
   );
   
   always @(posedge cpu_clk) begin
      if (!cpu_ADS_n) begin
         {cpu_s_h, cpu_s_d, cpu_s_i, cpu_s_r, cpu_addr_hi} <= cpu_D_o;
      end
   end

   always @(*) begin
      if (!cpu_RD_n) begin
         cpu_D_i <= mem[{cpu_addr_hi, cpu_addr}];
      end else begin
         cpu_D_i <= 8'bZZZZZZZZ;         
      end
   end
   
   always @(cpu_D_o)
   begin
      cpu_D_o_delay <= #50ns cpu_D_o;
   end

   always @(posedge cpu_WR_n) begin
      mem[{cpu_addr_hi, cpu_addr}] <= cpu_D_o_delay;
   end

endmodule