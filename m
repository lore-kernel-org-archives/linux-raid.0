From: Tom Vier <tmv@comcast.net>
Subject: Re: Root Drive Mirroring and LVM.
Date: Wed, 28 Jan 2004 20:01:01 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040129010101.GA13800@zero>
References: <868055F9-5045-11D8-8066-00039382032A@mindspring.com> <200401270801.i0R81HdT022197@kruuna.Helsinki.FI> <20040127093213.GA10049@iliana>
Reply-To: Tom Vier <tmv@comcast.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="FCuugMFkClbJLl1L"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040127093213.GA10049@iliana>
To: Sven Luther <sven.luther@wanadoo.fr>
Cc: linuxppc-dev@lists.linuxppc.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 27, 2004 at 10:32:13AM +0100, Sven Luther wrote:
> Seems ok for me. Also, i guess that there are other partition types,
> like the amiga partitition table the pegasos boxes mostly use, which has
> a 32bit identifier for partition types. I guess it is the task of the
> RAID code to have some per partition type checking for this RAID autodetect
> magic.

it's done in fs/partitions/. it could be made anything, as long as it's put
in the raid docs so people know.

here's a patch of mine for alpha, to give you an idea.

-- 
Tom Vier <tmv@comcast.net>
DSA Key ID 0xE6CB97DA

--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="part-fstype.diff"

diff -urN linux-2.4.10-ac7-patched-build/fs/partitions/osf.c linux-2.4.10-ac7-patched-build-osf/fs/partitions/osf.c
--- linux-2.4.10-ac7-patched-build/fs/partitions/osf.c	Sat Oct  6 13:25:48 2001
+++ linux-2.4.10-ac7-patched-build-osf/fs/partitions/osf.c	Sat Oct  6 13:25:20 2001
@@ -7,6 +7,7 @@
  *  Re-organised Feb 1998 Russell King
  */
 
+#include <linux/config.h>
 #include <linux/fs.h>
 #include <linux/genhd.h>
 #include <linux/kernel.h>
@@ -17,6 +18,10 @@
 #include "check.h"
 #include "osf.h"
 
+#if CONFIG_BLK_DEV_MD
+extern void md_autodetect_dev(kdev_t dev);
+#endif
+
 int osf_partition(struct gendisk *hd, struct block_device *bdev,
 		unsigned long first_sector, int current_minor)
 {
@@ -74,10 +79,16 @@
 	for (i = 0 ; i < le16_to_cpu(label->d_npartitions); i++, partition++) {
 		if ((current_minor & mask) == 0)
 		        break;
-		if (le32_to_cpu(partition->p_size))
-			add_gd_partition(hd, current_minor,
-				first_sector+le32_to_cpu(partition->p_offset),
-				le32_to_cpu(partition->p_size));
+		if (le32_to_cpu(partition->p_size)) {
+				add_gd_partition(hd, current_minor,
+					first_sector+le32_to_cpu(partition->p_offset),
+					le32_to_cpu(partition->p_size));
+#if CONFIG_BLK_DEV_MD
+				if (partition->p_fstype == LINUX_RAID_PARTITION) {
+					md_autodetect_dev(MKDEV(hd->major,current_minor));
+				}
+#endif
+		}
 		current_minor++;
 	}
 	printk("\n");

--FCuugMFkClbJLl1L--
