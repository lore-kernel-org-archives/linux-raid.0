From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: detecting read errors after RAID1 check operation
Date: Sat, 25 Aug 2007 10:27:46 -0400
Message-ID: <170fa0d20708250727j21b6e65ds8c7fc5fe9f20bcde@mail.gmail.com>
References: <18117.838.460416.573228@notabene.brown>
	 <28851.1187386297@mdt.ecitele.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <28851.1187386297@mdt.ecitele.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Mike Accetta <maccetta@laurelnetworks.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/17/07, Mike Accetta <maccetta@laurelnetworks.com> wrote:
>
> Neil Brown writes:
> > On Wednesday August 15, maccetta@laurelnetworks.com wrote:
> > > Neil Brown writes:
> > > > On Wednesday August 15, maccetta@laurelnetworks.com wrote:
> > > > >
> > > ...
> > > This happens in our old friend sync_request_write()?  I'm dealing with
> >
> > Yes, that would be the place.
> >
> > > ...
> > > This fragment
> > >
> > >     if (j < 0 || test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {
> > >             sbio->bi_end_io = NULL;
> > >             rdev_dec_pending(conf->mirrors[i].rdev, mddev);
> > >     } else {
> > >             /* fixup the bio for reuse */
> > >             ...
> > >     }
> > >
> > > looks suspicously like any correction attempt for 'check' is being
> > > short-circuited to me, regardless of whether or not there was a read
> > > error.  Actually, even if the rewrite was not being short-circuited,
> > > I still don't see the path that would update 'corrected_errors' in this
> > > case.  There are only two raid1.c sites that touch 'corrected_errors', one
> > > is in fix_read_errors() and the other is later in sync_request_write().
> > > With my limited understanding of how this all works, neither of these
> > > paths would seem to apply here.
> >
> > hmmm.... yes....
> > I guess I was thinking of the RAID5 code rather than the RAID1 code.
> > It doesn't do the right thing does it?
> > Maybe this patch is what we need.  I think it is right.
> >
> > Thanks,
> > NeilBrown
> >
> >
> > Signed-off-by: Neil Brown <neilb@suse.de>
> >
> > ### Diffstat output
> >  ./drivers/md/raid1.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
> > --- .prev/drivers/md/raid1.c  2007-08-16 10:29:58.000000000 +1000
> > +++ ./drivers/md/raid1.c      2007-08-17 12:07:35.000000000 +1000
> > @@ -1260,7 +1260,8 @@ static void sync_request_write(mddev_t *
> >                                       j = 0;
> >                               if (j >= 0)
> >                                       mddev->resync_mismatches += r1_bio->sec
> > tors;
> > -                             if (j < 0 || test_bit(MD_RECOVERY_CHECK, &mddev
> > ->recovery)) {
> > +                             if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mdde
> > v->recovery)
> > +                                           && text_bit(BIO_UPTODATE, &sbio->
> > bi_flags))) {
> >                                       sbio->bi_end_io = NULL;
> >                                       rdev_dec_pending(conf->mirrors[i].rdev,
> >  mddev);
> >                               } else {
>
> I tried this (with the typo fixed) and it indeed issues a re-write.
> However, it doesn't seem to do anything with the corrected errors
> count if the rewrite succeeds.  Since end_sync_write() is only used one
> other place when !In_sync, I tried the following and it seems to work
> to get the error count updated.  I don't know whether this belongs in
> end_sync_write() but I'd think it needs to come after the write actually
> succeeds so that seems like the earliest it could be done.

Neil,

Any feedback on Mike's patch?

thanks,
Mike
