From: Rene Herman <rene.herman@gmail.com>
Subject: Re: [RFH] Partition table recovery
Date: Mon, 23 Jul 2007 10:15:21 +0200
Message-ID: <46A46399.5090406@gmail.com>
References: <200707200813.03553.a1426z@gawab.com> <46A24846.7050803@gmail.com> <20070722011141.GJ26752@thunk.org> <200707220710.31402.a1426z@gawab.com> <20070722162802.GA20174@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010208010801000201050201"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070722162802.GA20174@thunk.org>
Sender: linux-raid-owner@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org
Cc: Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------010208010801000201050201
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 07/22/2007 06:28 PM, Theodore Tso wrote:

[ Al -- don't drop CCs please ]

> Well, let's think about this a bit.  What are the requirements?
> 
> 1) The partition manager should be able explicitly request that a new
> backup of the partition tables be stashed in each filesystem that has
> room for such a backup.  That way, when the user affirmatively makes a
> partition table change, it can get backed up in all of the right
> places automatically.

D-Bus? ;-)

> 2) The fsck program should *only* stash a backup of the partition
> table if there currently isn't one in the filesystem.  It may be that
> the partition table has been corrupted, and so merely doing an fsck
> should not transfer a current copy of the partition table to the
> filesystem-secpfic backup area.  It could be that the partition table
> was only partially recovered, and we don't want to overwrite the
> previously existing backups except on an explicit request from the
> system administrator.
> 
> 3) The mkfs program should automatically create a backup of the
> current partition table layout.  That way we get a backup in the newly
> created filesystem as soon as it is created.

On an integrated system like this, do you consider it acceptable to only do 
the MS-DOS partitions and not the other types that may be present _inside_ 
those partitions? (MINIX subpartitions, BSD slices, ...). I believe those 
should really also be done, but this would require keeping more information 
again.

> 4) The exact location of the backup may vary from filesystem to
> filesystem.  For ext2/3/4, bytes 512-1023 are always unused, and don't
> interfere with the boot sector at bytes 0-511, so that's the obvious
> location.  Other filesystems may have that location in use, and some
> other location might be a better place to store it.  Ideally it will
> be a well-known location, that isn't dependent on finding an inode
> table, or some such, but that may not be possible for all filesystems.
> 
> OK, so how about this as a solution that meets the above requirements?
> 
> /sbin/partbackup <device> [<fspart>]
> 
> 	Will scan <device> (i.e., /dev/hda, /dev/sdb, etc.) and create
> 	a 512 byte partition backup, using the format I've previously
> 	described.  If <fspart> is specified on the command line, it
> 	will use the blkid library to determine the filesystem type of
> 	<fspart>, and then attempt to execute
> 	/dev/partbackupfs.<fstype> to write the partition backup to
> 	<fspart>.  If <fspart> is '-', then it will write the 512 byte
> 	partition table to stdout.  If <fspart> is not specified on
> 	the command line, /sbin/partbackup will iterate over all
> 	partitions in <device>, use the blkid library to attempt to
> 	determine the correct filesystem type, and then execute 
> 	/sbin/partbackupfs.<fstype> if such a backup program exists.

I've cleaned up what I posted yesterday a bit and made it into the type of 
standalone-by-design program you suggest here (the version from yesterday 
required a -DTEST to be so). Not with the blkid bits though. Just dumps the 
sector to stdout (and a textual version to stderr if compiled with -DDEBUG).

I (very) briefly looked at blkid but unless I'm mistaken blkid needs device 
names? The documentation seems to be missing. When scanning the device for 
the partition table, we've built a list of partitions with offsets into the 
device and it would be nice if we could hand the fd and the offset off to 
something directly. If the program has to construct device names itself 
there's another truckload of pitfalls right there.

It wouldn't be hard to log minors as such, but you'd also need to be very 
sure you'd always do this in the same order as the kernel so that what I 
consider to be "/dev/sda2" is the same the kernel considers it to be. This 
is again rather fragile.

It might in fact make sense to just ask the kernel for the partitions on a 
device and not bother with scanning anything ourselves. Ie, just walk sysfs. 
Would you agree? This siginificantly reduces the risk of things getting out 
of sync, both scanning order and implementation.

