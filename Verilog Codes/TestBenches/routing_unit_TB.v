`timescale 1ns/1ns

module routing_unit_TB();
    
    reg[3:0] dest_l, dest_n, dest_s, dest_e, dest_w;
    wire[2:0] rout_l, rout_n, rout_s, rout_e, rout_w;

    localparam[2:0] LOCAL_CHANNEL_ID = 3'b000, NORTH_CHANNEL_ID = 3'b001, SOUTH_CHANNEL_ID = 3'b010, EAST_CHANNEL_ID = 3'b011, WEST_CHANNEL_ID = 3'b100; 

    routing_unit #(.ROUTER_ID(10)) UUT (dest_l, dest_n, dest_s, dest_e, dest_w, rout_l, rout_n, rout_s, rout_e, rout_w);

    initial begin
        
        #5 dest_l = 4'd11; // rout_id = EAST
           dest_n = 4'd14; // rout_id = SOUTH
           dest_s = 4'd8;  // rout_id = WEST
           dest_e = 4'd2;  // rout_id = NORTH
           dest_w = 4'd10; // rout_id = LOCAL

        #5
        if(rout_l == EAST_CHANNEL_ID)
            $display("Local routed to EAST correctly");
        else
            $display("Local routed in wrong way!!");
        
        if(rout_n == SOUTH_CHANNEL_ID)
            $display("North routed to SOUTH correctly");
        else
            $display("North routed in wrong way!!");

        if(rout_s == WEST_CHANNEL_ID)
            $display("South routed to WEST correctly");
        else
            $display("South routed in wrong way!!");

        if(rout_e == NORTH_CHANNEL_ID)
            $display("East routed to NORTH correctly");
        else
            $display("East routed in wrong way!!");

        if(rout_w == LOCAL_CHANNEL_ID)
            $display("West routed to LOCAL correctly");
        else
            $display("West routed in wrong way!!");

        $stop;

    end

endmodule