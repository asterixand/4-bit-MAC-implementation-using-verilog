`timescale 1ns/1ps

module mac(in_a, in_b, in_valid_a, in_valid_b, clk, 
			reset, mac_out, out_valid);

//input output declartion			
input signed [3:0] 	 in_a, in_b;
input 			     in_valid_a, in_valid_b;
input			     clk, reset;
output reg signed [10:0] mac_out;
output 		reg          out_valid;


//////////////////////////////////////////////////////////////////////////
parameter  IDLE  = 3'b000 ;
parameter WAIT_A = 3'b001 ;
parameter WAIT_B = 3'b010 ;
parameter  MAC   = 3'b011 ;

reg out_sig ;
reg [3:0] counter ;
reg [1:0] state_Next , state ;
reg signed [3:0] reg_a , reg_b ;
reg signed [10:0] reg_c , temp_out;

always@(negedge clk)
begin
	if(reset)
		counter <= 4'd0 ;
	else if(counter==4'd8)
		if(in_valid_a&in_valid_b)
		counter <= 4'd1 ;
		else
		counter <= 4'd0 ;
	else if(state==MAC)
		counter <= counter + 4'd1 ;
end

always@(posedge clk )
begin
	if(reset)
		state <= IDLE ;
	else
		state <= state_Next ;
end

always@(*)
begin
	case(state)
		IDLE : if(in_valid_a&in_valid_b) 
				 state_Next = MAC   ;
			   else if(in_valid_a) 
				state_Next = WAIT_B ; 
			   else if(in_valid_b) 
			    state_Next = WAIT_A ; 
			   else	        state_Next = IDLE   ;
		
		WAIT_A : if(in_valid_a) 
				  state_Next = MAC ; 
				 else state_Next = WAIT_A ;
				 
		WAIT_B : if(in_valid_b) 
		          state_Next = MAC ; 
				 else state_Next = WAIT_B ;
		
		MAC    : if(in_valid_a&in_valid_b) 
				 state_Next = MAC ; 
				 else if(in_valid_a)
					state_Next = WAIT_B ;
				 else if(in_valid_b)
					state_Next = WAIT_A ;
				 else state_Next = IDLE ;
		default : state_Next = IDLE ;
	endcase
end

always@(posedge clk)
begin
	if(in_valid_a)
		reg_a <= in_a ;
end

always@(posedge clk)
begin
	if(in_valid_b)
		reg_b <= in_b ;
end

always@(negedge clk)
begin
	if(reset)
		reg_c <= 11'd0 ;
	else if(counter==4'd8)
		if(in_valid_a&in_valid_b)
		reg_c <= reg_a*reg_b ;
		else
		reg_c <= 11'd0 ;
	else if(state==MAC)
		reg_c <= reg_c + (reg_a*reg_b) ;
	
end

always@(posedge clk)
begin
	if(counter>=4'd1&&counter<=4'd8)
		temp_out <= reg_c ;
end

always@(posedge clk)
begin
	if(counter==4'd8)
		out_sig <= 1 ;
	else
		out_sig <= 0 ;
end

always@(posedge clk)
begin
	if(out_sig)
		out_valid <= 1 ;
	else
		out_valid <= 0 ;
end

always@(posedge clk)
begin
	if(out_sig)
		mac_out <= temp_out ;
	
end

endmodule
