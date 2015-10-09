From: Shaohua Li <shli@fb.com>
Subject: [PATCH 1/9] MD: fix info output for journal disk
Date: Thu, 8 Oct 2015 21:54:05 -0700
Message-ID: <2537e2bcb31eaf918df28f25d096b31c2b9daa70.1444360850.git.shli@fb.com>
References: <cover.1444360850.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1444360850.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

journal disk can be faulty. The Journal and Faulty aren't exclusive with
each other.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0729cc7..daf42bb 100644
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
@@ -7335,18 +7336,21 @@ static int md_seq_show(struct seq_file *seq, void *v)
 		rcu_read_lock();
 		rdev_for_each_rcu(rdev, mddev) {
 			char b[BDEVNAME_SIZE];
+			bool skip = false;
 			seq_printf(seq, " %s[%d]",
 				bdevname(rdev->bdev,b), rdev->desc_nr);
 			if (test_bit(WriteMostly, &rdev->flags))
 				seq_printf(seq, "(W)");
 			if (test_bit(Faulty, &rdev->flags)) {
 				seq_printf(seq, "(F)");
-				continue;
+				skip = true;
 			}
 			if (test_bit(Journal, &rdev->flags)) {
 				seq_printf(seq, "(J)");
-				continue;
+				skip = true;
 			}
+			if (skip)
+				continue;
 			if (rdev->raid_disk < 0)
 				seq_printf(seq, "(S)"); /* spare */
 			if (test_bit(Replacement, &rdev->flags))
-- 
2.4.6

