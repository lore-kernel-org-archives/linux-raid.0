From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH v2] raid10: record correct address of bad block
Date: Tue, 23 Aug 2016 10:53:57 +0200
Message-ID: <1471942437-16720-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com, maksymilian.kunt@intel.com
List-Id: linux-raid.ids

For failed write request record block address on a device, not block
address in an array.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 drivers/md/raid10.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index cfa96b5..cd8d197 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2465,18 +2465,19 @@ static int narrow_write_error(struct r10bio *r10_bio, int i)
 
 	while (sect_to_write) {
 		struct bio *wbio;
+		sector_t wsector;
 		if (sectors > sect_to_write)
 			sectors = sect_to_write;
 		/* Write at 'sector' for 'sectors' */
 		wbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
 		bio_trim(wbio, sector - bio->bi_iter.bi_sector, sectors);
-		wbio->bi_iter.bi_sector = (r10_bio->devs[i].addr+
-				   choose_data_offset(r10_bio, rdev) +
-				   (sector - r10_bio->sector));
+		wsector = r10_bio->devs[i].addr + (sector - r10_bio->sector);
+		wbio->bi_iter.bi_sector = wsector +
+				   choose_data_offset(r10_bio, rdev);
 		wbio->bi_bdev = rdev->bdev;
 		if (submit_bio_wait(WRITE, wbio) < 0)
 			/* Failure! */
-			ok = rdev_set_badblocks(rdev, sector,
+			ok = rdev_set_badblocks(rdev, wsector,
 						sectors, 0)
 				&& ok;
 
-- 
1.8.3.1

