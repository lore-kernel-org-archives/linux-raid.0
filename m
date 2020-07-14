From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/23] init: remove the bstat helper
Date: Tue, 14 Jul 2020 21:04:07 +0200
Message-ID: <20200714190427.4332-4-hch@lst.de>
References: <20200714190427.4332-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200714190427.4332-1-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

The only caller of the bstat function becomes cleaner and simpler when
open coding the function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Song Liu <song@kernel.org>
---
 init/do_mounts.h    | 10 ----------
 init/do_mounts_md.c |  8 ++++----
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/init/do_mounts.h b/init/do_mounts.h
index 0bb0806de4ce2c..7513d1c14d13fe 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -20,16 +20,6 @@ static inline int create_dev(char *name, dev_t dev)
 	return ksys_mknod(name, S_IFBLK|0600, new_encode_dev(dev));
 }
 
-static inline u32 bstat(char *name)
-{
-	struct kstat stat;
-	if (vfs_stat(name, &stat) != 0)
-		return 0;
-	if (!S_ISBLK(stat.mode))
-		return 0;
-	return stat.rdev;
-}
-
 #ifdef CONFIG_BLK_DEV_RAM
 
 int __init rd_load_disk(int n);
diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
index b84031528dd446..359363e85ccd0b 100644
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -138,9 +138,9 @@ static void __init md_setup_drive(void)
 			dev = MKDEV(MD_MAJOR, minor);
 		create_dev(name, dev);
 		for (i = 0; i < MD_SB_DISKS && devname != NULL; i++) {
+			struct kstat stat;
 			char *p;
 			char comp_name[64];
-			u32 rdev;
 
 			p = strchr(devname, ',');
 			if (p)
@@ -150,9 +150,9 @@ static void __init md_setup_drive(void)
 			if (strncmp(devname, "/dev/", 5) == 0)
 				devname += 5;
 			snprintf(comp_name, 63, "/dev/%s", devname);
-			rdev = bstat(comp_name);
-			if (rdev)
-				dev = new_decode_dev(rdev);
+			if (vfs_stat(comp_name, &stat) == 0 &&
+			    S_ISBLK(stat.mode))
+				dev = new_decode_dev(stat.rdev);
 			if (!dev) {
 				printk(KERN_WARNING "md: Unknown device name: %s\n", devname);
 				break;
-- 
2.27.0
