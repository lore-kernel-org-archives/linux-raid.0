From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 02/10] md/raid1: simplify alloc_behind_master_bio()
Date: Wed, 05 Apr 2017 14:05:50 +1000
Message-ID: <149136515050.25893.5149255393971038064.stgit@noble>
References: <149136485390.25893.1797855041954158826.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <149136485390.25893.1797855041954158826.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Now that we always always pass an offset of 0 and a size
that matches the bio to alloc_behind_master_bio(),
we can remove the offset/size args and simplify the code.

We could probably remove bio_copy_data_partial() too.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid1.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 83853f65462a..06a13010f1b7 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1091,9 +1091,9 @@ static void unfreeze_array(struct r1conf *conf)
 }
 
 static struct bio *alloc_behind_master_bio(struct r1bio *r1_bio,
-					   struct bio *bio,
-					   int offset, int size)
+					   struct bio *bio)
 {
+	int size = bio->bi_iter.bi_size;
 	unsigned vcnt = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	int i = 0;
 	struct bio *behind_bio = NULL;
@@ -1120,8 +1120,7 @@ static struct bio *alloc_behind_master_bio(struct r1bio *r1_bio,
 		i++;
 	}
 
-	bio_copy_data_partial(behind_bio, bio, offset,
-			      behind_bio->bi_iter.bi_size);
+	bio_copy_data(behind_bio, bio);
 skip_copy:
 	r1_bio->behind_master_bio = behind_bio;;
 	set_bit(R1BIO_BehindIO, &r1_bio->state);
@@ -1464,9 +1463,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			    (atomic_read(&bitmap->behind_writes)
 			     < mddev->bitmap_info.max_write_behind) &&
 			    !waitqueue_active(&bitmap->behind_wait)) {
-				mbio = alloc_behind_master_bio(r1_bio, bio,
-							       0,
-							       max_sectors << 9);
+				mbio = alloc_behind_master_bio(r1_bio, bio);
 			}
 
 			bitmap_startwrite(bitmap, r1_bio->sector,


