From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V2] md/raid10: reset the 'first' at the end of loop
Date: Thu,  6 Apr 2017 09:12:18 +0800
Message-ID: <1491441138-16155-1-git-send-email-gqjiang@suse.com>
References: <1491017900-8150-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1491017900-8150-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com
List-Id: linux-raid.ids

We need to set "first = 0' at the end of rdev_for_each
loop, so we can get the array's min_offset_diff correctly
otherwise min_offset_diff just means the last rdev's
offset diff.

Suggested-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/raid10.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0f13d57..e055ec9 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3769,6 +3769,7 @@ static int raid10_run(struct mddev *mddev)
 
 		if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
 			discard_supported = true;
+		first = 0;
 	}
 
 	if (mddev->queue) {
@@ -4172,6 +4173,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 			if (first || diff < min_offset_diff)
 				min_offset_diff = diff;
 		}
+		first = 0;
 	}
 
 	if (max(before_length, after_length) > min_offset_diff)
-- 
2.6.6

