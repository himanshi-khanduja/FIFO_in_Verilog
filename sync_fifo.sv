module fifo_sync  
#( 
    parameter DATA_WIDTH = 8,  
    parameter DEPTH = 16      
)
(
    input wire clk,                 
    input wire rst,                
    input wire write_enable,        
    input wire read_enable,           
    input wire [DATA_WIDTH-1:0] din,   
    output wire [DATA_WIDTH-1:0] dout, 
    output wire empty,                
    output wire full                  
);

    // Internal signals
    reg [DATA_WIDTH-1:0] fifo_mem [0:DEPTH-1]; 
    reg [4:0] write_pointer = 0;               
    reg [4:0] read_pointer = 0;                
    reg [4:0] fifo_count = 0;                  

    // Write operation
    always @(posedge clk or posedge rst) begin 
        if (rst) begin
            write_pointer <= 0; 
        end else if (write_enable && !full) begin 
            fifo_mem[write_pointer] <= din;  
            write_pointer <= write_pointer + 1;  
        end
    end

    // Read operation
    always @(posedge clk or posedge rst) begin 
        if (rst) begin
            read_pointer <= 0; 
        end else if (read_enable && !empty) begin
            read_pointer <= read_pointer + 1;  
        end
    end

    // Output data
    assign dout = fifo_mem[read_pointer]; 

    // FIFO count logic
    always @(posedge clk or posedge rst) begin 
        if (rst) begin
            fifo_count <= 0;
        end else begin
            case ({write_enable && !full, read_enable && !empty})
                2'b01: fifo_count <= fifo_count - 1;  
                2'b10: fifo_count <= fifo_count + 1;  
                default: fifo_count <= fifo_count;    
            endcase
        end 
    end

    // Status flags
    assign full = (fifo_count == DEPTH); 
    assign empty = (fifo_count == 0); 

endmodule
