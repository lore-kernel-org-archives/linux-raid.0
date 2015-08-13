From: Shaohua Li <shli@fb.com>
Subject: [patch v2 09/11] raid5: disable batch with log enabled
Date: Thu, 13 Aug 2015 14:32:02 -0700
Message-ID: <2a5ccd162046ab106fe6b0f5dc5272bf4ef6afd9.1439500639.git.shli@fb.com>
References: <cover.1439500639.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1439500639.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

With log enabled, r5l_write_stripe will add the stripe to log. With
batch, several stripes are linked together. The stripes must be in the
same state. While with log, the log/reclaim unit is stripe, we can't
guarantee the several stripes are in the same state. Disabling batch for
log now.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 40799ed..80a9a78 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -759,6 +759,9 @@ static void unlock_two_stripes(struct stripe_head *sh1, struct stripe_head *sh2)
 /* Only freshly new full stripe normal write stripe can be added to a batch list */
 static bool stripe_can_batch(struct stripe_head *sh)
 {
+	struct r5conf *conf = sh->raid_conf;
+	if (conf->log)
+		return false;
 	return test_bit(STRIPE_BATCH_READY, &sh->state) &&
 		!test_bit(STRIPE_BITMAP_PENDING, &sh->state) &&
 		is_full_stripe_write(sh);
-- 
1.8.1

