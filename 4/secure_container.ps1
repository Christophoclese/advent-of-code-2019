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
[int32]$LowerBound = ($InputString -Split '-')[0]
[int32]$UpperBound = ($InputString -Split '-')[1]
[string[]]$ValidPasswords = @()

For ($Password = $LowerBound; $Password -le $UpperBound; $Password++) {
    # must match regex (11|22|33|44|55|66|77|88|99|00)
    If ($Password -match '(11|22|33|44|55|66|77|88|99|00)') {
        $PasswordString = [string]$Password
        Write-Verbose $PasswordString
        For ($Position = 0; $Position -lt $PasswordString.Length; $Position++) {
            Write-Host $PasswordString[$Position]
        }
    }
}
