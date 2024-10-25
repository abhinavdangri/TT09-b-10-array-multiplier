`timescale 1ns / 1ps

module array_mult_tb;

// Inputs
reg [3:0] m = 4'b0000;
reg [3:0] q = 4'b0000;

// Outputs
wire [7:0] p_struct;

// Reference
reg [7:0] p_ref = 8'b00000000;
integer failures = 0;

// Instantiate structural multiplier
array_mult_structural dut_struct(
    .m(m),
    .q(q),
    .p(p_struct)
);

// Stimulus
initial begin
    // Initialize Inputs (Test 0)
    m = 4'b0000;
    q = 4'b0000;
    p_ref = 8'b00000000;
    #10;

    // Test 1 - Base Case: Multiplying 1 * 1
    m = 4'b0001;
    q = 4'b0001;
    p_ref = 8'b00000001; // Expected: 1
    #10;

    // Test 2 - Simple Multiplication: 2 * 2
    m = 4'b0010;
    q = 4'b0010;
    p_ref = 8'b00000100; // Expected: 4
    #10;

    // Test 3 - Zero Multiplicand
    m = 4'b0000;
    q = 4'b1111;
    p_ref = 8'b00000000; // Expected: 0 * 15 = 0
    #10;

    // Test 4 - Zero Multiplier
    m = 4'b1111;
    q = 4'b0000;
    p_ref = 8'b00000000; // Expected: 15 * 0 = 0
    #10;

    // Test 5 - Maximum Values
    m = 4'b1111;
    q = 4'b1111;
    p_ref = 8'b11100001; // Expected: 15 * 15 = 225
    #10;

    // Test 6 - High Bit Multiplication
    m = 4'b1000;
    q = 4'b1000;
    p_ref = 8'b01000000; // Expected: 8 * 8 = 64
    #10;

    // Test 7 - One with High Bit
    m = 4'b0001;
    q = 4'b1000;
    p_ref = 8'b00001000; // Expected: 1 * 8 = 8
    #10;

    // Test 8 - Near Maximum Values
    m = 4'b0111;
    q = 4'b0111;
    p_ref = 8'b00110001; // Expected: 7 * 7 = 49
    #10;

    // Test 9 - Alternating Bits
    m = 4'b0101;
    q = 4'b1010;
    p_ref = 8'b00110010; // Expected: 5 * 10 = 50
    #10;

    // Test 10 - Middle Bits
    m = 4'b0011;
    q = 4'b1100;
    p_ref = 8'b00100100; // Expected: 3 * 12 = 36
    #10;

    // End of test

    // Reporting
    if (failures === 0) begin
        $display("All tests passed");
    end else begin
        $display("%d tests failed", failures);
    end
    $finish;
end

// Evaluation
reg check_timer = 1'b0;

always #5 check_timer = ~check_timer;

always @(posedge check_timer) begin
    if (p_struct !== p_ref) begin
        $display("Error at time %0dns: m = %b, q = %b, p_struct = %b, expected = %b", $time, m, q, p_struct, p_ref);
        failures = failures + 1;
    end
end

endmodule
