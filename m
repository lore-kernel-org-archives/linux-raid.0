From: Sage Weil <sage@newdream.net>
Subject: [PATCH] md: avoid use of broken kzalloc mempool
Date: Mon,  3 Aug 2009 13:54:46 -0700
Message-ID: <1249332888-13440-1-git-send-email-sage@newdream.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>, linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>, stable@kernel.org
List-Id: linux-raid.ids

The kzalloc mempool does not re-zero items that have been used and then
returned to the pool.  Manually zero the allocated multipath_bh instead.

CC: linux-raid@vger.kernel.org
CC: Neil Brown <neilb@suse.de>
CC: <stable@kernel.org>
Signed-off-by: Sage Weil <sage@newdream.net>
---
 drivers/md/multipath.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 237fe3f..151ce69 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -150,6 +150,7 @@ static int multipath_make_request (struct request_queue *q, struct bio * bio)
 	}
 
 	mp_bh = mempool_alloc(conf->pool, GFP_NOIO);
+	memset(mp_bh, 0, sizeof(*mp_bh));
 
 	mp_bh->master_bio = bio;
 	mp_bh->mddev = mddev;
@@ -490,7 +491,7 @@ static int multipath_run (mddev_t *mddev)
 	}
 	mddev->degraded = conf->raid_disks - conf->working_disks;
 
-	conf->pool = mempool_create_kzalloc_pool(NR_RESERVED_BUFS,
+	conf->pool = mempool_create_kmalloc_pool(NR_RESERVED_BUFS,
 						 sizeof(struct multipath_bh));
 	if (conf->pool == NULL) {
 		printk(KERN_ERR 
-- 
1.5.6.5

