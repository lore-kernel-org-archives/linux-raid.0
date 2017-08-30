From: Ming Lei <ming.lei@redhat.com>
Subject: Re: I/O hangs after resuming from suspend-to-ram
Date: Wed, 30 Aug 2017 16:06:29 +0800
Message-ID: <20170830080628.GA2402@ming.t460p>
References: <3926917.BCSovyVWdL@natalenko.name>
 <1615033.Xza1AIGLzP@natalenko.name>
 <20170829002425.GA28904@ming.t460p>
 <2329566.kid2YYBOAQ@natalenko.name>
 <20170830021537.GA4897@ming.t460p>
 <20170830051725.GA5840@ming.t460p>
 <692537117e26fe71b5e07cd8c86b38e4@natalenko.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <692537117e26fe71b5e07cd8c86b38e4@natalenko.name>
Sender: linux-block-owner@vger.kernel.org
To: oleksandr@natalenko.name
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

Hi,

On Wed, Aug 30, 2017 at 08:15:02AM +0200, oleksandr@natalenko.name wrote:
> Hello.
> 
> Addressing your questions below.
> 
> > Can't reproduce even with putting dmcypt on raid10 after applying my
> > patch.
> 
> Just a side note, that dm-crypt is not necessary here — I am able to trigger
> hang with RAID10 and LVM only.
> 
> > BTW, could you share us which blk-mq scheduler you are using on sata?
> 
> Okay, now it makes sense. Previously, without your patch I was able to
> reproduce the issue with "mq-deadline", "bfq" and "none". Now, I cannot
> trigger it with "none" set, but "mq-deadline" still hangs for me. Does this
> mean each scheduler should be modified separately?

No, it shouldn't.

> 
> > Could you apply the following debug patch and provide the dmesg log
> > after running the commands below?
> 
> Is it still relevant since I confirm issue to be fixed with "none"?

Please try the following patch and previous patch together and see
if they make a difference:


From bc5626b4b65c7ff26567e75f42584c2c43ffe7c1 Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@redhat.com>
Date: Wed, 30 Aug 2017 15:53:01 +0800
Subject: [PATCH] blk-mq: add requests in the tail of hctx->dispatch

So that we can allow to insert request at the head
of hctx->dispatch.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq-sched.c | 2 +-
 block/blk-mq.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index eeeea026fb47..b40dd063d61f 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -272,7 +272,7 @@ static bool blk_mq_sched_bypass_insert(struct blk_mq_hw_ctx *hctx,
 	 * the dispatch list.
 	 */
 	spin_lock(&hctx->lock);
-	list_add(&rq->queuelist, &hctx->dispatch);
+	list_add_tail(&rq->queuelist, &hctx->dispatch);
 	spin_unlock(&hctx->lock);
 	return true;
 }
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4603b115e234..fed3d0c16266 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1067,7 +1067,7 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list)
 		blk_mq_put_driver_tag(rq);
 
 		spin_lock(&hctx->lock);
-		list_splice_init(list, &hctx->dispatch);
+		list_splice_tail_init(list, &hctx->dispatch);
 		spin_unlock(&hctx->lock);
 
 		/*
-- 
2.9.5


-- 
Ming
