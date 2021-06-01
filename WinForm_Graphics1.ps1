
# ランダムにsystem.drawing.colorの一色を返す処理
function Get-RandomColor{
	# 色名情報の配列を生成
	$arr = [system.drawing.color]|get-member -static -MemberType Property | Select-Object Name
	$count = $arr.Count

	# 色名情報の配列の要素番号をランダムに生成
	$select = Get-Random -Maximum ($count - 1)
	$retcolor = $arr[$select]

	return $retcolor.Name

}

# フォントを選択する処理
function Get-SelectFont{
	$arr_font = [System.Drawing.FontFamily]::Families

	# フォントの指定
	$Font = New-Object System.Drawing.Font("メイリオ",12)
	# フォーム全体の設定
	$form = New-Object System.Windows.Forms.Form
	$form.Text = "選択"
	$form.Size = New-Object System.Drawing.Size(300,200)
	$form.StartPosition = "CenterScreen"
	$form.font = $Font

	# ラベルを表示
	$label = New-Object System.Windows.Forms.Label
	$label.Location = New-Object System.Drawing.Point(10,10)
	$label.Size = New-Object System.Drawing.Size(270,20)
	$label.Text = "フォントを選択してください"
	$form.Controls.Add($label)

	# OKボタンの設定
	$OKButton = New-Object System.Windows.Forms.Button
	$OKButton.Location = New-Object System.Drawing.Point(40,100)
	$OKButton.Size = New-Object System.Drawing.Size(75,30)
	$OKButton.Text = "OK"
	$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
	$form.AcceptButton = $OKButton
	$form.Controls.Add($OKButton)

	# キャンセルボタンの設定
	$CancelButton = New-Object System.Windows.Forms.Button
	$CancelButton.Location = New-Object System.Drawing.Point(130,100)
	$CancelButton.Size = New-Object System.Drawing.Size(75,30)
	$CancelButton.Text = "Cancel"
	$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
	$form.CancelButton = $CancelButton
	$form.Controls.Add($CancelButton)

	# コンボボックスを作成
	$Combo = New-Object System.Windows.Forms.Combobox
	$Combo.Location = New-Object System.Drawing.Point(50,50)
	$Combo.size = New-Object System.Drawing.Size(150,30)
	$Combo.DropDownStyle = "DropDown"
	$Combo.FlatStyle = "standard"
	$Combo.font = $Font

	$str_BackColor = Get-RandomColor
	Write-Host "Combo.BackColor: $str_BackColor"
	$Combo.BackColor = $str_BackColor

	$str_ForeColor = Get-RandomColor
	Write-Host "Combo.ForeColor: $str_ForeColor"
	$Combo.ForeColor = $str_ForeColor

	# コンボボックスに項目を追加
	ForEach ($select in $arr_font){
		$fontname = $select.Name
		[void] $Combo.Items.Add("$fontname")
	}

	# フォームにコンボボックスを追加
	$form.Controls.Add($Combo)

	# フォームを最前面に表示
	$form.Topmost = $True

	# フォームを表示＋選択結果を変数に格納
	$result = $form.ShowDialog()

	# 選択後、OKボタンが押された場合、選択項目を表示
	if ($result -eq "OK")
	{
		$ret = $combo.Text
	}else{
		exit
	}

	return $ret
}

# インストールされているフォントの中からランダムにフォントを選択し、フォント名を返す処理
function Get-RandomFont{
	$arr_font = [System.Drawing.FontFamily]::Families
	$count = $arr_font.Count
	$num_select = Get-Random -Maximum ($count - 1)

	$ret_font = $arr_font[$num_select]
	$ret_str = $ret_font.Name
	Write-Host "ret_str: $ret_str"

	return $ret_str
}

