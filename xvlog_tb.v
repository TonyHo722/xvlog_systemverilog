// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

//`timescale 1 ns / 1 ps

module xvlog_tb;
	reg clock;
    reg RSTB;

	always #12.5 clock <= (clock === 1'b0);

	initial begin
		clock = 0;
	end

	wire sys_clk = clock;
	wire sys_rst = ~RSTB;
	reg state = 1'd0;
	reg next_state = 1'd0;
	reg mgmtsoc_wishbone_cyc;
	reg mgmtsoc_wishbone_stb;

	initial begin
		$dumpfile("xvlog.vcd");
		$dumpvars(0, xvlog_tb);

	end

    reg [127:0] la_out_storage = 0;
    reg [127:0] la_output;
    
    always @(*) begin
        $display("=> checkpoint 1");
        la_output = 128'd0;
        $display("=> checkpoint 2");
        la_output = la_out_storage;
        $display("=> checkpoint 3");
    end    

    always @(posedge sys_clk) begin
        if (sys_rst) begin
            $display($time, "=> checkpoint 10");
            la_out_storage <= 128'd0;
            $display($time, "=> checkpoint 11");
        end        
    end 

	initial begin
		RSTB <= 1'b0;
		#2000;
		RSTB <= 1'b1;	    	// Release reset
		#1700;

		$finish;
		
	end

    always @(la_output) begin
        $display($time, "=> dump la_output=%x", la_output);
    end    

    always @(la_out_storage) begin
        $display($time, "=> dump la_out_storage=%x", la_out_storage);
    end    


    always @(posedge sys_clk) begin
        state <= next_state;
        if (sys_rst) begin
            state <= 0;
        end
        
    end

endmodule
`default_nettype wire

