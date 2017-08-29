From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v2] mdadm: set journal_clean after scanning all disks
Date: Tue, 29 Aug 2017 09:53:02 -0700
Message-ID: <20170829165302.3526230-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Song Liu <songliubraving@fb.com>, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

Summary:
In Incremental.c:count_active(), max_events is tracked to show to
which devices are up to date. If a device has events==max_events+1,
getinfo_super() is called to reload the superblock from this
device. getinfo_super1() blindly set journal_clean to 0, which is
wrong.

This patch fixes this by tracking max_journal_events for all the
disks. After scanning all disks, journal_clean is set if
max_journal_events >= max_events-1.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 Incremental.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 6cf2174..91301eb 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -684,6 +684,7 @@ static int count_active(struct supertype *st, struct mdinfo *sra,
 	int cnt = 0;
 	int replcnt = 0;
 	__u64 max_events = 0;
+	__u64 max_journal_events = 0;
 	char *avail = NULL;
 	int *best = NULL;
 	char *devmap = NULL;
@@ -714,8 +715,9 @@ static int count_active(struct supertype *st, struct mdinfo *sra,
 
 		info.array.raid_disks = raid_disks;
 		st->ss->getinfo_super(st, &info, devmap + raid_disks * devnum);
-		if (info.disk.raid_disk == MD_DISK_ROLE_JOURNAL)
-			bestinfo->journal_clean = 1;
+		if (info.disk.raid_disk == MD_DISK_ROLE_JOURNAL &&
+		    info.events > max_journal_events)
+			max_journal_events = info.events;
 		if (!avail) {
 			raid_disks = info.array.raid_disks;
 			avail = xcalloc(raid_disks, 1);
@@ -765,6 +767,8 @@ static int count_active(struct supertype *st, struct mdinfo *sra,
 			replcnt++;
 		st->ss->free_super(st);
 	}
+	if (max_journal_events >= max_events - 1)
+		bestinfo->journal_clean = 1;
 
 	if (!avail)
 		return 0;
-- 
2.9.5

