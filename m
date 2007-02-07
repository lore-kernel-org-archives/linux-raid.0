From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Move superblock on partition resize?
Date: Wed, 07 Feb 2007 21:50:14 +0300
Message-ID: <45CA1F66.4080907@tls.msk.ru>
References: <44918.192.168.0.1.1170871062.squirrel@bymeinc.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040103000303070406000000"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44918.192.168.0.1.1170871062.squirrel@bymeinc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Rob Bray <raid@bymeinc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------040103000303070406000000
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Rob Bray wrote:
> I am trying to grow a raid5 volume in-place. I would like to expand the
> partition boundaries, then grow raid5 into the newly-expanded partitions.
> I was wondering if there is a way to move the superblock from the end of
> the "old" partition to the end of the "new" partition. I've tried dd
> if=/dev/sdX1 of=/dev/sdX1 bs=512 count=256
> skip=(sizeOfOldPartitionInBlocks - 256) seek=(sizeOfNewPartitionInBlocks -
> 256) unsuccessfully. Also, copying the last 128KB (256 blocks) of the old
> partition before the table modification to a file, and placing that data
> at the tail of the new partition also yields no beans. I can drop one
> drive at a time from the group, change the partition table, then hot-add
> it, but a resync times 7 drives is a lot of juggling. Any ideas?

The superblock location is somewhat tricky to calculate correctly.

I've used a tiny program (attached) for exactly this purpose.

/mjt

--------------040103000303070406000000
Content-Type: text/x-csrc;
 name="mdsuper.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mdsuper.c"

/* mdsuper: read or write a linux software raid superbloc (version 0.90)
 * from or to a given device.
 * 
 * GPL.
 * Written by Michael Tokarev (mjt@tls.msk.ru)
 */

#define _GNU_SOURCE
#include <sys/types.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <sys/ioctl.h>
#include <linux/ioctl.h>
#include <linux/types.h>
#include <linux/raid/md_p.h>
#include <linux/fs.h>

int main(int argc, char **argv) {
  unsigned long long dsize;
  unsigned long long offset;
  int mdfd;
  int n;
  mdp_super_t super;
  const char *dev;

  if (argc != 3) {
    fprintf(stderr, "mdsuper: usage: mdsuper {read|write} mddev\n");
    return 1;
  }

  if (strcmp(argv[1], "read") == 0)
    n = O_RDONLY;
  else if (strcmp(argv[1], "write") == 0)
    n = O_WRONLY;
  else {
    fprintf(stderr, "mdsuper: read or write arg required, not \"%s\"\n",
            argv[1]);
    return 1;
  }

  dev = argv[2];
  mdfd = open(dev, n, 0);
  if (mdfd < 0) {
    perror(dev);
    return 1;
  }

  if (ioctl(mdfd, BLKGETSIZE64, &dsize) < 0) {
    perror(dev);
    return 1;
  }

  if (dsize < MD_RESERVED_SECTORS*2) {
    fprintf(stderr, "mdsuper: %s is too small\n", dev);
    return 1;
  }

  offset = MD_NEW_SIZE_SECTORS(dsize>>9);

  fprintf(stderr, "size=%Lu (%Lu sect), offset=%Lu (%Lu sect)\n",
          dsize, dsize>>9, offset * 512, offset);
  offset *= 512;

  if (n == O_RDONLY) {
    if (pread64(mdfd, &super, sizeof(super), offset) != sizeof(super)) {
      perror(dev);
      return 1;
    }
    if (super.md_magic != MD_SB_MAGIC) {
      fprintf(stderr, "%s: bad magic (0x%08x, should be 0x%08x)\n",
              dev, super.md_magic, MD_SB_MAGIC);
      return 1;
    }
    if (write(1, &super, sizeof(super)) != sizeof(super)) {
      perror("write");
      return 1;
    }
  }
  else {
    if (read(0, &super, sizeof(super)) != sizeof(super)) {
      perror("read");
      return 1;
    }
    if (pwrite64(mdfd, &super, sizeof(super), offset) != sizeof(super)) {
      perror(dev);
      return 1;
    }
  }

  return 0;
}

--------------040103000303070406000000--
