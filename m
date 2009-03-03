From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] md: stop defining MAJOR_NR
Date: Tue, 3 Mar 2009 18:58:43 +0100
Message-ID: <20090303175843.GA27386@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

MAJOR_NR was only required for magic in linux/blk.h in 2.4 or earlier
kernels, so no need to keep it around.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c	2009-02-27 17:44:32.351286370 +0100
+++ linux-2.6/drivers/md/md.c	2009-02-27 17:44:51.547286608 +0100
@@ -46,8 +46,6 @@
 #include <linux/file.h>
 #include <linux/delay.h>
 
-#define MAJOR_NR MD_MAJOR
-
 /* 63 partitions with the alternate major number (mdp) */
 #define MdpMinorShift 6
 
@@ -6464,13 +6462,13 @@ static void md_geninit(void)
 
 static int __init md_init(void)
 {
-	if (register_blkdev(MAJOR_NR, "md"))
+	if (register_blkdev(MD_MAJOR, "md"))
 		return -1;
 	if ((mdp_major=register_blkdev(0, "mdp"))<=0) {
-		unregister_blkdev(MAJOR_NR, "md");
+		unregister_blkdev(MD_MAJOR, "md");
 		return -1;
 	}
-	blk_register_region(MKDEV(MAJOR_NR, 0), 1UL<<MINORBITS, THIS_MODULE,
+	blk_register_region(MKDEV(MD_MAJOR, 0), 1UL<<MINORBITS, THIS_MODULE,
 			    md_probe, NULL, NULL);
 	blk_register_region(MKDEV(mdp_major, 0), 1UL<<MINORBITS, THIS_MODULE,
 			    md_probe, NULL, NULL);
@@ -6556,10 +6554,10 @@ static __exit void md_exit(void)
 	mddev_t *mddev;
 	struct list_head *tmp;
 
-	blk_unregister_region(MKDEV(MAJOR_NR,0), 1U << MINORBITS);
+	blk_unregister_region(MKDEV(MD_MAJOR,0), 1U << MINORBITS);
 	blk_unregister_region(MKDEV(mdp_major,0), 1U << MINORBITS);
 
-	unregister_blkdev(MAJOR_NR,"md");
+	unregister_blkdev(MD_MAJOR,"md");
 	unregister_blkdev(mdp_major, "mdp");
 	unregister_reboot_notifier(&md_notifier);
 	unregister_sysctl_table(raid_table_header);
