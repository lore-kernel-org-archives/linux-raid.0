From: Shaohua Li <shli@fb.com>
Subject: [PATCH 1/6] md: show journal for journal disk in disk state sysfs
Date: Sun, 4 Oct 2015 09:20:11 -0700
Message-ID: <ff04527123c846667aae1a6c5223d4a435796ece.1443973492.git.shli@fb.com>
References: <cover.1443973492.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1443973492.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Journal disk state sysfs entry should indicate it's journal

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f1cbb08..c643c9a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2464,6 +2464,10 @@ state_show(struct md_rdev *rdev, char *page)
 		len += sprintf(page+len, "%sin_sync",sep);
 		sep = ",";
 	}
+	if (test_bit(Journal, &flags)) {
+		len += sprintf(page+len, "%sjournal",sep);
+		sep = ",";
+	}
 	if (test_bit(WriteMostly, &flags)) {
 		len += sprintf(page+len, "%swrite_mostly",sep);
 		sep = ",";
-- 
2.4.6

