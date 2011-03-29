From: Tejun Heo <tj@kernel.org>
Subject: Re: raid1 boot regression in 2.6.37 [bisected]
Date: Tue, 29 Mar 2011 12:07:44 +0200
Message-ID: <20110329100744.GK6736@htj.dyndns.org>
References: <201103251725.21180.thomas.jarosch@intra2net.com>
 <4D90E580.7020406@intra2net.com>
 <20110329082503.GI6736@htj.dyndns.org>
 <201103291153.06495.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201103291153.06495.thomas.jarosch@intra2net.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Tue, Mar 29, 2011 at 11:53:06AM +0200, Thomas Jarosch wrote:
> On Tuesday, 29. March 2011 10:25:03 Tejun Heo wrote:
> > Can you please apply the following patch and see whether it resolves
> > the problem and report the boot log?
> 
> Ok, I did the following:
> - Check out commit e804ac780e2f01cb3b914daca2fd4780d1743db1
>   (md: fix and update workqueue usage)
> - Apply your patch
> - Add small debug output on top of it:
> 
> ------------------------------
> # git diff
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1e6534d..d2ddef4 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5899,6 +5899,16 @@ static int md_open(struct block_device *bdev, fmode_t mode)
>                                 once = true;
>                         }
>                 }
> +               /* DEBUG HACK */
> +               {
> +                   static bool tomj_once = false;
> +                   if (!tomj_once)
> +                   {
> +                               printk("TOMJ %s: md_open(): RT prio, pol=%u p=%d rt_p=%u\n",
> +                                      current->comm, current->policy, current->static_prio, current->rt_priority);
> +                       tomj_once = true;
> +                   }
> +               }
>                 msleep(10);
>                 /* Wait until bdev->bd_disk is definitely gone */
>                 flush_workqueue(md_misc_wq);
...
> TOMJ blkid: md_open(): RT prio, pol=0 p=118 rt_p=0
...
> As you can see, your printk() is not triggered(). I just
> copied your printk and made it print once unconditionally.
> 
> So probably the msleep(10); does the trick. Something
> seems very racy to me as other boxes with software RAID
> can boot the exact same kernel + dracut version just fine.
> 
> I'll put the box in a reboot loop over the lunch break.

Hmmm.. interesting, so no RT task there.  I don't know why the
softlockup is triggering then.  Ah, okay, none of CONFIG_PREEMPT and
CONFIG_PREEMPT_VOLUNTARY is set, right?

Anyways, the root cause here is that md_open() -ERESTARTSYS retrying
is busy looping without giving the put path a chance to run.  When it
was using flush_scheduled_work(), there were some unrelated work items
there so it ended up sleeping by accident giving the put path a chance
to run.  With the conversion, the flush domain is reduced and there's
nothing unrelated to wait for so it just busy loops.

Neil, we can put a short unconditional sleep there or somehow ensure
work item is queued before the restart loop engages.  What do you
think?

Thanks.

-- 
tejun
