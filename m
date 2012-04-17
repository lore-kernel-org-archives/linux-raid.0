From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 09/24] md/bitmap: move storage allocation from bitmap_load
 to bitmap_create.
Date: Tue, 17 Apr 2012 18:43:40 +1000
Message-ID: <20120417084340.6433.23279.stgit@notabene.brown>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We should allocate memory for the storage-bitmap at create-time, not
load time.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 0819ec2..79dafff 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1030,11 +1030,6 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 		goto err;
 	}
 
-	ret = bitmap_storage_alloc(&bitmap->storage, bitmap->chunks,
-				   !bitmap->mddev->bitmap_info.external);
-	if (ret)
-		goto err;
-
 	oldindex = ~0L;
 	offset = 0;
 	if (!bitmap->mddev->bitmap_info.external)
@@ -1781,6 +1776,12 @@ int bitmap_create(struct mddev *mddev)
 	if (!bitmap->bp)
 		goto error;
 
+	if (file || mddev->bitmap_info.offset) {
+		err = bitmap_storage_alloc(&bitmap->storage, bitmap->chunks,
+					   !mddev->bitmap_info.external);
+		if (err)
+			goto error;
+	}
 	printk(KERN_INFO "created bitmap (%lu pages) for device %s\n",
 		pages, bmname(bitmap));
 


