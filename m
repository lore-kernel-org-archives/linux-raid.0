From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: raid0/jbod/lvm, sorta?
Date: Wed, 30 Dec 2009 12:25:45 -0600
Message-ID: <A3.AF.07989.03B9B3B4@cdptpa-omtalb.mail.rr.com>
References: <20091230141555.GA26135@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091230141555.GA26135@septictank.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: 'Matt Garman' <matthew.garman@gmail.com>, 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> On Tue, Dec 29, 2009 at 11:12:42PM -0600, Leslie Rhorer wrote:
> > > I.e., similar to RAID-0, but if one drive dies, all data (but
> > > that on the failed drive) is still readily available?
> >
> > I can't imagine why anyone would want this.  If your data isn't
> > important - and the fact one is sanguine about losing any random
> > fraction of it argues this quite strongly - then RAID 0 fits the
> > bill.  If maintaining the data is important, then one needs
> > redundancy.
> 
> Well, I do have real backups.  So in my vision, I wouldn't really be
> losing data, just temporarily without it.

	Surely, and this is always the case (one hopes) when one has valid
backups.

> The point was to minimize data restore in the case of a failure.
> Say I have a 10 x 1 GB RAID-0 array.  That's 10 GB I have to restore
> in the case of a drive failure.  In my scenario, I only have to
> restore 1 GB.

	While I can certainly empathize with the desire to limit one's
workload when a failure occurs, I think one should weigh the extra effort
required in such an eventuality with the management issues encountered in
achieving such a goal.  Drive failures are a fairly rare event.  The daily
hassle of trying to deal with a fragmented drive topology I feel would far
exceed the hassle of a very occasional large restore event.

> > > I currently have a four-disc RAID5 device for media storage.
> > > The typical usage pattern is few writes, many reads, lots of
> > > idle time.  I got to thinking, with proper backups, RAID really
> > > only buys me availability or performance, neither of which are a
> > > priority.
> >
> > RAID 0 provides neither, and is designed only to provide
> > additional storage capacity.
> 
> I was under the impression that most people used RAID-0 for the
> performance benefits?  I.e., multiple spindles.

	Some do, yes, as that is one benefit.  Also, in come cases a group
of smaller drives may be less expensive than one larger drive, although
these days the largest drive size is also the least expensive per byte.  I
think most people who employ RAID0, however, do so primarily to allow for a
greater volume size.  Of course, there is nothing preventing one from having
all three benefits in mind, nor of enjoying all three benefits even if two
are not a priority.

> > > and (2) I felt that having all four discs spinup
> > > was too much wear and tear on the drives, when, in principle, only
> > > one drive needed to spin up.
> >
> > This isn't generally going to be true.  First of all, the odds are
> > moderately high the data you seek is going to span multiple
> > drives, even if it is not striped.
> 
> In my vision, each file would be strictly written to only one
> physical device.

	That's pretty inefficient.

> > Secondly, at a very minimum the superblocks and directory
> > structures are going to have to be read multiple times.  These are
> > very likely to span 2 or 3 drives or even more.
> 
> While I'm dreaming, I might as well add that either this information
> is mirrored across all drives and/or cached in RAM.  :)

	Surely, but again in order to implement such a scenario, the file
system layer is going to have to tell the array system layer where to put
each mirror, requiring it to have a knowledge of the underlying topology the
file system does not normally have.  Alternately, the info could be cached
in memory, of course, but ether way the file system is going to have to be
designed with this specifically in mind.  The array ordinarily has no idea
what blocks to be written are associated with which file, and the file
system may be writing multiple files simultaneously.

> > > I know I could do this manually with symlinks.  E.g., have a
> > > directory like /bigstore that contains symlinks into
> > > /mnt/drive1, /mnt/drive2, /mnt/drive3, etc.
> >
> > Well, that would work for reading the files, but not for much
> > else.  File creations would be almost nightmarish, and file writes
> > would be fraught with disaster.  What happens when the "array" has
> > plenty of space, but one drive has less than enough to write the
> > entire file?  In general, one cannot know a-priori how much space
> > a file will take unless it is simply being copied from one place
> 
> I guess I didn't think about the general file writing case.  For me,
> 99% of all files are put on my array via simple copy.  So the exact
> file size is known in advance.

	By you, yes, but not necessarily by the file system.  I don't think
