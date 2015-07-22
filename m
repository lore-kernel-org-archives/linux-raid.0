From: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 2/3] Skip cluster setup in case of error while reading bitmap
Date: Wed, 22 Jul 2015 12:09:16 -0500
Message-ID: <1437584957-23879-2-git-send-email-rgoldwyn@suse.com>
References: <1437584957-23879-1-git-send-email-rgoldwyn@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1437584957-23879-1-git-send-email-rgoldwyn@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

If the bitmap read fails, the error code set is -EINVAL. However,
we don't check for errors and go ahead with cluster_setup.
Skip the cluster setup in case of error.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index ed2346d..f23b8e4 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -671,7 +671,7 @@ out:
 	kunmap_atomic(sb);
 	/* Assiging chunksize is required for "re_read" */
 	bitmap->mddev->bitmap_info.chunksize = chunksize;
-	if (nodes && (bitmap->cluster_slot < 0)) {
+	if (err == 0 && nodes && (bitmap->cluster_slot < 0)) {
 		err = md_setup_cluster(bitmap->mddev, nodes);
 		if (err) {
 			pr_err("%s: Could not setup cluster service (%d)\n",
-- 
2.1.4

