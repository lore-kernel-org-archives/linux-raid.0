From: NeilBrown <neilb@suse.de>
Subject: [PATCH 004 of 6] md: Improve comments about locking situation in raid5 make_request
Date: Fri, 17 Mar 2006 18:21:40 +1100
Message-ID: <1060317072140.28656@suse.de>
References: <20060317181912.28543.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2006-03-17 18:18:35.000000000 +1100
+++ ./drivers/md/raid5.c	2006-03-17 18:18:44.000000000 +1100
@@ -1766,6 +1766,14 @@ static int make_request(request_queue_t 
 		if (likely(conf->expand_progress == MaxSector))
 			disks = conf->raid_disks;
 		else {
+			/* spinlock is needed as expand_progress may be
+			 * 64bit on a 32bit platform, and so it might be
+			 * possible to see a half-updated value
+			 * Ofcourse expand_progress could change after
+			 * the lock is dropped, so once we get a reference
+			 * to the stripe that we think it is, we will have
+			 * to check again.
+			 */
 			spin_lock_irq(&conf->device_lock);
 			disks = conf->raid_disks;
 			if (logical_sector >= conf->expand_progress)
@@ -1789,7 +1797,12 @@ static int make_request(request_queue_t 
 		if (sh) {
 			if (unlikely(conf->expand_progress != MaxSector)) {
 				/* expansion might have moved on while waiting for a
-				 * stripe, so we much do the range check again.
+				 * stripe, so we must do the range check again.
+				 * Expansion could still move past after this
+				 * test, but as we are holding a reference to
+				 * 'sh', we know that if that happens,
+				 *  STRIPE_EXPANDING will get set and the expansion
+				 * won't proceed until we finish with the stripe.
 				 */
 				int must_retry = 0;
 				spin_lock_irq(&conf->device_lock);
