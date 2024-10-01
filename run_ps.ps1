$bootloader_name = "boot1"
$kernel_name = "kernel"
$disk_image = "floppy.img"

$raised = $false

nasm -f bin -o "$($bootloader_name).bin" "$($bootloader_name).asm"

if($?) {
	Write-Host "Bootloader compiled successfully"
	qemu-img create -f raw floppy.img 1440K

	# Compile the kernel
	gcc -ffreestanding -nostdlib -m32 -c kernel\kernel.c -o kernel\kernel.o
	#ld -o kernel.bin -Ttext 0x1000 --oformat binary kernel\kernel.o
	ld -T NUL -m i386pe -Ttext 0x1000 -o kernel.tmp kernel\kernel.o
	objcopy -O binary kernel.tmp kernel.bin
	if(-not $?){
		exit 1
	}
	Write-Host "Kernel successfully compiled"
	try{
		$bootloader_data = [System.IO.File]::ReadAllBytes($bootloader_name + ".bin")
		$kernel_data = [System.IO.File]::ReadAllBytes($kernel_name + ".bin")

		$disk_image_file = [System.IO.File]::OpenWrite($disk_image)

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
		qemu-system-x86_64 -drive format=raw,file=floppy.img
		Remove-Item -Path ".\$($bootloader_name).bin"
	}
}
else{
	Write-Warning "Bootloader has issues! Resolve them and compile again."
}



