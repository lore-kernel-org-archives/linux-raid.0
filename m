From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 3 of 3 - Handle concurrent failure of two drives in raid5
Date: Wed, 18 Jun 2003 10:28:46 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19SQog-0000Vq-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

If two drives both fail during a write request, raid5 doesn't
cope properly and will eventually oops.

With this patch, blocks that have already been 'written'
are failed when double drive failure is noticed, as well as
blocks that are about to be written.

 ----------- Diffstat output ------------
 ./drivers/md/raid5.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletion(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-06-18 10:04:15.000000000 +1000
+++ ./drivers/md/raid5.c	2003-06-18 10:04:15.000000000 +1000
@@ -882,7 +882,7 @@ static void handle_stripe(struct stripe_
 	/* check if the array has lost two devices and, if so, some requests might
 	 * need to be failed
 	 */
-	if (failed > 1 && to_read+to_write) {
+	if (failed > 1 && to_read+to_write+written) {
 		for (i=disks; i--; ) {
 			/* fail all writes first */
 			if (sh->bh_write[i]) to_write--;
@@ -891,6 +891,14 @@ static void handle_stripe(struct stripe_
 				bh->b_reqnext = return_fail;
 				return_fail = bh;
 			}
+			/* and fail all 'written' */
+			if (sh->bh_written[i]) written--;
+			while ((bh = sh->bh_written[i])) {
+				sh->bh_written[i] = bh->b_reqnext;
+				bh->b_reqnext = return_fail;
+				return_fail = bh;
+			}
+
 			/* fail any reads if this device is non-operational */
 			if (!conf->disks[i].operational) {
 				spin_lock_irq(&conf->device_lock);
