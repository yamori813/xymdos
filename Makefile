all: xrdos.com yrdos.com

xrdos.com: xrdos.asm
	fasm xrdos.asm

yrdos.com: yrdos.asm
	fasm yrdos.asm

clean:
	rm *.com
