From: Neil Brown <neilb@suse.de>
Subject: Re: 4.1-rc6 radi5 OOPS
Date: Sat, 13 Jun 2015 14:26:00 +1000
Message-ID: <20150613142600.27da358d@home.neil.brown.name>
References: <wrfjlhg0mtmi.fsf@jes.lga.redhat.com>
	<20150604064048.0cb2d7c9@notabene.brown>
	<wrfjzj4glajs.fsf@jes.lga.redhat.com>
	<20150610101942.0bc26a25@home.neil.brown.name>
	<20150610115721.64c474fa@home.neil.brown.name>
	<wrfjk2vbv894.fsf@carbonite.lan.trained-monkey.org>
	<20150611164847.7cd87c13@home.neil.brown.name>
	<wrfj1thg4mrp.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfj1thg4mrp.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>
List-Id: linux-raid.ids

On Fri, 12 Jun 2015 17:52:58 -0400
Jes Sorensen <Jes.Sorensen@redhat.com> wrote:

> Neil Brown <neilb@suse.de> writes:
> > On Wed, 10 Jun 2015 12:27:35 -0400
> > Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> >
> >> Neil Brown <neilb@suse.de> writes:
> >> > On Wed, 10 Jun 2015 10:19:42 +1000 Neil Brown <neilb@suse.de> wrote:
> >> >
> >> >> So it looks like some sort of race.  I have other evidence of a race
> >> >> with the resync/reshape thread starting/stopping.  If I track that
> >> >> down it'll probably fix this issue too.
> >> >
> >> > I think I have found just such a race.  If you request a reshape just
> >> > as a recovery completes, you can end up with two reshapes running.
> >> > This causes confusion :-)
> >> >
> >> > Can you try this patch?  If I can remember how to reproduce my race
> >> > I'll test it on that too.
> >> >
> >> > Thanks,
> >> > NeilBrown
> >> 
> >> Hi Neil,
> >> 
> >> Thanks for the patch - I tried with this applied, but it still crashed
> >> for me :( I had to mangle it manually, somehow it got modified in the
> >> email.
> >
> > Very :-(
> >
> > I had high hopes for that patch.  I cannot find anything else that could lead
> > to what you are seeing.  I wish I could reproduce it but it is probably highly
> > sensitive to timing so some hardware shows it and others don't.
> >
> > It looks very much like two 'resync' threads are running at the same time.
> > When one finishes, it sets ->reshape_progress to -1 (MaxSector), which trips up
> > the other one.
> >
> > In the hang that I very rarely see, one thread (presumably) finishes and sets
> > MD_RECOVERY_DONE, so the raid5d threads waits for the resync thread to
> > complete, and that thread is waiting for the raid5d to retire some stripe_heads.
> >
> > ... though the 'resync' thread is probably actually doing a 'reshape'...
> 
> Neil
> 
> Good news - albeit not guaranteed yet. I tried with the full patch that
> you sent to Linus, and with that I haven't been able to reproduce the
> problem so far. I'll try and do some more testing over the weekend.
> 
> The patch I manually applied only had two hunks in it, the one you
> pushed to Linus looks a lot more complete :)

Thanks for testing.  I'm fairly sure you issue is fixed now, but it is very
nice to have it confirmed.

> 
> > Did you get a chance to bisect it?  I must admit that I doubt that would be
> > useful.  It probably starts when "md_start_sync" was introduced and maybe made
> > worse when some locking with mddev_lock was relaxed.
> >
> > The only way I can see a race is if MD_RECOVERY_DONE gets left set.  When a new
> > thread is started.  md_check_recovery always clears it before starting a thread,
> > but raid5_start_reshape doesn't - or didn't before the patch I gave you.
> >
> > It might make more sense to clear the bit in md_reap_sync_thread as below,
> > but if the first patch didn't work, this one is unlikely to.
> >
> > Would you be able to test with the following patch?  There is a chance it might
> > confirm whether two sync threads are running at the same time.
> 
> I can try with this patch on too, but I won't get to it before next
> week. It's been a week of non related MD issues.

Don't bother - that one is just an early version of one that went to Linus, so
you have tested the important bit.

Thanks,
NeilBrown


> 
> Thanks a lot!
> 
> Cheers,
> Jes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

