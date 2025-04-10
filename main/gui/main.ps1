Add-Type -AssemblyName System.Windows.Forms

function BaseApplication {
    param (
        [int]$width = 400,
        [int]$height = 280,
        [string]$title = "DF Taliban"
    )
    $form = New-Object System.Windows.Forms.Form
    $form.Text = $title
    $form.Size = New-Object System.Drawing.Size($width, $height)
    $form.StartPosition = "CenterScreen"

    return $form
}

function BaseContainer {
    param (
        [int]$width = 430,
        [int]$height = 280
    )
    $tabControl = New-Object System.Windows.Forms.TabControl
    $tabControl.Size = New-Object System.Drawing.Size($width, $height)
    $tabControl.Location = New-Object System.Drawing.Point(10,10)

    return $tabControl
}

function AddBombTab {
    $addBombTab = New-Object System.Windows.Forms.TabPage
    $addBombTab.Text = "Add Bomb"

    return $addBombTab
}

function CreatePlaceholder {
    param (
        [string]$label,
        [int]$xLocation,
        [int]$yLocation,
        [int]$width = 80
    )
    
    $placeholder = New-Object System.Windows.Forms.Label
    $placeholder.Text = $label
    $placeholder.Location = New-Object System.Drawing.Point($xLocation, $yLocation)
    $placeholder.Size = New-Object System.Drawing.Size($width, 20)
    $placeholder.TextAlign = "MiddleLeft"

    return $placeholder

}

function DatePicker {
    param(
        [int]$xLocation,
        [int]$yLocation,
        [int]$width = 200
    )
    $date = New-Object System.Windows.Forms.DateTimePicker
    $date.Format = [System.Windows.Forms.DateTimePickerFormat]::Short
    $date.Location = New-Object System.Drawing.Point($xLocation, $yLocation)
    $date.Size = New-Object System.Drawing.Size($width, 20)
    return $date
}

function TimePicker {
    param (
        [int]$xLocation,
        [int]$yLocation,
        [int]$width = 200
    )
    $time = New-Object System.Windows.Forms.DateTimePicker
    $time.Format = [System.Windows.Forms.DateTimePickerFormat]::Custom
    $time.CustomFormat = "HH:mm:ss"
    $time.ShowUpDown = $true
    $time.Location = New-Object System.Drawing.Point($xLocation, $yLocation)
    $time.Size = New-Object System.Drawing.Size($width, 20)
    return $time
}

function TextBox {
    param (
        [int]$xLocation,
        [int]$yLocation,
        [int]$width = 200
    )
    
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point($xLocation, $yLocation)
    $textBox.Size = New-Object System.Drawing.Size($width, 20)
    return $textBox
}


function TimePicker {
    param (
        [int]$xLocation,
        [int]$yLocation,
        [int]$width = 200
    )
    $time = New-Object System.Windows.Forms.DateTimePicker
    $time.Format = [System.Windows.Forms.DateTimePickerFormat]::Custom
    $time.CustomFormat = "HH:mm:ss"
    $time.ShowUpDown = $true
    $time.Location = New-Object System.Drawing.Point($xLocation, $yLocation)
    $time.Size = New-Object System.Drawing.Size($width, 20)
    return $time
}

function TextBox {
    param (
        [int]$xLocation,
        [int]$yLocation,
        [int]$width = 200
    )
    
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point($xLocation, $yLocation)
    $textBox.Size = New-Object System.Drawing.Size($width, 20)
    return $textBox
}

function CustomBtn {
    param (
        [int]$xLocation,
        [int]$yLocation,
        [int]$xSize,
        [int]$ySize,
        [string]$btnTitle
    )

    $customBtn = New-Object System.Windows.Forms.Button
    $customBtn.Text = $btnTitle
    $customBtn.Location = New-Object System.Drawing.Point($xLocation, $yLocation)
    $customBtn.Size = New-Object System.Drawing.Size($xSize, $ySize)

    return $customBtn
}

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    
    Start-Process powershell.exe "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}


