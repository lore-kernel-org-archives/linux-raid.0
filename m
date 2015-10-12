From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH 1/9] MD: fix info output for journal disk
Date: Mon, 12 Oct 2015 16:38:46 -0700
Message-ID: <20151012233846.GA3806623@devbig084.prn1.facebook.com>
References: <cover.1444360850.git.shli@fb.com>
 <2537e2bcb31eaf918df28f25d096b31c2b9daa70.1444360850.git.shli@fb.com>
 <87a8ro1wb0.fsf@notabene.neil.brown.name>
 <20151012170148.GA3081164@devbig084.prn1.facebook.com>
 <87si5fzn1r.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87si5fzn1r.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Tue, Oct 13, 2015 at 10:26:08AM +1100, Neil Brown wrote:
> Shaohua Li <shli@fb.com> writes:
> 
> > On Mon, Oct 12, 2015 at 04:37:55PM +1100, Neil Brown wrote:
> >> Shaohua Li <shli@fb.com> writes:
> >> 
> >> > journal disk can be faulty. The Journal and Faulty aren't exclusive with
> >> > each other.
> >> >
> >> > Signed-off-by: Shaohua Li <shli@fb.com>
> >> > ---
> >> >  drivers/md/md.c | 10 +++++++---
> >> >  1 file changed, 7 insertions(+), 3 deletions(-)
> >> >
> >> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> > index 0729cc7..daf42bb 100644
> >> > --- a/drivers/md/md.c
> >> > +++ b/drivers/md/md.c
> >> > @@ -5857,7 +5857,8 @@ static int get_disk_info(struct mddev *mddev, void __user * arg)
> >> >  		else if (test_bit(In_sync, &rdev->flags)) {
> >> >  			info.state |= (1<<MD_DISK_ACTIVE);
> >> >  			info.state |= (1<<MD_DISK_SYNC);
> >> > -		} else if (test_bit(Journal, &rdev->flags))
> >> > +		}
> >> > +		if (test_bit(Journal, &rdev->flags))
> >> >  			info.state |= (1<<MD_DISK_JOURNAL);
> >> >  		if (test_bit(WriteMostly, &rdev->flags))
> >> >  			info.state |= (1<<MD_DISK_WRITEMOSTLY);
> >> > @@ -7335,18 +7336,21 @@ static int md_seq_show(struct seq_file *seq, void *v)
> >> >  		rcu_read_lock();
> >> >  		rdev_for_each_rcu(rdev, mddev) {
> >> >  			char b[BDEVNAME_SIZE];
> >> > +			bool skip = false;
> >> >  			seq_printf(seq, " %s[%d]",
> >> >  				bdevname(rdev->bdev,b), rdev->desc_nr);
> >> >  			if (test_bit(WriteMostly, &rdev->flags))
> >> >  				seq_printf(seq, "(W)");
> >> >  			if (test_bit(Faulty, &rdev->flags)) {
> >> >  				seq_printf(seq, "(F)");
> >> > -				continue;
> >> > +				skip = true;
> >> >  			}
> >> >  			if (test_bit(Journal, &rdev->flags)) {
> >> >  				seq_printf(seq, "(J)");
> >> > -				continue;
> >> > +				skip = true;
> >> >  			}
> >> > +			if (skip)
> >> > +				continue;
> >> 
> >> Is this 'skip' stuff really needed?  What would go wrong if we just left
> >> it out?  An active journal will have raid_disk>=0 now won't it?  And
> >> if we don't support replacement of journals (which I suspect we
> >> shouldn't) then (R) will never get reported.
> >> 
> >> So can we just drop the 'skip'??
> >
> > Sounds good. Let me know if I should resend this one alone or the
> > series.
> 
> Just send this one alone.  I'll apply the rest from the previous
> posting.
> 
> I'm not entirely convinced about the race issue, but I don't really
> want to think about it today and as you seem certain we will go with the
> current code for now.
> If I think of something that does convince me, it can always be fixed
> later.

Cool, thanks!
