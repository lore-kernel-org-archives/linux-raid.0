From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: Re: BUG  - raid 1 deadlock on handle_read_error / wait_barrier
Date: Tue, 26 Feb 2013 09:09:26 -0500 (EST)
Message-ID: <alpine.DEB.2.02.1302260905390.1736@jlaw-desktop.mno.stratus.com>
References: <1361487504.4863.54.camel@linux-lxtg.site>  <20130225094350.4b8ef084@notabene.brown>  <20130225110458.2b1b1e2d@notabene.brown> <1361808662.20264.4.camel@148>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1361808662.20264.4.camel@148>
Sender: linux-raid-owner@vger.kernel.org
To: Tregaron Bayly <tbayly@bluehost.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Same here:  after ~15 hrs, ~300 surprise device removals and fio stress, 
no hung tasks to report.

-- Joe

On Mon, 25 Feb 2013, Tregaron Bayly wrote:

> > Actually  don't bother.  I think I've found the problem.  It is related to
> > pending_count and is easy to fix.
> > Could you try this patch please?
> > 
> > Thanks.
> > NeilBrown
> > 
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index 6e5d5a5..fd86b37 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -967,6 +967,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
> >  		bio_list_merge(&conf->pending_bio_list, &plug->pending);
> >  		conf->pending_count += plug->pending_cnt;
> >  		spin_unlock_irq(&conf->device_lock);
> > +		wake_up(&conf->wait_barrier);
> >  		md_wakeup_thread(mddev->thread);
> >  		kfree(plug);
> >  		return;
> 
> Running 15 hours now and no sign of the problem, which is 12 hours
> longer than it took to trigger the bug in the past.  I'll continue
> testing to be sure but I think this patch is a fix.
> 
> Thanks for the fast response!
> 
> Tregaron Bayly
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
