From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 14/16] md/raid10: remove unused variable.
Date: Wed, 11 May 2011 16:30:31 +1000
Message-ID: <20110511063031.21263.44036.stgit@notabene.brown>
References: <20110511062743.21263.72802.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110511062743.21263.72802.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This variable 'disk' is never used - how odd.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 80cc7e6..f44a3da 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1742,7 +1742,6 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 	r10bio_t *r10_bio;
 	struct bio *biolist = NULL, *bio;
 	sector_t max_sector, nr_sectors;
-	int disk;
 	int i;
 	int max_sync;
 	sector_t sync_blocks;
@@ -2020,7 +2019,6 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 	do {
 		struct page *page;
 		int len = PAGE_SIZE;
-		disk = 0;
 		if (sector_nr + (len>>9) > max_sector)
 			len = (max_sector - sector_nr) << 9;
 		if (len == 0)
@@ -2039,7 +2037,6 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 				}
 				goto bio_full;
 			}
-			disk = i;
 		}
 		nr_sectors += len>>9;
 		sector_nr += len>>9;


