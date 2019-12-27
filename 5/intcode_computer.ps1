<#
    .SYNOPSIS
        Intcode computer.

    .NOTES
        https://adventofcode.com/2019/day/5
#>
[CmdletBinding()]
Param(
    [string[]]$InstructionSet
)

function Run-Computer {
    Param(
        [array]$State
    )

    class Instruction {
        $CurrentInstructionIndex
        $Opcode
        $P1Mode
        $P2Mode
        $P3Mode
    }

    $CurrentInstructionIndex = 0

    Do {
        Write-Verbose "Jumping to instruction at postion $CurrentInstructionIndex"

        $CurrentInstruction = $State[$CurrentInstructionIndex]
        Write-Verbose "Read instruction $CurrentInstruction from position $CurrentInstructionIndex"

        # If the PaddedInstruction length exceeds 5 chars, something has gone wrong.
        # This should allow us to make assumptions about position and length below.
        If (($PaddedInstruction = "$CurrentInstruction".PadLeft(5,'0')).Length -gt 5) {
            Throw "Recieved invalid instruction: $PaddedInstruction"
        }
<#
$Instruction.CurrentInstructionIndex
$Instruction.Opcode
$Instruction.P1Mode
$Instruction.P2Mode
$Instruction.P3Mode
#>
        $Param3Mode = $PaddedInstruction[0]
        $Param2Mode = $PaddedInstruction[1]
        $Param1Mode = $PaddedInstruction[2]

        Write-Verbose $Param1Mode
        Write-Verbose $Param2Mode
        Write-Verbose $Param3Mode

        $Opcode = [int32]$PaddedInstruction.Substring(3, 2)
        Write-Verbose "Found opcode: $Opcode"

        Switch ($Opcode) {
            1 {
                #Addition
                #$Result = $Operand1 + $Operand2
                # Do-Math -Operation 'Addition' -State $State -InstructionIndex $CurrentInstructionIndex -ParamModes $Modes
            }
            2 {
                #Multiplication
                If ($Param1Mode -eq '1') {
                    $Operand1 = $State[$CurrentInstructionIndex + 1]
                }
                Else {
                    $Location1 = $State[$CurrentInstructionIndex + 1]
                    $Operand1 = $State[$Location1]
                }

                Write-Verbose "Read Operand1: $Operand1"

                If ($Param2Mode -eq '1') {
                    $Operand2 = $State[$CurrentInstructionIndex + 2]
                }
                Else {
                    $Location2 = $State[$CurrentInstructionIndex + 2]
                    $Operand2 = $State[$Location2]
                }

                Write-Verbose "Read Operand2: $Operand2"

                $Result = [int32]$Operand1 * [int32]$Operand2
                Write-Verbose "The result of the multiplcation operation is: $Result"

                If ($Param3Mode -eq '1') {
                    Throw "Attempted to write in immediate mode!"
                }
                Else {
                    $Location3 = $State[$CurrentInstructionIndex + 3]
                    $State[$Location3] = $Result
                    Write-Verbose "Wrote $Result to $Location3"
                }

                $CurrentInstructionIndex += 4
            }
            3 {
                #Input
            }
            4 {
                #Output
            }
            99 {
                Write-Verbose ($State -Join ',')
                Write-Verbose "Time to sleep."
                return
            }
            Default {
                Throw "Recieved invalid Opcode: $Opcode"
            }
        }
    } Until ($CurrentInstructionIndex -gt ($State.Length -1))

    Throw "Ran out of instructions?!"
}

If ($PSBoundParameters.ContainsKey('InstructionSet')) {
    $InitialState = $InstructionSet
}
Else {
    $InitialState = @(1002,4,3,4,33)
}

Run-Computer -State $InitialState
