Add-Type -AssemblyName System.Windows.Forms

# Create Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "DF Taliban"
$form.Size = New-Object System.Drawing.Size(450,350)
$form.StartPosition = "CenterScreen"

# Create Tab Control
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Size = New-Object System.Drawing.Size(430,280)
$tabControl.Location = New-Object System.Drawing.Point(10,10)
$form.Controls.Add($tabControl)

# Create First Tab (Main UI)
$tabPage1 = New-Object System.Windows.Forms.TabPage
$tabPage1.Text = "Add Bomb"
$tabControl.TabPages.Add($tabPage1)

# Date Label
$dateLabel = New-Object System.Windows.Forms.Label
$dateLabel.Text = "Date: "
$dateLabel.Location = New-Object System.Drawing.Point(20,40)
$dateLabel.AutoSize = $true
$tabPage1.Controls.Add($dateLabel)

# Date Picker
$datePicker = New-Object System.Windows.Forms.DateTimePicker
$datePicker.Format = [System.Windows.Forms.DateTimePickerFormat]::Custom
$datePicker.CustomFormat = "dddd,dd MMMM yyyy"
$datePicker.Location = New-Object System.Drawing.Point(100,40)
$tabPage1.Controls.Add($datePicker)

# Date of Explosion Label
$explosionLabel = New-Object System.Windows.Forms.Label
$explosionLabel.Text = "Date of explosion"
$explosionLabel.Location = New-Object System.Drawing.Point(20,10)
$explosionLabel.AutoSize = $true
$tabPage1.Controls.Add($explosionLabel)

# Time Label
$timeLabel = New-Object System.Windows.Forms.Label
$timeLabel.Text = "Time: "
$timeLabel.Location = New-Object System.Drawing.Point(20,80)
$timeLabel.AutoSize = $true
$tabPage1.Controls.Add($timeLabel)

# Time Picker
$timePicker = New-Object System.Windows.Forms.DateTimePicker
$timePicker.Format = [System.Windows.Forms.DateTimePickerFormat]::Custom
$timePicker.CustomFormat = "HH:mm:ss"
$timePicker.ShowUpDown = $true
$timePicker.Location = New-Object System.Drawing.Point(100,80)
$tabPage1.Controls.Add($timePicker)

# Directory Label
$dirLabel = New-Object System.Windows.Forms.Label
$dirLabel.Text = "Directory: "
$dirLabel.Location = New-Object System.Drawing.Point(20,120)
$dirLabel.AutoSize = $true
$tabPage1.Controls.Add($dirLabel)

# Directory Text Field
$dirTextBox = New-Object System.Windows.Forms.TextBox
$dirTextBox.Location = New-Object System.Drawing.Point(100,120)
$dirTextBox.Size = New-Object System.Drawing.Size(200,20)
$tabPage1.Controls.Add($dirTextBox)

# Directory Picker Button
$dirButton = New-Object System.Windows.Forms.Button
$dirButton.Text = "..."
$dirButton.Location = New-Object System.Drawing.Point(300,120)
$dirButton.Size = New-Object System.Drawing.Size(30,20)
$tabPage1.Controls.Add($dirButton)

# Folder Browser Dialog
$folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
$dirButton.Add_Click({
    if ($folderDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $dirTextBox.Text = $folderDialog.SelectedPath
    }
})

# Submit Button
$submitButton = New-Object System.Windows.Forms.Button
$submitButton.Text = "Add Bomb"
$submitButton.Location = New-Object System.Drawing.Point(20,160)
$tabPage1.Controls.Add($submitButton)

# Submit Action
$submitButton.Add_Click({
    $selectedDate = $datePicker.Value.ToString("yyyyMMdd")
    $selectedTime = $timePicker.Value.ToString("HHmmss")
    $selectedDir = $dirTextBox.Text
    
    # Generate random 6-digit number
    $randomNumber = -join ((48..57) | Get-Random -Count 6 | ForEach-Object {[char]$_})
    $taskName = "bomb_" + $randomNumber
    
    # Run external script with parameters
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File .\tools\create_task.ps1 -taskName '$taskName' -fullpath '$selectedDir' -date '$selectedDate' -time '$selectedTime'" -WindowStyle Hidden
})

# Create Second Tab (Task Management)
$tabPage2 = New-Object System.Windows.Forms.TabPage
$tabPage2.Text = "Delete Bomb"
$tabControl.TabPages.Add($tabPage2)

# Task List
$taskList = New-Object System.Windows.Forms.ListBox
$taskList.Location = New-Object System.Drawing.Point(20,20)
$taskList.Size = New-Object System.Drawing.Size(380,120)
$tabPage2.Controls.Add($taskList)

# Refresh Button
$refreshButton = New-Object System.Windows.Forms.Button
$refreshButton.Text = "Refresh"
$refreshButton.Location = New-Object System.Drawing.Point(320,150)
$tabPage2.Controls.Add($refreshButton)

# Load Tasks Function
function Load-Tasks {
    $taskList.Items.Clear()
    $tasks = Get-ScheduledTask | Where-Object {$_.TaskName -like "bomb_*"}
    foreach ($task in $tasks) {
        $taskList.Items.Add($task.TaskName)
    }
}

# Initial Load
Load-Tasks

$refreshButton.Add_Click({ Load-Tasks })

# Task Details Label
$taskDetails = New-Object System.Windows.Forms.Label
$taskDetails.Location = New-Object System.Drawing.Point(20,180)
$taskDetails.Size = New-Object System.Drawing.Size(380,40)
$tabPage2.Controls.Add($taskDetails)

# Task Selection Event
$taskList.Add_SelectedIndexChanged({
    $selectedTask = $taskList.SelectedItem
    if ($selectedTask) {
        $taskInfo = Get-ScheduledTask | Where-Object {$_.TaskName -eq $selectedTask}
        $runTime = [DateTime]::Parse($taskInfo.Triggers[0].StartBoundary).ToString("dd/MM/yyyy 'at' HH:mm")
        $taskDetails.Text = "Run Time: " + $runTime + [System.Environment]::NewLine + "Directory: " + ($taskInfo.Actions[0].Arguments -replace '.*-Path "([^"]+)".*', '$1')
    }
})

# Delete Task Button
$deleteTaskButton = New-Object System.Windows.Forms.Button
$deleteTaskButton.Text = "Delete Task"
$deleteTaskButton.Location = New-Object System.Drawing.Point(20,230)
$tabPage2.Controls.Add($deleteTaskButton)

$deleteTaskButton.Add_Click({
    $selectedTask = $taskList.SelectedItem
    if ($selectedTask) {
        Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File .\tools\delete_task.ps1 -taskName '$selectedTask'" -WindowStyle Hidden
        Load-Tasks
        $taskDetails.Text = ""
    }
})

# Show Form
$form.ShowDialog()
