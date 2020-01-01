<#
    .SYNOPSIS
        Secure container.

    .NOTES
        https://adventofcode.com/2019/day/4
#>
[CmdletBinding()]
Param(
)

[string]$InputString = '156218-652527'
[int32]$LowerBound, [int32]$UpperBound = $InputString -Split '-'
[string[]]$ValidPasswords = @()

For ($Password = $LowerBound; $Password -le $UpperBound; $Password++) {
    #Write-Verbose "Current Password: $Password"
    If ($Password -match '(11|22|33|44|55|66|77|88|99|00)') {
        #Write-Verbose "Found adjacent digits: $Password ($(($Matches.Values | select -Unique) -Join ','))"

        $PasswordString = [string]$Password # We need a string for the next section so we can get its length and index into it
        $PasswordPreviousValue = 0
        For ($Position = 0; $Position -lt $PasswordString.Length; $Position++) {
            $PasswordCurrentValue = $PasswordString[$Position]
            If ($PasswordCurrentValue -lt $PasswordPreviousValue) {
                continue
            }
            $PasswordPreviousValue = ($PasswordCurrentValue)
        }
        $ValidPasswords += $Password
    }
}

$ValidPasswords
