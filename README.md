# Simple-RV32I-core-in-VHDL
My first VHDL project, if you have any questions or suggestions you can contact me.

TO BE DONE:
-GDSI file <br />
-Formal verification


graph TD
    subgraph Instruction_Fetch
        PC[Program Counter] --> IM[Instruction Memory / ROM]
    end

    IM --> Decoder[Instruction Decoder]
    Decoder --> CU[Control Unit / Stall Logic]

    subgraph Execution_Core
        CU --> RF[Register File]
        RF --> ALU[ALU - 314 LUTs Optimized]
        Imm[Immediate Generator] --> ALU
    end

    subgraph Memory_Access
        ALU --> DM[Data Memory / RAM]
    end

    subgraph Write_Back
        DM --> MUX_WB[Write-Back Mux]
        ALU --> MUX_WB
        MUX_WB --> RF
    end

    CU -.->|Control Signals| ALU
    CU -.->|Stall/Trap| PC
    ALU -->|Zero Flag| CU
