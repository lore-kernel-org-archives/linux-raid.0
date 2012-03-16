From: Shaohua Li <shli@fusionio.com>
Subject: [patch v2 2/6] blk: dont allow discard request merge temporarily
Date: Fri, 16 Mar 2012 15:32:15 +0800
Message-ID: <20120316073512.485027511@fusionio.com>
References: <20120316073213.656519005@fusionio.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=blk-discard-nomerge.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, vgoyal@redhat.com, martin.petersen@oracle.com, Shaohua Li <shli@fusionio.com>
List-Id: linux-raid.ids

Didn't allow discard request merge temporarily, as SCSI layer isn't ready
for discard merge as Martin Petersen pointed out. This isn't fair for
non-scsi device, but looks this is the only way I can do currently.

We should have the same issue before, but maybe because discard merge is
very rare case. But now raid0/10 makes the merge quite possible, so we need
disable it explicitly.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 include/linux/blkdev.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h	2012-03-14 09:20:06.787261188 +0800
+++ linux/include/linux/blkdev.h	2012-03-14 09:20:47.797261248 +0800
@@ -575,7 +575,7 @@ static inline void blk_clear_queue_full(
  * it already be started by driver.
  */
 #define RQ_NOMERGE_FLAGS	\
-	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA)
+	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA | REQ_DISCARD)
 #define rq_mergeable(rq)	\
 	(!((rq)->cmd_flags & RQ_NOMERGE_FLAGS) && \
 	 (((rq)->cmd_flags & REQ_DISCARD) || \
