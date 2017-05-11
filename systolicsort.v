 module sorting_engine(
     input clk,
     input reset
     );
     
     wire [15:0] right [0:6];
     wire [1:0] odd_L, even_L, odd_R, even_R;
     
     wire [1:0] sp_even_R;
     assign sp_even_R = (even_R==2'b10)?2'b00:even_R;
     
     wire [1:0] sp_odd_L;
     assign sp_odd_L = (odd_L==2'b10)?2'b00:odd_L;
     
     bus_controller controller ( .even_L(even_L),
                                 .even_R(even_R),
                                 .odd_L(odd_L),
                                 .odd_R(odd_R),
                                 .reset(reset),
                                 .clk(clk)
                                 );
     
     processor p1 (  //.left(left),
                     .right(right[0]),
                     .L(sp_odd_L),
                     .R(odd_R),
                     .reset(reset),
                     .clk(clk),
                     .initval(32'h000f000e)
                     );
                     
     processor p2 (  .left(right[0]),
                     .right(right[1]),
                     .L(even_L),
                     .R(even_R),
                     .reset(reset),
                     .clk(clk),
                     .initval(32'h000a000d)
                     );
                     
     processor p3 (  .left(right[1]),
                     .right(right[2]),
                     .L(odd_L),
                     .R(odd_R),
                     .reset(reset),
                     .clk(clk),
                     .initval(32'h000c000b)
                     );
                     
     processor p4 (  .left(right[2]),
                     .right(right[3]),
                     .L(even_L),
                     .R(even_R),
                     .reset(reset),
                     .clk(clk),
                     .initval(32'h00080007)
                     );
                     
     processor p5 (  .left(right[3]),
                     .right(right[4]),
                     .L(odd_L),
                     .R(odd_R),
                     .reset(reset),
                     .clk(clk),
                     .initval(32'h00090006)
                     );
                     
     processor p6 (  .left(right[4]),
                     .right(right[5]),
                     .L(even_L),
                     .R(even_R),
                     .reset(reset),
                     .clk(clk),
                     .initval(32'h00030004)
                     );
                     
     processor p7 (  .left(right[5]),
                     .right(right[6]),
                     .L(odd_L),
                     .R(odd_R),
                     .reset(reset),
                     .clk(clk),
                     .initval(32'h00010002)
                     );
                     
     processor p8 (  .left(right[6]),
                     //.right(right[7]),
                     .L(even_L),
                     .R(sp_even_R),
                     .reset(reset),
                     .clk(clk),
                     .initval(32'h00000005)
                     );
     
 endmodule
 
 module cmp_swap(
     input [15:0] a,
     input [15:0] b,
     output [15:0] c,
     output [15:0] d
     );
     
     assign c = (a>b)?b:a;
     assign d = (a>b)?a:b;
     
 endmodule
     
 
 module processor(
     inout [15:0] left, 
     inout [15:0] right,
     input [1:0] L,
     input [1:0] R,
     input reset,
     input clk,
     input [31:0] initval
     );
     
     reg [15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8;
     
     assign left = (L==2'b11)?((r8==0)?r0:r1):16'bz;
     assign right = (R==2'b11)?((r8==0)?r2:r3):16'bz;
     
     wire [15:0] in1, in2;
     
     assign in1 = (r8==0)?r0:(r8==1)?r2:(r8==2)?r1:(r8==3)?r0:(r8==4)?r2:(r8==5)?r1:r8;
     assign in2 = (r8==0)?r1:(r8==1)?r3:(r8==2)?r2:(r8==3)?r1:(r8==4)?r3:(r8==5)?r2:r8;
     
     wire [15:0] out1, out2;
     
     cmp_swap cmp (  .a(in1), .b(in2), .c(out1), .d(out2));
     
     always @(posedge clk, negedge reset)
     begin
         if(reset==0)
         begin
             {r0, r1} <= initval;
             r8 <= 0;
         end
         else
         begin
             if(L==2'b10 && R==2'b00)
             begin
                 if(r8==0)
                 begin
                     r0<=left;
                 end
                 else
                 begin
                     r1<=left;
                 end
                 if(r8==16'h0)
                 begin
                     r8 <= r8 + 1'b1;
                 end
                 else
                 begin
                     r8 <= 16'h0;
                 end
             end
             else if ((L==2'b01 || L==2'b11) && R==2'b00)
             begin
                 r0<=r0;
                 r1<=r1;
                 r2<=r2;
                 r3<=r3;
                 if(r8==16'h0)
                 begin
                     r8 <= r8 + 1'b1;
                 end
                 else
                 begin
                     r8 <= 16'h0;
                 end
             end
             else if(R==2'b10 && L==2'b00)
             begin
                 if(r8==0)
                 begin
                     r2<=right;
                 end
                 else
                 begin
                     r3<=right;
                 end
                 if(r8==16'h0)
                 begin
                     r8 <= r8 + 1'b1;
                 end
                 else
                 begin
                     r8 <= 16'h0;
                 end
             end
             else if(R==2'b01 && L==2'b00)
             begin
                    
                 if(r8<16'h5)
                 begin
                     r8 <= r8 + 1'b1;
                 end
                 else
                 begin
                     r8 <= 0;
                 end
             
                 case(r8)
'h0:
                     begin
                         r0 <= out1;
                         r1 <= out2;
                     end
'h1:
                     begin
                         r2 <= out1;
                         r3 <= out2;
                     end
'h2:
                     begin
                         r1 <= out1;
                         r2 <= out2;
                     end
'h3:
                     begin
                         r0 <= out1;
                         r1 <= out2;
                     end
'h4:
                     begin
                         r2 <= out1;
                         r3 <= out2;
                     end
'h5:
                     begin
                         r1 <= out1;
                         r2 <= out2;
                     end
                 endcase
             end 
             else
             begin
                 r0<=r0;
                 r1<=r1;
                 r2<=r2;
                 r3<=r3;
                 if(r8==16'h0)
                 begin
                     r8 <= r8 + 1'b1;
                 end
                 else
                 begin
                     r8 <= 16'h0;
                 end
             end
         end
     end 
 endmodule
 
 module bus_controller(
     output reg [1:0] even_L,
     output reg [1:0] even_R,
     output reg [1:0] odd_L,
     output reg [1:0] odd_R,
     input reset,
     input clk
     );
     
     /*
     R = L = 00 -> Idle
     R = 11 -> Send Right, SL = XX
     L = 11 -> Send Left, SR = XX
     L = 10 -> Receive Left, SR = XX
     R = 10 -> Receive Right, SL = XX
     R = 01 -> Compare with value received from right
     This is because comparison is only after receiving from right
     */
     
     reg [2:0] sort_state;
     reg [2:0] data_state;
     reg [2:0] cmp_count;
 	
     initial
     begin
         cmp_count = 3'h0;
         sort_state = 3'h0;
         data_state = 3'h0;
 		even_L = 0;
 		even_R = 0;
 		odd_L = 0;
 		odd_R = 0;
     end
     
     /*
     state = 000 -> odd RR, even SL
     state = 001 -> odd cmp
     state = 010 -> odd SR, even RL
     state = 011 -> odd SL, even RR
     state = 100 -> even cmp
     state = 101 -> odd RL, even SR
     */
     
     always @(posedge clk, negedge reset)
     begin
         if(reset==0)
         begin
             sort_state <= 0;
             data_state <= 0;
             cmp_count <= 0;
             even_L = 0;
             even_R = 0;
             odd_L = 0;
             odd_R = 0;
         end
         else
         begin
             if(data_state==3'h0)
             begin
                 sort_state <= 3'h0;
                 data_state <= data_state + 1'b1;
             end
             else
             begin
                 if(sort_state==3'h0)
                 begin
                     sort_state <= 3'h1;
                 end
                 if(data_state==3'h5)
                 begin
                     data_state <= 3'h0;
                 end
             end
             case(sort_state)
'h1:
                 begin
                     odd_R <= 2'b10;
                     odd_L <= 2'b00;
                     even_L <= 2'b11;
                     even_R <= 2'b00;
                     cmp_count <= cmp_count + 1'b1;
                     if(cmp_count==3'h1)
                     begin
                         sort_state <= 3'h2;
                         cmp_count <= 0;
                     end
                 end
'h2:
                 begin
                     odd_R <= 2'b01;
                     odd_L <= 2'b00;
                     even_L <= 2'b00;
                     even_R <= 2'b00;
                     cmp_count <= cmp_count + 1'b1;
                     if(cmp_count==3'h5)
                     begin
                         sort_state <= 3'h3;
                         cmp_count <= 0;
                     end
                 end
'h3:
                 begin
                     odd_R <= 2'b11;
                     odd_L <= 2'b00;
                     even_L <= 2'b10;
                     even_R <= 2'b00;
                     cmp_count <= cmp_count + 1'b1;
                     if(cmp_count==3'h1)
                     begin
                         sort_state <= 3'h4;
                         cmp_count <= 0;
                     end
                 end
'h4:
                 begin
                     odd_R <= 2'b00;
                     odd_L <= 2'b11;
                     even_L <= 2'b00;
                     even_R <= 2'b10;
                     cmp_count <= cmp_count + 1'b1;
                     if(cmp_count==3'h1)
                     begin
                         sort_state <= 3'h5;
                         cmp_count <= 0;
                     end                
                 end
'h5:
                 begin
                     odd_R <= 2'b00;
                     odd_L <= 2'b00;
                     even_L <= 2'b00;
                     even_R <= 2'b01;
                     cmp_count <= cmp_count + 1'b1;
                     if(cmp_count==3'h5)
                     begin
                         sort_state <= 3'h6;
                         cmp_count <= 0;
                     end
                 end
'h6:
                 begin
                     odd_R <= 2'b00;
                     odd_L <= 2'b10;
                     even_L <= 2'b00;
                     even_R <= 2'b11;
                     cmp_count <= cmp_count + 1'b1;
                     if(cmp_count==3'h1)
                     begin
                         sort_state <= 3'h1;
                         cmp_count <= 0;
                         data_state <= data_state + 1'b1;
                     end
                 end
             endcase
         end
     end
 
 endmodule
