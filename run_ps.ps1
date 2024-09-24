$bootloader = "boot1.bin"
$disk_image = "floppy.img"
$raised = $false

nasm -f bin -o boot1.bin boot1.asm

try{
$bootloader_data = [System.IO.File]::ReadAllBytes($bootloader)

$disk_image_file = [System.IO.File]::OpenWrite($disk_image)
$disk_image_file.Write($bootloader_data, 0, $bootloader_data.Length)

$disk_image_file.Close()
}
catch{
	$error_message = $_
	Write-Error -Message Writing Failed! $error_message
	$raised = $true
}
if(!$raised){
Write-Host "Written successfully!"
}
qemu-system-x86_64 -drive format=raw,file=floppy.img