$mainForm = BaseApplication
$tabControl = BaseContainer
$bombTab = AddBombTab
$deletedAtPlaceholder = CreatePlaceholder -label "Deleted at:" -xLocation 20 -yLocation 10
$datePlaceholder = CreatePlaceholder -label "Date:" -xLocation 20 -yLocation 40
$timePlaceholder = CreatePlaceholder -label "Time:" -xLocation 20 -yLocation 80
$directoryPlaceholder = CreatePlaceholder -label "Directory:" -xLocation 20 -yLocation 120
$datePicker = DatePicker -xLocation 100 -yLocation 40
$timePicker = TimePicker -xLocation 100 -yLocation 80
$dirPath = TextBox -xLocation 100 -yLocation 120 -width 165
$dirBtnX = $dirPath.Location.X + $dirPath.Size.Width + 5
$dirBtnY = $dirPath.Location.Y
$dirBtn = CustomBtn -targetTextBox $dirPath -xLocation $dirBtnX -yLocation $dirBtnY -xSize 30 -ySize 20 -btnTitle "..."
$folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
$fileDialog = New-Object System.Windows.Forms.OpenFileDialog
$fileDialog.CheckFileExists = $true
$fileDialog.Multiselect = $false
$fileDialog.Title = "Select File"

$dirBtn.Add_Click({
    $choice = [System.Windows.Forms.MessageBox]::Show("Select YES for file, NO for folder.", "Pick Type", [System.Windows.Forms.MessageBoxButtons]::YesNoCancel)

    switch ($choice) {
        'Yes' {
            if ($fileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
                $dirPath.Text = $fileDialog.FileName
            }
        }
        'No' {
            if ($folderDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
                $dirPath.Text = $folderDialog.SelectedPath
            }
        }
    }
})

$registerTaskBtn = CustomBtn -targetTextBox $dirPath -xLocation 20 -yLocation 160 -xSize 100 -ySize 20 -btnTitle "Register Task"
$registerTaskBtn.Add_Click({

    if (-not (Test-Path -Path $dirPath.Text)) {
        [System.Windows.Forms.MessageBox]::Show(
            "The provided path is invalid. Please provide a valid file or directory path.",
            "Invalid Path",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
        return
    }

    if ([string]::IsNullOrWhiteSpace($dirPath.Text)) {
        [System.Windows.Forms.MessageBox]::Show(
            "Please provide a valid file or directory path before registering the task.",
            "Missing Path",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
        return
    }

    $selectedDate = $datePicker.Value.Date
    $selectedTime = $timePicker.Value.TimeOfDay
    $selectedDateTime = $selectedDate.Add($selectedTime)

    $currentDateTime = Get-Date

    if ($selectedDateTime -lt $currentDateTime) {
        [System.Windows.Forms.MessageBox]::Show(
            "Scheduled time must be in the future. Please pick a valid future date and time.",
            "Invalid Time",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
        return
    }

    $dateStr = $datePicker.Value.ToString("yyyyMMdd")
    $timeStr = $timePicker.Value.ToString("HHmm")
    $path = $dirPath.Text
    $guid = [guid]::NewGuid().ToString()
    $taskId = "taliban_" + $guid.Substring(0, 8)
    Write-Host "Created $taskId"

    $scriptPath = (Resolve-Path -Path "$PSScriptRoot\..\logic\registerTask.ps1").Path
    $arguments = "-ExecutionPolicy Bypass -NoProfile -File `"$scriptPath`" -date `"$dateStr`" -time `"$timeStr`" -path `"$path`" -taskId `"$taskId`""

    try {
        Start-Process -FilePath "powershell.exe" -ArgumentList $arguments -WindowStyle Hidden
        [System.Windows.Forms.MessageBox]::Show(
            "Task registered successfully!",
            "Success",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )
        Write-Host "Scheduled delete $path at $dateStr $timestr"
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show(
            "Failed to register task. Please try again.",
            "Error",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
    }
})



$bombTab.Controls.Add($deletedAtPlaceholder)
$bombTab.Controls.Add($datePlaceholder)
$bombTab.Controls.Add($timePlaceholder)
$bombTab.Controls.Add($directoryPlaceholder)
$bombTab.Controls.Add($datePicker)
$bombTab.Controls.Add($timePicker)
$bombTab.Controls.Add($dirPath)
$bombTab.Controls.Add($dirBtn)
$bombTab.Controls.Add($registerTaskBtn)
$tabControl.TabPages.Add($bombTab)
$mainForm.Controls.Add($tabControl)
$mainForm.ShowDialog()