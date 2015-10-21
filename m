From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 2/3] mdadm: Add description of write journal to md.4
Date: Wed, 21 Oct 2015 11:35:15 -0700
Message-ID: <1445452516-2816184-3-git-send-email-songliubraving@fb.com>
References: <1445452516-2816184-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1445452516-2816184-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, hch@infradead.org, dan.j.williams@intel.com, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 md.4 | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/md.4 b/md.4
index e955c3b..f1b88ee 100644
--- a/md.4
+++ b/md.4
@@ -874,6 +874,26 @@ The list is particularly useful when recovering to a spare.  If a few blocks
 cannot be read from the other devices, the bulk of the recovery can
 complete and those few bad blocks will be recorded in the bad block list.
 
+.SS RAID456 WRITE JOURNAL
+
+Due to non-atomicity nature of RAID write operations, interruption of
+write operations (system crash, etc.) to RAID456 array can lead to
+inconsistent parity and data loss (so called RAID-5 write hole).
+
+To plug the write hole, from Linux 4.4 (to be confirmed),
+.I md
+supports write ahead journal for RAID456. When the array is created,
+an additional journal device can be added to the array through
+.IR write-journal
+option. The RAID write journal works similar to file system journals.
+Before writing to the data disks, md persists data AND parity of the
+stripe to the journal device. After crashes, md searches the journal
+device for incomplete write operations, and replay them to the data
+disks.
+
+When the journal device fails, the RAID array is forced to run in
+read-only mode.
+
 .SS WRITE-BEHIND
 
 From Linux 2.6.14,
-- 
2.4.6

