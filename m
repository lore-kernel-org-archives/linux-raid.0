From: NeilBrown <neilb@suse.de>
Subject: [PATCH 021 of 29] md: md: use stripe_head_state in ops_run_io()
Date: Fri, 27 Jun 2008 16:51:37 +1000
Message-ID: <1080627065137.10652@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids


From: Dan Williams <dan.j.williams@intel.com>

In handle_stripe after taking sh->lock we sample some bits into 's' (struct
stripe_head_state):

	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);

Use these values from 's' in ops_run_io() rather than re-sampling the bits.
This ensures a consistent snapshot (as seen under sh->lock) is used.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-06-27 16:22:04.000000000 +1000
+++ ./drivers/md/raid5.c	2008-06-27 16:22:04.000000000 +1000
@@ -390,7 +390,7 @@ raid5_end_read_request(struct bio *bi, i
 static void
 raid5_end_write_request(struct bio *bi, int error);
 
-static void ops_run_io(struct stripe_head *sh)
+static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 {
 	raid5_conf_t *conf = sh->raid_conf;
 	int i, disks = sh->disks;
@@ -425,9 +425,7 @@ static void ops_run_io(struct stripe_hea
 		rcu_read_unlock();
 
 		if (rdev) {
-			if (test_bit(STRIPE_SYNCING, &sh->state) ||
-				test_bit(STRIPE_EXPAND_SOURCE, &sh->state) ||
-				test_bit(STRIPE_EXPAND_READY, &sh->state))
+			if (s->syncing || s->expanding || s->expanded)
 				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
 
 			set_bit(STRIPE_IO_STARTED, &sh->state);
@@ -2902,10 +2900,9 @@ static void handle_stripe5(struct stripe
 	if (pending)
 		raid5_run_ops(sh, pending);
 
-	ops_run_io(sh);
+	ops_run_io(sh, &s);
 
 	return_io(return_bi);
-
 }
 
 static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
