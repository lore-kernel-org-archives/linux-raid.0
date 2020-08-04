From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] md-cluster: Fix potential error pointer dereference in
 resize_bitmaps()
Date: Tue, 4 Aug 2020 13:16:45 +0300
Message-ID: <20200804101645.GB392148@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Song Liu <song@kernel.org>, Guoqing Jiang <gqjiang@suse.com>
Cc: Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

The error handling calls md_bitmap_free(bitmap) which checks for NULL
but will Oops if we pass an error pointer.  Let's set "bitmap" to NULL
on this error path.

Fixes: afd756286083 ("md-cluster/raid10: resize all the bitmaps before start reshape")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/md/md-cluster.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 73fd50e77975..d50737ec4039 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1139,6 +1139,7 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 		bitmap = get_bitmap_from_slot(mddev, i);
 		if (IS_ERR(bitmap)) {
 			pr_err("can't get bitmap from slot %d\n", i);
+			bitmap = NULL;
 			goto out;
 		}
 		counts = &bitmap->counts;
-- 
2.27.0
