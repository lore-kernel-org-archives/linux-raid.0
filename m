From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] md: use seconds granularity for error logging
Date: Fri, 17 Jun 2016 17:33:10 +0200
Message-ID: <20160617153347.380722-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>, NeilBrown <neilb@suse.com>, Guoqing Jiang <gqjiang@suse.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

The md code stores the exact time of the last error in the
last_read_error variable using a timespec structure. It only
ever uses the seconds portion of that though, so we can
use a scalar for it.

There won't be an overflow in 2038 here, because it already
used monotonic time and 32-bit is enough for that, but I've
decided to use time64_t for consistency in the conversion.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/md/md.c     |  3 +--
 drivers/md/md.h     |  2 +-
 drivers/md/raid10.c | 11 +++++------
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3745b9a7a2d7..ad512ad4610f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3179,8 +3179,7 @@ int md_rdev_init(struct md_rdev *rdev)
 	rdev->data_offset = 0;
 	rdev->new_data_offset = 0;
 	rdev->sb_events = 0;
-	rdev->last_read_error.tv_sec  = 0;
-	rdev->last_read_error.tv_nsec = 0;
+	rdev->last_read_error = 0;
 	rdev->sb_loaded = 0;
 	rdev->bb_page = NULL;
 	atomic_set(&rdev->nr_pending, 0);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 3c3412d85e42..20c667579ede 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -99,7 +99,7 @@ struct md_rdev {
 	atomic_t	read_errors;	/* number of consecutive read errors that
 					 * we have tried to ignore.
 					 */
-	struct timespec last_read_error;	/* monotonic time since our
+	time64_t	last_read_error;	/* monotonic time since our
 						 * last read error
 						 */
 	atomic_t	corrected_errors; /* number of corrected read errors,
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 41191e04d565..f8cdd08d0a40 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2170,21 +2170,20 @@ static void recovery_request_write(struct mddev *mddev, struct r10bio *r10_bio)
  */
 static void check_decay_read_errors(struct mddev *mddev, struct md_rdev *rdev)
 {
-	struct timespec cur_time_mon;
+	long cur_time_mon;
 	unsigned long hours_since_last;
 	unsigned int read_errors = atomic_read(&rdev->read_errors);
 
-	ktime_get_ts(&cur_time_mon);
+	cur_time_mon = ktime_get_seconds();
 
-	if (rdev->last_read_error.tv_sec == 0 &&
-	    rdev->last_read_error.tv_nsec == 0) {
+	if (rdev->last_read_error == 0) {
 		/* first time we've seen a read error */
 		rdev->last_read_error = cur_time_mon;
 		return;
 	}
 
-	hours_since_last = (cur_time_mon.tv_sec -
-			    rdev->last_read_error.tv_sec) / 3600;
+	hours_since_last = (long)(cur_time_mon -
+			    rdev->last_read_error) / 3600;
 
 	rdev->last_read_error = cur_time_mon;
 
-- 
2.9.0
