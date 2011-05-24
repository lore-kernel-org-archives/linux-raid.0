From: Jonathan Brassow <jbrassow@f14.redhat.com>
Subject: [PATCH 5 of 9] MD:  no integrity register if no gendisk
Date: Mon, 23 May 2011 22:06:42 -0500
Message-ID: <201105240306.p4O36g9i029513@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Patch name: md-no-integrity-register-if-no-gendisk.patch

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
