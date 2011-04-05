From: NeilBrown <neilb@suse.de>
Subject: Re: raid1 boot regression in 2.6.37 [bisected]
Date: Tue, 5 Apr 2011 13:46:29 +1000
Message-ID: <20110405134629.664b946c@notabene.brown>
References: <201103251725.21180.thomas.jarosch@intra2net.com>
	<4D90E580.7020406@intra2net.com>
	<20110329082503.GI6736@htj.dyndns.org>
	<201103291153.06495.thomas.jarosch@intra2net.com>
	<20110329100744.GK6736@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110329100744.GK6736@htj.dyndns.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Jarosch <thomas.jarosch@intra2net.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 29 Mar 2011 12:07:44 +0200 Tejun Heo <tj@kernel.org> wrote:

> On Tue, Mar 29, 2011 at 11:53:06AM +0200, Thomas Jarosch wrote:
> > On Tuesday, 29. March 2011 10:25:03 Tejun Heo wrote:
> > > Can you please apply the following patch and see whether it resolves
> > > the problem and report the boot log?
> > 
> > Ok, I did the following:
> > - Check out commit e804ac780e2f01cb3b914daca2fd4780d1743db1
> >   (md: fix and update workqueue usage)
> > - Apply your patch
> > - Add small debug output on top of it:
> > 
> > ------------------------------
> > # git diff
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 1e6534d..d2ddef4 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -5899,6 +5899,16 @@ static int md_open(struct block_device *bdev, fmode_t mode)
> >                                 once = true;
> >                         }
> >                 }
> > +               /* DEBUG HACK */
> > +               {
> > +                   static bool tomj_once = false;
> > +                   if (!tomj_once)
> > +                   {
> > +                               printk("TOMJ %s: md_open(): RT prio, pol=%u p=%d rt_p=%u\n",
> > +                                      current->comm, current->policy, current->static_prio, current->rt_priority);
> > +                       tomj_once = true;
> > +                   }
> > +               }
> >                 msleep(10);
> >                 /* Wait until bdev->bd_disk is definitely gone */
> >                 flush_workqueue(md_misc_wq);
> ...
> > TOMJ blkid: md_open(): RT prio, pol=0 p=118 rt_p=0
> ...
> > As you can see, your printk() is not triggered(). I just
> > copied your printk and made it print once unconditionally.
> > 
> > So probably the msleep(10); does the trick. Something
> > seems very racy to me as other boxes with software RAID
> > can boot the exact same kernel + dracut version just fine.
> > 
> > I'll put the box in a reboot loop over the lunch break.
> 
> Hmmm.. interesting, so no RT task there.  I don't know why the
> softlockup is triggering then.  Ah, okay, none of CONFIG_PREEMPT and
> CONFIG_PREEMPT_VOLUNTARY is set, right?
> 
> Anyways, the root cause here is that md_open() -ERESTARTSYS retrying
> is busy looping without giving the put path a chance to run.  When it
> was using flush_scheduled_work(), there were some unrelated work items
> there so it ended up sleeping by accident giving the put path a chance
> to run.  With the conversion, the flush domain is reduced and there's
> nothing unrelated to wait for so it just busy loops.
> 
> Neil, we can put a short unconditional sleep there or somehow ensure
> work item is queued before the restart loop engages.  What do you
> think?

(sorry for delay - leave and stuff...)

I don't think we should need to add a sleep - it should work as is.
Obviously it doesn't so I must be missing something, but I would like to find
out what it is to make sure I fix the right thing.

The interesting race is between md_open and mddev_put.
After mddev_put has made a firm decision to discard the mddev and consequently
del_gendisk, __blkdev_get can find the gendisk and try to re-open it.
This will find a different (new) mddev which is a problem.
So we return -ERESTARTSYS in that case so the lookup for a gendisk will be
retried.

The mddev_find in md_open will only return a new mddev after taking
all_mddevs_lock and finding that the old mddev is no longer available.
This must be after mddev_put has dropped the lock, and so after
queue_work has been called.

After mddev_find returns the new mddev, md_open calls flush_workqueue
and as the work item to complete the delete has definitely been queued, it
should wait for that work item to complete.

So the next time around the retry loop in __blkdev_get the old gendisk will
not be found....

Where is my logic wrong??

To put it another way matching your description Tejun, the put path has a
chance to run firstly while mddev_find is waiting for the spinlock, and then
while flush_workqueue is waiting for the rest of the put path to complete.


Thanks for any light you can shed on this...

NeilBrown
