From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: endianness of Linux kernel RAID
Date: Thu, 18 Aug 2005 14:44:08 +1000
Message-ID: <17156.4632.279747.557864@cse.unsw.edu.au>
References: <17144.14273.684705.729233@cse.unsw.edu.au>
	<20050811133811.58530.qmail@web35305.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Brent Walsh on Thursday August 11
Sender: linux-raid-owner@vger.kernel.org
To: Brent Walsh <blinux_adm@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday August 11, blinux_adm@yahoo.com wrote:
> 
> My array is raid5, so I decided to overwrite the
> big-endian superblocks and assemble the array.  Your
> patch worked as expected and the array is functioning
> properly.  Thanks for the help.
> 
> Is there a simple way convert the superblocks back to
> big-endian while the drives are connected to the
> little-endian machine?

Not with mdadm... I could but I don't think I really want to.

However I wrote the following little program to test the byteswapping
code in mdadm.  It does a full byteswap of the superblock on the
device that you pass as an argument.

NeilBrown


-----------cut--here--------
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <stdio.h>
#include <sys/mount.h>
/*
 * This is a tiny test program to endian-swap
 * the superblock on a given device.
 * We simply read 4k from where the superblock should be
 * do the swap, and write it back
 * Don't use this on a real array, use mdadm.
 */

#define MD_RESERVED_BYTES		(64 * 1024)
#define MD_RESERVED_SECTORS		(MD_RESERVED_BYTES / 512)

#define MD_NEW_SIZE_SECTORS(x)		((x & ~(MD_RESERVED_SECTORS - 1)) - MD_RESERVED_SECTORS)

main(int argc, char *argv[])
{
	int fd, i;
	unsigned long size;
	unsigned long long offset;
	char super[4096];
	if (argc != 2) {
		fprintf(stderr, "Usage: swap_super device\n");
		exit(1);
	}
	fd = open(argv[1], O_RDWR);
	if (fd<0) {
		perror(argv[1]);
		exit(1);
	}
	if (ioctl(fd, BLKGETSIZE, &size)) {
		perror("BLKGETSIZE");
		exit(1);
	}
	offset = MD_NEW_SIZE_SECTORS(size) * 512LL;
	if (lseek64(fd, offset, 0) < 0LL) {
		perror("lseek64");
		exit(1);
	}
	if (read(fd, super, 4096) != 4096) {
		perror("read");
		exit(1);
	}


	for (i=0; i < 4096 ; i+=4) {
		char t = super[i];
		super[i] = super[i+3];
		super[i+3] = t;
		t=super[i+1];
		super[i+1]=super[i+2];
		super[i+2]=t;
	}
	/* swap the u64 events counters */
	for (i=0; i<4; i++) {
		/* events_hi and events_lo */
		char t=super[32*4+7*4 +i];
		super[32*4+7*4 +i] = super[32*4+8*4 +i];
		super[32*4+8*4 +i] = t;

		/* cp_events_hi and cp_events_lo */
		t=super[32*4+9*4 +i];
		super[32*4+9*4 +i] = super[32*4+10*4 +i];
		super[32*4+10*4 +i] = t;
	}


	if (lseek64(fd, offset, 0) < 0LL) {
		perror("lseek64");
		exit(1);
	}
	if (write(fd, super, 4096) != 4096) {
		perror("write");
		exit(1);
	}
	exit(0);

}


