`timescale 1ns/1ns
module node #(parameter NODE_ID = 0, parameter PACKET_COUNT = 3) (clk, rst, data_in, req_in, ack_in, data_out, req_out, ack_out);
    
    input clk, rst, req_in, ack_out;
    input[17:0] data_in;

    output reg ack_in, req_out;
    output reg[17:0] data_out;


    reg[17:0] header_flit_gen, payload0_flit_gen, payload1_flit_gen, payload2_flit_gen, tail_flit_gen;
    reg[17:0] header_flit_rec, payload0_flit_rec, payload1_flit_rec, payload2_flit_rec, tail_flit_rec;
    reg[63:0] packet_gen, packet_rec;
    reg[3:0]  source_gen, dest_gen;
    reg[3:0]  source_rec, dest_rec; 
    reg[7:0]  packet_num_gen;
    reg[7:0]  packet_num_rec;
    reg[1:0]  type_indicator;

    localparam[1:0] HEADER_TYPE = 2'b01, PAYLOAD_TYPE = 2'b00, TAIL_TYPE = 2'b10;


    integer i, j;
    initial begin //generate packets
        #0 req_out = 1'b0;
        @(negedge rst);
        @(negedge clk);
        for(i=0; i<PACKET_COUNT; i = i + 1)begin

            #0 packet_gen = {$random, $random};
            #0 source_gen = NODE_ID;
            #0 dest_gen = $random;
            #0 dest_gen = (dest_gen == source_gen) ? dest_gen + 3 : dest_gen;
            #0 packet_num_gen  = i;

            #0 header_flit_gen   = {HEADER_TYPE, packet_num_gen, source_gen, dest_gen};
            #0 payload0_flit_gen = {PAYLOAD_TYPE, packet_gen[63:48]};
            #0 payload1_flit_gen = {PAYLOAD_TYPE, packet_gen[47:32]};
            #0 payload2_flit_gen = {PAYLOAD_TYPE, packet_gen[31:16]};
            #0 tail_flit_gen     = {TAIL_TYPE, packet_gen[15:0]};
            
            #1 req_out = 1'b1;
            @(posedge ack_out); 
            #1 req_out = 1'b0;
            @(negedge ack_out);
            // #0 $display("Generate Packet   \tN: %d\tP: %d\tS: %d\tD: %d\tT: %t\tValue: %h\n", NODE_ID, packet_num_gen, source_gen, dest_gen, $realtime, packet_gen);
            #1 data_out = header_flit_gen;
            // #0 $display("Header injected   \tN: %d\tP: %d\tS: %d\tD: %d\tT: %t\tValue: %h\n", NODE_ID, packet_num_gen, source_gen, dest_gen, $realtime, header_flit_gen);

            @(posedge clk);
            #1 data_out = payload0_flit_gen;
            // #0 $display("Payload 0 injected\tN: %d\tP: %d\tS: %d\tD: %d\tT: %t\tValue: %h\n", NODE_ID, packet_num_gen, source_gen, dest_gen, $realtime, payload0_flit_gen);

            @(posedge clk);
            #1 data_out = payload1_flit_gen;
            // #0 $display("Payload 1 injected\tN: %d\tP: %d\tS: %d\tD: %d\tT: %t\tValue: %h\n", NODE_ID, packet_num_gen, source_gen, dest_gen, $realtime, payload1_flit_gen);

            @(posedge clk);
            #1 data_out = payload2_flit_gen;
            // #0 $display("Payload 2 injected\tN: %d\tP: %d\tS: %d\tD: %d\tT: %t\tValue: %h\n", NODE_ID, packet_num_gen, source_gen, dest_gen, $realtime, payload2_flit_gen);

            @(posedge clk);
            #1 data_out = tail_flit_gen;
            // #0 $display("Tail injected     \tN: %d\tP: %d\tS: %d\tD: %d\tT: %t\tValue: %h\n", NODE_ID, packet_num_gen, source_gen, dest_gen, $realtime, tail_flit_gen);

            @(posedge clk);  
            #0 $display("Packet Injected   \tN: %d\tP: %d\tS: %d\tD: %d\tT: %t\tValue: %h\n", NODE_ID, packet_num_gen, source_gen, dest_gen, $realtime, packet_gen); 
        end

    end

    initial begin //recieve packets
        #0 ack_in = 1'b0;
        @(negedge rst);
        while (1) begin    
            @(posedge req_in);
            #2 ack_in = 1'b1;
            @(negedge req_in);
            #2 ack_in = 1'b0;

            @(posedge clk);
            #0 header_flit_rec = data_in;
            #0 {type_indicator, packet_num_rec, source_rec, dest_rec} = header_flit_rec;
            // if(type_indicator != HEADER_TYPE)
            //     $display("Header type was incorrect\tN: %d\tP: %d\tS: %d\tD: %d\tT: %t\tValue: %h\n", NODE_ID, packet_num_rec, source_rec, dest_rec, $realtime, header_flit_rec);
            // else
            //     $display("Header recieved   \tN: %d\tP: %d\tS: %d\tD: %d\tT: %t\tValue: %h\n", NODE_ID, packet_num_rec, source_rec, dest_rec, $realtime, header_flit_rec);
            
            @(posedge clk);
            #0 payload0_flit_rec = data_in;
            // #0 {type_indicator, packet_num_rec, source_rec, dest_rec} = payload0_flit_rec;
            // if(payload0_flit_rec[17:16] != PAYLOAD_TYPE)
            //     $display("Payload 0 type was incorrect\tN: %d\tP: %d\tS: %d\tD: %d\tT: %t\tValue: %h\n", NODE_ID, packet_num_rec, source_rec, dest_rec, $realtime, payload0_flit_rec);
            // else
            //     $display("Payload 0 recieved\tN: %d\tP: %d\tS: %d\tD: %d\tT: %t\tValue: %h\n", NODE_ID, packet_num_rec, source_rec, dest_rec, $realtime, payload0_flit_rec);

            @(posedge clk);
            #0 payload1_flit_rec = data_in;
            // #0 {type_indicator, packet_num_rec, source_rec, dest_rec} = payload1_flit_rec;
            // if(payload1_flit_rec[17:16] != PAYLOAD_TYPE)
            //     $display("Payload 1 type was incorrect\tN: %d\tP: %d\tS: %d\tD: %d\tT: %t\tValue: %h\n", NODE_ID, packet_num_rec, source_rec, dest_rec, $realtime, payload1_flit_rec);
            // else
            //     $display("Payload 1 recieved\tN: %d\tP: %d\tS: %d\tD: %d\tT: %t\tValue: %h\n", NODE_ID, packet_num_rec, source_rec, dest_rec, $realtime, payload1_flit_rec);

            @(posedge clk);
            #0 payload2_flit_rec = data_in;
            // #0 {type_indicator, packet_num_rec, source_rec, dest_rec} = payload2_flit_rec;
            // if(payload2_flit_rec[17:16] != PAYLOAD_TYPE)
            //     $display("Payload 2 type was incorrect\tN: %d\tP: %d\tS: %d\tD: %d\tT: %t\tValue: %h\n", NODE_ID, packet_num_rec, source_rec, dest_rec, $realtime, payload2_flit_rec);
            // else
            //     $display("Payload 2 recieved\tN: %d\tP: %d\tS: %d\tD: %d\tT: %t\tValue: %h\n", NODE_ID, packet_num_rec, source_rec, dest_rec, $realtime, payload2_flit_rec);
        
            @(posedge clk);
            #0 tail_flit_rec = data_in;
            // #0 {type_indicator, packet_num_rec, source_rec, dest_rec} = tail_flit_rec;
            // if(tail_flit_rec[17:16] != TAIL_TYPE)
            //     $display("Tail type was incorrect\tN: %d\tP: %d\tS: %d\tD: %d\tT: %t\tValue: %h\n", NODE_ID, packet_num_rec, source_rec, dest_rec, $realtime, tail_flit_rec);
            // else
            //     $display("Tail recieved     \tN: %d\tP: %d\tS: %d\tD: %d\tT: %t\tValue: %h\n", NODE_ID, packet_num_rec, source_rec, dest_rec, $realtime, tail_flit_rec);
            
            
            #0 packet_rec = {payload0_flit_rec[15:0], payload1_flit_rec[15:0], payload2_flit_rec[15:0], tail_flit_rec[15:0]};
            #0 $display("Packet recieved   \tN: %d\tP: %d\tS: %d\tD: %d\tT: %t\tValue: %h\n", NODE_ID, packet_num_rec, source_rec, dest_rec, $realtime, packet_rec);
            
        end
    end


endmodule