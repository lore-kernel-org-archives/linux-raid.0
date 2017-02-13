From: Shaohua Li <shli@fb.com>
Subject: [PATCH --resend 2/2] md/multipath: disable WRITE SAME if it fails for multipath
Date: Mon, 13 Feb 2017 11:55:48 -0800
Message-ID: <0c162e2280760e1af0f34d58fb90f2b723d5ae9d.1487015420.git.shli@fb.com>
References: <cover.1487015420.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1487015420.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com
List-Id: linux-raid.ids

This is the part for multipath. Since multipatch already attaches
private data into original bio, we just disable write same there.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/multipath.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index aa8c4e5c..5ee9579 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -89,6 +89,10 @@ static void multipath_end_request(struct bio *bio)
 	struct mpconf *conf = mp_bh->mddev->private;
 	struct md_rdev *rdev = conf->multipaths[mp_bh->path].rdev;
 
+	if (bio_op(bio) == REQ_OP_WRITE_SAME && bio->bi_error == -EREMOTEIO &&
+	    !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors)
+		mp_bh->mddev->queue->limits.max_write_same_sectors = 0;
+
 	if (!bio->bi_error)
 		multipath_end_bh_io(mp_bh, 0);
 	else if (!(bio->bi_opf & REQ_RAHEAD)) {
-- 
2.9.3

