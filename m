From: Shaohua Li <shli@fb.com>
Subject: [PATCH 1/2] md: clear CHANGE_PENDING in readonly array
Date: Fri, 18 Sep 2015 10:20:12 -0700
Message-ID: <bda150068cfdb69bf8b632c32dc2a7db17c919f4.1442596586.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

If faulty disks of an array are more than allowed degraded number, the
array enters error handling. It will be marked as read-only with
MD_CHANGE_PENDING/RECOVERY_NEEDED set. But currently recovery doesn't
clear CHANGE_PENDING bit for read-only array.  If MD_CHANGE_PENDING is
set for a raid5 array, all returned IO will be hold on a list till the
bit is clear. But recovery nevery clears this bit, the IO is always in
pending state and nevery finish. This has bad effects like upper layer
can't get an IO error and the array can't be stopped.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 95824fb..c596b73 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8209,6 +8209,7 @@ void md_check_recovery(struct mddev *mddev)
 			md_reap_sync_thread(mddev);
 			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+			clear_bit(MD_CHANGE_PENDING, &mddev->flags);
 			goto unlock;
 		}
 
-- 
1.8.1

