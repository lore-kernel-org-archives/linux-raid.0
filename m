From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md ] Fix raid1 read_balancing code.
Date: Tue, 15 Jun 2004 09:50:05 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1Ba1DJ-0002Bi-4v@notabene.cse.unsw.edu.au>
References: <20040615094915.8393.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The meaning of mddev->in_sync changed subtly a while ago, and raid1
wasn't changed to match.  This results in raid1 read_balancing
not working properly.
This patch corrects the relevant test.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid1.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-06-15 09:49:00.000000000 +1000
+++ ./drivers/md/raid1.c	2004-06-15 09:49:08.000000000 +1000
@@ -376,7 +376,8 @@ static int read_balance(conf_t *conf, st
 	 * device if no resync is going on, or below the resync window.
 	 * We take the first readable disk when above the resync window.
 	 */
-	if (!conf->mddev->in_sync && (this_sector + sectors >= conf->next_resync)) {
+	if (conf->mddev->recovery_cp < MaxSector &&
+	    (this_sector + sectors >= conf->next_resync)) {
 		/* make sure that disk is operational */
 		new_disk = 0;
 
