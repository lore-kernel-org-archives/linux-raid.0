From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 8] MD:  no integrity register if no gendisk
Date: Tue, 07 Jun 2011 17:46:50 -0500
Message-ID: <1307486810.31279.5.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Don't attempt md_integrity_register if there is no gendisk struct available.

When MD arrays are built via device-mapper, the gendisk structure is not
available via mddev.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -1781,8 +1781,8 @@ int md_integrity_register(mddev_t *mddev
 
 	if (list_empty(&mddev->disks))
 		return 0; /* nothing to do */
-	if (blk_get_integrity(mddev->gendisk))
-		return 0; /* already registered */
+	if (!mddev->gendisk || blk_get_integrity(mddev->gendisk))
+		return 0; /* shouldn't register, or already is */
 	list_for_each_entry(rdev, &mddev->disks, same_set) {
 		/* skip spares and non-functional disks */
 		if (test_bit(Faulty, &rdev->flags))


