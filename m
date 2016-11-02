From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 4/9] md/linear: replace printk() with pr_*()
Date: Wed, 02 Nov 2016 14:16:49 +1100
Message-ID: <147805660956.23566.8317748507456310492.stgit@noble>
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

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/linear.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 86f5d435901d..9c7d4f5483ea 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -101,8 +101,8 @@ static struct linear_conf *linear_conf(struct mddev *mddev, int raid_disks)
 		sector_t sectors;
 
 		if (j < 0 || j >= raid_disks || disk->rdev) {
-			printk(KERN_ERR "md/linear:%s: disk numbering problem. Aborting!\n",
-			       mdname(mddev));
+			pr_warn("md/linear:%s: disk numbering problem. Aborting!\n",
+				mdname(mddev));
 			goto out;
 		}
 
@@ -123,8 +123,8 @@ static struct linear_conf *linear_conf(struct mddev *mddev, int raid_disks)
 			discard_supported = true;
 	}
 	if (cnt != raid_disks) {
-		printk(KERN_ERR "md/linear:%s: not enough drives present. Aborting!\n",
-		       mdname(mddev));
+		pr_warn("md/linear:%s: not enough drives present. Aborting!\n",
+			mdname(mddev));
 		goto out;
 	}
 
@@ -262,9 +262,7 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 	return;
 
 out_of_bounds:
-	printk(KERN_ERR
-	       "md/linear:%s: make_request: Sector %llu out of bounds on "
-	       "dev %s: %llu sectors, offset %llu\n",
+	pr_err("md/linear:%s: make_request: Sector %llu out of bounds on dev %s: %llu sectors, offset %llu\n",
 	       mdname(mddev),
 	       (unsigned long long)bio->bi_iter.bi_sector,
 	       bdevname(tmp_dev->rdev->bdev, b),
@@ -275,7 +273,6 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 
 static void linear_status (struct seq_file *seq, struct mddev *mddev)
 {
-
 	seq_printf(seq, " %dk rounding", mddev->chunk_sectors / 2);
 }
 


