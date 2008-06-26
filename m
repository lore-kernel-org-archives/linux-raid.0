From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH] disable queue flag test in barrier check
Date: Wed, 25 Jun 2008 22:07:22 -0500
Message-ID: <486307EA.7080007@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: xfs-oss <xfs@oss.sgi.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

md raid1 can pass down barriers, but does not set an ordered flag 
on the queue, so xfs does not even attempt a barrier write, and 
will never use barriers on these block devices.

I propose removing the flag check and just let the barrier write
test determine barrier support.

The risk here, I suppose, is that if something does not set an ordered
flag and also does not properly return an error on a barrier write...
but if it's any consolation jbd/ext3/reiserfs never test the flag, 
and don't even do a test write, they just disable barriers the first 
time an actual journal barrier write fails.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: linux-2.6.25.1/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6.25.1.orig/fs/xfs/linux-2.6/xfs_super.c
+++ linux-2.6.25.1/fs/xfs/linux-2.6/xfs_super.c
@@ -733,14 +733,6 @@ xfs_mountfs_check_barriers(xfs_mount_t *
 		return;
 	}
 
-	if (mp->m_ddev_targp->bt_bdev->bd_disk->queue->ordered ==
-					QUEUE_ORDERED_NONE) {
-		xfs_fs_cmn_err(CE_NOTE, mp,
-		  "Disabling barriers, not supported by the underlying device");
-		mp->m_flags &= ~XFS_MOUNT_BARRIER;
-		return;
-	}
-
 	if (xfs_readonly_buftarg(mp->m_ddev_targp)) {
 		xfs_fs_cmn_err(CE_NOTE, mp,
 		  "Disabling barriers, underlying device is readonly");


