From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 1/3] md/raid1: fix: IO can block resync indefinitely
Date: Wed, 09 Nov 2016 10:21:32 +1100
Message-ID: <147864729272.1076.727849896269121517.stgit@noble>
References: <147864718560.1076.2148299631932240330.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <147864718560.1076.2148299631932240330.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

While performing a resync/recovery, raid1 divides the
array space into three regions:
 - before the resync
 - at or shortly after the resync point
 - much further ahead of the resync point.

Write requests to the first or third do not need to wait.  Write
requests to the middle region do need to wait if resync requests are
pending.

If there are any active write requests in the middle region, resync
will wait for them.

Due to an accounting error, there is a small range of addresses,
between conf->next_resync and conf->start_next_window, where write
requests will *not* be blocked, but *will* be counted in the middle
region.  This can effectively block resync indefinitely if filesystem
writes happen repeatedly to this region.

As ->next_window_requests is incremented when the sector is before
  conf->start_next_window + NEXT_NORMALIO_DISTANCE
the same boundary should be used for determining when write requests
should wait.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index aac2a05cf8d1..9ac61cd85e5c 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -834,7 +834,7 @@ static bool need_to_wait_for_sync(struct r1conf *conf, struct bio *bio)
 	else if (conf->barrier && bio_data_dir(bio) == WRITE) {
 		if ((conf->mddev->curr_resync_completed
 		     >= bio_end_sector(bio)) ||
-		    (conf->next_resync + NEXT_NORMALIO_DISTANCE
+		    (conf->start_next_window + NEXT_NORMALIO_DISTANCE
 		     <= bio->bi_iter.bi_sector))
 			wait = false;
 		else


