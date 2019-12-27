[CmdletBinding()]
Param(
    [ValidateNotNullOrEmpty()]
    [int32[]]$InstructionSet = @(3,225,1,225,6,6,1100,1,238,225,104,0,1102,45,16,225,2,65,191,224,1001,224,-3172,224,4,224,102,8,223,223,1001,224,5,224,1,223,224,223,1102,90,55,225,101,77,143,224,101,-127,224,224,4,224,102,8,223,223,1001,224,7,224,1,223,224,223,1102,52,6,225,1101,65,90,225,1102,75,58,225,1102,53,17,224,1001,224,-901,224,4,224,1002,223,8,223,1001,224,3,224,1,224,223,223,1002,69,79,224,1001,224,-5135,224,4,224,1002,223,8,223,1001,224,5,224,1,224,223,223,102,48,40,224,1001,224,-2640,224,4,224,102,8,223,223,1001,224,1,224,1,224,223,223,1101,50,22,225,1001,218,29,224,101,-119,224,224,4,224,102,8,223,223,1001,224,2,224,1,223,224,223,1101,48,19,224,1001,224,-67,224,4,224,102,8,223,223,1001,224,6,224,1,223,224,223,1101,61,77,225,1,13,74,224,1001,224,-103,224,4,224,1002,223,8,223,101,3,224,224,1,224,223,223,1102,28,90,225,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,7,226,677,224,102,2,223,223,1005,224,329,1001,223,1,223,8,226,677,224,1002,223,2,223,1005,224,344,101,1,223,223,8,226,226,224,1002,223,2,223,1006,224,359,101,1,223,223,1008,677,226,224,1002,223,2,223,1005,224,374,1001,223,1,223,108,677,677,224,1002,223,2,223,1005,224,389,1001,223,1,223,1107,226,677,224,1002,223,2,223,1006,224,404,101,1,223,223,1008,226,226,224,102,2,223,223,1006,224,419,1001,223,1,223,7,677,226,224,1002,223,2,223,1005,224,434,101,1,223,223,1108,226,226,224,1002,223,2,223,1005,224,449,101,1,223,223,7,226,226,224,102,2,223,223,1005,224,464,101,1,223,223,108,677,226,224,102,2,223,223,1005,224,479,1001,223,1,223,1007,677,226,224,1002,223,2,223,1006,224,494,1001,223,1,223,1007,677,677,224,1002,223,2,223,1006,224,509,1001,223,1,223,107,677,677,224,1002,223,2,223,1005,224,524,101,1,223,223,1108,226,677,224,102,2,223,223,1006,224,539,1001,223,1,223,8,677,226,224,102,2,223,223,1005,224,554,101,1,223,223,1007,226,226,224,102,2,223,223,1006,224,569,1001,223,1,223,107,677,226,224,102,2,223,223,1005,224,584,1001,223,1,223,108,226,226,224,102,2,223,223,1006,224,599,1001,223,1,223,107,226,226,224,1002,223,2,223,1006,224,614,1001,223,1,223,1108,677,226,224,1002,223,2,223,1005,224,629,1001,223,1,223,1107,677,677,224,102,2,223,223,1005,224,644,1001,223,1,223,1008,677,677,224,102,2,223,223,1005,224,659,101,1,223,223,1107,677,226,224,1002,223,2,223,1006,224,674,101,1,223,223,4,223,99,226)
)

class Instruction {
    ### Properties

    [int32]$Opcode

    [int32]$P1

    [ValidateSet(0,1)]
    [int32]$P1Mode

    [int32]$P2

    [ValidateSet(0,1)]
    [int32]$P2Mode

    [int32]$P3

    [ValidateSet(0,1)]
    [int32]$P3Mode

    ### Methods

