From: NeilBrown <neilb@suse.de>
Subject: [PATCH 004 of 6] md: Clean out unplug and other queue function on md shutdown
Date: Tue, 20 Feb 2007 17:35:05 +1100
Message-ID: <1070220063505.16178@suse.de>
References: <20070220172544.15678.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932801AbXBTGgG@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


The mddev and queue might be used for another array which does not
set these, so they need to be cleared.

Signed-off-by: NeilBrown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    3 +++
 1 file changed, 3 insertions(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-02-20 17:13:54.000000000 +1100
+++ ./drivers/md/md.c	2007-02-20 17:13:08.000000000 +1100
@@ -3322,6 +3322,9 @@ static int do_md_stop(mddev_t * mddev, i
 				set_disk_ro(disk, 0);
 			blk_queue_make_request(mddev->queue, md_fail_request);
 			mddev->pers->stop(mddev);
+			mddev->queue->merge_bvec_fn = NULL;
+			mddev->queue->unplug_fn = NULL;
+			mddev->queue->issue_flush_fn = NULL;
 			if (mddev->pers->sync_request)
 				sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
 
