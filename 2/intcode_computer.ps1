<#
    .SYNOPSIS
        Intcode computer.

    .NOTES
        https://adventofcode.com/2019/day/2
#>
[CmdletBinding()]
Param(
)

#$State = @(1,9,10,3,2,3,11,0,99,30,40,50)
#$State = @(1,0,0,0,99)
#$State = @(2,3,0,3,99)
#$State = @(2,4,4,5,99,0)
#$State = @(1,1,1,4,99,5,6,0,99)
#$State = @(1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,6,1,19,2,19,13,23,1,23,10,27,1,13,27,31,2,31,10,35,1,35,9,39,1,39,13,43,1,13,43,47,1,47,13,51,1,13,51,55,1,5,55,59,2,10,59,63,1,9,63,67,1,6,67,71,2,71,13,75,2,75,13,79,1,79,9,83,2,83,10,87,1,9,87,91,1,6,91,95,1,95,10,99,1,99,13,103,1,13,103,107,2,13,107,111,1,111,9,115,2,115,10,119,1,119,5,123,1,123,2,127,1,127,5,0,99,2,14,0,0)
$State = @(1,12,2,3,1,1,2,3,1,3,4,3,1,5,0,3,2,6,1,19,2,19,13,23,1,23,10,27,1,13,27,31,2,31,10,35,1,35,9,39,1,39,13,43,1,13,43,47,1,47,13,51,1,13,51,55,1,5,55,59,2,10,59,63,1,9,63,67,1,6,67,71,2,71,13,75,2,75,13,79,1,79,9,83,2,83,10,87,1,9,87,91,1,6,91,95,1,95,10,99,1,99,13,103,1,13,103,107,2,13,107,111,1,111,9,115,2,115,10,119,1,119,5,123,1,123,2,127,1,127,5,0,99,2,14,0,0)

$CurrentOpcodeIndex = 0

Do {
    Write-Verbose "Jumping to Opcode at postion $CurrentOpcodeIndex"
    
    $Opcode = $State[$CurrentOpcodeIndex]
    Write-Verbose "Read Opcode $Opcode from position $CurrentOpcodeIndex"
    If ($Opcode -eq 99) {
        $State -Join ','
        Write-Host "Time to sleep."
        Exit 0
    }

    $Location1 = $State[$CurrentOpcodeIndex + 1]
    Write-Verbose "Read Location1 $Location1 from position $($CurrentOpcodeIndex + 1)"
    $Operand1 = $State[$Location1]
    Write-Verbose "Read Operand1 $Operand1 from position $Location1"

    $Location2 = $State[$CurrentOpcodeIndex + 2]
    Write-Verbose "Read Location2 $Location2 from position $($CurrentOpcodeIndex + 2)"
    $Operand2 = $State[$Location2]
    Write-Verbose "Read Operand2 $Operand2 from position $Location2"

    Switch ($Opcode) {
        1 {
            $Result = $Operand1 + $Operand2
        }
        2 {
            $Result = $Operand1 * $Operand2
        }
        Default {
            Throw "Recieved invalid Opcode: $Opcode"
        }
    }

    $Location3 = $State[$CurrentOpcodeIndex + 3]
    $State[$Location3] = $Result
    Write-Verbose "Wrote $Result to $Location3"

    $CurrentOpcodeIndex += 4
} Until ($CurrentOpcodeIndex -gt ($State.Length -1))

