`timescale 1ns / 1ps

module ram_reader(
    input  logic clk,
    input  logic reset,               //starts as soon reset is deasserted
    output logic [26:0] ram_address,  //the following 4 signals control the command FIFO
    output logic [2:0] ram_cmd,      
    output logic ram_en,            
    input  logic ram_rdy,
    input  logic ram_rd_valid,
    input  logic ram_rd_data_end,
    input  logic [63:0] ram_rd_data,
    input  logic [26:0] read_address,
    output logic [15:0] read_data_out,  //16-bit output word
    output logic read_data_valid        //16-bit output is valid
    );

    logic [26:0] old_ram_address;
    logic [127:0] data_burst;
    logic [127:0] next_data_burst;

    logic [2:0] word_sel;
    logic [2:0] old_word_sel;

    assign word_sel = read_address[2:0];

    assign read_data_out = data_burst[word_sel*16 +: 16]; //select 16 bit word from burst

    typedef enum logic [2:0] {
        RESET,
        WAIT_READ,
        SEND_CMD,
        WAIT_NEW_BURST,
        LOAD_NEW_BURST,
        DEASSERT_VALID
    } state_t;
    state_t current_state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            next_state <= RESET;
        end
        else begin
            current_state <= next_state;  
            data_burst <= next_data_burst;
        end

        unique case(current_state)
            RESET:
                begin
                    next_state = WAIT_READ;
                    old_ram_address <= 'hFFFFFFFF;
                    old_word_sel <= 'b111;
                    data_burst <= 0;
                end

            WAIT_READ:
                begin
                    if ((old_word_sel != word_sel) && read_address[26:3] == old_ram_address[26:3])
                        begin
                            next_state = DEASSERT_VALID;
                            old_word_sel <= word_sel;
                            old_ram_address <= read_address;
                        end
                    else if(old_ram_address != read_address && ram_rdy)
                        begin
                            next_state = SEND_CMD;
                            old_ram_address <= read_address;
                            old_word_sel <= word_sel;
                        end
                    else
                        begin
                            next_state = WAIT_READ;
                        end
                end

            SEND_CMD:
                begin
                    next_state = WAIT_NEW_BURST;
                end

            WAIT_NEW_BURST:
                begin
                    if(ram_rd_valid)
                        begin
                            next_state = LOAD_NEW_BURST;
                        end
                    else
                        begin
                            next_state = WAIT_NEW_BURST;
                        end
                end

            LOAD_NEW_BURST:
                begin                
                    if(ram_rd_data_end)
                            begin
                                next_state = WAIT_READ;
                            end
                        else
                            begin
                                next_state = LOAD_NEW_BURST;
                            end
                end

            DEASSERT_VALID:
                begin
                    next_state = WAIT_READ;
                end

        endcase
    end

    always_comb
        begin
            next_state = current_state;
            next_data_burst = data_burst;

            ram_cmd = 3'b000;      
            ram_en = 1'b0;        
            ram_address = 0;
            read_data_valid = 0;

            unique case(current_state)

                RESET:
                    begin
                        ram_cmd = 3'b000;      
                        ram_en = 1'b0;        
                        read_data_valid = 0;
                    end

                WAIT_READ:
                    begin
                        read_data_valid = 1;
                    end

                SEND_CMD:
                    begin
                        ram_cmd = 3'b001;
                        read_data_valid = 0;
                        ram_en = 1;
                        ram_address = (read_address & 27'h7FFFFF8);
                    end

                WAIT_NEW_BURST:
                    begin
                        ram_cmd = 3'b001;
                        ram_en = 0;
                        read_data_valid = 0;
                    end

                LOAD_NEW_BURST:
                    begin
                        ram_en = 0;
                        read_data_valid = 0;
                        if (ram_rd_data_end) begin
                            next_data_burst [63:0] = ram_rd_data; //assign lower words
                        end
                        else
                            next_data_burst [127:64] = ram_rd_data; //assign upper words
                    end
                
                DEASSERT_VALID:
                    begin
                        read_data_valid = 0;
                    end

                default:
                    begin
                        ram_cmd = 3'b000;      
                        ram_en = 1'b0;        
                        ram_address = 0;
                    end
            endcase
        end
endmodule