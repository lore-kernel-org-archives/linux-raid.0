From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.20.3 AMD64 oops in CFQ code
Date: Thu, 22 Mar 2007 20:00:52 +0100
Message-ID: <20070322190052.GA19922@kernel.dk>
References: <20070322184155.GY19922@kernel.dk> <20070322185413.13929.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070322185413.13929.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux@horizon.com
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>, linux-kernel@dale.us, cebbert@redhat.com
List-Id: linux-raid.ids

On Thu, Mar 22 2007, linux@horizon.com wrote:
> > 3 (I think) seperate instances of this, each involving raid5. Is your
> > array degraded or fully operational?
> 
> Ding! A drive fell out the other day, which is why the problems only
> appeared recently.
> 
> md5 : active raid5 sdf4[5] sdd4[3] sdc4[2] sdb4[1] sda4[0]
>       1719155200 blocks level 5, 64k chunk, algorithm 2 [6/5] [UUUU_U]
>       bitmap: 149/164 pages [596KB], 1024KB chunk
> 
> H'm... this means that my alarm scripts aren't working.  Well, that's
> good to know.  The drive is being re-integrated now.

Heh, at least something good came out of this bug then :-)
But that's reaffirming. Neil, are you following this? It smells somewhat
fishy wrt raid5.

I wonder if this triggers anything?

--- linux-2.6.20.3/block/ll_rw_blk.c~	2007-03-22 19:59:17.128833635 +0100
+++ linux-2.6.20.3/block/ll_rw_blk.c	2007-03-22 19:59:28.850045490 +0100
@@ -1602,6 +1602,8 @@
  **/
 void generic_unplug_device(request_queue_t *q)
 {
+	WARN_ON(irqs_disabled());
+
 	spin_lock_irq(q->queue_lock);
 	__generic_unplug_device(q);
 	spin_unlock_irq(q->queue_lock);

-- 
Jens Axboe

