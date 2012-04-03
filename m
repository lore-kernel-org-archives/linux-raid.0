From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 06/10] md: teach sync_page_io about new_data_offset.
Date: Tue, 03 Apr 2012 15:53:01 +1000
Message-ID: <20120403055301.19495.59705.stgit@notabene.brown>
References: <20120403054656.19495.36380.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120403054656.19495.36380.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Some code in raid1 and raid10 use sync_page_io to
read/write pages when responding to read errors.
As we will shortly support changing data_offset for
raid10, this function must understand new_data_offset.

So add that understanding.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0db613d..8da63d1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -886,6 +886,10 @@ int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 		rdev->meta_bdev : rdev->bdev;
 	if (metadata_op)
 		bio->bi_sector = sector + rdev->sb_start;
+	else if (rdev->mddev->reshape_position != MaxSector &&
+		 (rdev->mddev->reshape_backwards ==
+		  (sector >= rdev->mddev->reshape_position)))
+		bio->bi_sector = sector + rdev->new_data_offset;
 	else
 		bio->bi_sector = sector + rdev->data_offset;
 	bio_add_page(bio, page, size, 0);


