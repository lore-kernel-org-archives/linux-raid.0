From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/17] initrd: remove the BLKFLSBUF call in handle_initrd
Date: Thu,  9 Jul 2020 17:18:06 +0200
Message-ID: <20200709151814.110422-10-hch@lst.de>
References: <20200709151814.110422-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200709151814.110422-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

BLKFLSBUF used to be overloaded for the ramdisk driver to free the whole
ramdisk, which was completely different behavior compared to all other
drivers.  But this magic overload got removed in commit ff26956875c2
("brd: remove support for BLKFLSBUF"), so this call is entirely
pointless now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 init/do_mounts_initrd.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index d72beda824aa79..e4f88e9e1c0839 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -115,21 +115,12 @@ static void __init handle_initrd(void)
 	if (!error)
 		printk("okay\n");
 	else {
-		int fd = ksys_open("/dev/root.old", O_RDWR, 0);
 		if (error == -ENOENT)
 			printk("/initrd does not exist. Ignored.\n");
 		else
 			printk("failed\n");
 		printk(KERN_NOTICE "Unmounting old root\n");
 		ksys_umount("/old", MNT_DETACH);
-		printk(KERN_NOTICE "Trying to free ramdisk memory ... ");
-		if (fd < 0) {
-			error = fd;
-		} else {
-			error = ksys_ioctl(fd, BLKFLSBUF, 0);
-			ksys_close(fd);
-		}
-		printk(!error ? "okay\n" : "failed\n");
 	}
 }
 
-- 
2.26.2
