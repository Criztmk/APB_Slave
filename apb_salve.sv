
`define SETUP     2'b00
`define W_ENABLE  2'b01
`define R_ENABLE  2'b10

module apb_slave

(
  input                        clk,
  input                        rst_n,
  input        [7:0] paddr,
  input                        pwrite,
  input                        psel,
  input                        penable,
  input        [31:0] pwdata,
  output reg [31:0] prdata
);

  reg [31:0] mem [64];

  reg [1:0] apb_st =0;
//const logic [1:0] SETUP = 0;
//const logic [1:0] W_ENABLE = 1;
//const logic [1:0] R_ENABLE = 2;

// SETUP -> ENABLE
  always @(negedge rst_n or posedge clk) begin
  if (rst_n == 0) begin
    apb_st <= `SETUP;
    prdata <= 0;
  end

  else begin
    case (apb_st)
      `SETUP : begin
        // clear the prdata
        //prdata <= 0;

        // Move to ENABLE when the psel is asserted
        if (psel) begin
          if (pwrite) begin
            apb_st <= `W_ENABLE;
          end
          else begin
            apb_st <= `R_ENABLE;
          end
        end
      end

      `W_ENABLE : begin
        // write pwdata to memory
        if (psel && penable && pwrite) begin
          mem[paddr] <= pwdata;
        end

        // return to SETUP
        apb_st <= `SETUP;
      end

      `R_ENABLE : begin
        // read prdata from memory
        
        if (psel && penable && !pwrite) begin
          
          prdata <= mem[paddr];
          end

        // return to SETUP
        apb_st <= `SETUP;
      end
      default: begin
        apb_st <= `SETUP;
      end
    endcase
  end
end 

endmodule
