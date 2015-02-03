From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 01/26] md: do_release_stripe(): No need to call
 md_wakeup_thread() twice
Date: Wed, 04 Feb 2015 08:42:28 +1100
Message-ID: <20150203214228.3448.90778.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

67f455486d2ea20b2d94d6adf5b9b783d079e321 introduced a call to
md_wakeup_thread() when adding to the delayed_list. However the md
thread is woken up unconditionally just below.

Remove the unnecessary wakeup call.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid5.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b98765f6f77f..274db1834d43 100644
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


