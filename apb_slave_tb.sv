// Code your testbench here
// or browse Examples

module apb_slave_tb();
  
  reg pclk;
  reg prstn;
  reg [7:0]paddr;
  reg psel;
  reg penb;
  reg pwrite;
  reg [31:0]pwdata;
  
  wire [31:0]prdata;
  reg [31:0]rdata;
  
  initial begin
    //asserting reset
    
    pclk=0;
    prstn=0;
    #5;
    prstn=1;
    psel=0;
    penb=0;
    pwdata=0;
    #5;
   //calling write and Read task
    Write();
    #10;
    Read();
    #10
    $finish;
  end
    
    always #1 pclk =~pclk;
  
  apb_slave dut(.clk(pclk),.rst_n(prstn),.paddr(paddr),.pwrite(pwrite),.psel(psel),.penable(penb),.pwdata(pwdata),.prdata(prdata));
  
   task Write;
 begin
      for (int i = 0; i < 64; i=i+1) begin
       // begin 
	 	psel = 1;
	 	pwrite = 1;
		paddr = i;
        pwdata = i;
        @(posedge pclk);   
        penb = 1;
        @(posedge pclk);
        psel=0;
        penb=0;
         
      $display("%0t PADDR %h, PWDATA %h  ",$time, paddr,pwdata);
	 //end
//end
   end
 end
   endtask
  
  task Read;
begin	 
    for (int j = 0;  j< 64; j= j+1) begin
  		psel =1;
      @(posedge pclk)
        penb = 1;
        paddr = j;
        pwrite = 0;
        rdata = prdata;
      @(posedge pclk)
      psel=0;
      penb=0;
      $display("PADDR %h, PRDATA %h  ",paddr,rdata);
end
end
 endtask
  
  
  initial begin
    // Dump waves
    $dumpvars(2, apb_slave_tb);
  end
endmodule
