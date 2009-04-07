From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Tue, 7 Apr 2009 12:47:20 -0500
Message-ID: <20090407174723.LMYU4586.cdptpa-omta02.mail.rr.com@Leslie>
References: <49DA677C.2080009@hp.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49DA677C.2080009@hp.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > could tell without losing any additional files.  I'm not saying ext3
> cause
> > any of the problems, but it certainly allowed itself to be corrupted by
> > hardware issues.
> 
> Some observations from a filesystem guy lurking on this list...
> 
> You won't find a filesystem that can't be corrupted by bad hardware.

That's absolutely true, but a RAID array is supposed to be fault tolerant.
Now, I am well aware of the vast difference between fault tolerant and fault
proof, and I cannot begin to claim another file system would not have
suffered problems, but to my admittedly inexperienced (in the realm of ext3
and other Linux file systems) eye, a journal which thinks the device is
bigger than it really is after an array expansion causing a loss of data
seems pretty frail.  It's not like there was an actual array failure or any
number of bad blocks associated with the event.  It also left a  bit of a
bad taste in my mouth that fsck could not repair the issue until I converted
the system to ext2.

> Most filesystems update some same set of common blocks to do a
> create.  This is particularly true of journal filesystems like
> reiserFS.  If the journal write stalls, everything else can hang
> on a journaling fs.

Yes, I would expect that.  Read or write failures from those common blocks
- and nothing else - should not ordinarily be related to the volume of data
being read or written elsewhere on the array, however.  In other words, if
the common blocks are number 1000 - 2000, then reading and writing to blocks
10,000 and above should not cause the rate of failure of reads from blocks
1000 - 2000 to change.  Instead, what we see quite clearly in this case is
modest to high write and / or read rates in blocks 10,000 and above cause
file creation events on blocks 1000 - 2000 to fail, while low data rates do
not.  I also think it is probably significant that the journal is obviously
written to by both file creations and file writes, yet only creations cause
the failure.  Now if certain sections of the journal blocks are only for
file creation, then why do read-only data rates affect the issue at all?

> While I agree your symptoms sound more like a software problem, my
> experience with enterprise raid arrays and drives says I would not
> rule hardware out as the trigger for the problem.

Nor have I done so.  At this point, I haven't ruled out anything.  It's
taking better than a day to scan each drive using badblocks, so it's going
to be about 2 weeks before I have scanned all 10 drives.  AFAIK, the
badblocks routine itself has not triggered any read/write halts.

> That 20 minute hang sure sounds like an array ignoring the host.
> With an enterprise array a 20 minute state like that is "normal"
> and really makes us want to beat the storage guys severely.

I can't argue against that at this point, for certain.  What puzzles me
(among other things) is why do 5 of the drives show zero reads while 5 of
them show very low levels of read activity, and always the same 5 drives?
The main question, of course, is not so much what is happening, as why, and
of course how can it be avoided?

Fortunately the multi-minute hangs only occur once a month, when the array
is resyncing.  Even so, however, the nearly continuous 40 second hangs are
driving me mad.  I have a large number of videos to edit, and stretching
what should be a 7 minute manual process into 20 minutes 4 or 5 times a day
is getting old fast.

> As was pointed out, there is a block layer "plug" when a device
> says "I'm busy".  That requires the FS to issue an "unplug", but
> if a code path doesn't have it... hang until some other path is
> taken that does do the unplug.
> 
> I suggest using blktrace to see what is happening between the
> filesystem, block layer, and device.

Thanks!  I'll take a look after all the drives are scanned.

> But none of them will protect you from bad hardware.

No, of course not, but I believe I am pretty close to having a stable
hardware set.  Before that gathers any flames, let me hasten to say that in
no way means I am certain of it, or that I refuse to change out any suspect
hardware.  Changing out non-suspect hardware, however, is just a means of
introducing more possible failures into a system.

