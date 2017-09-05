From: Shaohua Li <shli@kernel.org>
Subject: [PATCH] md/raid5: fix a race condition in stripe batch
Date: Tue,  5 Sep 2017 11:01:24 -0700
Message-ID: <3664847d95e60a9a943858b7800f8484669740fc.1504634287.git.shli@fb.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: sthiell@stanford.edu, gqjiang@suse.com, Shaohua Li <shli@fb.com>, "v4.1+" <stable@vger.kernel.org>
List-Id: linux-raid.ids

From: Shaohua Li <shli@fb.com>

We have a race condition in below scenario, say have 3 continuous stripes, sh1,
sh2 and sh3, sh1 is the stripe_head of sh2 and sh3:

CPU1				CPU2				CPU3
handle_stripe(sh3)
				stripe_add_to_batch_list(sh3)
				-> lock(sh2, sh3)
				-> lock batch_lock(sh1)
				-> add sh3 to batch_list of sh1
				-> unlock batch_lock(sh1)
								clear_batch_ready(sh1)
								-> lock(sh1) and batch_lock(sh1)
								-> clear STRIPE_BATCH_READY for all stripes in batch_list
								-> unlock(sh1) and batch_lock(sh1)
->clear_batch_ready(sh3)
-->test_and_clear_bit(STRIPE_BATCH_READY, sh3)
--->return 0 as sh->batch == NULL
				-> sh3->batch_head = sh1
				-> unlock (sh2, sh3)

In CPU1, handle_stripe will continue handle sh3 even it's in batch stripe list
of sh1. By moving sh3->batch_head assignment in to batch_lock, we make it
impossible to clear STRIPE_BATCH_READY before batch_head is set.

Thanks Stephane for helping debug this tricky issue.

Reported-and-tested-by: Stephane Thiell <sthiell@stanford.edu>
Cc: stable@vger.kernel.org (v4.1+)
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 049a958d3c1e..90414a4e0d49 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -811,6 +811,14 @@ static void stripe_add_to_batch_list(struct r5conf *conf, struct stripe_head *sh
 			spin_unlock(&head->batch_head->batch_lock);
 			goto unlock_out;
 		}
+		/*
+		 * We must assign batch_head of this stripe within the
+		 * batch_lock, otherwise clear_batch_ready of batch head
+		 * stripe could clear BATCH_READY bit of this stripe and
+		 * this stripe->batch_head doesn't get assigned, which
+		 * could confuse clear_batch_ready for this stripe
+		 */
+		sh->batch_head = head->batch_head;
 
 		/*
 		 * at this point, head's BATCH_READY could be cleared, but we
@@ -818,8 +826,6 @@ static void stripe_add_to_batch_list(struct r5conf *conf, struct stripe_head *sh
 		 */
 		list_add(&sh->batch_list, &head->batch_list);
 		spin_unlock(&head->batch_head->batch_lock);
-
-		sh->batch_head = head->batch_head;
 	} else {
 		head->batch_head = head;
 		sh->batch_head = head->batch_head;
-- 
2.11.0
