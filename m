From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 1/2] [mdadm] fix bug in assemble
Date: Mon, 7 Dec 2015 17:08:39 -0800
Message-ID: <1449536919-3773378-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, dan.j.williams@intel.com, shli@fb.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

In Assemble, getinfo_super() over writes journal_clean, to same
correct journal clean, keep it in "journal_clean_tmp" before
getinfo_super().

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 Assemble.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Assemble.c b/Assemble.c
index 6b9a6da..0ab5943 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1302,6 +1302,7 @@ int Assemble(struct supertype *st, char *mddev,
 	int bestcnt = 0;
 	int devcnt;
 	unsigned int okcnt, sparecnt, rebuilding_cnt, replcnt, journalcnt;
+	int journal_clean_tmp = 0;
 	int i;
 	int was_forced = 0;
 	int most_recent = 0;
@@ -1592,7 +1593,7 @@ try_again:
 			) {
 			devices[j].uptodate = 1;
 			if (devices[j].i.disk.state & (1<<MD_DISK_JOURNAL))
-				content->journal_clean = 1;
+				journal_clean_tmp = 1;  /* store in journal_clean_tmp */
 			if (i < content->array.raid_disks * 2) {
 				if (devices[j].i.recovery_start == MaxSector ||
 				    (content->reshape_active &&
@@ -1664,6 +1665,8 @@ try_again:
 #ifndef MDASSEMBLE
 	sysfs_init(content, mdfd, NULL);
 #endif
+	/* after reload context, store journal_clean in context */
+	content->journal_clean = journal_clean_tmp;
 	for (i=0; i<bestcnt; i++) {
 		int j = best[i];
 		unsigned int desired_state;
-- 
2.4.6

