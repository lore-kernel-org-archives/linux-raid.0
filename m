From: NeilBrown <neilb@suse.de>
Subject: [PATCH 007 of 7] md: Get name for block device in sysfs
Date: Fri, 14 Dec 2007 17:26:47 +1100
Message-ID: <1071214062647.1928@suse.de>
References: <20071214171950.1308.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-raid.ids


Given an fd on a block device, returns a string like

	/block/sda/sda1

which can be used to find related information in /sys.

Ideally we should have an ioctl that works on char devices as well,
but that seems far from trivial, so it seems reasonable to have
this until the later can be implemented.

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ioctl.c      |   13 +++++++++++++
 ./include/linux/fs.h |    2 ++
 2 files changed, 15 insertions(+)

diff .prev/block/ioctl.c ./block/ioctl.c
--- .prev/block/ioctl.c	2007-12-14 17:18:50.000000000 +1100
+++ ./block/ioctl.c	2007-12-14 16:15:41.000000000 +1100
@@ -227,8 +227,21 @@ int blkdev_ioctl(struct inode *inode, st
 	struct block_device *bdev = inode->i_bdev;
 	struct gendisk *disk = bdev->bd_disk;
 	int ret, n;
+	char b[BDEVNAME_SIZE*2  + 10];
 
 	switch(cmd) {
+	case BLKGETNAME:
+		strcpy(b, "/block/");
+		bdevname(bdev->bd_contains, b+7);
+		if (bdev->bd_contains != bdev) {
+			char *e = b + strlen(b);
+			*e++ = '/';
+			bdevname(bdev, e);
+		}
+		if (copy_to_user((char __user *)arg, b, strlen(b)+1))
+			return -EFAULT;
+		return 0;
+
 	case BLKFLSBUF:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;

diff .prev/include/linux/fs.h ./include/linux/fs.h
--- .prev/include/linux/fs.h	2007-12-14 17:18:50.000000000 +1100
+++ ./include/linux/fs.h	2007-12-14 16:13:03.000000000 +1100
@@ -218,6 +218,8 @@ extern int dir_notify_enable;
 #define BLKTRACESTOP _IO(0x12,117)
 #define BLKTRACETEARDOWN _IO(0x12,118)
 
+#define BLKGETNAME _IOR(0x12, 119, char [1024])
+
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
 #define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
