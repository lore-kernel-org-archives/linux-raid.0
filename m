From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 12/14] md: remove CONFIG_MD_RAID_RESHAPE config option.
Date: Tue, 31 Mar 2009 15:54:44 +1100
Message-ID: <20090331045444.2589.86566.stgit@notabene.brown>
References: <20090331044827.2589.95894.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090331044827.2589.95894.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

This was only needed when the code was experimental.  Most of it
is well tested now, so the option is no longer useful.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/Kconfig |   29 -----------------------------
 drivers/md/raid5.c |   10 ----------
 2 files changed, 0 insertions(+), 39 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 449d0b9..36e0675 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -152,35 +152,6 @@ config MD_RAID456
 
 	  If unsure, say Y.
 
-config MD_RAID5_RESHAPE
-	bool "Support adding drives to a raid-5 array"
-	depends on MD_RAID456
-	default y
-	---help---
-	  A RAID-5 set can be expanded by adding extra drives. This
-	  requires "restriping" the array which means (almost) every
-	  block must be written to a different place.
-
-          This option allows such restriping to be done while the array
-	  is online.
-
-	  You will need mdadm version 2.4.1 or later to use this
-	  feature safely.  During the early stage of reshape there is
-	  a critical section where live data is being over-written.  A
-	  crash during this time needs extra care for recovery.  The
-	  newer mdadm takes a copy of the data in the critical section
-	  and will restore it, if necessary, after a crash.
-
-	  The mdadm usage is e.g.
-	       mdadm --grow /dev/md1 --raid-disks=6
-	  to grow '/dev/md1' to having 6 disks.
-
-	  Note: The array can only be expanded, not contracted.
-	  There should be enough spares already present to make the new
-	  array workable.
-
-	  If unsure, say Y.
-
 config MD_RAID6_PQ
 	tristate
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 062df84..fb11c13 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -948,7 +948,6 @@ static int grow_stripes(raid5_conf_t *conf, int num)
 	return 0;
 }
 
-#ifdef CONFIG_MD_RAID5_RESHAPE
 static int resize_stripes(raid5_conf_t *conf, int newsize)
 {
 	/* Make all the stripes able to hold 'newsize' devices.
@@ -1073,7 +1072,6 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 	conf->pool_size = newsize;
 	return err;
 }
-#endif
 
 static int drop_one_stripe(raid5_conf_t *conf)
 {
@@ -4822,7 +4820,6 @@ static int raid5_resize(mddev_t *mddev, sector_t sectors)
 	return 0;
 }
 
-#ifdef CONFIG_MD_RAID5_RESHAPE
 static int raid5_check_reshape(mddev_t *mddev)
 {
 	raid5_conf_t *conf = mddev_to_conf(mddev);
@@ -4967,7 +4964,6 @@ static int raid5_start_reshape(mddev_t *mddev)
 	md_new_event(mddev);
 	return 0;
 }
-#endif
 
 /* This is called from the reshape thread and should make any
  * changes needed in 'conf'
@@ -5289,11 +5285,9 @@ static struct mdk_personality raid6_personality =
 	.sync_request	= sync_request,
 	.resize		= raid5_resize,
 	.size		= raid5_size,
-#ifdef CONFIG_MD_RAID5_RESHAPE
 	.check_reshape	= raid5_check_reshape,
 	.start_reshape  = raid5_start_reshape,
 	.finish_reshape = raid5_finish_reshape,
-#endif
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid6_takeover,
 	.reconfig	= raid6_reconfig,
@@ -5314,11 +5308,9 @@ static struct mdk_personality raid5_personality =
 	.sync_request	= sync_request,
 	.resize		= raid5_resize,
 	.size		= raid5_size,
-#ifdef CONFIG_MD_RAID5_RESHAPE
 	.check_reshape	= raid5_check_reshape,
 	.start_reshape  = raid5_start_reshape,
 	.finish_reshape = raid5_finish_reshape,
-#endif
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid5_takeover,
 	.reconfig	= raid5_reconfig,
@@ -5340,11 +5332,9 @@ static struct mdk_personality raid4_personality =
 	.sync_request	= sync_request,
 	.resize		= raid5_resize,
 	.size		= raid5_size,
-#ifdef CONFIG_MD_RAID5_RESHAPE
 	.check_reshape	= raid5_check_reshape,
 	.start_reshape  = raid5_start_reshape,
 	.finish_reshape = raid5_finish_reshape,
-#endif
 	.quiesce	= raid5_quiesce,
 };
 


