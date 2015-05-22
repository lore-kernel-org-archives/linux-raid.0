From: NeilBrown <neilb@suse.de>
Subject: [PATCH 1/8] md/raid5: ensure whole batch is delayed for all
 required bitmap updates.
Date: Fri, 22 May 2015 15:30:58 +1000
Message-ID: <20150522053058.2117.14782.stgit@notabene.brown>
References: <20150522052802.2117.40527.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150522052802.2117.40527.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When we add a stripe to a batch, we need to be sure that
head stripe will wait for the bitmap update required for the new
stripe.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid5.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 987c67298953..c3ccefbd4fe7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -848,6 +848,15 @@ static void stripe_add_to_batch_list(struct r5conf *conf, struct stripe_head *sh
 		    < IO_THRESHOLD)
 			md_wakeup_thread(conf->mddev->thread);
 
+	if (test_and_clear_bit(STRIPE_BIT_DELAY, &sh->state)) {
+		int seq = sh->bm_seq;
+		if (test_bit(STRIPE_BIT_DELAY, &sh->batch_head->state) &&
+		    sh->batch_head->bm_seq > seq)
+			seq = sh->batch_head->bm_seq;
+		set_bit(STRIPE_BIT_DELAY, &sh->batch_head->state);
+		sh->batch_head->bm_seq = seq;
+	}
+
 	atomic_inc(&sh->count);
 unlock_out:
 	unlock_two_stripes(head, sh);


