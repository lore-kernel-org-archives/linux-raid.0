From: Shaohua Li <shli@fb.com>
Subject: [PATCH V2] MD: fix info output for journal disk
Date: Mon, 12 Oct 2015 16:59:50 -0700
Message-ID: <6e6d9cd5bc79883cfb22a62b9bdc98b161aad301.1444694209.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

journal disk can be faulty. The Journal and Faulty aren't exclusive with
each other.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0729cc7..f1114a6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5857,7 +5857,8 @@ static int get_disk_info(struct mddev *mddev, void __user * arg)
 		else if (test_bit(In_sync, &rdev->flags)) {
 			info.state |= (1<<MD_DISK_ACTIVE);
 			info.state |= (1<<MD_DISK_SYNC);
-		} else if (test_bit(Journal, &rdev->flags))
+		}
+		if (test_bit(Journal, &rdev->flags))
 			info.state |= (1<<MD_DISK_JOURNAL);
 		if (test_bit(WriteMostly, &rdev->flags))
 			info.state |= (1<<MD_DISK_WRITEMOSTLY);
@@ -7339,14 +7340,12 @@ static int md_seq_show(struct seq_file *seq, void *v)
 				bdevname(rdev->bdev,b), rdev->desc_nr);
 			if (test_bit(WriteMostly, &rdev->flags))
 				seq_printf(seq, "(W)");
+			if (test_bit(Journal, &rdev->flags))
+				seq_printf(seq, "(J)");
 			if (test_bit(Faulty, &rdev->flags)) {
 				seq_printf(seq, "(F)");
 				continue;
 			}
-			if (test_bit(Journal, &rdev->flags)) {
-				seq_printf(seq, "(J)");
-				continue;
-			}
 			if (rdev->raid_disk < 0)
 				seq_printf(seq, "(S)"); /* spare */
 			if (test_bit(Replacement, &rdev->flags))
-- 
2.4.6

