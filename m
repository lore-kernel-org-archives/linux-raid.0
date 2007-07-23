From: Rene Herman <rene.herman@gmail.com>
Subject: Re: [RFH] Partition table recovery
Date: Mon, 23 Jul 2007 12:54:35 +0200
Message-ID: <46A488EB.2050305@gmail.com>
References: <200707200813.03553.a1426z@gawab.com> <46A24846.7050803@gmail.com> <20070722011141.GJ26752@thunk.org> <200707220710.31402.a1426z@gawab.com> <20070722162802.GA20174@thunk.org> <46A46399.5090406@gmail.com> <20070723084146.GP22998@lug-owl.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000409090102030903020205"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070723084146.GP22998@lug-owl.de>
Sender: linux-raid-owner@vger.kernel.org
To: Jan-Benedict Glaw <jbglaw@lug-owl.de>
Cc: Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------000409090102030903020205
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 07/23/2007 10:41 AM, Jan-Benedict Glaw wrote:

> As multibyte on-disk variables, these will need LE/BE conversion.

Indeed, thanks -- has been updated in the version that is attached.

Also fixes a bug that snuck in (failed to add offset to entry->start).

>> struct entry {
>> 	uint8_t flags;
>> 	uint8_t type;
>> 	uint16_t __1;
>> 	uint64_t start;
>> 	uint32_t size;
> 
> Dito.

This can stay for now. The partition table backup would indeed need some 
defined byte-order but it might be "whatever order the filesystem it's 
backed up onto uses". Since it's not directly written to any filesystem for 
now, host order will do currently.

> Looks like a useful program, but you'd definively fix the LE/BE issues.
> If you do that, it'll be able to even run on BE machines, too.

I might disagree with the usefulness. I believe that preferably a backup 
should be made with help from the kernel (if only by walking sysfs) to avoid 
things getting out of sync between kernel and backup program.

(this program largely does the same as the kernel does but even now there's 
already a difference in so far that I didn't bother to de-garbage the 3rd 
and 4th entries in the second level extendeds).

Rene.


--------------000409090102030903020205
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

#include <endian.h>
#include <byteswap.h>

static inline uint32_t le_32(uint32_t n)
{
#ifdef __LITTLE_ENDIAN
	return n;
#else
	return bswap_32(n);
#endif
}

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
				ret = do_sector(fd, le_32(cur->start), 0);
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
		entry->start = le_32(cur->start) + offset + start;
		entry->size  = le_32(cur->size);
	}
	if (ext)
		ret = do_sector(fd, offset, le_32(ext->start));
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

--------------000409090102030903020205--
