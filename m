From: Neil Brown <neilb@suse.de>
Subject: Re: 2.6.20.3 AMD64 oops in CFQ code
Date: Fri, 23 Mar 2007 10:59:46 +1100
Message-ID: <17923.6258.855467.589548@notabene.brown>
References: <20070322184155.GY19922@kernel.dk>
	<20070322185413.13929.qmail@science.horizon.com>
	<20070322190052.GA19922@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jens Axboe on Thursday March 22
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux@horizon.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@dale.us, cebbert@redhat.com
List-Id: linux-raid.ids

On Thursday March 22, jens.axboe@oracle.com wrote:
> On Thu, Mar 22 2007, linux@horizon.com wrote:
> > > 3 (I think) seperate instances of this, each involving raid5. Is your
> > > array degraded or fully operational?
> > 
> > Ding! A drive fell out the other day, which is why the problems only
> > appeared recently.
> > 
> > md5 : active raid5 sdf4[5] sdd4[3] sdc4[2] sdb4[1] sda4[0]
> >       1719155200 blocks level 5, 64k chunk, algorithm 2 [6/5] [UUUU_U]
> >       bitmap: 149/164 pages [596KB], 1024KB chunk
> > 
> > H'm... this means that my alarm scripts aren't working.  Well, that's
> > good to know.  The drive is being re-integrated now.
> 
> Heh, at least something good came out of this bug then :-)
> But that's reaffirming. Neil, are you following this? It smells somewhat
> fishy wrt raid5.

Yes, I've been trying to pay attention....

The evidence does seem to point to raid5 and degraded arrays being
implicated.  However I'm having trouble finding how the fact that an array
is degraded would be visible down in the elevator except for having a
slightly different distribution of reads and writes.

One possible way is that if an array is degraded, then some read
requests will go through the stripe cache rather than direct to the
device.  However I would more expect the direct-to-device path to have
problems as it is much newer code.  Going through the cache for reads
is very well tested code - and reads come from the cache for most
writes anyway, so the elevator will still see lots of single-page.
reads.  It only ever sees single-page write.

There might be more pressure on the stripe cache when running
degraded, so we might call the ->unplug_fn a little more often, but I
doubt that would be noticeable.

As you seem to suggest by the patch, it does look like some sort of
unlocked access to the cfq_queue structure.  However apart from the
comment before cfq_exit_single_io_context being in the wrong place
(should be before __cfq_exit_single_io_context) I cannot see anything
obviously wrong with the locking around that structure.

So I'm afraid I'm stumped too. 

NeilBrown

> 
> I wonder if this triggers anything?
> 
> --- linux-2.6.20.3/block/ll_rw_blk.c~	2007-03-22 19:59:17.128833635 +0100
> +++ linux-2.6.20.3/block/ll_rw_blk.c	2007-03-22 19:59:28.850045490 +0100
> @@ -1602,6 +1602,8 @@
>   **/
>  void generic_unplug_device(request_queue_t *q)
>  {
> +	WARN_ON(irqs_disabled());
> +
>  	spin_lock_irq(q->queue_lock);
>  	__generic_unplug_device(q);
>  	spin_unlock_irq(q->queue_lock);
> 
> -- 
> Jens Axboe
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
