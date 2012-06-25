From: Shaohua Li <shli@kernel.org>
Subject: [patch 02/10 v3] raid5: delayed stripe fix
Date: Mon, 25 Jun 2012 15:24:49 +0800
Message-ID: <20120625072606.544356632@kernel.org>
References: <20120625072447.268095276@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid5-delayed-stripe-fix.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

There isn't locking setting STRIPE_DELAYED and STRIPE_PREREAD_ACTIVE bits, but
the two bits have relationship. A delayed stripe can be moved to hold list only
when preread active stripe count is below IO_THRESHOLD. If a stripe has both
the bits set, such stripe will be in delayed list and preread count not 0,
which will make such stripe never leave delayed list.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-06-25 14:36:15.964613183 +0800
+++ linux/drivers/md/raid5.c	2012-06-25 14:36:57.280096788 +0800
@@ -196,12 +196,14 @@ static void __release_stripe(struct r5co
 		BUG_ON(!list_empty(&sh->lru));
 		BUG_ON(atomic_read(&conf->active_stripes)==0);
 		if (test_bit(STRIPE_HANDLE, &sh->state)) {
-			if (test_bit(STRIPE_DELAYED, &sh->state))
+			if (test_bit(STRIPE_DELAYED, &sh->state) &&
+			    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 				list_add_tail(&sh->lru, &conf->delayed_list);
 			else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
 				   sh->bm_seq - conf->seq_write > 0)
 				list_add_tail(&sh->lru, &conf->bitmap_list);
 			else {
+				clear_bit(STRIPE_DELAYED, &sh->state);
 				clear_bit(STRIPE_BIT_DELAY, &sh->state);
 				list_add_tail(&sh->lru, &conf->handle_list);
 			}

