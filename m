From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] MD: Prevent sysfs operations on uninitialized kobjects
Date: Thu, 07 Mar 2013 16:24:26 -0600
Message-ID: <1362695066.28152.7.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, jbrassow@redhat.com
List-Id: linux-raid.ids

MD: Prevent sysfs operations on uninitialized kobjects

Device-mapper does not use sysfs; but when device-mapper is leveraging
MD's RAID personalities, MD sometimes attempts to update sysfs.  This
patch adds checks for 'mddev-kobj.sd' in sysfs_[un]link_rdev to ensure
it is about to operate on something valid.  This patch also checks for
'mddev->kobj.sd' before calling 'sysfs_notify' in 'remove_and_add_spares'.
Although 'sysfs_notify' already makes this check, doing so in
'remove_and_add_spares' prevents an additional mutex operation.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/md.h
===================================================================
--- linux-upstream.orig/drivers/md/md.h
+++ linux-upstream/drivers/md/md.h
@@ -506,7 +506,7 @@ static inline char * mdname (struct mdde
 static inline int sysfs_link_rdev(struct mddev *mddev, struct md_rdev *rdev)
 {
 	char nm[20];
-	if (!test_bit(Replacement, &rdev->flags)) {
+	if (!test_bit(Replacement, &rdev->flags) && mddev->kobj.sd) {
 		sprintf(nm, "rd%d", rdev->raid_disk);
 		return sysfs_create_link(&mddev->kobj, &rdev->kobj, nm);
 	} else
@@ -516,7 +516,7 @@ static inline int sysfs_link_rdev(struct
 static inline void sysfs_unlink_rdev(struct mddev *mddev, struct md_rdev *rdev)
 {
 	char nm[20];
-	if (!test_bit(Replacement, &rdev->flags)) {
+	if (!test_bit(Replacement, &rdev->flags) && mddev->kobj.sd) {
 		sprintf(nm, "rd%d", rdev->raid_disk);
 		sysfs_remove_link(&mddev->kobj, nm);
 	}
Index: linux-upstream/drivers/md/md.c
===================================================================
--- linux-upstream.orig/drivers/md/md.c
+++ linux-upstream/drivers/md/md.c
@@ -7646,10 +7646,8 @@ static int remove_and_add_spares(struct
 				removed++;
 			}
 		}
-	if (removed)
-		sysfs_notify(&mddev->kobj, NULL,
-			     "degraded");
-
+	if (removed && mddev->kobj.sd)
+		sysfs_notify(&mddev->kobj, NULL, "degraded");
 
 	rdev_for_each(rdev, mddev) {
 		if (rdev->raid_disk >= 0 &&


