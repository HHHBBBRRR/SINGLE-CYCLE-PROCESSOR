module regfile (
    input  wire          clk,
    input  wire          we3,
    input  wire [4 : 0]   a1,
    input  wire [4 : 0]   a2,
    input  wire [4 : 0]   a3,
    input  wire [31 : 0] wd3,
    output wire [31 : 0] rd1,
    output wire [31 : 0] rd2
);
    reg [31 : 0] rf[31 : 0];

    always @( posedge clk ) begin
        if (we3) begin
            rf[a3] <= wd3;
        end
    end

    assign rd1 = (a1 != 0) ? rf[a1] : 32'b0;
    assign rd2 = (a2 != 0) ? rf[a2] : 32'b0;
    
endmodule