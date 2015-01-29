From: Jes.Sorensen@redhat.com
Subject: [PATCH] md: do_release_stripe(): No need to call md_wakeup_thread() twice
Date: Thu, 29 Jan 2015 12:38:29 -0500
Message-ID: <1422553109-29247-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

67f455486d2ea20b2d94d6adf5b9b783d079e321 introduced a call to
md_wakeup_thread() when adding to the delayed_list. However the md
thread is woken up unconditionally just below.

Remove the unnecessary wakeup call.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/md/raid5.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c1b0d52..41494d9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -296,12 +296,9 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 	BUG_ON(atomic_read(&conf->active_stripes)==0);
 	if (test_bit(STRIPE_HANDLE, &sh->state)) {
 		if (test_bit(STRIPE_DELAYED, &sh->state) &&
-		    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
+		    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 			list_add_tail(&sh->lru, &conf->delayed_list);
-			if (atomic_read(&conf->preread_active_stripes)
-			    < IO_THRESHOLD)
-				md_wakeup_thread(conf->mddev->thread);
-		} else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
+		else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
 			   sh->bm_seq - conf->seq_write > 0)
 			list_add_tail(&sh->lru, &conf->bitmap_list);
 		else {
-- 
2.1.0

