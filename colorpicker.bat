@echo off
SETLOCAL EnableDelayedExpansion
for /f "Tokens=* Delims=" %%x in ('type %0') do (
    if "!EXIT_FOUND!"=="true" (set COMMAND=!COMMAND!%%x)    
    if "%%x"=="exit" (set EXIT_FOUND=true)    
)
powershell -windowstyle hidden -command %COMMAND% >NUL
exit

Add-Type -AssemblyName System.Windows.Forms, System.Drawing;

$s = 55; 
$h = $s / 2; 
$s2 = $s * 2; 
$s4 = $s * 4; 

$size = New-Object System.Drawing.Size $s, $s;
$img = New-Object System.Drawing.Bitmap $s2, $s;
$g = [System.Drawing.Graphics]::FromImage($img);

$timer = New-Object System.Windows.Forms.Timer;
$timer.Interval = 40;
$timer.add_tick({UpdateImage});
$timer.start();

function UpdateImage() {
  $x = [System.Windows.Forms.Cursor]::Position.X - $h;
  $y = [System.Windows.Forms.Cursor]::Position.Y - $h;
  $p = New-Object System.Drawing.Point $x, $y;
  $g.CopyFromScreen($p, [System.Drawing.Point]::Empty, $size);
  $c = $img.GetPixel($h, $h);
  $b = New-Object System.Drawing.SolidBrush $c;
  $g.FillRectangle($b, $s, 0, $s, $s2);
  $b = New-Object System.Drawing.SolidBrush black;
  $g.FillRectangle($b, $h, $h + 2, 1, 5);
  $g.FillRectangle($b, $h, $h - 5, 1, 5);
  $g.FillRectangle($b, $h + 2, $h, 5, 1);
  $g.FillRectangle($b, $h - 5, $h, 5, 1);
  $pictureBox.Image = $img;
  $form.Text = \"#\" + $(hex $c.R) + $(hex $c.G) + $(hex $c.B);
}

function hex($i) {
  return [System.Convert]::ToString($i, 16).PadLeft(2, \"0\");
}

$pictureBox = New-Object Windows.Forms.PictureBox;
$pictureBox.Width = $s4; 
$pictureBox.Height = $s2;
$pictureBox.SizeMode = 'Zoom';

$form = New-Object system.Windows.Forms.Form;
$form.Width = $s4 + 9; 
$form.Height = $s2 + 36;
$form.controls.add($pictureBox);
$form.TopMost = $true;
$form.FormBorderStyle = 'Fixed3D';
$form.MaximizeBox = $false;
$form.ShowDialog();

$g.Dispose();
$img.Dispose();
