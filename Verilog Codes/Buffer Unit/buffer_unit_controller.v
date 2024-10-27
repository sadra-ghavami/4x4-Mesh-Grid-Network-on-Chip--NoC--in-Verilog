module buffer_unit_controller(clk, rst, req_in, ack_in, flit_type, read, write, empty, full, load_dest, req_out, ack_out, req_port, grant_port);
    
    input clk, rst, req_in, empty, full, ack_out, grant_port;
    input[1:0] flit_type;

    output reg ack_in, read, write, load_dest, req_out, req_port;

    localparam[2:0] WRI_STATE = 3'b000, GAI_STATE = 3'b001, RDI_STATE = 3'b010, RP_STATE = 3'b011,
                    GRO_STATE = 3'b100, WAO_STATE = 3'b101, SDO_STATE = 3'b110;
    
    localparam[1:0] HEADER_FLIT = 2'b01, PAYLOAD_FLIT = 2'b00, TAIL_FLIT = 2'b10;

    reg[2:0] ps, ns;

    always @(posedge clk, posedge rst) begin
        if(rst)
            ps <= WRI_STATE;
        else
            ps <= ns;
    end


    always @(*) begin
        ns = WRI_STATE;
        
        case(ps) 

        WRI_STATE: ns = req_in ? GAI_STATE : WRI_STATE;

        GAI_STATE: ns = req_in ? GAI_STATE : RDI_STATE;

        RDI_STATE: ns = (flit_type == TAIL_FLIT) ? RP_STATE : RDI_STATE;

        RP_STATE:  ns = grant_port ? GRO_STATE : RP_STATE;

        GRO_STATE: ns = ack_out ? WAO_STATE : GRO_STATE;

        WAO_STATE: ns = ack_out ? WAO_STATE : SDO_STATE;

        SDO_STATE: ns = empty ? WRI_STATE : SDO_STATE;

        default:   ns = WRI_STATE;

        endcase
    end

    always @(*) begin
        {ack_in, read, write, load_dest, req_out, req_port} = 6'b0;

        case(ps)

            GAI_STATE: ack_in = 1'b1;

            RDI_STATE: {write, load_dest} = {1'b1, (flit_type == HEADER_FLIT) ? 1'b1 : 1'b0};

            RP_STATE:  req_port = 1'b1;

            GRO_STATE: {req_port, req_out} = 2'b11;

            WAO_STATE: {req_port, read} = {1'b1, ~ack_out};

            SDO_STATE: {req_port, read} = 2'b11;

            default:   {ack_in, read, write, load_dest, req_out, req_port} = 6'b0;

        endcase
    end

endmodule