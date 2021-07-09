Param (
    [Parameter(Mandatory=$true)][string]$templateName
)

$trainingMax = Get-Content "./config/training-max.json" -Raw | ConvertFrom-Json
$template = Get-Content "./templates/$templateName`.json" -Raw | ConvertFrom-Json
$repSchemes = Get-Content "./config/rep-schemes.json" -Raw | ConvertFrom-Json

Function New-ExerciseRow ($week, $day, $lift, $sets, $reps, $weight) {
    $newRow = New-Object PSObject
    $newRow | Add-Member NoteProperty Week $week
    $newRow | Add-Member NoteProperty Day $day
    $newRow | Add-Member NoteProperty Lift $lift
    $newRow | Add-Member NoteProperty Weight "=MROUND($weight,5)"
    $newRow | Add-Member NoteProperty Sets $sets
    $newRow | Add-Member NoteProperty "Target Reps" (Format-Amrap $reps)
    $newRow | Add-Member NoteProperty "Actual Reps" $null
    Return $newRow
}

Function Format-Amrap ($reps) {
    # Numbers on macos ignores an addition sign for reps like "5+"
    If ("$reps".contains("+")) {
        #Return "=TEXT(`"$reps`")" # This didn't work well with Numbers either
        Return "AMRAP $reps" # We'll just make it really obvious that this is a string!
    } Else {
        Return $reps
    }
}

Function New-FileName ($templateName) {
    $datePart = (Get-Date).toString("yyyy-MM-dd")
    Return "./output/531`_$templateName`_$datePart.csv"
}

$allRows = @()

$week = 0
While ($week -lt $template.total_weeks) {
    $day = 1
    $template.days | Foreach {
        $_.exercises | Foreach {
            $liftName = $_.name
            $repSchemeName = $_.format
            $liftMax = $trainingMax.$liftName
            $repScheme = $repSchemes | Where { $_.name -eq $repSchemeName }
            If ($repScheme.weeks.count -eq 1) {
                $rows = $repScheme.weeks[0].rows
            } Else {
                $rows = $repScheme.weeks[$week].rows
            }
            $rows | Foreach {
                $row = $_
                If ($row.weight -gt 0) {
                    $liftPercent = $row.weight / 100
                    $liftWeight = $liftMax * $liftPercent
                } Else {
                    $liftWeight = 0
                }
                $allRows += New-ExerciseRow ($week + 1) $day $liftName $row.sets $row.reps $liftWeight
            }
        }
        $day++
    }
    $week++
}

#Return $allRows
$outputFileName = New-FileName $templateName
$allRows | Export-Csv $outputFileName -NoTypeInformation

Write-Host -ForegroundColor Yellow "Your template is ready. Open $outputFileName and copy its contents into a Google Sheet or do whatever you want with it."