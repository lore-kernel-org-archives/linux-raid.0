From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 07/15] Revert "md/raid5: limit request size according to
 implementation limits"
Date: Wed, 15 Mar 2017 14:05:13 +1100
Message-ID: <148954711328.18641.11888859968110396364.stgit@noble>
References: <148954692173.18641.1294690639716682540.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <148954692173.18641.1294690639716682540.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

This reverts commit e8d7c33232e5fdfa761c3416539bc5b4acd12db5.

Now that raid5 doesn't abuse bi_phys_segments any more, we no longer
need to impose these limits.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid5.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c3a8838e4b17..4e906e5903e8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7357,15 +7357,6 @@ static int raid5_run(struct mddev *mddev)
 			stripe = (stripe | (stripe-1)) + 1;
 		mddev->queue->limits.discard_alignment = stripe;
 		mddev->queue->limits.discard_granularity = stripe;
-
-		/*
-		 * We use 16-bit counter of active stripes in bi_phys_segments
-		 * (minus one for over-loaded initialization)
-		 */
-		blk_queue_max_hw_sectors(mddev->queue, 0xfffe * STRIPE_SECTORS);
-		blk_queue_max_discard_sectors(mddev->queue,
-					      0xfffe * STRIPE_SECTORS);
-
 		/*
 		 * unaligned part of discard request will be ignored, so can't
 		 * guarantee discard_zeroes_data


