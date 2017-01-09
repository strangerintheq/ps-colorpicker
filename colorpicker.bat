@echo off
SETLOCAL EnableDelayedExpansion
for /f "Tokens=* Delims=" %%x in ('type %0') do (
    if "!EXIT_FOUND!"=="true" (set COMMAND=!COMMAND!%%x)    
    if "%%x"=="exit" (set EXIT_FOUND=true)    
)
powershell -windowstyle hidden -command %COMMAND% >NUL

exit

Add-Type -AssemblyName System.Windows.Forms, System.Drawing;

$s = 40; 
$h = $s / 2; 
$s2 = $s * 2; 
$s4 = $s * 4; 

$size = New-Object System.Drawing.Size($s, $s);
$img = New-Object System.Drawing.Bitmap($s2, $s);
$g = [System.Drawing.Graphics]::FromImage($img);

$timer = New-Object System.Windows.Forms.Timer;
$timer.Interval = 40;
$timer.add_tick({UpdateImage});
$timer.start();

function UpdateImage() {
  $x = [System.Windows.Forms.Cursor]::Position.X - $h;
  $y = [System.Windows.Forms.Cursor]::Position.Y - $h;
  $p = New-Object System.Drawing.Point($x, $y);
  $g.CopyFromScreen($p, [System.Drawing.Point]::Empty, $size);
  $c = $img.GetPixel($h, $h);
  $b = New-Object System.Drawing.SolidBrush($c);
  $g.FillRectangle($b, $s, 0, $s, $s2);
  $b = New-Object System.Drawing.SolidBrush black;
  $g.FillRectangle($b, $h, $h + 2, 1, 5);
  $g.FillRectangle($b, $h, $h - 6, 1, 5);
  $g.FillRectangle($b, $h + 2, $h, 5, 1);
  $g.FillRectangle($b, $h - 6, $h, 5, 1);
  $pictureBox.Image = $img;
  $label.Text = \"#\" + $(hex $c.R) + $(hex $c.G) + $(hex $c.B) + \"   r:\" + $c.R + \" g:\" + $c.G + \" b:\" + $c.B;
  $x = $x + 70;
  $y = $y - $h;
  $form.Location = New-Object System.Drawing.Point($x, $y);
}


function hex($i) {
  return [System.Convert]::ToString($i, 16).PadLeft(2, \"0\");
}

$pictureBox = New-Object Windows.Forms.PictureBox;
$pictureBox.Width = $s4; 
$pictureBox.Height = $s2;
$pictureBox.Location  = New-Object System.Drawing.Point(1, 1);
$pictureBox.SizeMode = 'Zoom';

$label = New-Object Windows.Forms.Label;
$label.Location = New-Object System.Drawing.Point(0, $s2);
$label.Width = $s4; 


$form = New-Object system.Windows.Forms.Form;
$form.Width = $s4 + 2; 
$form.Height = $s2 + 14;
$form.controls.add($pictureBox);
$form.controls.add($label);
$form.TopMost = $true;
$form.FormBorderStyle = 'None';
$form.MaximizeBox = $false;
$form.ShowDialog();

$g.Dispose();
$img.Dispose();
