$bootloader_name = "boot1"
$disk_image = "floppy.img"
$raised = $false

nasm -f bin -o "$($bootloader_name).bin" "$($bootloader_name).asm"

if($?) {
	Write-Host "Bootloader compiled successfully"
	qemu-img create -f raw floppy.img 1440K
	try{
		$bootloader_data = [System.IO.File]::ReadAllBytes($bootloader_name + ".bin")
		
		$disk_image_file = [System.IO.File]::OpenWrite($disk_image)
		$disk_image_file.Write($bootloader_data, 0, $bootloader_data.Length)
		
		$disk_image_file.Close()
	}
	catch{
		$error_message = $_
		Write-Warning -Message "Writing Failed! $($error_message)"
		$raised = $true
	}
	if(!$raised){
		Write-Host "Bootloader written onto disk image"
		qemu-system-x86_64 -drive format=raw,file=floppy.img
		Remove-Item -Path ".\$($bootloader_name).bin"
	}
}
else{
	Write-Warning "Bootloader has issues! Resolve them and compile again."
}



