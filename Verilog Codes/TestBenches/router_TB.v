`timescale 1ns/1ns

module router_TB();

    reg clk = 0, rst = 0;
    
    wire req_in_local, req_in_west, req_in_north, req_in_east, req_in_south;

    wire ack_out_local, ack_out_west, ack_out_north, ack_out_east, ack_out_south;

    wire[17:0] data_in_local, data_in_west, data_in_north, data_in_east, data_in_south;


    wire ack_in_local, ack_in_west, ack_in_north, ack_in_east, ack_in_south;

    wire req_out_local, req_out_west, req_out_north, req_out_east, req_out_south;

    wire[17:0] data_out_local, data_out_west, data_out_north, data_out_east, data_out_south;


    router #(.ROUTER_ID(6))  UUT      (.clk(clk), .rst(rst),
                                      .data_in_local(data_in_local), .req_in_local(req_in_local), .ack_in_local(ack_in_local), .req_out_local(req_out_local), .ack_out_local(ack_out_local), .data_out_local(data_out_local),
                                      .data_in_west(data_in_west), .req_in_west(req_in_west), .ack_in_west(ack_in_west), .req_out_west(req_out_west), .ack_out_west(ack_out_west), .data_out_west(data_out_west),
                                      .data_in_north(data_in_north), .req_in_north(req_in_north), .ack_in_north(ack_in_north), .req_out_north(req_out_north), .ack_out_north(ack_out_north), .data_out_north(data_out_north),
                                      .data_in_east(data_in_east), .req_in_east(req_in_east), .ack_in_east(ack_in_east), .req_out_east(req_out_east), .ack_out_east(ack_out_east), .data_out_east(data_out_east),
                                      .data_in_south(data_in_south), .req_in_south(req_in_south), .ack_in_south(ack_in_south), .req_out_south(req_out_south), .ack_out_south(ack_out_south), .data_out_south(data_out_south));


    node #(.NODE_ID(6), .PACKET_COUNT(2)) local_node (.clk(clk), .rst(rst), .data_in(data_out_local), .req_in(req_out_local), .ack_in(ack_out_local),
                                                      .data_out(data_in_local), .req_out(req_in_local), .ack_out(ack_in_local));

    node #(.NODE_ID(5), .PACKET_COUNT(2)) west_node (.clk(clk), .rst(rst), .data_in(data_out_west), .req_in(req_out_west), .ack_in(ack_out_west),
                                                      .data_out(data_in_west), .req_out(req_in_west), .ack_out(ack_in_west));

    node #(.NODE_ID(2), .PACKET_COUNT(2)) north_node (.clk(clk), .rst(rst), .data_in(data_out_north), .req_in(req_out_north), .ack_in(ack_out_north),
                                                      .data_out(data_in_north), .req_out(req_in_north), .ack_out(ack_in_north));

    node #(.NODE_ID(7), .PACKET_COUNT(2)) east_node  (.clk(clk), .rst(rst), .data_in(data_out_east), .req_in(req_out_east), .ack_in(ack_out_east),
                                                      .data_out(data_in_east), .req_out(req_in_east), .ack_out(ack_in_east));

    node #(.NODE_ID(10), .PACKET_COUNT(2)) south_node (.clk(clk), .rst(rst), .data_in(data_out_south), .req_in(req_out_south), .ack_in(ack_out_south),
                                                      .data_out(data_in_south), .req_out(req_in_south), .ack_out(ack_in_south));

    
    always #10 clk = ~clk;

    initial begin
        #2 rst = 1'b1;
        #5 rst = 1'b0;
        #3000 $stop;


    end

endmodule