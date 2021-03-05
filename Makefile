#
#
#

ASM=fasm

all: xrdos.com yrdos.com

xrdos.com: xrdos.asm
	$(ASM) xrdos.asm

yrdos.com: yrdos.asm
	$(ASM) yrdos.asm

zip:
	zip xydos xrdos.com yrdos.com

clean:
	rm -rf *.com *.zip
