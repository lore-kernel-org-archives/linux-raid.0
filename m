From: Shaohua Li <shli@fb.com>
Subject: [PATCH 2/4] raid5: grown at least NR_STRIPE_HASH_LOCKS stripes
Date: Thu, 28 May 2015 17:33:46 -0700
Message-ID: <08b93a26b679edad7d3065b6c6d5819d3b1f41b9.1432859513.git.shli@fb.com>
References: <a92a0c36813c740c5de65a95b75ef161c1f2ede1.1432859513.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a92a0c36813c740c5de65a95b75ef161c1f2ede1.1432859513.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

stripes are in hash list. If we are waiting for a free stripe, we must
make sure there is free stripe in corresponding hash list. To do this,
we simpliy allocate at lease NR_STRIPE_HASH_LOCKS stripes at runtime
stripe allocation.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index bfa2042..0cceb71 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5867,7 +5867,9 @@ static void raid5d(struct md_thread *thread)
 
 	spin_unlock_irq(&conf->device_lock);
 	if (test_and_clear_bit(R5_ALLOC_MORE, &conf->cache_state)) {
-		grow_one_stripe(conf, __GFP_NOWARN);
+		int i;
+		for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
+			grow_one_stripe(conf, __GFP_NOWARN);
 		/* Set flag even if allocation failed.  This helps
 		 * slow down allocation requests when mem is short
 		 */
-- 
1.8.1

