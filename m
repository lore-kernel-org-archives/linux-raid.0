From: NeilBrown <neilb@suse.de>
Subject: [PATCH 3/5] md/raid1: make sure resync waits for conflicting writes
 to complete.
Date: Wed, 10 Sep 2014 16:20:44 +1000
Message-ID: <20140910062044.26400.20958.stgit@notabene.brown>
References: <20140910062039.26400.36745.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140910062039.26400.36745.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Eivind Sarto <eivindsarto@gmail.com>, Brassow Jonathan <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org, majianpeng <majianpeng@gmail.com>
List-Id: linux-raid.ids

The resync/recovery process for raid1 was recently changed
so that writes could happen in parallel with resync providing
they were in different regions of the device.

There is a problem though:  While a write request will always
wait for conflicting resync to complete, a resync request
will *not* always wait for conflicting writes to complete.

Two changes are needed to fix this:

1/ raise_barrier (which waits until it is safe to do resync)
   must wait until current_window_requests is zero
2/ wait_battier (which wait at the start of a new write request)
   must update current_window_requests if the request could
   possible conflict with a concurrent resync.

As concurrent writes and resync can lead to data loss,
this patch is suitable for -stable.

Fixes: 79ef3a8aa1cb1523cc231c9a90a278333c21f761
Cc: stable@vger.kernel.org (v3.13+)
Cc: majianpeng <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 65afd8aa6608..86753358ea46 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -845,10 +845,12 @@ static void raise_barrier(struct r1conf *conf)
 	 * C: next_resync + RESYNC_SECTORS > start_next_window, meaning
 	 *    next resync will reach to the window which normal bios are
 	 *    handling.
+	 * D: while there are any active requests in the current window.
 	 */
 	wait_event_lock_irq(conf->wait_barrier,
 			    !conf->array_frozen &&
 			    conf->barrier < RESYNC_DEPTH &&
+			    conf->current_window_requests == 0 &&
 			    (conf->start_next_window >=
 			     conf->next_resync + RESYNC_SECTORS),
 			    conf->resync_lock);
@@ -915,8 +917,8 @@ static sector_t wait_barrier(struct r1conf *conf, struct bio *bio)
 	}
 
 	if (bio && bio_data_dir(bio) == WRITE) {
-		if (conf->next_resync + NEXT_NORMALIO_DISTANCE
-		    <= bio->bi_iter.bi_sector) {
+		if (bio->bi_iter.bi_sector >=
+		    conf->next_resync) {
 			if (conf->start_next_window == MaxSector)
 				conf->start_next_window =
 					conf->next_resync +


