From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH] md/raid10: remove unnecessary checks with 'first'
Date: Sat,  1 Apr 2017 11:38:20 +0800
Message-ID: <1491017900-8150-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com
List-Id: linux-raid.ids

Since the value of first is always '1', we can
set min_offset_diff directly.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/raid10.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0f13d57..edaf8f4 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3702,7 +3702,6 @@ static int raid10_run(struct mddev *mddev)
 	struct md_rdev *rdev;
 	sector_t size;
 	sector_t min_offset_diff = 0;
-	int first = 1;
 	bool discard_supported = false;
 
 	if (mddev->private == NULL) {
@@ -3758,8 +3757,7 @@ static int raid10_run(struct mddev *mddev)
 			diff = -diff;
 		if (diff < 0)
 			diff = 0;
-		if (first || diff < min_offset_diff)
-			min_offset_diff = diff;
+		min_offset_diff = diff;
 
 		if (mddev->gendisk)
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
@@ -4140,7 +4138,6 @@ static int raid10_start_reshape(struct mddev *mddev)
 
 	unsigned long before_length, after_length;
 	sector_t min_offset_diff = 0;
-	int first = 1;
 	struct geom new;
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *rdev;
@@ -4169,8 +4166,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 				diff = -diff;
 			if (diff < 0)
 				diff = 0;
-			if (first || diff < min_offset_diff)
-				min_offset_diff = diff;
+			min_offset_diff = diff;
 		}
 	}
 
-- 
2.6.6

