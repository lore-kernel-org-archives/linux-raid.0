From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 21/54] md/raid1: Delete three unwanted spaces behind asterisks
Date: Thu, 6 Oct 2016 11:19:41 +0200
Message-ID: <2677c627-21c4-6ce3-5dba-787146bc00ea@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 4 Oct 2016 21:01:34 +0200

The script "checkpatch.pl" pointed information out like the following.

ERROR: "foo * bar" should be "foo *bar"

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid1.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 3a03d19..fc9d600 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -72,7 +72,7 @@ static void allow_barrier(struct r1conf *conf, sector_t start_next_window,
 			  sector_t bi_sector);
 static void lower_barrier(struct r1conf *conf);
 
-static void * r1bio_pool_alloc(gfp_t gfp_flags, void *data)
+static void *r1bio_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	struct pool_info *pi = data;
 	int size = offsetof(struct r1bio, bios[pi->raid_disks]);
@@ -96,7 +96,7 @@ static void r1bio_pool_free(void *r1_bio, void *data)
 #define CLUSTER_RESYNC_WINDOW_SECTORS (CLUSTER_RESYNC_WINDOW >> 9)
 #define NEXT_NORMALIO_DISTANCE (3 * RESYNC_WINDOW_SECTORS)
 
-static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
+static void *r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	struct pool_info *pi = data;
 	struct r1bio *r1_bio;
@@ -1027,7 +1027,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	kfree(plug);
 }
 
-static void raid1_make_request(struct mddev *mddev, struct bio * bio)
+static void raid1_make_request(struct mddev *mddev, struct bio *bio)
 {
 	struct r1conf *conf = mddev->private;
 	struct raid1_info *mirror;
-- 
2.10.1