The kernel doesn't currently store/export everything you'd want to store in 
a backup (as far as I'm aware, that is) but that could conceivably change. 
It would make things significantly less fragile.

Rene.

--------------010208010801000201050201
Content-Type: text/plain;
 name="partbackup.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="partbackup.c"

/*
 * Public Domain 2007, Rene Herman
 */

#define _LARGEFILE64_SOURCE

#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <fcntl.h>

enum {
	DOS_EXTENDED   = 0x05,
	WIN98_EXTENDED = 0x0f,
	LINUX_EXTENDED = 0x85,
};

struct partition {
        uint8_t boot_ind;
	uint8_t head;
	uint8_t sector;
	uint8_t cyl;
        uint8_t sys_ind;
	uint8_t end_head;
	uint8_t end_sector;
	uint8_t end_cyl;
        uint32_t start;
        uint32_t size;
} __attribute__((packed));

struct entry {
	uint8_t flags;
	uint8_t type;
	uint16_t __1;
	uint64_t start;
	uint32_t size;
} __attribute__((packed));

enum {
	ENTRY_FLAG_PRIMARY  = 0x01,
	ENTRY_FLAG_BOOTABLE = 0x80,
};

struct backup {
	uint8_t signature[8];
	uint16_t type;
	uint8_t heads;
	uint8_t sectors;
	uint8_t count;
	uint8_t __1[3];
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

#define ARRAY_SIZE(arr) (sizeof arr / sizeof arr[0])

int is_extended(struct partition *partition)
{
	int ret = 0;

	switch (partition->sys_ind) {
	case DOS_EXTENDED:
	case WIN98_EXTENDED:
	case LINUX_EXTENDED:
		ret = 1;
	}
	return ret;
}

unsigned char *get_sector(int fd, uint64_t n)
{
	unsigned char *sector;

	if (lseek64(fd, n << 9, SEEK_SET) < 0) {
		perror("lseek64");
		return NULL;
	}
	sector = malloc(512);
	if (!sector) {
		fprintf(stderr, "malloc: out of memory\n");
		return NULL;
	}
	if (read(fd, sector, 512) != 512) {
		perror("read");
		free(sector);
		return NULL;
	}
	return sector;
}

void put_sector(unsigned char *sector)
{
	free(sector);
}

#define TABLE_OFFSET (512 - 2 - 4 * sizeof(struct partition))

inline struct partition *table(unsigned char *sector)
{
	return (struct partition *)(sector + TABLE_OFFSET);
}

int do_sector(int fd, uint32_t offset, uint32_t start)
{
	unsigned char *sector;
	struct partition *cur;
	struct partition *ext = NULL;
	int ret = 0;

	sector = get_sector(fd, offset + start);
	if (!sector)
		return -1;

	if (sector[510] != 0x55 || sector[511] != 0xaa) {
		ret = -1;
		goto out;
	}
	for (cur = table(sector); cur < table(sector) + 4; cur++) {
		struct entry *entry;

		if (!cur->size)
			continue;

		cur->end_head += 1;
		if (backup.heads < cur->end_head)
			backup.heads = cur->end_head;

		cur->end_sector &= 0x3f;
		if (backup.sectors < cur->end_sector) 
			backup.sectors = cur->end_sector;

		if (is_extended(cur)) {
			if (!offset) {
				ret = do_sector(fd, cur->start, 0);
				if (ret < 0)
					goto out;
			} else if (!ext)
				ext = cur;
			continue;
		}
		if (backup.count == ARRAY_SIZE(backup.table)) {
			fprintf(stderr, "do_sector: out of space!\n");
			ret = -1;
			goto out;
		}
		entry = backup.table + backup.count++;

		entry->flags = cur->boot_ind;
		if (!offset)
			entry->flags |= ENTRY_FLAG_PRIMARY;

		entry->type  = cur->sys_ind;
		entry->start = cur->start + start;
		entry->size  = cur->size;
	}
	if (ext)
		ret = do_sector(fd, offset, ext->start);
  out:
	put_sector(sector);
	return ret;
}

void show_backup(void)
{
#ifdef DEBUG

	int i;

	fprintf(stderr, "signature: ");
	for (i = 0; i < 8; i++)
		fprintf(stderr, "%c", backup.signature[i]);
	fprintf(stderr, "\n");

	fprintf(stderr, "     type: %d\n", backup.type);
	fprintf(stderr, "    heads: %d\n", backup.heads);
	fprintf(stderr, "  sectors: %d\n", backup.sectors);
	fprintf(stderr, "    count: %d\n", backup.count);

	for (i = 0; i < backup.count; i++) {
		fprintf(stderr, "\n");
		fprintf(stderr, "%2d: flags: %02x\n", i, backup.table[i].flags);
		fprintf(stderr, "%2d:  type: %02x\n", i, backup.table[i].type);
		fprintf(stderr, "%2d: start: %llu\n", i, backup.table[i].start);
		fprintf(stderr, "%2d:  size: %u\n", i, backup.table[i].size);
	}
#endif
}

int main(int argc, char *argv[])
{
	int fd;
	struct stat buf;

	if (argc != 2) {
		printf("%s <blkdev>\n", argv[0]);
		return EXIT_FAILURE;
	}
	fd = open(argv[1], O_RDONLY);
	if (fd < 0) {
		perror("open");
		return EXIT_FAILURE;
	}
	if (fstat(fd, &buf) < 0) {
		perror("stat");
		return EXIT_FAILURE;
	}
	if (!S_ISBLK(buf.st_mode))
		fprintf(stderr, "warning: not a block device\n");
	
	if (do_sector(fd, 0, 0) < 0)
		return EXIT_FAILURE;

	if (close(fd) < 0) {
		perror("close");
		return EXIT_FAILURE;
	}
	if (write(STDOUT_FILENO, &backup, sizeof backup) != sizeof backup) {
		perror("write");
		return EXIT_FAILURE;
	}

	show_backup();

	return EXIT_SUCCESS;
}

--------------010208010801000201050201--
