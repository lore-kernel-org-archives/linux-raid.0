From: Shaohua Li <shli@fb.com>
Subject: [PATCH] md/raid1: fix write behind issues introduced by bio_clone_bioset_partial
Date: Tue, 21 Feb 2017 15:32:37 -0800
Message-ID: <81018680b558c83936577af437ee4b29d0d5cb3e.1487719900.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

There are two issues, introduced by commit 8e58e32(md/raid1: use
bio_clone_bioset_partial() in case of write behind):
- bio_clone_bioset_partial() uses bytes instead of sectors as parameters
- in writebehind mode, we return bio if all !writemostly disk bios finish,
  which could happen before writemostly disk bios run. So all
  writemostly disk bios should have their bvec. Here we just make sure
  all bios are cloned instead of fast cloned.

Cc: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid1.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e1ee446..33526b4 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1472,8 +1472,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio)
 			    !waitqueue_active(&bitmap->behind_wait)) {
 				mbio = bio_clone_bioset_partial(bio, GFP_NOIO,
 								mddev->bio_set,
-								offset,
-								max_sectors);
+								offset << 9,
+								max_sectors << 9);
 				alloc_behind_pages(mbio, r1_bio);
 			}
 
@@ -1485,8 +1485,15 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio)
 		}
 
 		if (!mbio) {
-			mbio = bio_clone_fast(bio, GFP_NOIO, mddev->bio_set);
-			bio_trim(mbio, offset, max_sectors);
+			if (r1_bio->behind_bvecs)
+				mbio = bio_clone_bioset_partial(bio, GFP_NOIO,
+								mddev->bio_set,
+								offset << 9,
+								max_sectors << 9);
+			else {
+				mbio = bio_clone_fast(bio, GFP_NOIO, mddev->bio_set);
+				bio_trim(mbio, offset, max_sectors);
+			}
 		}
 
 		if (r1_bio->behind_bvecs) {
-- 
2.9.3

