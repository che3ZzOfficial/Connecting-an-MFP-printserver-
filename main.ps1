Add-Type -assembly System.Windows.Forms
$main_form = New-Object System.Windows.Forms.Form ### сама форма
$main_form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon('\\comp286.sir.local\Share\Личные папки\Деревянкин\Разработка подключение к принтеру\free-icon-multifunction-printer-1547967.ico')
$wshell = New-Object -ComObject Wscript.Shell
$ErrorActionPreference = 'Stop'
$printServers = @("print1","print2","print3") # переменная с названиями принт-серверов (в дальнейшем для перебора принтеров в них)

$main_form.Text ='Подключение МФУ.' # название формы
$main_form.Width = 400 # ширина
$main_form.Height = 500 # высота

$main_form.AutoSize = $true # автомат растяжение формы

$description_name_pc = New-Object System.Windows.Forms.Label
$description_name_pc.Text = "Имя вашего компьютера:"
$description_name_pc.Location  = New-Object System.Drawing.Point(100,20)
$description_name_pc.AutoSize = $true
$description_name_pc.Font = 'Microsoft Sans Serif,15'
$main_form.Controls.Add($description_name_pc)

$name_pc = New-Object system.Windows.Forms.Label
$name_pc.text = [System.Net.Dns]::GetHostName()
$name_pc.AutoSize = $false
$name_pc.Width = 400
$name_pc.Height = 50
$name_pc.location = New-Object System.Drawing.Point(160,50)
$name_pc.Font = 'Microsoft Sans Serif,25'
$name_pc.ForeColor = '#ff0000'
$main_form.Controls.Add($name_pc)


$description_mfu = New-Object System.Windows.Forms.Label
$description_mfu.Text = "МФУ-"
$description_mfu.Location  = New-Object System.Drawing.Point(150,150)
$description_mfu.AutoSize = $true
$description_mfu.Font = 'Microsoft Sans Serif,20'
$main_form.Controls.Add($description_mfu)

$name_mfu = New-Object System.Windows.Forms.TextBox
$name_mfu.AutoSize = $false
$name_mfu.MaxLength = 4 # всего 4 символа.
$name_mfu.Font = 'Microsoft Sans Serif,18'
$name_mfu.Location = New-Object System.Drawing.Point(250,150)
$name_mfu.Size = New-Object System.Drawing.Size(100,50)
$name_mfu.Add_TextChanged({
if ($this.Text -match '[^0-9]') { # автоматическое удаление букв в texbox
$cursorPos = $this.SelectionStart
$this.Text = $this.Text -replace '[^0-9]',''
$this.SelectionStart = $cursorPos - 1
$this.SelectionLength = 0
}
})
$main_form.Controls.Add($name_mfu)

$button_printer_def = New-Object system.Windows.Forms.CheckBox
$button_printer_def.AutoSize = $false
$button_printer_def.location= New-Object System.Drawing.Point(200,200)
$button_printer_def.Size = New-Object System.Drawing.Size(150,50)
$button_printer_def.text = "Добавить принтер по умолчанию?"
$main_form.Controls.Add($button_printer_def)	




$button_add_printer = New-Object system.Windows.Forms.Button
$button_add_printer.BackColor="#a4ba67"
$button_add_printer.text = "Добавить принтер"
$button_add_printer.width= 400
$button_add_printer.height= 50
$button_add_printer.location= New-Object System.Drawing.Point(70,250)
$button_add_printer.Font = 'Microsoft Sans Serif,25'
$main_form.Controls.Add($button_add_printer)
$button_add_printer.add_Click({
$mfu_name="МФУ-"+$name_mfu.text
$found = $false
foreach ($server in $printServers) {
    try {
        $printer = Get-Printer -ComputerName $server -name $mfu_name -ErrorAction SilentlyContinue
        if ($printer) {
                Write-Host "Принтер '$mfu_name' найден на сервере '$server".
                $found = $true
                $installedPrinters = Get-Printer -Name "\\$server\$mfu_name" -ErrorAction SilentlyContinue
                Write-Host $installedPrinters
                if (-not $installedPrinters){
                    $Output = $wshell.Popup("Принтер '$mfu_name' добавляется.")
                    (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\$server\$mfu_name")
                    Write-Host "Принтер '$mfu_name' успешно добавлен."
                    $Output = $wshell.Popup("Принтер '$mfu_name' успешно добавлен.")
                    If ($button_printer_def.Checked -eq $true) {(New-Object -ComObject WScript.Network).SetDefaultPrinter("\\$server\$mfu_name")}
                    
                }else{
                 If ($button_printer_def.Checked -eq $true) {(New-Object -ComObject WScript.Network).SetDefaultPrinter("\\$server\$mfu_name")}
                 Write-Host "Принтер '$mfu_name' уже установлен."
                $Output = $wshell.Popup("Принтер '$mfu_name' уже установлен.")}
        }
    } catch {
        Write-Host "Ошибка при проверке сервера '$server': $_"
    }
}
if (!$found) {
    Write-Host "Принтер '$mfu_name' не найден на всех серверах."
    $Output = $wshell.Popup("Принтер '$mfu_name' не найден.")}
}
)





$main_form.ShowDialog() # показ формы