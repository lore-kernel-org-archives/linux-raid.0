From: Colin King <colin.king@canonical.com>
Subject: [PATCH] md: raid10: remove a couple of redundant variables and initializations
Date: Wed, 11 Oct 2017 11:46:54 +0100
Message-ID: <20171011104654.19686-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

From: Colin Ian King <colin.king@canonical.com>

Variables dev and bio_last_sector are assigned values that are never
read and hence these are redundant variables and can be removed.
Also remove the duplicated initialization of sectors, the latter
assignment is identical to the first and can be removed.

Cleans up 3 clang build warnings:
Value stored to 'dev' is never read
Value stored to 'bio_last_sector' is never read
Value stored to 'sectors' during its initialization is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/md/raid10.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 950fbefbedbb..d1998ddd9345 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -383,12 +383,11 @@ static void raid10_end_read_request(struct bio *bio)
 {
 	int uptodate = !bio->bi_status;
 	struct r10bio *r10_bio = bio->bi_private;
-	int slot, dev;
+	int slot;
 	struct md_rdev *rdev;
 	struct r10conf *conf = r10_bio->mddev->private;
 
 	slot = r10_bio->read_slot;
-	dev = r10_bio->devs[slot].devnum;
 	rdev = r10_bio->devs[slot].rdev;
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
@@ -748,7 +747,6 @@ static struct md_rdev *read_balance(struct r10conf *conf,
 
 	raid10_find_phys(conf, r10_bio);
 	rcu_read_lock();
-	sectors = r10_bio->sectors;
 	best_slot = -1;
 	best_rdev = NULL;
 	best_dist = MaxSector;
@@ -2575,7 +2573,6 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 	struct bio *bio;
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *rdev = r10_bio->devs[slot].rdev;
-	sector_t bio_last_sector;
 
 	/* we got a read error. Maybe the drive is bad.  Maybe just
 	 * the block and we can fix it.
@@ -2586,7 +2583,6 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 	 * frozen.
 	 */
 	bio = r10_bio->devs[slot].bio;
-	bio_last_sector = r10_bio->devs[slot].addr + rdev->data_offset + r10_bio->sectors;
 	bio_put(bio);
 	r10_bio->devs[slot].bio = NULL;
 
-- 
2.14.1
