SRC_DIR = src
INC_DIR = inc
BUILD_DIR = build
CC = i686-w64-mingw32-gcc
BIN = kernel.bin
CFLAGS = -ffreestanding -nostdlib -m32

C_SOURCES = $(wildcard $(SRC_DIR)/kernel/*.c $(SRC_DIR)/drivers/*.c)
HEADERS = $(wildcard $(INC_DIR)/kernel/*.h $(INC_DIR)/drivers/*.h)

OBJS = $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(C_SOURCES))

all: $(BUILD_DIR)/$(BIN)

$(BUILD_DIR)/kernel.bin: $(BUILD_DIR)/kernel.tmp
	objcopy -O binary $< $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c $(HEADERS)
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@ -I$(INC_DIR) -Wall
		
$(BUILD_DIR)/kernel.tmp: $(OBJS)
	ld -m i386pe -Ttext 0x1000 -o $@ $(OBJS)

clean:
	rm -f $(BUILD_DIR)/kernel/*.o $(BUILD_DIR)/drivers/*.o build/*.bin build/*.tmp 

kernel.dis: kernel.bin
	ndisasm -b 32 $ < > $@
