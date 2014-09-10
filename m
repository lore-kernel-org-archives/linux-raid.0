From: NeilBrown <neilb@suse.de>
Subject: [PATCH 4/5] md/raid1: Don't use next_resync to determine how far
 resync has progressed
Date: Wed, 10 Sep 2014 16:20:44 +1000
Message-ID: <20140910062044.26400.98319.stgit@notabene.brown>
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

next_resync is (approximately) the locate for the next resync request.
However it does *not* reliably determine the earliest location
at which resync might be happening.
This is because resync requests can complete out of order, and
or only limit the number of current requests, not the distance
from the earliest pending request to the latest.

mddev->curr_resync_completed is a reliable indicator of the earliest
position at which resync could be happening.   It is updated less
frequently, but is actually reliable which is more important.

So use it to determine if a write request is before the region
being resynced and so safe from conflict.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 86753358ea46..08a6989fcff6 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -875,12 +875,10 @@ static bool need_to_wait_for_sync(struct r1conf *conf, struct bio *bio)
 	if (conf->array_frozen || !bio)
 		wait = true;
 	else if (conf->barrier && bio_data_dir(bio) == WRITE) {
-		if (conf->next_resync < RESYNC_WINDOW_SECTORS)
-			wait = true;
-		else if ((conf->next_resync - RESYNC_WINDOW_SECTORS
-				>= bio_end_sector(bio)) ||
-			 (conf->next_resync + NEXT_NORMALIO_DISTANCE
-				<= bio->bi_iter.bi_sector))
+		if ((conf->mddev->curr_resync_completed
+		     >= bio_end_sector(bio)) ||
+		    (conf->next_resync + NEXT_NORMALIO_DISTANCE
+		     <= bio->bi_iter.bi_sector))
 			wait = false;
 		else
 			wait = true;
@@ -918,7 +916,7 @@ static sector_t wait_barrier(struct r1conf *conf, struct bio *bio)
 
 	if (bio && bio_data_dir(bio) == WRITE) {
 		if (bio->bi_iter.bi_sector >=
-		    conf->next_resync) {
+		    conf->mddev->curr_resync_completed) {
 			if (conf->start_next_window == MaxSector)
 				conf->start_next_window =
 					conf->next_resync +


