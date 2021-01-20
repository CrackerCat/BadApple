# Assumes that ../pongoOS contains a clone of the latest pongoOS
# repository from https://github.com/checkra1n/pongoOS with
# compiled binaries.

badapple.bin: main.c video.h Makefile video.o gifdec.c
	xcrun -sdk iphoneos gcc gifdec.c main.c video.o -o badapple.bin -arch arm64 -mabi=aapcs -Xlinker -kext -nostdlib -Xlinker -fatal_warnings -D_SECURE__STRING_H_ -O3

clean:
	rm -f badapple.bin

video.h: bad-apple/video.h
	cp bad-apple/video.h ./

video.o: bad-apple/video.o
	cp bad-apple/video.o ./

test:
	python3.8 ../pongoOS/scripts/upload_data.py badapple.bin
	(printf 'modload\nbad_apple\n'; cat) | (../pongoOS/scripts/pongoterm || true)