From: Shaohua Li <shli@fb.com>
Subject: [PATCH 5/6] md: set In_Sync for log disk
Date: Sun, 4 Oct 2015 09:20:15 -0700
Message-ID: <a55c7473e8261d76339a3c0625d730cf0b991985.1443973492.git.shli@fb.com>
References: <cover.1443973492.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1443973492.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

We forgot set the bit for log disk

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ec6574d..2fbecd7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1646,6 +1646,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 				return -EINVAL;
 			}
 			set_bit(Journal, &rdev->flags);
+			set_bit(In_sync, &rdev->flags);
 			rdev->journal_tail = le64_to_cpu(sb->journal_tail);
 			if (mddev->recovery_cp == MaxSector)
 				set_bit(MD_JOURNAL_CLEAN, &mddev->flags);
-- 
2.4.6

