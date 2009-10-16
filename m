From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 01/11] Revert "md: do not progress the resync process if
	the stripe was blocked"
Date: Fri, 16 Oct 2009 16:49:17 +1100
Message-ID: <20091016054917.24208.31173.stgit@notabene.brown>
References: <20091016054316.24208.33818.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091016054316.24208.33818.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

This reverts commit df10cfbc4d7ab93260d997df754219d390d62a9d.

This patch was based on a misunderstanding and risks introducing a busy-wait loop.
So revert it.

Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   19 ++++++-------------
 1 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9482980..ec14ff5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2896,7 +2896,7 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
  *
  */
 
-static bool handle_stripe5(struct stripe_head *sh)
+static void handle_stripe5(struct stripe_head *sh)
 {
 	raid5_conf_t *conf = sh->raid_conf;
 	int disks = sh->disks, i;
@@ -3167,11 +3167,9 @@ static bool handle_stripe5(struct stripe_head *sh)
 	ops_run_io(sh, &s);
 
 	return_io(return_bi);
-
-	return blocked_rdev == NULL;
 }
 
-static bool handle_stripe6(struct stripe_head *sh)
+static void handle_stripe6(struct stripe_head *sh)
 {
 	raid5_conf_t *conf = sh->raid_conf;
 	int disks = sh->disks;
@@ -3455,17 +3453,14 @@ static bool handle_stripe6(struct stripe_head *sh)
 	ops_run_io(sh, &s);
 
 	return_io(return_bi);
-
-	return blocked_rdev == NULL;
 }
 
-/* returns true if the stripe was handled */
-static bool handle_stripe(struct stripe_head *sh)
+static void handle_stripe(struct stripe_head *sh)
 {
 	if (sh->raid_conf->level == 6)
-		return handle_stripe6(sh);
+		handle_stripe6(sh);
 	else
-		return handle_stripe5(sh);
+		handle_stripe5(sh);
 }
 
 static void raid5_activate_delayed(raid5_conf_t *conf)
@@ -4277,9 +4272,7 @@ static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *ski
 	clear_bit(STRIPE_INSYNC, &sh->state);
 	spin_unlock(&sh->lock);
 
-	/* wait for any blocked device to be handled */
-	while (unlikely(!handle_stripe(sh)))
-		;
+	handle_stripe(sh);
 	release_stripe(sh);
 
 	return STRIPE_SECTORS;


