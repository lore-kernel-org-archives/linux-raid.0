From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 13/18] md/raid5: add rcu protection to rdev accesses in
 handle_failed_sync.
Date: Thu, 02 Jun 2016 16:19:52 +1000
Message-ID: <20160602061952.2939.26791.stgit@noble>
References: <20160602061319.2939.72280.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160602061319.2939.72280.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The rdev could be freed while handle_failed_sync is running, so
rcu protection is needed.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid5.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8959e6dd31dd..e9ad22d64bd7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3210,15 +3210,16 @@ handle_failed_sync(struct r5conf *conf, struct stripe_head *sh,
 		/* During recovery devices cannot be removed, so
 		 * locking and refcounting of rdevs is not needed
 		 */
+		rcu_read_lock();
 		for (i = 0; i < conf->raid_disks; i++) {
-			struct md_rdev *rdev = conf->disks[i].rdev;
+			struct md_rdev *rdev = rcu_dereference(conf->disks[i].rdev);
 			if (rdev
 			    && !test_bit(Faulty, &rdev->flags)
 			    && !test_bit(In_sync, &rdev->flags)
 			    && !rdev_set_badblocks(rdev, sh->sector,
 						   STRIPE_SECTORS, 0))
 				abort = 1;
-			rdev = conf->disks[i].replacement;
+			rdev = rcu_dereference(conf->disks[i].replacement);
 			if (rdev
 			    && !test_bit(Faulty, &rdev->flags)
 			    && !test_bit(In_sync, &rdev->flags)
@@ -3226,6 +3227,7 @@ handle_failed_sync(struct r5conf *conf, struct stripe_head *sh,
 						   STRIPE_SECTORS, 0))
 				abort = 1;
 		}
+		rcu_read_unlock();
 		if (abort)
 			conf->recovery_disabled =
 				conf->mddev->recovery_disabled;