# Create a graphic main routine
function Get-Graphics{
	Write-Host "[Get-Graphics] START"

	# 描画先とするImageオブジェクトを作成する
	$canvas = New-Object System.Drawing.Bitmap(500, 500)
	# ImageオブジェクトのGraphicsオブジェクトを作成する
	$graphic = [System.Drawing.Graphics]::FromImage($canvas)
	# Create Pen object
	$pen = New-Object System.Drawing.Pen("Red")

	# 位置(0, 0)に100x80の四角を赤色で描く
	$graphic.DrawRectangle($pen, 0, 0, 100, 80)
	# 先に描いた四角に内接する楕円を黒で描く
	$graphic.DrawEllipse($pen, 0, 0, 100, 80)
	
	#リソースを解放する
	$graphic.Dispose()

	Write-Host "[Get-Graphics] END"
	
	return $canvas
}


# 入力された内容を表示する
function Show_Message($text){
	Write-Host "Show_Message: start"

	# フォームの作成
	$form = New-Object System.Windows.Forms.Form
	$form.Text = "入力内容の表示"
	$form.Size = New-Object System.Drawing.Size(600,500)
	$form.StartPosition = "CenterScreen"

	$str_BackColor = Get-RandomColor
	Write-Host "[Show_Message]str_BackColor: $str_BackColor"
	$form.BackColor = $str_BackColor
	
	$form.MaximizeBox = $false
	$form.MinimizeBox = $false
	$form.FormBorderStyle = "FixedSingle"
	$form.Opacity = 1

	# OKボタンの設定
	$OKButton = New-Object System.Windows.Forms.Button
	$OKButton.Location = New-Object System.Drawing.Point(40,100)
	$OKButton.Size = New-Object System.Drawing.Size(75,30)
	$OKButton.Text = "OK"
	$OKButton.DialogResult = "OK"
	$OKButton.Flatstyle = "Popup"

	$str_OKBackColor = Get-RandomColor
	Write-Host "str_OKBackColor: $str_OKBackColor"
	$OKButton.Backcolor = $str_OKBackColor

	$str_OKForeColor = Get-RandomColor
	Write-Host "str_OKForeColor: $str_OKForeColor"
	$OKButton.forecolor = $str_OKForeColor

	# モードの選択(ランダムor選択)
	$mode = Read-Host "random mode: r or R , select mode: s or S"
	if(($mode -eq 'r') -or ($mode -eq 'R')){
		# フォントの設定(ランダムに設定する)
		$font_selected = Get-RandomFont
	}elseif(($mode -eq 's') -or ($mode -eq 'S')) {
		# 選択式でフォントの設定を行う
		$font_selected = Get-SelectFont
	}else {
		
	}
	Write-Host "font_selected: $font_selected"
	$Font = New-Object System.Drawing.Font("$font_selected", 22)

	# ラベルの設定
	$label = New-Object System.Windows.Forms.Label
	$label.Location = New-Object System.Drawing.Point(10,30)
	$label.Size = New-Object System.Drawing.Size(500,500)
	$label.Text = $text

	$str_labelforeColor = Get-RandomColor
	Write-Host "[Show_Message]str_labelForeColor: $str_labelforeColor"
	$label.forecolor = $str_labelforeColor

	$label.font = $Font

	# Create a graphic and put it on the label.
	$label.image = Get-Graphics

	# 最前面に表示：する
	$form.Topmost = $True

	# 入力ボックス部分を選択した状態にする
	$form.Add_Shown({$textBox.Select()})

	# キーとボタンの関係
	$form.AcceptButton = $OKButton

	# ボタン等をフォームに追加
	$form.Controls.Add($OKButton)
	$form.Controls.Add($label)

	# フォームを表示させ、その結果を受け取る
	$result = $form.ShowDialog()

	# 結果による処理分岐
	if ($result -eq "OK")
	{
		$x = $label.Text
		Write-Host "$x"
		Write-Host "Show_Message: end"

		return 0
	}
}

