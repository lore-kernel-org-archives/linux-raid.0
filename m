From: Eric Mei <meijia@gmail.com>
Subject: [PATCH] md/raid5: don't do chunk aligned read on degraded array.
Date: Wed, 18 Mar 2015 23:39:11 -0600
Message-ID: <550A60FF.3050902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Eric Mei <eric.mei@seagate.com>

When array is degraded, read data landed on failed drives will result in 
reading rest of data in a stripe. So a single sequential read would 
result in same data being read twice.

This patch is to avoid chunk aligned read for degraded array. The 
downside is to involve stripe cache which means associated CPU overhead 
and extra memory copy.

Signed-off-by: Eric Mei <eric.mei@seagate.com>
---
  drivers/md/raid5.c |   15 ++++++++++++---
  1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index cd2f96b..763c64a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4180,8 +4180,12 @@ static int raid5_mergeable_bvec(struct mddev *mddev,
         unsigned int chunk_sectors = mddev->chunk_sectors;
         unsigned int bio_sectors = bvm->bi_size >> 9;

-       if ((bvm->bi_rw & 1) == WRITE)
-               return biovec->bv_len; /* always allow writes to be 
mergeable */
+       /*
+        * always allow writes to be mergeable, read as well if array
+        * is degraded as we'll go through stripe cache anyway.
+        */
+       if ((bvm->bi_rw & 1) == WRITE || mddev->degraded)
+               return biovec->bv_len;

         if (mddev->new_chunk_sectors < mddev->chunk_sectors)
                 chunk_sectors = mddev->new_chunk_sectors;
@@ -4656,7 +4660,12 @@ static void make_request(struct mddev *mddev, 
struct bio * bi)

         md_write_start(mddev, bi);

-       if (rw == READ &&
+       /*
+        * If array is degraded, better not do chunk aligned read because
+        * later we might have to read it again in order to reconstruct
+        * data on failed drives.
+        */
+       if (rw == READ && mddev->degraded == 0 &&
              mddev->reshape_position == MaxSector &&
              chunk_aligned_read(mddev,bi))
                 return;
-- 
1.7.1
