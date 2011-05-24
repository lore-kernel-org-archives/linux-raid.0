From: Jonathan Brassow <jbrassow@f14.redhat.com>
Subject: [PATCH 2 of 9] MD:  should_read_superblock
Date: Mon, 23 May 2011 22:06:09 -0500
Message-ID: <201105240306.p4O369g2029293@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Patch name: md-should_read_superblock.patch

Add new function to determine whether MD superblocks should be read.

It used to be sufficient to check if mddev->raid_disks was set to determine
whether to read the superblock or not.  However, device-mapper (dm-raid.c)
sets this value before calling md_run().  Thus, we need additional mechanisms
for determining whether to read the superblock.  This patch adds the condition
that if rdev->meta_bdev is set, the superblock should be read - something that
only device-mapper does (and only when there are superblocks to be read/used).

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -4421,6 +4421,20 @@ static void md_safemode_timeout(unsigned
 	md_wakeup_thread(mddev->thread);
 }
 
+static int should_read_super(mddev_t *mddev)
+{
+	mdk_rdev_t *rdev, *tmp;
+
+	if (!mddev->raid_disks)
+		return 1;
+
+	rdev_for_each(rdev, tmp, mddev)
+		if (rdev->meta_bdev)
+			return 1;
+
+	return 0;
+}
+
 static int start_dirty_degraded;
 
 int md_run(mddev_t *mddev)
@@ -4442,7 +4456,7 @@ int md_run(mddev_t *mddev)
 	/*
 	 * Analyze all RAID superblock(s)
 	 */
-	if (!mddev->raid_disks) {
+	if (should_read_super(mddev)) {
 		if (!mddev->persistent)
 			return -EINVAL;
 		analyze_sbs(mddev);
