From: Rene Herman <rene.herman@gmail.com>
Subject: Re: [RFH] Partition table recovery
Date: Sun, 22 Jul 2007 11:11:49 +0200
Message-ID: <46A31F55.2000009@gmail.com>
References: <200707200813.03553.a1426z@gawab.com> <200707201429.34419.a1426z@gawab.com> <20070720113914.GJ22998@lug-owl.de> <200707201522.17270.a1426z@gawab.com> <20070720160614.GG26752@thunk.org> <46A24846.7050803@gmail.com> <20070722011141.GJ26752@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020807070509090408090102"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070722011141.GJ26752@thunk.org>
Sender: linux-raid-owner@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, Rene Herman <rene.herman@gmail.com>, Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------020807070509090408090102
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 07/22/2007 03:11 AM, Theodore Tso wrote:

>> This is a problem. Today the CHS fields in the partition entries don't
>> mean much of anything anymore and Linux happily ignores them but DOS
>> and (hence) Windows 9x do not. From time to time I still have the
>> Windows 98 install that's sitting in a corner of my disk throw a fit
>> just by having set the BIOS from LBA to Large (meaning the geometry the
>> BIOS pretends the disk has changes) for example. Old DOS installs that
>> I keep around for the purpose of hardware testing with the originally
>> supplied drivers make for even more of a "don't touch, don't touch!"
>> thing -- various version of DOS throw fits for various reasons.
> 
> This is true, but that's due to the fundamentally broken nature of CHS.
> You need them to boot, and that's about it.  I will say up front that I
> don't particularly care about legacy operating system such as DOS,
> Windows 98, or Minix 3.  So the idea of simply having the number of heads
> and sectors in the partition header is that we can reconstruct CHS fields
> such that it is likely with modern hardware you will get it right.

Well, I still don't believe this all to be a great idea but it was sort of 
fun so the attached does largely what you want -- build a list of all data 
partitions.

The heads/sectors fields it for now just gets from the HDIO_GETGEO call. A 
better source would be guessing the values from the partition table itself 
but that _also_ doesn't make too much sense. If you're reconstructing a 
sanitized version of the table anyway, it makes better sense to reconstruct 
it with the values HDIO_GETGEO returns at restoration time.

I kept your suggested format, but in fact, the 64-bit "start" value seems 
not very useful if we're getting the value from a 32-bit field in the old 
partition tables anyway. With that shrunk down to 32-bit again, there would 
be enough room for the complete partition table entry...

> For ancient systems that do all sorts of weird things such as ECHS,
> etc., yeah, you're pretty much doomed, and the bigger danger comes
> from futzing with BIOS settings, et. al.  But it's 2007, gosh darn it!
> "Here's a quarter, kid, buy yourself a real computer".  :-)

Thanks, but real computers won't host my ISA cards...

> Yes, I'm very aware of the extended partitioning scheme mess.  What I
> was proposing to back up here is only the real partitions, not the
> fake extended partitions.  The idea is to store *just* enough
> information so that a partition table manager can recover the
> partition tables in such a way that the original filesystem
> information can be recovered.

This should do I guess. It enters all data partitions into the list, in the 
order in which they are encountered and sets a flag to signify that a 
partition was a logical rather than primary. Another option would be to just 
reserve the first 4 entries for the primaries and the rest for the logicals 
but this saves entries if there are fewer than 4 primaries and was in fact 
easier...

The program enters partitions in what should be the same order as Linux 
itself does. Primaries from slot 0 to 3 as normal (but not backed up to 
entry 0 to 3 as said -- the LOGICAL flag indentifies them), extended 
partitions in the MBR in the order as encountered, with the logicals in the 
second-level table as encountered, and following only the first extented in 
the second-level table.

Made it into a generic C program -- didn't look at e2fsprogs sources yet.

Need to be off now and haven't yet stared at this as long as I'd like so 
don't slap me if I've left a few bugs in (although it seems to work nicely). 
The program dumps the backup sector to stdout -- it's ofcourse easy to 
change it to print the entries out so they're easy to compare against, say, 
"fdisk -l -us".

Oh, and once you've looked at it, please throw it away. As said, I still 
don't think it's a great idea ;-)

Rene.


--------------020807070509090408090102
Content-Type: text/plain;
 name="backup.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="backup.c"

/*
 * Public Domain 2007, Rene Herman
 *
 * gcc -W -Wall -DTEST -D_LARGEFILE64_SOURCE -o backup backup.c
 *
 */

