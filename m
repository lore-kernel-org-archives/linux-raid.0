From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 07/17] md: raid1/raid10: don't use .bi_vcnt to check if all pages are added
Date: Thu, 16 Feb 2017 19:45:37 +0800
Message-ID: <1487245547-24384-8-git-send-email-tom.leiming@gmail.com>
References: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

Instead we use the index of the pre-allocated pages buffer, it should
be more explicit because the index(.bi_error) just means how many pages
are added to the bio.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid1.c  | 2 +-
 drivers/md/raid10.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 8904a9149671..23a3a678a9ed 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2835,7 +2835,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		nr_sectors += len>>9;
 		sector_nr += len>>9;
 		sync_blocks -= (len>>9);
-	} while (r1_bio->bios[disk]->bi_vcnt < RESYNC_PAGES);
+	} while (r1_bio->bios[disk]->bi_error < RESYNC_PAGES);
  bio_full:
 	/* return .bi_error back to bio */
 	for (i = 0 ; i < conf->raid_disks * 2; i++) {
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 9cfc22cd1330..8262f3e1dd93 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3453,7 +3453,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		}
 		nr_sectors += len>>9;
 		sector_nr += len>>9;
-	} while (biolist->bi_vcnt < RESYNC_PAGES);
+	} while (biolist->bi_error < RESYNC_PAGES);
  bio_full:
 	/* return .bi_error back to bio, and set resync's as -EIO */
 	for (bio= biolist ; bio ; bio=bio->bi_next)
-- 
2.7.4
