From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID5 resync blocking on 2.6.0-test11
Date: Wed, 17 Mar 2004 10:23:03 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16471.35927.112459.636557@notabene.cse.unsw.edu.au>
References: <3FD90B15.8050905@campogeral.com.br>
	<3FDF691D.9090405@campogeral.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Fernando Serboncini on Tuesday December 16
To: Fernando Serboncini <fserb@campogeral.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday December 16, fserb@campogeral.com.br wrote:
> Fernando Serboncini wrote:
> > --- linux-2.6.0-test11/drivers/md/md.c  2003-11-26 18:43:29.000000000 -0200
> > +++ linux/drivers/md/md.c       2003-12-10 23:29:33.000000000 -0200
> > @@ -3290,6 +3290,8 @@
> >                 currspeed =
> > (j-mddev->resync_mark_cnt)/2/((jiffies-mddev->resync_mark)/HZ +1) +1;
> > 
> >                 if (currspeed > sysctl_speed_limit_min) {
> > +                       set_user_nice(current,19);
> > +
> >                         if ((currspeed > sysctl_speed_limit_max) ||
> >                                         !is_mddev_idle(mddev)) {
> >                                 current->state = TASK_INTERRUPTIBLE;
> > @@ -3297,6 +3299,8 @@
> >                                 goto repeat;
> >                         }
> >                 }
> > +               else
> > +                       set_user_nice(current,-20);
> >         }
> >         printk(KERN_INFO "md: md%d: sync done.\n",mdidx(mddev));
> >         /*
> > 
> 
> For what've seen, this causes no harm at all.
> Can anyone confirm that this is the right thing to do with the 
> "blocking" issue?

Sorry for not replying earlier.  I was on leave in December and never
got  back to this.

This shouldn't be needed any longer.  Have you tried a recent kernel
without this patch?

Thanks,
NeilBrown
