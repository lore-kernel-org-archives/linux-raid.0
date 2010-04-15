From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 15/28] md/raid5: small tidyup in raid5_align_endio
Date: Thu, 15 Apr 2010 16:21:08 +1000
Message-ID: <20100415062108.5126.68121.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Diving through ->queue to find mddev is unnecessarily complex - there
is an easier path to finding mddev, so use that.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid5.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 020143d..7bfeba3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3713,10 +3713,10 @@ static void raid5_align_endio(struct bio *bi, int error)
 
 	bio_put(bi);
 
-	mddev = raid_bi->bi_bdev->bd_disk->queue->queuedata;
-	conf = mddev->private;
 	rdev = (void*)raid_bi->bi_next;
 	raid_bi->bi_next = NULL;
+	mddev = rdev->mddev;
+	conf = mddev->private;
 
 	rdev_dec_pending(rdev, conf->mddev);
 


