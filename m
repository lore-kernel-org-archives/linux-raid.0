From: Ming Lei <ming.lei@redhat.com>
Subject: Re: I/O hangs after resuming from suspend-to-ram
Date: Mon, 28 Aug 2017 20:58:28 +0800
Message-ID: <20170828125822.GA19670@ming.t460p>
References: <3926917.BCSovyVWdL@natalenko.name>
 <1579257.t1hTzJa9iD@natalenko.name>
 <20170827060200.GA30521@ming.t460p>
 <4174287.OjL0pO8MRx@natalenko.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4174287.OjL0pO8MRx@natalenko.name>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

On Sun, Aug 27, 2017 at 09:43:52AM +0200, Oleksandr Natalenko wrote:
> Hi.
> 
> Here is disk setup for QEMU VM:
> 
> ===
> [root@archmq ~]# smartctl -i /dev/sda
> …
> Device Model:     QEMU HARDDISK
> Serial Number:    QM00001
> Firmware Version: 2.5+
> User Capacity:    4,294,967,296 bytes [4.29 GB]
> Sector Size:      512 bytes logical/physical
> Device is:        Not in smartctl database [for details use: -P showall]
> ATA Version is:   ATA/ATAPI-7, ATA/ATAPI-5 published, ANSI NCITS 340-2000
> Local Time is:    Sun Aug 27 09:31:54 2017 CEST
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> 
> [root@archmq ~]# lsblk
> NAME                MAJ:MIN RM  SIZE RO TYPE   MOUNTPOINT
> sda                   8:0    0    4G  0 disk   
> `-sda1                8:1    0    4G  0 part   
>   `-md0               9:0    0    4G  0 raid10 
>     `-system        253:0    0    4G  0 crypt  
>       |-system-boot 253:1    0  512M  0 lvm    /boot
>       |-system-swap 253:2    0  512M  0 lvm    [SWAP]
>       `-system-root 253:3    0    3G  0 lvm    /
> sdb                   8:16   0    4G  0 disk   
> `-sdb1                8:17   0    4G  0 part   
>   `-md0               9:0    0    4G  0 raid10 
>     `-system        253:0    0    4G  0 crypt  
>       |-system-boot 253:1    0  512M  0 lvm    /boot
>       |-system-swap 253:2    0  512M  0 lvm    [SWAP]
>       `-system-root 253:3    0    3G  0 lvm    /
> sr0                  11:0    1 1024M  0 rom
> 
> [root@archmq ~]# mdadm --misc --detail /dev/md0
> /dev/md0:
>         Version : 1.2
>   Creation Time : Sat Jul 29 16:37:05 2017
>      Raid Level : raid10
>      Array Size : 4191232 (4.00 GiB 4.29 GB)
>   Used Dev Size : 4191232 (4.00 GiB 4.29 GB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
> 
>     Update Time : Sun Aug 27 09:30:33 2017
>           State : clean 
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : far=2
>      Chunk Size : 512K
> 
>            Name : archiso:0
>            UUID : 43f4be59:c8d2fa0a:a94acdff:1c7f2f4e
>          Events : 485
> 
>     Number   Major   Minor   RaidDevice State
>        0       8        1        0      active sync   /dev/sda1
>        1       8       17        1      active sync   /dev/sdb1
> ===
> 
> In words: 2 virtual disks, RAID10 setup with far-2 layout, LUKS on it, then 
> LVM, then ext4 for boot, swap and btrfs for /.
> 
> I couldn't reproduce the issue with single disk without RAID.

Could you verify if the following patch fixes your issue?


From 9fa53d708ebc1d5b87e62e542dc54272529da244 Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@redhat.com>
Date: Mon, 28 Aug 2017 19:59:08 +0800
Subject: [PATCH] blk-mq: align to legacy path for implementing blk_execute_rq

In legacy path, when one request is run via blk_execute_rq(),
it is added to q->queue_head directly, and I/O scheduler's
queue is bypassed because either merging or sorting isn't
needed.

When SCSI device is put into quiece state, such as during
system suspend, we need to add the request of RQF_PM into
head of the queue.

This patch fixes I/O hang after system resume.

Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c     |  2 +-
 block/blk-exec.c     |  2 +-
 block/blk-flush.c    |  2 +-
 block/blk-mq-sched.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 block/blk-mq-sched.h |  2 ++
 5 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index dbecbf4a64e0..fb75bc646ebc 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2330,7 +2330,7 @@ blk_status_t blk_insert_cloned_request(struct request_queue *q, struct request *
 	if (q->mq_ops) {
 		if (blk_queue_io_stat(q))
 			blk_account_io_start(rq, true);
-		blk_mq_sched_insert_request(rq, false, true, false, false);
+		blk_mq_sched_insert_request_bypass(rq, false, true, false, false);
 		return BLK_STS_OK;
 	}
 
diff --git a/block/blk-exec.c b/block/blk-exec.c
index 5c0f3dc446dc..4565aa6bb624 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -61,7 +61,7 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	 * be reused after dying flag is set
 	 */
 	if (q->mq_ops) {
-		blk_mq_sched_insert_request(rq, at_head, true, false, false);
+		blk_mq_sched_insert_request_bypass(rq, at_head, true, false, false);
 		return;
 	}
 
diff --git a/block/blk-flush.c b/block/blk-flush.c
index ed5fe322abba..51e89e5c525a 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -463,7 +463,7 @@ void blk_insert_flush(struct request *rq)
 	if ((policy & REQ_FSEQ_DATA) &&
 	    !(policy & (REQ_FSEQ_PREFLUSH | REQ_FSEQ_POSTFLUSH))) {
 		if (q->mq_ops)
-			blk_mq_sched_insert_request(rq, false, true, false, false);
+			blk_mq_sched_insert_request_bypass(rq, false, true, false, false);
 		else
 			list_add_tail(&rq->queuelist, &q->queue_head);
 		return;
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 4ab69435708c..eeeea026fb47 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -354,6 +354,64 @@ static void blk_mq_sched_insert_flush(struct blk_mq_hw_ctx *hctx,
 		blk_mq_add_to_requeue_list(rq, false, true);
 }
 
+static void blk_mq_flush_hctx(struct blk_mq_hw_ctx *hctx,
+			      struct elevator_queue *e,
+			      const bool has_sched_dispatch,
+			      struct list_head *rqs)
+{
+	LIST_HEAD(list);
+
+	if (!has_sched_dispatch)
+		blk_mq_flush_busy_ctxs(hctx, &list);
+	else {
+		while (true) {
+			struct request *rq;
+
+			rq = e->type->ops.mq.dispatch_request(hctx);
+			if (!rq)
+				break;
+			list_add_tail(&rq->queuelist, &list);
+		}
+	}
+
+	list_splice_tail(&list, rqs);
+}
+
+void blk_mq_sched_insert_request_bypass(struct request *rq, bool at_head,
+					bool run_queue, bool async,
+					bool can_block)
+{
+	struct request_queue *q = rq->q;
+	struct elevator_queue *e = q->elevator;
+	struct blk_mq_ctx *ctx = rq->mq_ctx;
+	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, ctx->cpu);
+	LIST_HEAD(list);
+	const bool has_sched_dispatch = e && e->type->ops.mq.dispatch_request;
+
+	if (rq->tag == -1 && op_is_flush(rq->cmd_flags)) {
+		blk_mq_sched_insert_flush(hctx, rq, can_block);
+		return;
+	}
+
+	if (at_head)
+		list_add_tail(&rq->queuelist, &list);
+	else {
+		blk_mq_flush_hctx(hctx, e, has_sched_dispatch, &list);
+		list_add_tail(&rq->queuelist, &list);
+		run_queue = true;
+	}
+
+	spin_lock(&hctx->lock);
+	if (at_head)
+		list_splice(&list, &hctx->dispatch);
+	else
+		list_splice_tail(&list, &hctx->dispatch);
+	spin_unlock(&hctx->lock);
+
+	if (run_queue)
+		blk_mq_run_hw_queue(hctx, async);
+}
+
 void blk_mq_sched_insert_request(struct request *rq, bool at_head,
 				 bool run_queue, bool async, bool can_block)
 {
diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
index 9267d0b7c197..4d01697a627f 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -18,6 +18,8 @@ void blk_mq_sched_restart(struct blk_mq_hw_ctx *hctx);
 
 void blk_mq_sched_insert_request(struct request *rq, bool at_head,
 				 bool run_queue, bool async, bool can_block);
+void blk_mq_sched_insert_request_bypass(struct request *rq, bool at_head,
+					bool run_queue, bool async, bool can_block);
 void blk_mq_sched_insert_requests(struct request_queue *q,
 				  struct blk_mq_ctx *ctx,
 				  struct list_head *list, bool run_queue_async);
-- 
2.9.5



-- 
Ming
