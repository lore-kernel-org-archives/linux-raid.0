From: Shaohua Li <shli@kernel.org>
Subject: [patch 2/2]raid5: avoid find discard stripe
Date: Sat, 19 Oct 2013 14:51:42 +0800
Message-ID: <20131019065141.GB10670@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com
List-Id: linux-raid.ids


SCSI discard will damage discard stripe bio setting, eg, some fields are
changed. If the stripe is reused very soon, we have wrong bios setting. We
remove discard stripe from hash list, so next time the strip will be fully
initialized.

Suite for backport to 3.7+. Of course, the 'conf->hash_locks +
sh->hash_lock_index' should be replaced to '&conf->device_lock' for old kernel.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2013-10-19 14:10:30.839946446 +0800
+++ linux/drivers/md/raid5.c	2013-10-19 14:24:59.977011959 +0800
@@ -3035,6 +3035,7 @@ static void handle_stripe_clean_event(st
 		}
 	if (!discard_pending &&
 	    test_bit(R5_Discard, &sh->dev[sh->pd_idx].flags)) {
+		unsigned long flags;
 		clear_bit(R5_Discard, &sh->dev[sh->pd_idx].flags);
 		clear_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags);
 		if (sh->qd_idx >= 0) {
@@ -3043,6 +3044,14 @@ static void handle_stripe_clean_event(st
 		}
 		/* now that discard is done we can proceed with any sync */
 		clear_bit(STRIPE_DISCARD, &sh->state);
+		/*
+		 * SCSI discard will change some bio fields and the stripe has
+		 * no updated data, so remove it from hash list and the stripe
+		 * will be reinitialized
+		 */
+		spin_lock_irqsave(conf->hash_locks + sh->hash_lock_index, flags);
+		remove_hash(sh);
+		spin_unlock_irqrestore(conf->hash_locks + sh->hash_lock_index, flags);
 		if (test_bit(STRIPE_SYNC_REQUESTED, &sh->state))
 			set_bit(STRIPE_HANDLE, &sh->state);
 
