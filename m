From: NeilBrown <neilb@suse.de>
Subject: [PATCH 8/8] md/raid5: break stripe-batches when the array has
 failed.
Date: Fri, 22 May 2015 15:30:58 +1000
Message-ID: <20150522053058.2117.38642.stgit@notabene.brown>
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

Once the array has too much failure, we need to break
stripe-batches up so they can all be dealt with.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid5.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 90da2376e0bb..041341c66ae5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4330,6 +4330,7 @@ static void handle_stripe(struct stripe_head *sh)
 	if (s.failed > conf->max_degraded) {
 		sh->check_state = 0;
 		sh->reconstruct_state = 0;
+		break_stripe_batch_list(sh, 0);
 		if (s.to_read+s.to_write+s.written)
 			handle_failed_stripe(conf, sh, &s, disks, &s.return_bi);
 		if (s.syncing + s.replacing)


