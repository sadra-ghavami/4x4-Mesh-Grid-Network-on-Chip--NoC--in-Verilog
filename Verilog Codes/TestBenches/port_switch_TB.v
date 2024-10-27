`timescale 1ns/1ns
module port_switch_TB();

    reg clk = 0, rst = 0, req_port_local, req_port_west, req_port_north, req_port_east, req_port_south;

    reg[2:0] rout_port_local, rout_port_west, rout_port_north, rout_port_east, rout_port_south;

    reg req_out_local, req_out_west, req_out_north, req_out_east, req_out_south;

    reg[17:0] data_out_local, data_out_west, data_out_north, data_out_east, data_out_south;

    reg ack_out_port;

    

    wire grant_local, grant_west, grant_north, grant_east, grant_south;
    wire req_out_port;
    wire ack_out_local, ack_out_west, ack_out_north, ack_out_east, ack_out_south;
    wire[17:0] data_out_port;

    localparam[2:0] LOCAL_CHANNEL_ID = 3'b000, NORTH_CHANNEL_ID = 3'b001, SOUTH_CHANNEL_ID = 3'b010, EAST_CHANNEL_ID = 3'b011, WEST_CHANNEL_ID = 3'b100; 

    port_switch #(.PORT_ID(SOUTH_CHANNEL_ID)) UUT (clk, rst, req_port_local, rout_port_local, req_port_west, rout_port_west, req_port_north, rout_port_north, 
                                                   req_port_east, rout_port_east, req_port_south, rout_port_south, grant_local, grant_west, grant_north, grant_east, grant_south,
                                                   req_out_local, data_out_local, req_out_west, data_out_west, req_out_north, data_out_north, req_out_east, data_out_east, 
                                                   req_out_south, data_out_south, ack_out_local, ack_out_west, ack_out_north, ack_out_east, ack_out_south, ack_out_port,
                                                   req_out_port, data_out_port, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);


    always #10 clk = ~clk;

    initial begin
        ack_out_port = 1'b0;
        @(negedge rst);
        while(1) begin
            @(posedge req_out_port);
            @(posedge clk);
            #3 ack_out_port = 1'b1;
            @(negedge req_out_port);
            #2 ack_out_port = 1'b0;
            @(posedge clk);
            $display("the out port recieved %h", data_out_port);
        end      
    end

    initial begin 
        #0 {req_port_local, req_port_west, req_port_north, req_port_east, req_port_south} = 5'b0;
        #0 {req_out_local, req_out_west, req_out_north, req_out_east, req_out_south} = 5'b0;
        #2 rst = 1'b1;
        #5 rst = 1'b0;

        #40 {req_port_local, req_port_west, req_port_north, req_port_east, req_port_south} = 5'b11111;
        #0  {rout_port_local, rout_port_west, rout_port_north, rout_port_east, rout_port_south} = {5{SOUTH_CHANNEL_ID}};
        
        #80 if(grant_local & ~grant_west & ~grant_north & ~grant_east & ~grant_south)
                $display("Local port got the grant correctly\ttime: %t", $realtime);
            else
                $display("Local port didn't get the grant unfortunately\ttime: %t", $realtime);
        #0 req_out_local = 1'b1;
        @(posedge ack_out_local);
        #0 req_out_local = 1'b0;
        @(negedge ack_out_local);
        #0 data_out_local = $random;
        $display("local port sent %h data to out port", data_out_local);


        #20 req_port_local = 1'b0;
        #80 if(~grant_local & grant_west & ~grant_north & ~grant_east & ~grant_south)
                $display("West port got the grant correctly\ttime: %t", $realtime);
            else
                $display("West port didn't get the grant unfortunately\ttime: %t", $realtime);
        #0 req_out_west = 1'b1;
        @(posedge ack_out_west);
        #0 req_out_west = 1'b0;
        @(negedge ack_out_west);
        #0 data_out_west = $random;
        $display("west port sent %h data to out port", data_out_west);


        #20 req_port_west = 1'b0;
        #80 if(~grant_local & ~grant_west & grant_north & ~grant_east & ~grant_south)
                $display("North port got the grant correctly\ttime: %t", $realtime);
            else
                $display("North port didn't get the grant unfortunately\ttime: %t", $realtime);
        #0 req_out_north = 1'b1;
        @(posedge ack_out_north);
        #0 req_out_north = 1'b0;
        @(negedge ack_out_north);
        #0 data_out_north = $random;
        $display("North port sent %h data to out port", data_out_north);


        #20 req_port_north = 1'b0;
        #80 if(~grant_local & ~grant_west & ~grant_north & grant_east & ~grant_south)
                $display("East port got the grant correctly\ttime: %t", $realtime);
            else
                $display("East port didn't get the grant unfortunately\ttime: %t", $realtime);
        #0 req_out_east = 1'b1;
        @(posedge ack_out_east);
        #0 req_out_east = 1'b0;
        @(negedge ack_out_east);
        #0 data_out_east = $random;
        $display("east port sent %h data to out port", data_out_east);


        #20 req_port_east = 1'b0;
        #80 if(~grant_local & ~grant_west & ~grant_north & ~grant_east & grant_south)
                $display("South port got the grant correctly\ttime: %t", $realtime);
            else
                $display("South port didn't get the grant unfortunately\ttime: %t", $realtime);
        #0 req_out_south = 1'b1;
        @(posedge ack_out_south);
        #0 req_out_south = 1'b0;
        @(negedge ack_out_south);
        #0 data_out_south = $random;
        $display("South port sent %h data to out port", data_out_south);
        
        #20 $stop;


    end


endmodule