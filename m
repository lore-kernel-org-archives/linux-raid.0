From: Shaohua Li <shli@fb.com>
Subject: [PATCH 2/2] raid5-cache: fix lockdep warning
Date: Wed, 16 Nov 2016 17:20:19 -0800
Message-ID: <29709f0fbd66cef1d743a78be112305976eb4880.1479345454.git.shli@fb.com>
References: <5d6f023fb1d1398317d07f02634f90b055e26f4b.1479345454.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d6f023fb1d1398317d07f02634f90b055e26f4b.1479345454.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: songliubraving@fb.com, neilb@suse.com
List-Id: linux-raid.ids

lockdep reports warning of the rcu_dereference usage. Using normal rdev
access pattern to avoid the warning.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 641dec8..fe62578 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -987,16 +987,28 @@ static int r5l_recovery_flush_one_stripe(struct r5l_log *log,
 			continue;
 
 		/* in case device is broken */
+		rcu_read_lock();
 		rdev = rcu_dereference(conf->disks[disk_index].rdev);
-		if (rdev)
+		if (rdev) {
+			atomic_inc(&rdev->nr_pending);
+			rcu_read_unlock();
 			sync_page_io(rdev, stripe_sect, PAGE_SIZE,
 				     sh->dev[disk_index].page, REQ_OP_WRITE, 0,
 				     false);
+			rdev_dec_pending(rdev, rdev->mddev);
+			rcu_read_lock();
+		}
 		rrdev = rcu_dereference(conf->disks[disk_index].replacement);
-		if (rrdev)
+		if (rrdev) {
+			atomic_inc(&rrdev->nr_pending);
+			rcu_read_unlock();
 			sync_page_io(rrdev, stripe_sect, PAGE_SIZE,
 				     sh->dev[disk_index].page, REQ_OP_WRITE, 0,
 				     false);
+			rdev_dec_pending(rrdev, rrdev->mddev);
+			rcu_read_lock();
+		}
+		rcu_read_unlock();
 	}
 	raid5_release_stripe(sh);
 	return 0;
-- 
2.9.3

