From: Shaohua Li <shli@kernel.org>
Subject: [PATCH] md: make suspend range wait timed out
Date: Fri,  9 Jun 2017 12:41:10 -0700
Message-ID: <d95473d287e196a86a83390cb9c136913643bd61.1497037210.git.shli@fb.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: linux-raid.ids

From: Shaohua Li <shli@fb.com>

suspend range is controlled by userspace. If userspace doesn't clear suspend
range, it's possible a thread will wait for the range forever, we can't even
kill it. This is bad behavior. Add a timeout in the wait. If timeout happens,
we return IO error. The app controlling suspend range looks like part of disk
firmware, if disk isn't responded for a long time, timed out IO error is
returned.

A simple search in SCSI code shows maximum IO timeout is 120s, so I use this
value here too.

Cc: NeilBrown <neilb@suse.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.h    |  1 +
 drivers/md/raid1.c | 12 +++++++++++-
 drivers/md/raid5.c | 10 +++++++++-
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 63d342d560b8..11a0ec33e79b 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -29,6 +29,7 @@
 
 #define MaxSector (~(sector_t)0)
 
+#define MD_SUSPEND_TIMEOUT (120 * HZ)
 /*
  * These flags should really be called "NO_RETRY" rather than
  * "FAILFAST" because they don't make any promise about time lapse,
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d9e5373444d2..bc6dee0259df 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1326,6 +1326,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	    (mddev_is_clustered(mddev) &&
 	     md_cluster_ops->area_resyncing(mddev, WRITE,
 		     bio->bi_iter.bi_sector, bio_end_sector(bio)))) {
+		long remaining = -1;
 
 		/*
 		 * As the suspend_* range is controlled by userspace, we want
@@ -1345,10 +1346,19 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 				break;
 			sigfillset(&full);
 			sigprocmask(SIG_BLOCK, &full, &old);
-			schedule();
+			remaining = schedule_timeout(MD_SUSPEND_TIMEOUT);
 			sigprocmask(SIG_SETMASK, &old, NULL);
+			if (remaining == 0)
+				break;
 		}
 		finish_wait(&conf->wait_barrier, &w);
+		if (remaining == 0) {
+			pr_err("md/raid1:%s: suspend range is locked\n",
+				mdname(mddev));
+			bio->bi_error = -ETIMEDOUT;
+			bio_endio(bio);
+			return;
+		}
 	}
 	wait_barrier(conf, bio->bi_iter.bi_sector);
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index cf1ac2e0f4c8..24297f1530d1 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5685,6 +5685,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 			if (rw == WRITE &&
 			    logical_sector >= mddev->suspend_lo &&
 			    logical_sector < mddev->suspend_hi) {
+				long remaining = -1;
 				raid5_release_stripe(sh);
 				/* As the suspend_* range is controlled by
 				 * userspace, we want an interruptible
@@ -5697,10 +5698,17 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 					sigset_t full, old;
 					sigfillset(&full);
 					sigprocmask(SIG_BLOCK, &full, &old);
-					schedule();
+					remaining = schedule_timeout(
+							MD_SUSPEND_TIMEOUT);
 					sigprocmask(SIG_SETMASK, &old, NULL);
 					do_prepare = true;
 				}
+				if (remaining == 0) {
+					pr_err("md/raid5:%s: suspend range is locked\n",
+						mdname(mddev));
+					bi->bi_error = -ETIMEDOUT;
+					break;
+				}
 				goto retry;
 			}
 
-- 
2.11.0

