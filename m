From: Song Liu <songliubraving@fb.com>
Subject: RE: [PATCH 7/8] md: skip resync for raid array with journal
Date: Thu, 1 Oct 2015 17:47:38 +0000
Message-ID: <C709E4D363AAB64590BFAC54D4C478AA0104B82A61@PRN-MBX02-4.TheFacebook.com>
References: <cover.1441221530.git.shli@fb.com>
 <7c5622ab3335f31a27f807d8fee27f8bb60675ae.1441221530.git.shli@fb.com>
 <871tdgmt4w.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871tdgmt4w.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, Shaohua Li <shli@fb.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: Kernel Team <Kernel-team@fb.com>, "hch@infradead.org" <hch@infradead.org>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Tuesday, September 29, 2015 9:25 PM
> To: Shaohua Li; linux-raid@vger.kernel.org
> Cc: Kernel Team; Song Liu; hch@infradead.org; dan.j.williams@intel.com
> Subject: Re: [PATCH 7/8] md: skip resync for raid array with journal
> 
> Shaohua Li <shli@fb.com> writes:
> 
> > If a raid array has journal, the journal can guarantee the
> > consistency, we can skip resync after a unclean shutdown. The
> > exception is raid creation or user initiated resync, which we still do a raid
> resync.
> >
> > Signed-off-by: Shaohua Li <shli@fb.com>
> > ---
> >  drivers/md/md.c | 4 ++++
> >  drivers/md/md.h | 1 +
> >  2 files changed, 5 insertions(+)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c index b3f9eed..95824fb
> > 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -1669,6 +1669,8 @@ static int super_1_validate(struct mddev *mddev,
> struct md_rdev *rdev)
> >  			}
> >  			set_bit(Journal, &rdev->flags);
> >  			rdev->journal_tail = le64_to_cpu(sb->journal_tail);
> > +			if (mddev->recovery_cp == MaxSector)
> > +				set_bit(MD_JOURNAL_CLEAN, &mddev-
> >flags);
> >  			break;
> >  		default:
> >  			rdev->saved_raid_disk = role;
> > @@ -1711,6 +1713,8 @@ static void super_1_sync(struct mddev *mddev,
> struct md_rdev *rdev)
> >  	sb->events = cpu_to_le64(mddev->events);
> >  	if (mddev->in_sync)
> >  		sb->resync_offset = cpu_to_le64(mddev->recovery_cp);
> > +	else if (test_bit(MD_JOURNAL_CLEAN, &mddev->flags))
> > +		sb->resync_offset = cpu_to_le64(MaxSector);
> >  	else
> >  		sb->resync_offset = cpu_to_le64(0);
> >
> > diff --git a/drivers/md/md.h b/drivers/md/md.h index 226f4ba..0288a0b
> > 100644
> > --- a/drivers/md/md.h
> > +++ b/drivers/md/md.h
> > @@ -236,6 +236,7 @@ struct mddev {
> >  #define MD_STILL_CLOSED	4	/* If set, then array has not been
> opened since
> >  				 * md_ioctl checked on it.
> >  				 */
> > +#define MD_JOURNAL_CLEAN 5	/* A raid with journal is already clean
> */
> >
> >  	int				suspended;
> >  	atomic_t			active_io;
> > --
> > 1.8.1
> 
> This looks right as far as it goes, but I don't think it goes far enough.
> The particular scenario that bothers me is if the array is started without the
> journal being present.
> I cannot see anything to prevent that - is there?

I have sent mdadm patches that prevent the array to assemble with missing 
journal, for both --assemble and --incremental:

http://marc.info/?l=linux-raid&m=144080445720123
http://marc.info/?l=linux-raid&m=144080446120127 

We can force start in both cases with --force or --run. 

Currently, mdadm doesn't clear MD_FEATURE_JOURNAL bit, so we get warning 
every time. 

I did miss one step: to mark the missing journal as fault. 

> 
> In that case we need to assume that the array is not in-sync, and we need to
> clear MD_FEATURE_JOURNAL so if it gets stopped and then assembled again
> with the stale journal doesn't get used.
> 
> One unfortunate side effect of that is that you couldn't stop the array cleanly
> (leaving the journal effectively empty) and then restart with no journal and
> no resync.  Is that a problem I wonder?
> 
> I'm not sure what the best solution is here, but we need a clear
> understanding of what happens if you try to assemble an array without the
> journal where previously it had one, and I don't think the current code gets it
> right.

I just talked with Shaohua. We think we can probably do the following:

1. When assemble with cache device missing, show the warning (with --force 
option). Run resync if previous shutdown is not clean (this is the default
behavior. 

2. When we get I/O error on the journal device at run time, make the whole
array as read only. 

3. Add new operation that adds new journal device to an array with missing 
journal. We can limit this option to inactive array only. 

Would this follow cover all the cases?

Thanks,
Song

