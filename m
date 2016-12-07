From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 2/3] md/r5cache: after recovery, increase journal seq by 1000
Date: Wed, 7 Dec 2016 09:42:06 -0800
Message-ID: <20161207174207.3685260-2-songliubraving@fb.com>
References: <20161207174207.3685260-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161207174207.3685260-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Currently, we increase journal entry seq by 10 after recovery.
However, this is not sufficient in the following case.

After crash the journal looks like

| seq+0 | +1 | +2 | +3 | +4 | +5 | +6 | +7 | ... | +11 | +12 |

If +1 is not valid, we dropped all entries from +1 to +12; and
write seq+10:

| seq+0 | +10 | +2 | +3 | +4 | +5 | +6 | +7 | ... | +11 | +12 |

However, if we write a big journal entry with seq+11, it will
connect with some stale journal entry:

| seq+0 | +10 |                     +11                 | +12 |

To reduce the risk of this issue, we increase seq by 1000 instead.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 875f963..5301081 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2003,8 +2003,8 @@ static int r5c_recovery_flush_log(struct r5l_log *log,
  * happens again, new recovery will start from meta 1. Since meta 2n is
  * valid now, recovery will think meta 3 is valid, which is wrong.
  * The solution is we create a new meta in meta2 with its seq == meta
- * 1's seq + 10 and let superblock points to meta2. The same recovery will
- * not think meta 3 is a valid meta, because its seq doesn't match
+ * 1's seq + 1000 and let superblock points to meta2. The same recovery
+ * will not think meta 3 is a valid meta, because its seq doesn't match
  */
 
 /*
@@ -2034,7 +2034,7 @@ static int r5c_recovery_flush_log(struct r5l_log *log,
  *   ---------------------------------------------
  *   ^                              ^
  *   |- log->last_checkpoint        |- ctx->pos+1
- *   |- log->last_cp_seq            |- ctx->seq+11
+ *   |- log->last_cp_seq            |- ctx->seq+1001
  *
  * However, it is not safe to start the state machine yet, because data only
  * parities are not yet secured in RAID. To save these data only parities, we
@@ -2045,7 +2045,7 @@ static int r5c_recovery_flush_log(struct r5l_log *log,
  *   -----------------------------------------------------------------
  *   ^                                                ^
  *   |- log->last_checkpoint                          |- ctx->pos+n
- *   |- log->last_cp_seq                              |- ctx->seq+10+n
+ *   |- log->last_cp_seq                              |- ctx->seq+1000+n
  *
  * If failure happens again during this process, the recovery can safe start
  * again from log->last_checkpoint.
@@ -2057,7 +2057,7 @@ static int r5c_recovery_flush_log(struct r5l_log *log,
  *   -----------------------------------------------------------------
  *                        ^                         ^
  *                        |- log->last_checkpoint   |- ctx->pos+n
- *                        |- log->last_cp_seq       |- ctx->seq+10+n
+ *                        |- log->last_cp_seq       |- ctx->seq+1000+n
  *
  * Then we can safely start the state machine. If failure happens from this
  * point on, the recovery will start from new log->last_checkpoint.
@@ -2157,8 +2157,8 @@ static int r5l_recovery_log(struct r5l_log *log)
 	if (ret)
 		return ret;
 
-       pos = ctx.pos;
-       ctx.seq += 10;
+	pos = ctx.pos;
+	ctx.seq += 1000;
 
 	if (ctx.data_only_stripes == 0) {
 		log->next_checkpoint = ctx.pos;
-- 
2.9.3