most file systems check beforehand whether the file being written just
happens to be a copy and there just happens to be enough room for the copy
to finish.  Of course, backup utilities often do this very thing, but that
is a specialized application.  File systems are generally designed to handle
the more general cases effectively, rather than targeting efficiency for
special cases.  That said, you might find one which has tuning available for
the more specific cases.  Some file systems these days are also staring to
take more notice of the underlying topology and the developers of both array
utilities and file systems are starting to have their system talk more
loquaciously to one another.

> In the general file creation/file writing case, I guess I'd just
> pick the drive with the most free space, and start writing.  If that
> drive runs out of space, writes simply fail.

	See my comment above and the one I posted previously below.

> Although, I can see
> how this would drive people insane, seeing their file writes fail
> when, "df" says they have plenty of free space!  (Maybe, for the
> purposes of tools like "df", free space would be equal to the
> largest amount of free space on a single drive.  E.g., if you have
> 9 drives with 1 GB free, and 1 with 2 GB free, df says you have 2 GB
> free.)

	See my comments above and below, twice.

> > to another.  For that matter, what happens when all 10 drives in
> > the array have 1G left on them, and one wishes to write a 5G file?
> 
> You have to buy a new drive, delete files off an existing drive, or
> maybe even have some fancy "defrag"-like utility that shuffles whole
> files around the drives.

	Have my comments above and below tattooed on your eyelids.  Dealing
with such issues on a regular basis would be a monumental headache,
especially when the failing writes may be autonomous.  I suppose you could
keep a fairly large "scratch" drive (or small array) for general purpose
reads and writes, along with some number of mounted "permanent" drives.  You
could write a simple script which is run against any files you want to have
on the permanent system that checks to see where the file will fit, copies
it, and then creates the symlinks in a specialized directory.

	For example, you could create three directories, one /Permanent, one
/Transition, and one /OverSize on your scratch drive / array.  Any file you
wish to put on a permanent drive you can simply either create in the
/Transition directory in the first place, or else move to the /Transition
directory when you want to make the file "permanent".  Have a cron job run
every few minutes or so that checks the /Transition directory for files that
are there and not opened by any other process.  Have the script determine
the drive with the largest free space, make sure it will fit, and then move
the file, creating a symlink in /Permanent.  If it won't fit, have the
script notify the admin via e-mail and move the file over to the /OverSize
directory.  Note any application which thinks it knows where to find the
files won't be able to do so any longer.

> > I think the very limited benefits of what you seek are far
> > outweighed by the pitfalls and trouble of implementing it.  It
> > might be possible to cache the drive structures somewhere and then
> > attempt to only spin up the required drives, but a fragmented
> > semi-array is a really bad idea, if you ask me.  Even attempting
> > the former woud require a much closer association between the file
> > systems and the underlying arrays than is now the case, and
> > perhaps moreso than is prudent.

> Now that you point out the more general use cases of what I was
> describing, I agree it's definitely not trivial.  I wasn't really
> suggesting someone go off and implement this, as much as seeing if
> something already existed.  I'll probably look into the UnionFS, as
> many people suggested.  Or, for my narrow requirements, I could
> probably get away with manual management and some simple scripts.  I
> might not even need that, as, e.g., MythTV can be pointed to a root
> directory and find all files below (at least for pre-existing
> files).  <shrug>
> 
> [1] Regarding the WD GreenPower drives.  I don't get the full
>     benefit of these drives, because the "head parking" feature of
>     those drives doesn't really work for me.  I started a discussion
>     on this a while ago, but the gist is: the heads will
>     park/unload, but only briefly.  Generally within five minutes,
>     something causes them to unpark.  I was unable to track down
>     what caused that.
> 
>     Said discussion was titled "linux disc access when idle", on
>     this mailing list:
>     http://marc.info/?l=linux-raid&m=125078611926294&w=2
> 
>     Even without the head parking, they are still among the lowest
>     powered drives, although the 5900rpm drives from Seagate and
>     5400rpm "EcoGreen" from Samsung are similar.  This according to
>     SilentPCReview.com, whose results are consistent with my
>     experience.


