$bootloader_name = "boot"
$src_dir = "src"
$boot_folder_path = "$($src_dir)\boot"
$build_dir = "build"
$kernel_bin = "kernel.bin"
$disk_image = "floppy.img"

$raised = $false

nasm -f bin -o "$($build_dir)\$($bootloader_name).bin" "$($boot_folder_path)\$($bootloader_name).asm"

if($?) {
	Write-Host "Bootloader compiled successfully"
	qemu-img create -f raw $build_dir\floppy.img 1440K

	# Compile the kernel
	make all
	if(-not $?){
		Write-Warning -Message "Make build failed! Exiting."
		exit 1
	}
	Write-Host "Kernel successfully compiled"
	try{
		$bootloader_data = [System.IO.File]::ReadAllBytes("$($build_dir)\$($bootloader_name).bin")
		$kernel_data = [System.IO.File]::ReadAllBytes("$($build_dir)\$($kernel_bin)")

		$disk_image_file = [System.IO.File]::OpenWrite("$($build_dir)\$($disk_image)")

		$disk_image_file.Write($bootloader_data, 0, $bootloader_data.Length)
		$disk_image_file.Write($kernel_data, 0, $kernel_data.Length)

		$disk_image_file.Close()
	}
	catch{
		$error_message = $_
		Write-Warning -Message "Writing Failed! $($error_message)"
		$raised = $true
	}

	if(!$raised){
		Write-Host "Bootloader written onto disk image"
		qemu-system-x86_64 -drive format=raw,file=$build_dir\floppy.img
		Remove-Item -Path ".\$($build_dir)\$($bootloader_name).bin"
	}
}
else{
	Write-Warning "Bootloader has issues! Resolve them and compile again."
}

make clean



