From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 4 of 6] Fix endless loop when syncing an array that doesn't need any resync.
Date: Mon, 07 Feb 2005 13:44:19 +1100
Message-ID: <E1Cxyst-0004fm-LC@notabene.cse.unsw.edu.au>
References: <20050207133555.17870.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


If the resync checkpoint for an array is at the end of the array,
It doesn't get set to MAX_SECTOR, so resyncing will be retried.
By updating curr_resync early, this problem is fixed.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-02-07 13:32:22.000000000 +1100
+++ ./drivers/md/md.c	2005-02-07 13:33:59.000000000 +1100
@@ -3475,10 +3475,12 @@ static void md_do_sync(mddev_t *mddev)
 	init_waitqueue_head(&mddev->recovery_wait);
 	last_check = 0;
 
-	if (j)
+	if (j>2) {
 		printk(KERN_INFO 
 			"md: resuming recovery of %s from checkpoint.\n",
 			mdname(mddev));
+		mddev->curr_resync = j;
+	}
 
 	while (j < max_sectors) {
 		int sectors;
@@ -3565,7 +3567,7 @@ static void md_do_sync(mddev_t *mddev)
 
 	if (!test_bit(MD_RECOVERY_ERR, &mddev->recovery) &&
 	    mddev->curr_resync > 2 &&
-	    mddev->curr_resync > mddev->recovery_cp) {
+	    mddev->curr_resync >= mddev->recovery_cp) {
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
 			printk(KERN_INFO 
 				"md: checkpointing recovery of %s.\n",
