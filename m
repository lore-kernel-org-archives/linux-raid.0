From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md ] md: allow degraded raid1 array to resync after an unclean shutdown.
Date: Wed, 23 Mar 2005 14:31:20 +1100
Message-ID: <E1DDwaW-0003NC-5X@notabene.cse.unsw.edu.au>
References: <20050323142016.12770.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The following is (I think) appropriate for 2.4.30.  The bug it fixes
can result in data corruption in a fairly unusual circumstance (having
a 3 drive raid1 array running in degraded mode, and suffering a system
crash). 

### Comments for Changeset

If a raid1 array has more than two devices, and not all are working,
then it will not resync after an unclean shutdown (as it will think
that it should reconstruct a failed drive, and will find there aren't
any spares...)

This patch fixes the problem.

Problem found by Mario Holbe <Mario.Holbe@TU-Ilmenau.DE> (thanks!)

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid1.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-03-23 11:28:56.000000000 +1100
+++ ./drivers/md/raid1.c	2005-03-23 11:38:41.000000000 +1100
@@ -891,6 +891,8 @@ static int raid1_diskop(mddev_t *mddev, 
 	mdp_disk_t *failed_desc, *spare_desc, *added_desc;
 	mdk_rdev_t *spare_rdev, *failed_rdev;
 
+	if (conf->resync_mirrors)
+		return 1; /* Cannot do any diskops during a resync */
 
 	switch (state) {
 	case DISKOP_SPARE_ACTIVE:
@@ -1333,6 +1335,8 @@ static void raid1syncd (void *data)
 
 	up(&mddev->recovery_sem);
 	raid1_shrink_buffers(conf);
+
+	md_recover_arrays(); /* incase we are degraded and a spare is available */
 }
 
 /*
@@ -1741,10 +1745,6 @@ static int raid1_run (mddev_t *mddev)
 	conf->last_used = j;
 
 
-	if (conf->working_disks != sb->raid_disks) {
-		printk(KERN_ALERT "raid1: md%d, not all disks are operational -- trying to recover array\n", mdidx(mddev));
-		start_recovery = 1;
-	}
 
 	{
 		const char * name = "raid1d";
@@ -1756,7 +1756,7 @@ static int raid1_run (mddev_t *mddev)
 		}
 	}
 
-	if (!start_recovery && !(sb->state & (1 << MD_SB_CLEAN)) &&
+	if (!(sb->state & (1 << MD_SB_CLEAN)) &&
 	    (conf->working_disks > 1)) {
 		const char * name = "raid1syncd";
 
@@ -1769,6 +1769,9 @@ static int raid1_run (mddev_t *mddev)
 		printk(START_RESYNC, mdidx(mddev));
 		conf->resync_mirrors = 1;
 		md_wakeup_thread(conf->resync_thread);
+	} else if (conf->working_disks != sb->raid_disks) {
+		printk(KERN_ALERT "raid1: md%d, not all disks are operational -- trying to recover array\n", mdidx(mddev));
+		start_recovery = 1;
 	}
 
 	/*