#include <stdlib.h>

enum {
	DOS_EXTENDED   = 0x05,
	WIN98_EXTENDED = 0x0f,
	LINUX_EXTENDED = 0x85,
};

struct partition {
        unsigned char boot_ind;
	unsigned char __1[3];
        unsigned char sys_ind;
	unsigned char __2[3];
        unsigned int start;
        unsigned int size;
} __attribute__((packed));

struct entry {
	unsigned char flags;
	unsigned char type;
	unsigned short __1;
	unsigned long long start;
	unsigned int size;
} __attribute__((packed));

enum {
	ENTRY_FLAG_LOGICAL  = 0x01,
	ENTRY_FLAG_BOOTABLE = 0x80,
};

struct backup {
	unsigned char signature[8];
	unsigned short type;
	unsigned char heads;
	unsigned char sectors;
	unsigned char count;
	unsigned char __1[3];
	struct entry table[31];
} __attribute__((packed));

#define BACKUP_SIGNATURE "PARTBAK1"

enum {
	BACKUP_TYPE_MBR = 1,
};

struct backup backup = {
	.signature = BACKUP_SIGNATURE,
	.type	   = BACKUP_TYPE_MBR,
};

int is_extended(struct partition *entry)
{
	int ret = 0;

	switch (entry->sys_ind) {
	case DOS_EXTENDED:
	case WIN98_EXTENDED:
	case LINUX_EXTENDED:
		ret = 1;
	}
	return ret;
}

unsigned char *get_sector(unsigned int n);
void put_sector(unsigned char *sector);

int do_sector(unsigned int offset, unsigned int start)
{
	unsigned char *sector;
	struct partition *partition;
	struct partition *extended = NULL;

	start += offset;
	sector = get_sector(start);
	if (!sector) 
		return -1;

	if (sector[510] != 0x55 || sector[511] != 0xaa) {
		put_sector(sector);
		return -1;
	}

	partition = (struct partition *)(sector + 510 - 4 * sizeof *partition);
	do {
		struct entry *entry;

		if (!partition->size)
			continue;

		if (is_extended(partition)) {
			if (!offset)
				do_sector(partition->start, 0);
			else if (!extended)
				extended = partition;
			continue;
		}
		entry = backup.table + backup.count++;

		entry->flags = partition->boot_ind;
		if (offset)
			entry->flags |= ENTRY_FLAG_LOGICAL;
		entry->type  = partition->sys_ind;
		entry->start = start + partition->start;
		entry->size  = partition->size;

	} while (++partition < (struct partition *)(sector + 510));

	if (extended)
		do_sector(offset, extended->start);

	put_sector(sector);
	return 0;
}

#ifdef TEST
#include <stdio.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <fcntl.h>

#include <linux/hdreg.h>

int fd;

unsigned char *get_sector(unsigned int n)
{
	unsigned char *sector = malloc(512);

	if (!sector)
		return NULL;

	if (lseek64(fd, (off64_t)n << 9, SEEK_SET) < 0)
		goto free;

	if (read(fd, sector, 512) != 512) {
  free:		
		free(sector);
		sector = NULL;
	}
	return sector;
}

void put_sector(unsigned char *sector)
{
	free(sector);
}

int main(int argc, char *argv[])
{
	struct stat buf;
	struct hd_geometry geometry;

	if (argc != 2) {
		printf("%s <blkdev>\n", argv[0]);
		return EXIT_FAILURE;
	}
	fd = open(argv[1], O_RDONLY);
	if (fd < 0) {
		perror("open");
		return EXIT_FAILURE;
	}
	if (fstat(fd, &buf) < 0 || !S_ISBLK(buf.st_mode)) {
		perror("stat");
		return EXIT_FAILURE;
	}
	if (ioctl(fd, HDIO_GETGEO, &geometry) == 0) {
		backup.heads = geometry.heads;
		backup.sectors = geometry.sectors;
	}
	if (do_sector(0, 0) < 0)
		return EXIT_FAILURE;

	if (close(fd) < 0) {
		perror("close");
		return EXIT_FAILURE;
	}
	if (write(STDOUT_FILENO, &backup, sizeof backup) != sizeof backup) {
		perror("write");
		return EXIT_FAILURE;
	}
	return EXIT_SUCCESS;
}
#endif

--------------020807070509090408090102--
