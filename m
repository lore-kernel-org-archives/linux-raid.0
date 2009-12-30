From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: raid0/jbod/lvm, sorta?
Date: Wed, 30 Dec 2009 08:15:55 -0600
Message-ID: <20091230141555.GA26135@septictank.raw-sewage.fake>
References: <20091230000357.GA23485@septictank.raw-sewage.fake> <52.81.08392.151EA3B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52.81.08392.151EA3B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Dec 29, 2009 at 11:12:42PM -0600, Leslie Rhorer wrote:
> > I.e., similar to RAID-0, but if one drive dies, all data (but
> > that on the failed drive) is still readily available?
> 
> I can't imagine why anyone would want this.  If your data isn't
> important - and the fact one is sanguine about losing any random
> fraction of it argues this quite strongly - then RAID 0 fits the
> bill.  If maintaining the data is important, then one needs
> redundancy.

Well, I do have real backups.  So in my vision, I wouldn't really be
losing data, just temporarily without it.

The point was to minimize data restore in the case of a failure.
Say I have a 10 x 1 GB RAID-0 array.  That's 10 GB I have to restore
in the case of a drive failure.  In my scenario, I only have to
restore 1 GB.

> > I currently have a four-disc RAID5 device for media storage.
> > The typical usage pattern is few writes, many reads, lots of
> > idle time.  I got to thinking, with proper backups, RAID really
> > only buys me availability or performance, neither of which are a
> > priority.
> 
> RAID 0 provides neither, and is designed only to provide
> additional storage capacity.

I was under the impression that most people used RAID-0 for the
performance benefits?  I.e., multiple spindles.

> > So I have four discs constantly running, using a fair amount of
> > power.  And I need more space, so the power consumption only
> > goes up.
> 
> Get lower power drives.  WD green drives use much less power than
> any other drive I have tried, but if you find drives with even
> lower consumption, go with them.  Of course, SSDs have even lower
> power consumption, but are quite expensive.

Those are exactly what I have. :) See notes[1] below.

> > and (2) I felt that having all four discs spinup
> > was too much wear and tear on the drives, when, in principle, only
> > one drive needed to spin up.
> 
> This isn't generally going to be true.  First of all, the odds are
> moderately high the data you seek is going to span multiple
> drives, even if it is not striped.

In my vision, each file would be strictly written to only one
physical device.

> Secondly, at a very minimum the superblocks and directory
> structures are going to have to be read multiple times.  These are
> very likely to span 2 or 3 drives or even more.

While I'm dreaming, I might as well add that either this information
is mirrored across all drives and/or cached in RAM.  :)

> > I know I could do this manually with symlinks.  E.g., have a
> > directory like /bigstore that contains symlinks into
> > /mnt/drive1, /mnt/drive2, /mnt/drive3, etc.
> 
> Well, that would work for reading the files, but not for much
> else.  File creations would be almost nightmarish, and file writes
> would be fraught with disaster.  What happens when the "array" has
> plenty of space, but one drive has less than enough to write the
> entire file?  In general, one cannot know a-priori how much space
> a file will take unless it is simply being copied from one place

I guess I didn't think about the general file writing case.  For me,
99% of all files are put on my array via simple copy.  So the exact
file size is known in advance.

In the general file creation/file writing case, I guess I'd just
pick the drive with the most free space, and start writing.  If that
drive runs out of space, writes simply fail.  Although, I can see
how this would drive people insane, seeing their file writes fail
when, "df" says they have plenty of free space!  (Maybe, for the
purposes of tools like "df", free space would be equal to the
largest amount of free space on a single drive.  E.g., if you have
9 drives with 1 GB free, and 1 with 2 GB free, df says you have 2 GB
free.)

> to another.  For that matter, what happens when all 10 drives in
> the array have 1G left on them, and one wishes to write a 5G file?

You have to buy a new drive, delete files off an existing drive, or
maybe even have some fancy "defrag"-like utility that shuffles whole
files around the drives.

> I think the very limited benefits of what you seek are far
> outweighed by the pitfalls and trouble of implementing it.  It
> might be possible to cache the drive structures somewhere and then
> attempt to only spin up the required drives, but a fragmented
> semi-array is a really bad idea, if you ask me.  Even attempting
> the former woud require a much closer association between the file
> systems and the underlying arrays than is now the case, and
> perhaps moreso than is prudent.

Now that you point out the more general use cases of what I was
describing, I agree it's definitely not trivial.  I wasn't really
suggesting someone go off and implement this, as much as seeing if
something already existed.  I'll probably look into the UnionFS, as
many people suggested.  Or, for my narrow requirements, I could
probably get away with manual management and some simple scripts.  I
might not even need that, as, e.g., MythTV can be pointed to a root
directory and find all files below (at least for pre-existing
files).  <shrug>

[1] Regarding the WD GreenPower drives.  I don't get the full
    benefit of these drives, because the "head parking" feature of
    those drives doesn't really work for me.  I started a discussion
    on this a while ago, but the gist is: the heads will
    park/unload, but only briefly.  Generally within five minutes,
    something causes them to unpark.  I was unable to track down
    what caused that.

    Said discussion was titled "linux disc access when idle", on
    this mailing list:
    http://marc.info/?l=linux-raid&m=125078611926294&w=2

    Even without the head parking, they are still among the lowest
    powered drives, although the 5900rpm drives from Seagate and
    5400rpm "EcoGreen" from Samsung are similar.  This according to
    SilentPCReview.com, whose results are consistent with my
    experience.

