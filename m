From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 3/3] md/raid10: move rdev->corrected_errors counting
Date: Wed, 29 Jun 2011 01:47:26 +0900
Message-ID: <1309279646-4950-4-git-send-email-namhyung@gmail.com>
References: <1309279646-4950-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1309279646-4950-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Read errors are considered to corrected if write-back and re-read
cycle is finished without further problems. Thus moving the rdev->
corrected_errors counting after the re-reading looks more reasonable
IMHO.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
For end_sync_read(), I'm not sure what should I do. But I think, at
least, the counting should be moved to end_sync_write() and that
might require additional field(s) in r10_bio. So I leave it as is
for simplicity now. How do you think?

 drivers/md/raid10.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 8628a62a02f0..0660bc9597d8 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1524,7 +1524,6 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 			    test_bit(In_sync, &rdev->flags)) {
 				atomic_inc(&rdev->nr_pending);
 				rcu_read_unlock();
-				atomic_add(s, &rdev->corrected_errors);
 				if (sync_page_io(rdev,
 						 r10_bio->devs[sl].addr +
 						 sect,
@@ -1589,6 +1588,7 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 					       (unsigned long long)(
 						       sect + rdev->data_offset),
 					       bdevname(rdev->bdev, b));
+					atomic_add(s, &rdev->corrected_errors);
 				}
 
 				rdev_dec_pending(rdev, mddev);
-- 
1.7.6

