From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH] md/raid5: limit request size according to implementation
 limits
Date: Sun, 27 Nov 2016 19:32:32 +0300
Message-ID: <148026435214.19980.7956943898609877817.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Neil Brown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-raid.ids

Current implementation employ 16bit counter of active stripes in lower
bits of bio->bi_phys_segments. If request is big enough to overflow
this counter bio will be completed and freed too early.

Fortunately this not happens in default configuration because several
other limits prevent that: stripe_cache_size * nr_disks effectively
limits count of active stripes. And small max_sectors_kb at lower
disks prevent that during normal read/write operations.

Overflow easily happens in discard if it's enabled by module parameter
"devices_handle_discard_safely" and stripe_cache_size is set big enough.

This patch limits requests size with 256Mb - 8Kb to prevent overflows.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Shaohua Li <shli@kernel.org>
Cc: Neil Brown <neilb@suse.com>
Cc: stable@vger.kernel.org
---
 drivers/md/raid5.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 92ac251e91e6..cce6057b9aca 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6984,6 +6984,15 @@ static int raid5_run(struct mddev *mddev)
 			stripe = (stripe | (stripe-1)) + 1;
 		mddev->queue->limits.discard_alignment = stripe;
 		mddev->queue->limits.discard_granularity = stripe;
+
+		/*
+		 * We use 16-bit counter of active stripes in bi_phys_segments
+		 * (minus one for over-loaded initialization)
+		 */
+		blk_queue_max_hw_sectors(mddev->queue, 0xfffe * STRIPE_SECTORS);
+		blk_queue_max_discard_sectors(mddev->queue,
+					      0xfffe * STRIPE_SECTORS);
+
 		/*
 		 * unaligned part of discard request will be ignored, so can't
 		 * guarantee discard_zeroes_data

