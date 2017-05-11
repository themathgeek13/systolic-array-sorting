module sortingengine_tb;
   parameter NUMINPUTS = 16;
   parameter WIDTH = 16;
   integer i, errors;

   reg [WIDTH-1:0]  xin[0:NUMINPUTS-1];
   reg [WIDTH-1:0]  xout[0:NUMINPUTS-1];
   reg [WIDTH-1:0] x[0:NUMINPUTS-1];
   reg [WIDTH-1:0] exps[0:NUMINPUTS-1];
   wire [WIDTH-1:0] s[0:NUMINPUTS-1];
   reg clk, reset;
   
   sorting_engine dut(clk, reset, x[0],x[1],x[2],x[3],x[4],x[5],x[6],x[7],x[8],x[9],x[10],x[11],x[12],x[13],x[14],x[15],s[0],s[1],s[2],s[3],s[4],s[5],s[6],s[7],s[8],s[9],s[10],s[11],s[12],s[13],s[14],s[15]);

   initial begin
      errors = 0;
      
      $readmemb("xin.txt", xin);
      $readmemb("sin.txt", xout);

      for(i=0; i<NUMINPUTS; i=i+1) begin
         x[i] = xin[i];
         exps[i] = xout[i];
         // Simulation will automatically apply the inputs and update the output

         if (exps[i] != s[i]) begin
            errors = errors + 1;
            $display("Error on input %d: expected %d, got %d", i, exps[i], s[i]);
         end
      end
      if (errors > 0) begin
         $display("[FAIL] There were %d errors in the output!", errors);
      end else begin
         $display("[PASS] No errors!");
      end
   end
   
endmodule // sortingengine_tb
