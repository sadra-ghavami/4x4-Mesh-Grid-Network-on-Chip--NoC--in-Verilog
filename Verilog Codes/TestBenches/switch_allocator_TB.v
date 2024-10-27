`timescale  1ns/1ns

module switch_allocator_TB();
    
    reg clk = 0, rst = 0, req_port_local, req_port_west, req_port_north, req_port_east, req_port_south;

    reg[2:0] rout_port_local, rout_port_west, rout_port_north, rout_port_east, rout_port_south;

    wire grant_local, grant_west, grant_north, grant_east, grant_south;

    localparam[2:0] LOCAL_CHANNEL_ID = 3'b000, NORTH_CHANNEL_ID = 3'b001, SOUTH_CHANNEL_ID = 3'b010, EAST_CHANNEL_ID = 3'b011, WEST_CHANNEL_ID = 3'b100; 
    
    switch_allocator #(.PORT_ID(NORTH_CHANNEL_ID)) UUT (.clk(clk), .rst(rst), .req_port_local(req_port_local), .rout_port_local(rout_port_local), .req_port_west(req_port_west),
                                          .rout_port_west(rout_port_west), .req_port_north(req_port_north), .rout_port_north(rout_port_north), .req_port_east(req_port_east),
                                          .rout_port_east(rout_port_east), .req_port_south(req_port_south), .rout_port_south(rout_port_south), .grant_local(grant_local),
                                          .grant_west(grant_west), .grant_north(grant_north), .grant_east(grant_east), .grant_south(grant_south));

    always #10 clk = ~clk;

    initial begin 
        #0 {req_port_local, req_port_west, req_port_north, req_port_east, req_port_south} = 5'b0;
        #2 rst = 1'b1;
        #5 rst = 1'b0;

        #40 {req_port_local, req_port_west, req_port_north, req_port_east, req_port_south} = 5'b11111;
        #0  {rout_port_local, rout_port_west, rout_port_north, rout_port_east, rout_port_south} = {5{NORTH_CHANNEL_ID}};
        
        #80 if(grant_local & ~grant_west & ~grant_north & ~grant_east & ~grant_south)
                $display("Local port got the grant correctly\ttime: %t", $realtime);
            else
                $display("Local port didn't get the grant unfortunately\ttime: %t", $realtime);
        #0 req_port_local = 1'b0;

        #80 if(~grant_local & grant_west & ~grant_north & ~grant_east & ~grant_south)
                $display("west port got the grant correctly\ttime: %t", $realtime);
            else
                $display("west port didn't get the grant unfortunately\ttime: %t", $realtime);
        #0 req_port_west = 1'b0;

        #80 if(~grant_local & ~grant_west & grant_north & ~grant_east & ~grant_south)
                $display("North port got the grant correctly\ttime: %t", $realtime);
            else
                $display("North port didn't get the grant unfortunately\ttime: %t", $realtime);
        #0 req_port_north = 1'b0;

        #80 if(~grant_local & ~grant_west & ~grant_north & grant_east & ~grant_south)
                $display("East port got the grant correctly\ttime: %t", $realtime);
            else
                $display("East port didn't get the grant unfortunately\ttime: %t", $realtime);
        #0 req_port_east = 1'b0;

        #80 if(~grant_local & ~grant_west & ~grant_north & ~grant_east & grant_south)
                $display("South port got the grant correctly\ttime: %t", $realtime);
            else
                $display("South port didn't get the grant unfortunately\ttime: %t", $realtime);
        #20 $stop;


    end

    

endmodule