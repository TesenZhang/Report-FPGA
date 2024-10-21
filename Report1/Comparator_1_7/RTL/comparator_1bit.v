module comparator_1bit(
    input A,
    input B,
    output reg LED1, 
    output reg LED2, 
    output reg LED3  
);

always @(A or B)
begin
    if (A < B) begin
        LED1 = 1'b1; 
        LED2 = 1'b0;
        LED3 = 1'b0;
    end
    else if (A == B) begin
        LED1 = 1'b0;
        LED2 = 1'b1; 
        LED3 = 1'b0;
    end
    else begin
        LED1 = 1'b0;
        LED2 = 1'b0;
        LED3 = 1'b1; 
    end
end

endmodule