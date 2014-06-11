void clrscr () {
	unsigned char *vidmem = (unsigned char *)0xB8000;
	const long size = 80*25;
	long loop;

	for (loop=0; loop<size; loop++) {
    	*vidmem++ = 0;
    	*vidmem++ = 0xF;
	}
	out(0x3D4, 14);
	out(0x3D5, 0);
	out(0x3D4, 15);
	out(0x3D5, 0);
}

void print (const char *_message) {
	unsigned char *vidmem = (unsigned char *)0xB8000);
	unsigned short offset;
	unsigned long i;

	out(0x3D4, 14);
	offset = in(0x3D5) << 8;
	out(0x3D4, 15);
	offset |= in(0x3D5);
	vidmem += offset*2;
	i = 0;
	while (_message[i] != 0) {
		*vidmem = _message[i++];
		vidmem += 2;
	}
	offset += i;
	out(0x3D5, (unsigned char)(offset));
	out(0x3D4, 14);
	out(0x3D5, (unsigned char)(offset >> 8));
}