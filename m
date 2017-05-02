From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/6] md: Replace 17 seq_printf() calls by seq_puts()
Date: Tue, 2 May 2017 16:26:18 +0200
Message-ID: <146824c7-73ca-9f2e-99b8-d81ec2250bf2@users.sourceforge.net>
References: <f05bfc4e-7935-7e87-cc85-f0d9c5e3846a@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f05bfc4e-7935-7e87-cc85-f0d9c5e3846a@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 2 May 2017 14:22:45 +0200

Strings which did not contain data format specifications should be put
into a sequence. Thus use the corresponding function "seq_puts".

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/md.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7f0a35ee192a..65233a91e5e2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7487,7 +7487,7 @@ static void status_unused(struct seq_file *seq)
 	int i = 0;
 	struct md_rdev *rdev;
 
-	seq_printf(seq, "unused devices: ");
+	seq_puts(seq, "unused devices: ");
 
 	list_for_each_entry(rdev, &pending_raid_disks, same_set) {
 		char b[BDEVNAME_SIZE];
@@ -7496,7 +7496,7 @@ static void status_unused(struct seq_file *seq)
 			      bdevname(rdev->bdev,b));
 	}
 	if (!i)
-		seq_printf(seq, "<none>");
+		seq_puts(seq, "<none>");
 
 	seq_putc(seq, '\n');
 }
@@ -7525,13 +7525,13 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
 
 	if (resync == 0) {
 		if (mddev->recovery_cp < MaxSector) {
-			seq_printf(seq, "\tresync=PENDING");
+			seq_puts(seq, "\tresync=PENDING");
 			return 1;
 		}
 		return 0;
 	}
 	if (resync < 3) {
-		seq_printf(seq, "\tresync=DELAYED");
+		seq_puts(seq, "\tresync=DELAYED");
 		return 1;
 	}
 
@@ -7559,7 +7559,7 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
 		seq_putc(seq, '>');
 		for (i = 0; i < y; i++)
 			seq_putc(seq, '.');
-		seq_printf(seq, "] ");
+		seq_puts(seq, "] ");
 	}
 	seq_printf(seq, " %s =%3u.%u%% (%llu/%llu)",
 		   (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)?
@@ -7673,7 +7673,8 @@ static int md_seq_show(struct seq_file *seq, void *v)
 
 	if (v == (void*)1) {
 		struct md_personality *pers;
-		seq_printf(seq, "Personalities : ");
+
+		seq_puts(seq, "Personalities : ");
 		spin_lock(&pers_lock);
 		list_for_each_entry(pers, &pers_list, list)
 			seq_printf(seq, "[%s] ", pers->name);
@@ -7694,9 +7695,9 @@ static int md_seq_show(struct seq_file *seq, void *v)
 						mddev->pers ? "" : "in");
 		if (mddev->pers) {
 			if (mddev->ro==1)
-				seq_printf(seq, " (read-only)");
+				seq_puts(seq, " (read-only)");
 			if (mddev->ro==2)
-				seq_printf(seq, " (auto-read-only)");
+				seq_puts(seq, " (auto-read-only)");
 			seq_printf(seq, " %s", mddev->pers->name);
 		}
 
@@ -7707,17 +7708,17 @@ static int md_seq_show(struct seq_file *seq, void *v)
 			seq_printf(seq, " %s[%d]",
 				bdevname(rdev->bdev,b), rdev->desc_nr);
 			if (test_bit(WriteMostly, &rdev->flags))
-				seq_printf(seq, "(W)");
+				seq_puts(seq, "(W)");
 			if (test_bit(Journal, &rdev->flags))
-				seq_printf(seq, "(J)");
+				seq_puts(seq, "(J)");
 			if (test_bit(Faulty, &rdev->flags)) {
-				seq_printf(seq, "(F)");
+				seq_puts(seq, "(F)");
 				continue;
 			}
 			if (rdev->raid_disk < 0)
-				seq_printf(seq, "(S)"); /* spare */
+				seq_puts(seq, "(S)"); /* spare */
 			if (test_bit(Replacement, &rdev->flags))
-				seq_printf(seq, "(R)");
+				seq_puts(seq, "(R)");
 			sectors += rdev->sectors;
 		}
 		rcu_read_unlock();
@@ -7742,17 +7743,18 @@ static int md_seq_show(struct seq_file *seq, void *v)
 			seq_printf(seq, " super external:%s",
 				   mddev->metadata_type);
 		else
-			seq_printf(seq, " super non-persistent");
+			seq_puts(seq, " super non-persistent");
 
 		if (mddev->pers) {
 			mddev->pers->status(seq, mddev);
-			seq_printf(seq, "\n      ");
+			seq_puts(seq, "\n      ");
 			if (mddev->pers->sync_request) {
 				if (status_resync(seq, mddev))
-					seq_printf(seq, "\n      ");
+					seq_puts(seq, "\n      ");
 			}
-		} else
-			seq_printf(seq, "\n       ");
+		} else {
+			seq_puts(seq, "\n       ");
+		}
 
 		bitmap_status(seq, mddev->bitmap);
 		seq_putc(seq, '\n');
-- 
2.12.2

