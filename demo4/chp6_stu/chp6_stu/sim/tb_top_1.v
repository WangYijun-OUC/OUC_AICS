`timescale 1ns/100ps

module tb_top_1;

    reg clk;
    reg rst_n;

    reg [1:0] pe_ctl;
    reg pe_vld_i;

    reg [1:0] inst_addr;
    reg [3:0] weight_addr;
    reg [3:0] neuron_addr;
    reg [1:0] result_addr;

    reg [7:0] inst[3:0];
    reg [511:0] neuron[15:0];
    reg [511:0] weight[15:0];
    reg [31:0] result[3:0];

    wire [7:0] pe_inst;
    wire [511:0] pe_weight;
    wire [511:0] pe_neuron;

    assign pe_inst = inst[inst_addr];
    assign pe_weight = weight[weight_addr];
    assign pe_neuron = neuron[neuron_addr];

    initial begin
        /* TODO: 修改数据文件路径 */     
        $readmemh("D:/zhi_neng_ji_suan/demo4/chp6_stu/chp6_stu/data/inst", inst);
        $readmemh("D:/zhi_neng_ji_suan/demo4/chp6_stu/chp6_stu/data/neuron", neuron);
        $readmemh("D:/zhi_neng_ji_suan/demo4/chp6_stu/chp6_stu/data/weight", weight);
        $readmemh("D:/zhi_neng_ji_suan/demo4/chp6_stu/chp6_stu/data/result", result);
    end

    initial begin
        // initial state
        clk = 1'b0;
        rst_n = 1'b0;

        pe_ctl = 2'b00;
        pe_vld_i = 1'b0;

        inst_addr = 2'b0;
        weight_addr = 4'b0;
        neuron_addr = 4'b0;
        result_addr = 2'b0;

        // reset finish
        #10 rst_n = 1'b1;

        // compute for the first output
        #1 pe_ctl = 2'b01;
           pe_vld_i = 1'b1;

           inst_addr = 2'b00;
           weight_addr = 4'b0000;
           neuron_addr = 4'b0000;
           result_addr = 2'b00;

        #1 pe_ctl = 2'b00;

           weight_addr = 4'b0001;
           neuron_addr = 4'b0001;

        #1 weight_addr = 4'b0010;
           neuron_addr = 4'b0010;

        #1 pe_ctl = 2'b10;

           weight_addr = 4'b0011;
           neuron_addr = 4'b0011;

        #1 pe_vld_i = 2'b00;

        // compute for the second output
        #1 pe_ctl = 2'b01;
           pe_vld_i = 1'b1;

           inst_addr = 2'b01;
           weight_addr = 4'b0100;
           neuron_addr = 4'b0100;
           result_addr = 2'b01;

        #1 pe_ctl = 2'b00;

           weight_addr = 4'b0101;
           neuron_addr = 4'b0101;

        #1 weight_addr = 4'b0110;
           neuron_addr = 4'b0110;

        #1 pe_ctl = 2'b10;

           weight_addr = 4'b0111;
           neuron_addr = 4'b0111;

        #1 pe_vld_i = 2'b00;

        // compute for the third output
        #1 pe_ctl = 2'b01;
           pe_vld_i = 1'b1;

           inst_addr = 2'b10;
           weight_addr = 4'b1000;
           neuron_addr = 4'b1000;
           result_addr = 2'b10;

        #1 pe_ctl = 2'b00;

           weight_addr = 4'b1001;
           neuron_addr = 4'b1001;

        #1 weight_addr = 4'b1010;
           neuron_addr = 4'b1010;

        #1 pe_ctl = 2'b10;

           weight_addr = 4'b1011;
           neuron_addr = 4'b1011;

        #1 pe_vld_i = 2'b00;

        // compute for the fourth output
        #1 pe_ctl = 2'b01;
           pe_vld_i = 1'b1;

           inst_addr = 2'b11;
           weight_addr = 4'b1100;
           neuron_addr = 4'b1100;
           result_addr = 2'b11;

        #1 pe_ctl = 2'b00;

           weight_addr = 4'b1101;
           neuron_addr = 4'b1101;

        #1 weight_addr = 4'b1110;
           neuron_addr = 4'b1110;

        #1 pe_ctl = 2'b10;

           weight_addr = 4'b1111;
           neuron_addr = 4'b1111;

        #1 pe_vld_i = 2'b00;

        #10 $finish;
    end

    always begin
        #0.5 clk = ~clk;
    end

    wire [31:0] pe_result;
    wire pe_vld_o;
    parallel_pe uut(
        .clk(clk),
        .rst_n(rst_n),
        .neuron(pe_neuron),
        .weight(pe_weight),
        .ctl(pe_ctl),
        .vld_i(pe_vld_i),
        .result(pe_result),
        .vld_o(pe_vld_o));

    reg compare_pass;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            compare_pass <= 1'b0;
        end
        else if (pe_vld_o && (pe_result == result[result_addr])) begin
            compare_pass <= 1'b1;
            $display("num.%d correct", result_addr);
        end
        else if (~pe_vld_o) begin
            compare_pass <= 1'b0;
        end
    end

   /*reg [1:0] result_addr_1;

   reg compare_pass;
   always@(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         result_addr_1 <= 2'h0;
      end else if(pe_vld_o) begin
         result_addr_1 <= result_addr_1 + 1'b1;
      end
   end

   always@(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         compare_pass <= 1'b1;
      end else if(pe_vld_o && (pe_result != result[result_addr_1][31:0])) begin
         $display("FAIL: num.%d result not correct!!!", result_addr_1);
         compare_pass <= 1'b0;
      end else if(pe_vld_o && (pe_result == result[result_addr_1][31:0])) begin
         $display("INFO: num.%d result is correct.", result_addr_1);
      end
   end*/

endmodule // tb_top_1