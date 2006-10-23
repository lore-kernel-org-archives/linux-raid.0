From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 4] md: Fix up maintenance of ->degraded in multipath.
Date: Mon, 23 Oct 2006 17:08:01 +1000
Message-ID: <1061023070801.29256@suse.de>
References: <20061023170347.29132.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751643AbWJWHIU@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


A recent fix which made sure ->degraded was initialised properly
exposed a second bug - ->degraded wasn't been updated when drives
failed or were hot-added.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/multipath.c |    2 ++
 1 file changed, 2 insertions(+)

diff .prev/drivers/md/multipath.c ./drivers/md/multipath.c
--- .prev/drivers/md/multipath.c	2006-10-23 16:34:54.000000000 +1000
+++ ./drivers/md/multipath.c	2006-10-23 16:35:38.000000000 +1000
@@ -277,6 +277,7 @@ static void multipath_error (mddev_t *md
 			set_bit(Faulty, &rdev->flags);
 			set_bit(MD_CHANGE_DEVS, &mddev->flags);
 			conf->working_disks--;
+			mddev->degraded++;
 			printk(KERN_ALERT "multipath: IO failure on %s,"
 				" disabling IO path. \n	Operation continuing"
 				" on %d IO paths.\n",
@@ -336,6 +337,7 @@ static int multipath_add_disk(mddev_t *m
 				blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
 
 			conf->working_disks++;
+			mddev->degraded--;
 			rdev->raid_disk = path;
 			set_bit(In_sync, &rdev->flags);
 			rcu_assign_pointer(p->rdev, rdev);
