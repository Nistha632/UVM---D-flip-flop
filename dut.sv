//module declaration for synchronous fifo
module sync_fifo #(int DATA_WIDTH = 8, int DEPTH = 16) (
   input      clk, rst,
   input      write_en, read_en,
   input      [DATA_WIDTH-1:0] wdata,
   output reg [DATA_WIDTH-1:0] rdata,
   output reg full, empty,error,
   output reg amst_full, amst_empty
);
 
   //read and write toggle flags
   reg wr_toggle_f;
   reg rd_toggle_f;
 
   //declaring read and write pointer
   reg [$clog2(DEPTH)-1:0]wr_ptr, rd_ptr;
   //declaring fifo memory
   reg [DATA_WIDTH-1:0] sync_fifo [DEPTH];
 
   always @(posedge clk, posedge rst) begin
       //condition when reset is asserted
       if(rst) begin
           empty       <= 1;
           full        <= 0;
           error       <= 0;
           wr_ptr      <= 0;
           rd_ptr      <= 0;
           rdata       <= 0;
           wr_toggle_f <= 0;
           rd_toggle_f <= 0;
       end
       //condition when reset is not asserted
       else begin
           //condition when read enable is high
           if(read_en) begin
               if(empty == 1'b1) begin
                   error = 1;
               end
               else begin
                   rdata = sync_fifo[rd_ptr];
                   error = 0;
                   if(rd_ptr == DEPTH-1) begin
                       rd_toggle_f = ~rd_toggle_f;
                       rd_ptr = 0;
                   end
                   else begin
                       rd_ptr++;
                   end
               end
           end
           //condition for write enable high
           if(write_en) begin
               if(full == 1'b1) begin
                   error = 1;
               end
               else begin
                   sync_fifo[wr_ptr] = wdata;
                   error = 0;
                   //condition for rollover
                   if(wr_ptr == DEPTH-1) begin
                       wr_toggle_f = ~wr_toggle_f;
                       wr_ptr = 0;
                   end
                   //normal condition
                   else begin
                       wr_ptr++;
                   end
               end
           end
       end
   end
 
   //procedural block for all flags
   always @(wr_ptr, rd_ptr) begin
       //condition for fifo full
       if((wr_ptr == rd_ptr)&&(wr_toggle_f != rd_toggle_f)) begin
           full = 1'b1;
       end
       //condition for fifo almost full
       else if((wr_toggle_f == rd_toggle_f)&&((wr_ptr - rd_ptr) == DEPTH-1)) begin
           amst_full = 1'b1;
           full      = 1'b0;
       end
       //condition for fifo almost full
       else if((wr_toggle_f != rd_toggle_f)&&((rd_ptr - wr_ptr) == 1)) begin
           amst_full = 1'b1;
           full      = 1'b0;
       end
       //condition for fifo empty
       else if((wr_ptr == rd_ptr)&&(wr_toggle_f == rd_toggle_f)) begin
           empty = 1'b1;
       end
       //condition for fifo almost empty
       else if((wr_toggle_f == rd_toggle_f)&&((wr_ptr - rd_ptr) == 1)) begin
           amst_empty = 1'b1;
           empty      = 1'b0;
       end
       //condition for fifo almost empty
       else if((wr_toggle_f != rd_toggle_f)&&((rd_ptr-wr_ptr) == DEPTH-1)) begin
           amst_empty = 1'b1;
           empty      = 1'b0;
       end
       else begin
           full       = 1'b0;
           amst_full  = 1'b0;
           empty      = 1'b0;
           amst_empty = 1'b0;
       end
   end
 
//end of fifo design module
endmodule : sync_fifo

