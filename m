From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: 2.5.62 oops and Raid-5
Date: Tue, 18 Feb 2003 16:40:20 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15953.51012.470042.33785@notabene.cse.unsw.edu.au>
References: <20030218001930.AFB21457CC@chronozon.artofdns.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stef Telford on Monday February 17
To: Stef Telford <stef@chronozon.artofdns.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday February 17, stef@chronozon.artofdns.com wrote:
> Ah, silly me, should have done that in the first place.
> apologies.
> 

>  
> Trace; c0267f47 <generic_unplug_device+77/80>
> Trace; c012c403 <run_workqueue+73/e0>
> Trace; c0267f50 <blk_unplug_work+0/10>
> Trace; c012c078 <worker_thread+1c8/200>
> Trace; c0119fd0 <default_wake_function+0/20>
> Trace; c0119fd0 <default_wake_function+0/20>
> Trace; c012beb0 <worker_thread+0/200>
> Trace; c0108d39 <kernel_thread_helper+5/c>
> 
Hmm... I cannot see how recent changes would have affected this, but
does the following patch help?

Thanks,
NeilBrown



 ----------- Diffstat output ------------
 ./drivers/block/ll_rw_blk.c |    2 ++
 1 files changed, 2 insertions(+)

diff ./drivers/block/ll_rw_blk.c~current~ ./drivers/block/ll_rw_blk.c
--- ./drivers/block/ll_rw_blk.c~current~	2003-02-18 16:38:49.000000000 +1100
+++ ./drivers/block/ll_rw_blk.c	2003-02-18 16:38:57.000000000 +1100
@@ -240,6 +240,8 @@ void blk_queue_make_request(request_queu
 	blk_queue_hardsect_size(q, 512);
 	blk_queue_dma_alignment(q, 511);
 
+	INIT_LIST_HEAD(&q->queue_head);
+
 	q->unplug_thresh = 4;		/* hmm */
 	q->unplug_delay = (3 * HZ) / 1000;	/* 3 milliseconds */
 	if (q->unplug_delay == 0)

