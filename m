From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [md PATCH 8/8] Enable OLCE for external IMSM metadata
Date: Wed, 24 Feb 2010 07:44:16 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D1016F65C0@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From b959ebd3a72a3edc9694425d3bbf44410ed6fcbe Mon Sep 17 00:00:00 2001
From: Adam Kwolek <adam.kwolek@intel.com>
Date: Thu, 18 Feb 2010 11:28:18 +0100
Subject: [PATCH] OLCE: Workaround for set size problem

Changes to be committed:
	modified:   md.c

When from user space array size is set after reshape VFS is lost. 
(Volume is not mountable or links are broken)
Notifying block device about size change in "old" way resolves problem
For now.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 drivers/md/md.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5e31b36..f418ef6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3892,8 +3892,32 @@ array_size_store(mddev_t *mddev, const char *buf, size_t len)
 
 	mddev->array_sectors = sectors;
 	set_capacity(mddev->gendisk, mddev->array_sectors);
+#define OLCE_SET_SIZE_WORKAROUND
+#ifdef OLCE_SET_SIZE_WORKAROUND
+	if (mddev->pers) {
+		/* when from user space array size is set after reshape
+		 * VFS is lost.
+		 * Notifying block device about size change in "old" way
+		 * fixes problem
+		 * this is the same as previously used update_array_sectors()OC
+		 */
+		struct block_device *bdev;
+		bdev = bdget_disk(mddev->gendisk, 0);
+
+		printk(KERN_INFO "OLCE: OLCE_SET_SIZE_WORKAROUND\n");
+		if (bdev) {
+			mutex_lock(&bdev->bd_inode->i_mutex);
+			i_size_write(bdev->bd_inode,
+				(loff_t) mddev->array_sectors << 9);
+			mutex_unlock(&bdev->bd_inode->i_mutex);
+			bdput(bdev);
+		}
+	}
+#else
 	if (mddev->pers)
 		revalidate_disk(mddev->gendisk);
+	printk(KERN_INFO "OLCE: OLCE_SET_SIZE_WORKAROUND NOT used\n");
+#endif
 
 	return len;
 }
-- 
1.6.0.2

