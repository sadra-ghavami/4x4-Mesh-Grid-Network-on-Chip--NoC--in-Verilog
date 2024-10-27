module NOC_4x4 (clk, rst);
    input clk, rst;

    wire[17:0] data_in_node [0:15];
    wire[0:15] req_in_node, ack_in_node, req_out_node, ack_out_node;
    wire[17:0] data_out_node [0:15];

    wire[17:0] data_in_horizontal [0:19];
    wire[0:19] req_in_horizontal, ack_in_horizontal, req_out_horizontal, ack_out_horizontal;
    wire[17:0] data_out_horizontal [0:19];

    wire[17:0] data_in_vertical [0:19];
    wire[0:19] req_in_vertical, ack_in_vertical, req_out_vertical, ack_out_vertical;
    wire[17:0] data_out_vertical [0:19];

    localparam size = 4;
    localparam packet_count = 2;

    genvar i, j;
    generate
        for(i = 0; i < size; i = i + 1)

            for(j = 0; j < size; j = j + 1) begin
                
                router #(.ROUTER_ID(i * size + j)) router_unit (.clk(clk), .rst(rst),
                    .data_in_local(data_out_node[i * size + j]), .req_in_local(req_out_node[i * size + j]), .ack_in_local(ack_out_node[i * size + j]), .req_out_local(req_in_node[i * size + j]), .ack_out_local(ack_in_node[i * size + j]), .data_out_local(data_in_node[i * size + j]),

                    .data_in_west(data_in_horizontal[i * (size+1) + j]), .req_in_west(req_in_horizontal[i * (size+1) + j]), .ack_in_west(ack_in_horizontal[i * (size+1) + j]), .req_out_west(req_out_horizontal[i * (size+1) + j]), .ack_out_west(ack_out_horizontal[i * (size+1) + j]), .data_out_west(data_out_horizontal[i * (size+1) + j]),

                    .data_in_north(data_in_vertical[j * (size+1) + i]), .req_in_north(req_in_vertical[j * (size+1) + i]), .ack_in_north(ack_in_vertical[j * (size+1) + i]), .req_out_north(req_out_vertical[j * (size+1) + i]), .ack_out_north(ack_out_vertical[j * (size+1) + i]), .data_out_north(data_out_vertical[j * (size+1) + i]),

                    .data_in_east(data_out_horizontal[i * (size+1) + j + 1]), .req_in_east(req_out_horizontal[i * (size+1) + j + 1]), .ack_in_east(ack_out_horizontal[i * (size+1) + j + 1]), .req_out_east(req_in_horizontal[i * (size+1) + j + 1]), .ack_out_east(ack_in_horizontal[i * (size+1) + j + 1]), .data_out_east(data_in_horizontal[i * (size+1) + j + 1]),
                                      
                    .data_in_south(data_out_vertical[j * (size+1) + i + 1]), .req_in_south(req_out_vertical[j * (size+1) + i + 1]), .ack_in_south(ack_out_vertical[j * (size+1) + i + 1]), .req_out_south(req_in_vertical[j * (size+1) + i + 1]), .ack_out_south(ack_in_vertical[j * (size+1) + i + 1]), .data_out_south(data_in_vertical[j * (size+1) + i + 1]));

                node #(.NODE_ID(i * size + j), .PACKET_COUNT(packet_count)) node_unit (.clk(clk), .rst(rst), .data_in(data_in_node[i * size + j]), .req_in(req_in_node[i * size + j]), .ack_in(ack_in_node[i * size + j]),
                                                                            .data_out(data_out_node[i * size + j]), .req_out(req_out_node[i * size + j]), .ack_out(ack_out_node[i * size + j]));


            end

    endgenerate
    
endmodule