    [void]Parse([int32[]]$State, [int32]$Index) {
        [string]$Instruction = $State[$Index]
        Write-Verbose "Read instruction: $Instruction"

        If (($PaddedInstruction = "$Instruction".PadLeft(5,'0')).Length -gt 5) {
            Throw "Recieved invalid instruction: $PaddedInstruction"
        }

        $this.Opcode = $PaddedInstruction.Substring(3, 2)
        # Indexing into a string gives a [char].
        # When casting a [char] such as '0' or '1' to an [int] you end up with the ASCII code.
        # Hence casting as [string] which casts to [int] as expected
        $this.P1Mode = [string]$PaddedInstruction[2]
        $this.P2Mode = [string]$PaddedInstruction[1]
        $this.P3Mode = [string]$PaddedInstruction[0]


        If ($Value1 = $State[$Index + 1]) {
            If ($this.P1Mode -or ($this.Opcode -eq 3 -or $this.Opcode -eq 4)) {
                $this.P1 = $Value1
            }
            Else {
                $this.P1 = $State[$Value1]
            }
        }
        Else {
            Write-Verbose "There was no value to read at $($Index + 1)."
        }

        If ($Value2 = $State[$Index + 2]) {
            If ($this.P2Mode) {
                $this.P2 = $Value2
            }
            Else {
                $this.P2 = $State[$Value2]
            }
        }
        Else {
            Write-Verbose "There was no value to read at $($Index + 2)."
        }

        If ($Value3 = $State[$Index + 3]) {
            If ($this.P3Mode) {
                Throw "Attempted to write in immediate mode!"
            }
            Else {
                $this.P3 = $Value3
            }
        }
        Else {
            Write-Verbose "There was no value to read at $($Index + 3)."
        }
    }

    [string]ToString() {
        return [PSCustomObject]@{
            Opcode = $this.Opcode
            P1 = $this.P1
            P1Mode = $this.P1Mode
            P2 = $this.P2
            P2Mode = $this.P2Mode
            P3 = $this.P3
            P3Mode = $this.P3Mode
        }
    }
}

class IntcodeComputer {
    ### Properties

    [int32[]]$InitialInstructionSet
    [int32[]]$CurrentState
    [int32]$CurrentInstructionIndex


    ### Constructors
    IntcodeComputer([int32[]]$Instructions) {
        $this.InitialInstructionSet = $Instructions
    }

    
    ### Methods

    [int32]Run() {
        $this.CurrentState = $this.InitialInstructionSet.Clone()

        Do {
            $Next4 = $this.CurrentState[$this.CurrentInstructionIndex..($this.CurrentInstructionIndex + 3)] -Join ','
            Write-Verbose "Reading next instruction from $($this.CurrentInstructionIndex) ($Next4)"

            # Parse current instructions
            $Instruction = [Instruction]::new()
            $Instruction.Parse($this.CurrentState, $this.CurrentInstructionIndex)
            Write-Verbose "Parsed instruction: $Instruction"

            Switch ($Instruction.Opcode) {
                1 {
                    #Addition
                    Write-Verbose "Performing addition of P1 ($($Instruction.P1)) and P2 ($($Instruction.P2))"
                    $this.CurrentState[$Instruction.P3] = $Instruction.P1 + $Instruction.P2
                    $this.CurrentInstructionIndex += 4
                }
                2 {
                    #Multiplication
                    Write-Verbose "Performing multiplication"
                    $this.CurrentState[$Instruction.P3] = $Instruction.P1 * $Instruction.P2
                    $this.CurrentInstructionIndex += 4
                }
                3 {
                    #Input
                    $this.CurrentState[$Instruction.P1] = [int32](Read-Host -Prompt "Enter an integer")
                    $this.CurrentInstructionIndex += 2
                }
                4 {
                    #Output
                    Write-Host "The value at $($Instruction.P1) is $($this.CurrentState[$Instruction.P1])"
                    $this.CurrentInstructionIndex += 2
                }
                99 {
                    Write-Host "Exit code encountered. Shutting down..."
                    Write-Verbose "Final state: $($this.CurrentState -Join ',')"
                    Write-Verbose "Time to sleep."
                    return 0 # successful exit
                }
                Default {
                    Throw "Recieved invalid Opcode: $($Instruction.Opcode)"
                }
            }
        } Until ($this.CurrentInstructionIndex -gt ($this.CurrentState.Length -1))

        Throw "Ran out of instructions?!"
    }

    [void]PrintCurrentState() {
        Write-Host $this.CurrentState
    }
}

$Computer = [IntcodeComputer]::new($InstructionSet)
$Result = $Computer.Run()
$Result