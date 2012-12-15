From: shhuiw@gmail.com
Subject: [PATCH] md: cleanup: move the comment for bio_clone_mddev to the right place
Date: Sun, 16 Dec 2012 00:54:38 +0800
Message-ID: <1355590478-5465-1-git-send-email-shhuiw@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Wang Sheng-Hui <shhuiw@gmail.com>

Place the comment before bio_clone_mddev instead of bio_alloc_mddev.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 drivers/md/md.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index bd8bf09..e9ecab4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -151,10 +151,6 @@ static const struct block_device_operations md_fops;
 
 static int start_readonly;
 
-/* bio_clone_mddev
- * like bio_clone, but with a local bio set
- */
-
 struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
 			    struct mddev *mddev)
 {
@@ -170,6 +166,9 @@ struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
 }
 EXPORT_SYMBOL_GPL(bio_alloc_mddev);
 
+/* bio_clone_mddev
+ * like bio_clone, but with a local bio set
+ */
 struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
 			    struct mddev *mddev)
 {
-- 
1.7.10.4

