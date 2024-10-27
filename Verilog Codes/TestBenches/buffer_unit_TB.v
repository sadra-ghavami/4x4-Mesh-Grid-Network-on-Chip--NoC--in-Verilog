`timescale 1ns/1ns

module buffer_unit_TB();
    reg clk = 0, rst = 0, grant_port;
    wire buf_unit_req_in, buf_unit_ack_out;
    wire[17:0] buf_unit_data_in;

    wire buf_unit_ack_in, buf_unit_req_port, buf_unit_req_out;
    wire[3:0] buf_unit_dest;
    wire[17:0] buf_unit_data_out;

    buffer_unit UUT(.clk(clk), .rst(rst), .data_in(buf_unit_data_in), .req_in(buf_unit_req_in), .ack_in(buf_unit_ack_in), .req_port(buf_unit_req_port), .grant_port(grant_port),
                    .req_out(buf_unit_req_out), .ack_out(buf_unit_ack_out), .dest(buf_unit_dest), .data_out(buf_unit_data_out));

    node #(.NODE_ID(0), .PACKET_COUNT(3)) node_generator (.clk(clk), .rst(rst), .data_in(), .req_in(), .ack_in(), .data_out(buf_unit_data_in), .req_out(buf_unit_req_in), .ack_out(buf_unit_ack_in));

    node #(.NODE_ID(1), .PACKET_COUNT(3)) node_reciever (.clk(clk), .rst(rst), .data_in(buf_unit_data_out), .req_in(buf_unit_req_out), .ack_in(buf_unit_ack_out), .data_out(), .req_out(), .ack_out());

    always #10 clk = ~clk;

    integer i;
    initial begin
        #2 rst = 1'b1;
        #5 rst = 1'b0;
        for(i=0; i<3; i = i + 1) begin
        @(posedge buf_unit_req_port);
        #2 grant_port = 1'b1;
           $display("Registered destination is: %d\n", buf_unit_dest);
        @(negedge buf_unit_req_port);
        #2 grant_port = 1'b0;
        end
        #20 $stop;
    end

endmodule