From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/1] md/raid1: Avoid raid1 resync getting stuck
Date: Wed, 16 Sep 2015 10:20:05 -0400
Message-ID: <1442413205-9593-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1442413205-9593-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1442413205-9593-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, nate.dailey@stratus.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

close_sync() needs to set conf->next_resync to a large, but safe value
below MaxSector and use it to determine whether or not to set
start_next_window in wait_barrier()

Solution suggested by Neil Brown.

Reported-by: Nate Dailey <nate.dailey@stratus.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/md/raid1.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4517f06..763a0a8 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -881,8 +881,7 @@ static sector_t wait_barrier(struct r1conf *conf, struct bio *bio)
 	}
 
 	if (bio && bio_data_dir(bio) == WRITE) {
-		if (bio->bi_iter.bi_sector >=
-		    conf->mddev->curr_resync_completed) {
+		if (bio->bi_iter.bi_sector >= conf->next_resync) {
 			if (conf->start_next_window == MaxSector)
 				conf->start_next_window =
 					conf->next_resync +
@@ -1516,7 +1515,7 @@ static void close_sync(struct r1conf *conf)
 	conf->r1buf_pool = NULL;
 
 	spin_lock_irq(&conf->resync_lock);
-	conf->next_resync = 0;
+	conf->next_resync = MaxSector - 2 * NEXT_NORMALIO_DISTANCE;
 	conf->start_next_window = MaxSector;
 	conf->current_window_requests +=
 		conf->next_window_requests;
-- 
2.4.3

