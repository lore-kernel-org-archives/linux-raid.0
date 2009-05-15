From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 6/6] md: raid0: Fix a memory leak when stopping a raid0 array.
Date: Fri, 15 May 2009 15:18:18 +0200
Message-ID: <1242393498-7528-7-git-send-email-maan@systemlinux.org>
References: <1242393498-7528-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1242393498-7528-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: raziebe@gmail.com, linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

raid0_stop() removes all references to the raid0 configuration but
misses to free the ->devlist buffer.

This patch closes this leak, removes a pointless initialization and
fixes a coding style issue in raid0_stop().

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/raid0.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 74689ad..0305061 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -300,16 +300,15 @@ static int raid0_run(mddev_t *mddev)
 	return 0;
 }
 
-static int raid0_stop (mddev_t *mddev)
+static int raid0_stop(mddev_t *mddev)
 {
 	raid0_conf_t *conf = mddev_to_conf(mddev);
 
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	kfree(conf->strip_zone);
-	conf->strip_zone = NULL;
+	kfree(conf->devlist);
 	kfree(conf);
 	mddev->private = NULL;
-
 	return 0;
 }
 
-- 
1.5.4.3

