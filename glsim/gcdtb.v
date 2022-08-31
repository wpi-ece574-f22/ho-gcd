module gcdtb();

   reg [7:0]  a, b;
   reg 	      ld, clk, reset;
   wire [7:0] q;
   wire       rdy;

   integer    nld;
   integer    nrdy;
   
   gcd dut(.a(a), 
  	    .b(b), 
  	    .ld(ld), 
  	    .clk(clk), 
  	    .reset(reset), 
  	    .q(q), 
  	    .rdy(rdy));
   
   always
     begin
	clk = 1'b0;
	#5;
	clk = 1'b1;
	#5;
     end
   
   initial
     begin
	
	$dumpfile("trace.vcd");
	$dumpvars(0, gcdtb);

	nld = 0;
	nrdy = 0;
	
	reset = 1'b1;
	ld    = 1'b0;
	repeat (3) @(posedge clk);
	
	reset = 1'b0;
	
	repeat (3) @(posedge clk);
	
	while (nld < 100)
	  begin
	     
	     if (nld < (nrdy + 1))
	       begin
 		  a = $random;
		  b = $random;
		  $display("gcd(%d, %d)", a, b);
		  
		  ld = 1'b1;
		  nld = nld + 1;		  
	       end
	     else
	       ld = 1'b0;

	     if (rdy)
	       begin
	       nrdy = nrdy + 1;
	       $display("%t result #%d = %d", $time, nrdy, q);
	       end
	     
	     @(posedge clk);
	  end 
	     
	while (nrdy < 100)
	  begin
	     
	     if (rdy)
	       begin
	       nrdy = nrdy + 1;
	       $display("%t result #%d = %d", $time, nrdy, q);
	       end
	     
	     @(posedge clk);
	  end 

	$finish;
     end
   
endmodule
