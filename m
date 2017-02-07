From: Shaohua Li <shli@fb.com>
Subject: [PATCH 3/5] md/raid5: change disk limits
Date: Tue, 7 Feb 2017 08:56:00 -0800
Message-ID: <85dbaec7da65adb759784f10f15b54cd0c00f3c1.1486485935.git.shli@fb.com>
References: <cover.1486485935.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1486485935.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: khlebnikov@yandex-team.ru, hch@lst.de, neilb@suse.com
List-Id: linux-raid.ids

Now we are using atomic_t to track stripes for a bio, the original limit
(because of 16-bits data for the tracking) doesn't apply any more.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index fd3e5ce..467ad4f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7255,13 +7255,8 @@ static int raid5_run(struct mddev *mddev)
 		mddev->queue->limits.discard_alignment = stripe;
 		mddev->queue->limits.discard_granularity = stripe;
 
-		/*
-		 * We use 16-bit counter of active stripes in bi_phys_segments
-		 * (minus one for over-loaded initialization)
-		 */
-		blk_queue_max_hw_sectors(mddev->queue, 0xfffe * STRIPE_SECTORS);
-		blk_queue_max_discard_sectors(mddev->queue,
-					      0xfffe * STRIPE_SECTORS);
+		blk_queue_max_hw_sectors(mddev->queue, BLK_DEF_MAX_SECTORS);
+		blk_queue_max_discard_sectors(mddev->queue, UINT_MAX);
 
 		/*
 		 * unaligned part of discard request will be ignored, so can't
-- 
2.9.3

