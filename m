From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH] md/raid10: introduce handle_badblocks
Date: Thu, 13 Apr 2017 17:28:28 +0800
Message-ID: <1492075708-4412-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, neilb@suse.com, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

If the state of r10bio is either R10BIO_IsSync or
R10BIO_IsRecover, then handle_write_completed calls
the same logic to clear or set badblock for bio and
repl_bio, so refactor these codes to a new function
named handle_badblocks.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/raid10.c | 42 +++++++++++++++++-------------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 4167091..a707772 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2620,6 +2620,20 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 	raid10_read_request(mddev, r10_bio->master_bio, r10_bio);
 }
 
+static void handle_badblocks(struct r10bio *r10_bio, struct md_rdev *rdev,
+			     struct r10conf *conf, int slot, bool repl)
+{
+	struct bio *bio = repl ? r10_bio->devs[slot].repl_bio :
+				 r10_bio->devs[slot].bio;
+	sector_t addr = r10_bio->devs[slot].addr;
+
+	if (!bio->bi_error)
+		rdev_clear_badblocks(rdev, addr, r10_bio->sectors, 0);
+	else
+		if (!rdev_set_badblocks(rdev, addr, r10_bio->sectors, 0))
+			md_error(conf->mddev, rdev);
+}
+
 static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 {
 	/* Some sort of write request has finished and it
@@ -2638,34 +2652,12 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 			rdev = conf->mirrors[dev].rdev;
 			if (r10_bio->devs[m].bio == NULL)
 				continue;
-			if (!r10_bio->devs[m].bio->bi_error) {
-				rdev_clear_badblocks(
-					rdev,
-					r10_bio->devs[m].addr,
-					r10_bio->sectors, 0);
-			} else {
-				if (!rdev_set_badblocks(
-					    rdev,
-					    r10_bio->devs[m].addr,
-					    r10_bio->sectors, 0))
-					md_error(conf->mddev, rdev);
-			}
+			handle_badblocks(r10_bio, rdev, conf, m, false);
+
 			rdev = conf->mirrors[dev].replacement;
 			if (r10_bio->devs[m].repl_bio == NULL)
 				continue;
-
-			if (!r10_bio->devs[m].repl_bio->bi_error) {
-				rdev_clear_badblocks(
-					rdev,
-					r10_bio->devs[m].addr,
-					r10_bio->sectors, 0);
-			} else {
-				if (!rdev_set_badblocks(
-					    rdev,
-					    r10_bio->devs[m].addr,
-					    r10_bio->sectors, 0))
-					md_error(conf->mddev, rdev);
-			}
+			handle_badblocks(r10_bio, rdev, conf, m, true);
 		}
 		put_buf(r10_bio);
 	} else {
-- 
2.6.6

