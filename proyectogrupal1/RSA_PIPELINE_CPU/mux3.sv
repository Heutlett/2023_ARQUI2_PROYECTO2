module mux3 #(parameter WIDTH = 8)
(
    // Entradas
    input logic [1:0] sel,
    input logic [WIDTH-1:0] d0, d1, d2,

    // Salida
    output logic [WIDTH-1:0] y
);

    always_comb
    begin
        case(sel)
            2'b00: y = d0;
            2'b01: y = d1;
            2'b11: y = d2;
				// Si es 2, xx. No se esta utilizando.
            default: y = 'bx; // En caso de selección inválida, salida indeterminada
        endcase
    end

endmodule
