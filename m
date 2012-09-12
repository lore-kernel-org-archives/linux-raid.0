From: Shaohua Li <shli@kernel.org>
Subject: Re: [RFC 1/2]raid1: only write mismatch sectors in sync
Date: Wed, 12 Sep 2012 13:29:41 +0800
Message-ID: <20120912052941.GA15827@kernel.org>
References: <20120726080150.GA21457@kernel.org>
 <20120731155304.11c40f9b@notabene.brown>
 <CANejiEWZk6JcErw9Y6cqpotYMypQA_jvv8N0612FBq81Lo8jVQ@mail.gmail.com>
 <20120911105908.51681433@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120911105908.51681433@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 11, 2012 at 10:59:08AM +1000, NeilBrown wrote:
> On Tue, 31 Jul 2012 16:12:04 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > 2012/7/31 NeilBrown <neilb@suse.de>:
> > > On Thu, 26 Jul 2012 16:01:50 +0800 Shaohua Li <shli@kernel.org> wrote:
> > >
> > >> Write has some impacts to SSD:
> > >> 1. wear out flash. Frequent write can speed out the progress.
> > >> 2. increase the burden of garbage collection of SSD firmware. If no space
> > >> left for write, SSD firmware garbage collection will try to free some space.
> > >> 3. slow down subsequent write. After write SSD to some extents (for example,
> > >> write the whole disk), subsequent write will slow down significantly (because
> > >> almost every write invokes garbage collection in such case).
> > >>
> > >> We want to avoid unnecessary write as more as possible. raid sync generally
> > >> involves a lot of unnecessary write. For example, even two disks don't have
> > >> any data, we write the second disk for the whole disk size.
> > >>
> > >> To reduce write, we always compare raid disk data and only write mismatch part.
> > >> This means sync will have extra IO read and memory compare. So this scheme is
> > >> very bad for hard disk raid and sometimes SSD raid too if mismatch part is
> > >> majority. But sometimes this can be very helpful to reduce write, in that case,
> > >> since sync is rare operation, the extra IO/CPU usage is worthy paying. People
> > >> who want to use the feature should understand the risk first. So this ability
> > >> is off by default, a sysfs entry can be used to enable it.
> > >>
> > >> Signed-off-by: Shaohua Li <shli@fusionio.com>
> > >> ---
> > >>  drivers/md/md.c    |   41 +++++++++++++++++++++++++++++++
> > >>  drivers/md/md.h    |    3 ++
> > >>  drivers/md/raid1.c |   70 +++++++++++++++++++++++++++++++++++++++++++++++++----
> > >>  3 files changed, 110 insertions(+), 4 deletions(-)
> > >>
> > >> Index: linux/drivers/md/md.h
> > >> ===================================================================
> > >> --- linux.orig/drivers/md/md.h        2012-07-25 13:51:00.353775521 +0800
> > >> +++ linux/drivers/md/md.h     2012-07-26 10:36:38.500740552 +0800
> > >> @@ -325,6 +325,9 @@ struct mddev {
> > >>  #define      MD_RECOVERY_FROZEN      9
> > >>
> > >>       unsigned long                   recovery;
> > >> +#define MD_RECOVERY_MODE_REPAIR              0
> > >> +#define MD_RECOVERY_MODE_DISCARD     1
> > >> +     unsigned long                   recovery_mode;
> > >
> > > You have not documented the meaning of these two flags at all, and I don't
> > > feel up to guessing.
> > >
> > > The patch looks more complex that it should be.  The behaviour you are
> > > suggesting is exactly the behaviour you get when MD_RECOVERY_REQUESTED is
> > > set, so at most I expect to see a few places where that flag is tested
> > > changed to test something else as well.
> > >
> > > How would this be used?  It affects resync and resync happens as soon as the
> > > array is assembled.  So when and how would you set the flag which says
> > > "prefer reads to writes"?  It seems like it needs to be set in the metadata.
> > >
> > > BTW RAID10 already does this - it reads and compares for a normal sync.  So
> > > maybe just tell people to use raid10 if they want this behaviour?
> > 
> > It's true, the behavior likes MD_RECOVERY_REQUESTED, ie, read all disks,
> > only do write if two disk data not match. But I hope it works as soon as the
> > array is assembled. Surely we can set in the metadata, but I didn't want to
> > enable it by default, since even with SSD, the read-compare-write isn't optimal
> > some times, because it involves extra IO read and memory compare.
> > 
> > It appears MD_RECOVERY_REQUESTED assumes disks are insync.
> > It doesn't read disk !insync, so it doesn't work for assemble.
> > 
> > In my mind, user frozen the sync first (with sync_action setting), and then
> > enable read-compare-write, and finally continue the sync. I can't stop
> > a recovery and set MD_RECOVERY_REQUESTED, so I added a flag.
> > Anyway, please suggest what the preferred way for this.
> 
> I guess I just don't find this functionality at all convincing.  It isn't
> clear when anyone would use it, or how they would use it.  It seems best not
> to provide it.

The background is: For SSD, writting a hard formatted disk and fully filled
disk, the first case could be 300% faster than the second case depending on SSD
firmware and how fragmented the filled disk is. So this isn't a trival
performance issue.

The usage model is something like this: one disk is borken, add a new disk to
the raid. Currently we copy the whole disk of the first disk to the second. For
SSD, if the first disk and second disk have most data identical or most content
of the first is 0, the copy is very bad. In this scenario, we can avoid some
copy, which will make latter write to the disk faster. Thinking about 300%
faster :).

I don't think we can do this in underlayer. We don't want to do it always.
Detecting 0 is very expensive.

And this isn't intrusive to me. We only do the 'copy avoidness' in sync, and
sync is rare event.

I hope to convince you this is a useful functionality, then we can discuss the
implementation.

Thanks,
Shaohua
