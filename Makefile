#
#
#

ASM=nasm

all: xrdos.com yrdos.com

xrdos.com: xrdos.asm
	$(ASM) -o $@ xrdos.asm

yrdos.com: yrdos.asm
	$(ASM) -o $@ yrdos.asm

zip:
	zip xydos xrdos.com yrdos.com

clean:
	rm -rf *.com *.zip
