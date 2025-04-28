`timescale 1ns / 1ps

module ascii_to_token(
        input logic [7:0] input_ascii,
        output logic [6:0] output_token
    );
    
    always_comb
    begin
        if(input_ascii == 32) 
        begin
            output_token = 1;
        end 
        else if(input_ascii == 33)
        begin
            output_token = 2;
        end
        else if(input_ascii == 34)
        begin
            output_token = 3;
        end
        else if(input_ascii == 39)
        begin
            output_token = 4;
        end
        else if(input_ascii == 44)
        begin
            output_token = 5;
        end
        else if(input_ascii == 45)
        begin
            output_token = 6;
        end
        else if(input_ascii == 46)
        begin
            output_token = 7;
        end
        else if(input_ascii == 48)
        begin
            output_token = 8;
        end
        else if(input_ascii == 49)
        begin
            output_token = 9;
        end
        else if(input_ascii == 50)
        begin
            output_token = 10;
        end
        else if(input_ascii == 51)
        begin
            output_token = 11;
        end
        else if(input_ascii == 52)
        begin
            output_token = 12;
        end
        else if(input_ascii == 53)
        begin
            output_token = 13;
        end
        else if(input_ascii == 54)
        begin
            output_token = 14;
        end
        else if(input_ascii == 55)
        begin
            output_token = 15;
        end
        else if(input_ascii == 56)
        begin
            output_token = 16;
        end
        else if(input_ascii == 57)
        begin
            output_token = 17;
        end
        else if(input_ascii == 58)
        begin
            output_token = 18;
        end
        else if(input_ascii == 59)
        begin
            output_token = 19;
        end
        else if(input_ascii == 60)
        begin
            output_token = 20;
        end
        else if(input_ascii == 62)
        begin
            output_token = 21;
        end
        else if(input_ascii == 63)
        begin
            output_token = 22;
        end
        else if(input_ascii == 65)
        begin
            output_token = 23;
        end
        else if(input_ascii == 66)
        begin
            output_token = 24;
        end
        else if(input_ascii == 67)
        begin
            output_token = 25;
        end
        else if(input_ascii == 68)
        begin
            output_token = 26;
        end
        else if(input_ascii == 69)
        begin
            output_token = 27;
        end
        else if(input_ascii == 70)
        begin
            output_token = 28;
        end
        else if(input_ascii == 71)
        begin
            output_token = 29;
        end
        else if(input_ascii == 72)
        begin
            output_token = 30;
        end
        else if(input_ascii == 73)
        begin
            output_token = 31;
        end
        else if(input_ascii == 74)
        begin
            output_token = 32;
        end
        else if(input_ascii == 75)
        begin
            output_token = 33;
        end
        else if(input_ascii == 76)
        begin
            output_token = 34;
        end
        else if(input_ascii == 77)
        begin
            output_token = 35;
        end
        else if(input_ascii == 78)
        begin
            output_token = 36;
        end
        else if(input_ascii == 79)
        begin
            output_token = 37;
        end
        else if(input_ascii == 80)
        begin
            output_token = 38;
        end
        else if(input_ascii == 81)
        begin
            output_token = 39;
        end
        else if(input_ascii == 82)
        begin
            output_token = 40;
        end
        else if(input_ascii == 83)
        begin
            output_token = 41;
        end
        else if(input_ascii == 84)
        begin
            output_token = 42;
        end
        else if(input_ascii == 85)
        begin
            output_token = 43;
        end
        else if(input_ascii == 86)
        begin
            output_token = 44;
        end
        else if(input_ascii == 87)
        begin
            output_token = 45;
        end
        else if(input_ascii == 88)
        begin
            output_token = 46;
        end
        else if(input_ascii == 89)
        begin
            output_token = 47;
        end
        else if(input_ascii == 90)
        begin
            output_token = 48;
        end
        else if(input_ascii == 97)
        begin
            output_token = 49;
        end
        else if(input_ascii == 98)
        begin
            output_token = 50;
        end
        else if(input_ascii == 99)
        begin
            output_token = 51;
        end
        else if(input_ascii == 100)
        begin
            output_token = 52;
        end
        else if(input_ascii == 101)
        begin
            output_token = 53;
        end
        else if(input_ascii == 102)
        begin
            output_token = 54;
        end
        else if(input_ascii == 103)
        begin
            output_token = 55;
        end
        else if(input_ascii == 104)
        begin
            output_token = 56;
        end
        else if(input_ascii == 105)
        begin
            output_token = 57;
        end
        else if(input_ascii == 106)
        begin
            output_token = 58;
        end
        else if(input_ascii == 107)
        begin
            output_token = 59;
        end
        else if(input_ascii == 108)
        begin
            output_token = 60;
        end
        else if(input_ascii == 109)
        begin
            output_token = 61;
        end
        else if(input_ascii == 110)
        begin
            output_token = 62;
        end
        else if(input_ascii == 111)
        begin
            output_token = 63;
        end
        else if(input_ascii == 112)
        begin
            output_token = 64;
        end
        else if(input_ascii == 113)
        begin
            output_token = 65;
        end
        else if(input_ascii == 114)
        begin
            output_token = 66;
        end
        else if(input_ascii == 115)
        begin
            output_token = 67;
        end
        else if(input_ascii == 116)
        begin
            output_token = 68;
        end
        else if(input_ascii == 117)
        begin
            output_token = 69;
        end
        else if(input_ascii == 118)
        begin
            output_token = 70;
        end
        else if(input_ascii == 119)
        begin
            output_token = 71;
        end
        else if(input_ascii == 120)
        begin
            output_token = 72;
        end
        else if(input_ascii == 121)
        begin
            output_token = 73;
        end
        else if(input_ascii == 122)
        begin
            output_token = 74;
        end
        else if(input_ascii == 124)
        begin
            output_token = 75;
        end
        else
        begin
            output_token = 0;
        end
    end
endmodule
