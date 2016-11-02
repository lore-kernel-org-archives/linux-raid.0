From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 1/9] md: fix some issues with alloc_disk_sb()
Date: Wed, 02 Nov 2016 14:16:49 +1100
Message-ID: <147805660892.23566.6467773696190310278.stgit@noble>
References: <147805657658.23566.1748253447749986766.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <147805657658.23566.1748253447749986766.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

1/ don't print a warning if allocation fails.
 page_alloc() does that already.
2/ always check return status for error.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/md.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 18d0c4adbd7b..e3d20fb1d839 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -684,11 +684,8 @@ static inline sector_t calc_dev_sboffset(struct md_rdev *rdev)
 static int alloc_disk_sb(struct md_rdev *rdev)
 {
 	rdev->sb_page = alloc_page(GFP_KERNEL);
-	if (!rdev->sb_page) {
-		printk(KERN_ALERT "md: out of memory.\n");
+	if (!rdev->sb_page)
 		return -ENOMEM;
-	}
-
 	return 0;
 }
 
@@ -8785,15 +8782,18 @@ static int read_rdev(struct mddev *mddev, struct md_rdev *rdev)
 	 * variable in case we err in the future
 	 */
 	rdev->sb_page = NULL;
-	alloc_disk_sb(rdev);
-	ClearPageUptodate(rdev->sb_page);
-	rdev->sb_loaded = 0;
-	err = super_types[mddev->major_version].load_super(rdev, NULL, mddev->minor_version);
-
+	err = alloc_disk_sb(rdev);
+	if (err == 0) {
+		ClearPageUptodate(rdev->sb_page);
+		rdev->sb_loaded = 0;
+		err = super_types[mddev->major_version].
+			load_super(rdev, NULL, mddev->minor_version);
+	}
 	if (err < 0) {
 		pr_warn("%s: %d Could not reload rdev(%d) err: %d. Restoring old values\n",
 				__func__, __LINE__, rdev->desc_nr, err);
-		put_page(rdev->sb_page);
+		if (rdev->sb_page)
+			put_page(rdev->sb_page);
 		rdev->sb_page = swapout;
 		rdev->sb_loaded = 1;
 		return err;


