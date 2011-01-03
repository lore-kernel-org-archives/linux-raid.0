From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Mismatches
Date: Sun, 2 Jan 2011 21:12:47 -0600
Message-ID: <4A.5C.02631.0BE312D4@cdptpa-omtalb.mail.rr.com>
References: <20110103123535.4eda6f6f@notabene.brown>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110103123535.4eda6f6f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Sunday, January 02, 2011 7:36 PM
> To: lrhorer@satx.rr.com
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Mismatches
> 
> On Sun, 2 Jan 2011 19:10:38 -0600 "Leslie Rhorer" <lrhorer@satx.rr.com>
> wrote:
> 
> >
> > 	OK, I asked this question here before, and I got no answer
> > whatsoever.  I wasn't too concerned previously, but now that I lost the
> > entire array the last time I tried to do a growth, I am truly concerned.
> > Would someone please answer my question this time, and perhaps point me
> > toward a resolution?  The monthly array check just finished on my main
> > machine.  For many months, this happened at the first of the month and
> > completed without issue and with zero mismatches.  As of a couple of
> months
> > ago, it started to report large numbers of mismatches.  It just
> completed
> > this afternoon with the following:
> >
> > RebuildFinished /dev/md0 mismatches found: 96614968
> >
> > 	Now, 96,000,000 mismatches would seem to be a matter of great
> > concern, if you ask me.  How can there be any, really, when the entire
> array
> > - all 11T - was re-written just a few weeks ago?  How can I find out
> what
> > the nature of these mismatches is, and how can I correct them without
> > destroying the data on the array?  How can I look to prevent them in the
> > future?  I take it the monthly checkarray routine (which basically
> > implements ` echo check > /sys/block/md0/md/sync_action`) does not
> attempt
> > to fix any errors it finds?
> >
> > 	I just recently found out md uses simple parity to try to maintain
> > the validity of the data.  I had always thought it was ECC.  With simple
> > parity it can be difficult or even impossible to tell which data member
> is
> > in error, given two conflicting members.  Where should I go from here?
> Can
> > I use `echo repair > /sys/block/md0/md/sync_action` with impunity?
> What,
> > exactly, will this do when it comes across a mismatch between one or
> more
> > members?
> >
> > RAID6 array
> > mdadm - v2.6.7.2
> > kernel 2.6.26-2-amd64
> >
> 
> 96,000,000 is certainly a big number.  It seems to suggest that one of

	No kidding, especially since the data was very recently re-written
to the array.  I'm getting reports of errors from more than one array,
however, with no drives in common.  What's more, I am not getting errors on
other arrays with every disk in common.  Specifically, the main array is an
11T RAID6 array with 14 raw SATA members, all in a single PM enclosure, on 3
different channels, assembled as md0.  It's the one with the 96 million
mismatches.  OTOH, I have a pair of drives in the main CPU enclosure, one
SATA and one PATA.  Each is divided into 3 partitions, and each partition
pair forms a RAID1 array.  Thus md1 = sda1 + hda1, md2 = sda2 + hda2, and
md3 = sda1 + hda1.  Md1 has no mismatches, although it is also quite small
(411M).  Md2 has 128 mismatches, and is 328G.  Md3 had 37,632 mismatches,
and is only 171G.  What's more, md3 gets very limited use.  It is allocated
as swap space, and this server almost never swaps anything of which to
speak.  The used swap space is usually under 200KB.

	Before I received your reply, I went ahead and turned off swap and
then started the repair on md3 just to see what would happen.  Obviously,
the data in the swap area is of no concern once swap is disabled.

> your
> devices is returning a lot of bad data to reads.
> If this is true, you would expect to get corrupt data when you read from
> the
> array.  Do you?

	Not of which I know, or at least it doesn't seem so, but the growth
from 13 drives to 14 really hacked the data to pieces.  The file system
croaked, and after recovery, quite a few files were lost.  Most, however, we
still there, but almost every large file was corrupt.  The bulk of the data
(in size, not number of files) is video, and when I attempted to play almost
any video, it jumped, stuttered, and splashed confetti across the screen.  A
handful of small files were also trashed.  I looked at one of them - a flat
text file - and it was complete garbage.  I suspect that something like
1/11th of the data was corrupt - being that the array was formerly 11 data +
2 parity.  I suppose it could have been 1/12th of the data, since the new
shape is 12 + 2.

> Does 'fsck' find any problems?

	It doesn't look like it:
RAID-Server:/etc/default# xfs_repair -n /dev/md0
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - agno = 32
        - agno = 33
        - agno = 34
        - agno = 35
        - agno = 36
        - agno = 37
        - agno = 38
        - agno = 39
        - agno = 40
        - agno = 41
        - agno = 42
        - agno = 43
        - agno = 44
        - agno = 45
        - agno = 46
        - agno = 47
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - agno = 32
        - agno = 33
        - agno = 34
        - agno = 35
        - agno = 36
        - agno = 37
        - agno = 38
        - agno = 39
        - agno = 40
        - agno = 41
        - agno = 42
        - agno = 43
        - agno = 44
        - agno = 45
        - agno = 46
        - agno = 47
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.

	I don't know of a way to check the integrity of the swap area, and
md2 is root, so I would have to take the server down to check it.
> 
> The problem could be in a drive, or in a cable or in a controller.  It is
> hard to know which.

	Not if the problem has a single source.  Md1, md2, and md3 do not
share drives, cables, or controllers.  Other than the CPU, the memory, and
the southbridge, they don't have anything in common.  Of course it is within
the realm of possibility the errors are unrelated, but the fact all of the
arrays which began reporting mismatches did so the very same month is very
suggestive of a single source.

> I would recommend not writing to the array until you have isolated the
> problem as writing can just propagate errors.

	I'll limit the writing, but I don't know I can stop entirely.  I
wouldn't even be able to write this message without it, as the IMAP server
uses the array.

> Possibly:
>   shut down array
>   compute the sha1sum of each device
>   compute the sha1sum again

	Um.  I presume you mean `sha1sum /dev/sdX`?  Check me if I'm wrong,
but even at 200 MBps, that's going to take 2.5 hours per drive, isn't it?
That's 35 solid hours, and I'll have to restart the process every hour and a
quarter, as it finishes each drive.  I'm not entirely sure the drives could
sustain 200 MBps, either.  I suppose I could write a script.


> If there is any difference, you are closer to the error
> If every device reports the same sha1sum, both times, then it is
> presumably
> just one device which has consistent errors.
> 
> I would then try assembling the array with all-but-one-drive (use a bitmap
> so
> you can add/remove devices without triggering a recovery) and do a 'check'
> for each config and hope that one config (i.e. with one particular device
> missing) reports no mismatches.  That would point to the missing device
> being
> the problem.

	That's not exactly going to be fast, either.  <sigh>


> 'check' does not correct any mismatches it finds, though if it hits a read
> error it will try to correct that.
> 
> RAID6 can sometimes determine which device is in error, but that has not
> been
> implemented in md/raid6 yet.
> 
> I wouldn't use 'repair' as that could hide the errors rather than fixing
> them, and there would be no way back.  When it comes across a mismatch it
> generates the Parity and the Q block from the data and writes them out.
> If
> the P or Q block were wrong, this is a good fix.  If one data block was
> wrong, this is bad.

	I see.  <Ugh>