# Windows Formの表示処理
function Show_WinForm() {

	Write-Host "Show_WinForm: start"

	# フォームの作成
	$form = New-Object System.Windows.Forms.Form
	$form.Text = "入力"
	$form.Size = New-Object System.Drawing.Size(260,180)
	$form.StartPosition = "CenterScreen"
	
	$str_formBackColor = Get-RandomColor
	Write-Host "[Show_WinForm]str_formBackColor: $str_formBackColor"
	$form.BackColor = $str_formBackColor

	$form.MaximizeBox = $false
	$form.MinimizeBox = $false
	$form.FormBorderStyle = "FixedSingle"
	$form.Opacity = 1

	# OKボタンの設定
	$OKButton = New-Object System.Windows.Forms.Button
	$OKButton.Location = New-Object System.Drawing.Point(40,100)
	$OKButton.Size = New-Object System.Drawing.Size(75,30)
	$OKButton.Text = "OK"
	$OKButton.DialogResult = "OK"
	$OKButton.Flatstyle = "Popup"

	$str_OKBackColor = Get-RandomColor
	Write-Host "[Show_WinForm]str_OKBackColor: $str_OKBackColor"
	$OKButton.Backcolor = $str_OKBackColor
	
	$str_OKforeColor = Get-RandomColor
	Write-Host "[Show_WinForm]str_OKforeColor: $str_OKforeColor"
	$OKButton.forecolor = $str_OKforeColor

	# キャンセルボタンの設定
	$CancelButton = New-Object System.Windows.Forms.Button
	$CancelButton.Location = New-Object System.Drawing.Point(130,100)
	$CancelButton.Size = New-Object System.Drawing.Size(75,30)
	$CancelButton.Text = "Cancel"
	$CancelButton.DialogResult = "Cancel"
	$CancelButton.Flatstyle = "Popup"

	$str_cancelBackColor = Get-RandomColor
	Write-Host "[Show_WinForm]str_cancelBackColor: $str_cancelBackColor"
	$CancelButton.backcolor = $str_cancelBackColor

	$str_cancelForeColor = Get-RandomColor
	Write-Host "[Show_WinForm]str_cancelForeColor: $str_cancelForeColor"
	$CancelButton.forecolor = $str_cancelForeColor

	# フォントの設定
	$Font = New-Object System.Drawing.Font("メイリオ",11)

	# ラベルの設定
	$label = New-Object System.Windows.Forms.Label
	$label.Location = New-Object System.Drawing.Point(10,30)
	$label.Size = New-Object System.Drawing.Size(250,20)
	$label.Text = "何か入力してください"

	$str_labelBackColor = Get-RandomColor
	Write-Host "[Show_WinForm]str_labelBackColor: $str_labelBackColor"
	$label.forecolor = $str_labelBackColor

	$label.font = $Font

	# 入力ボックスの設定
	$textBox = New-Object System.Windows.Forms.TextBox
	$textBox.Location = New-Object System.Drawing.Point(10,70)
	$textBox.Size = New-Object System.Drawing.Size(225,50)
	$textBox.Font = New-Object System.Drawing.Font("MS 明朝",11)

	# 最前面に表示：する
	$form.Topmost = $True

	# 入力ボックス部分を選択した状態にする
	$form.Add_Shown({$textBox.Select()})

	# キーとボタンの関係
	$form.AcceptButton = $OKButton
	$form.CancelButton = $CancelButton

	# ボタン等をフォームに追加
	$form.Controls.Add($OKButton)
	$form.Controls.Add($CancelButton)
	$form.Controls.Add($label)
	$form.Controls.Add($textBox)

	# フォームを表示させ、その結果を受け取る
	$result = $form.ShowDialog()

	# 結果による処理分岐
	if (($result -eq "OK") -and ($textBox.Text.Length -gt 0)){
		$x = $textBox.Text
		Write-Host "$x"
		Show_Message($x)
	}elseif($textBox.Text.Length -gt 0){
		# メッセージボックスの表示
		[System.Windows.Forms.MessageBox]::Show("Input is Anything")
	}

	Write-Host "Show_WinForm: end"

}

# main

# アセンブリの読み込み
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

while ($true) {
    $select = Read-Host "please enter and start. if you want to quit, please 'q' and enter"
    if(($select -ne 'q') -or ($select -ne 'Q')){
        # Windows Form shows
        Show_WinForm
    }else {
        $date = Get-Date
        Write-Host "terminate this program ($date)"
        Start-Sleep 1
        return
    }   
}