From: "Lelsie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Sun, 5 Apr 2009 01:30:19 -0500
Message-ID: <20090405063022.LLUH19140.cdptpa-omta03.mail.rr.com@Leslie>
References: <49D8020E.3010705@gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49D8020E.3010705@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Lelsie Rhorer wrote:

Is that my error in spelling my name, or yours?  If mine, how do I fix it?

> Writes don't trigger this sort of events, it is only the reads, and
> are you sure the data the you wrote is still readable?

This data has been read and written, hundreds of gigabytes a day, for
months.  None of the files have experienced any noticeable problems.  I
can't vouch for every byte, of course, but no read out of the tens of
millions of blocks read has ever triggered a halt or produced a noticeable
error, AFAIK.  Typical read rates are between 5000 and 20,000 blocks per
second for one or two hours at a time.

> And what I said if you read it carefully is, that *WHEN* you hit a bad
> sector it will cause a delay almost every time, not you will hit a
> delay every time you read the disk.

So why is it that thousands of read blocks per second continuously over
hours at a time and spanning the entire drive space many times over have
never produced a single event, yet creating a 200 byte file under some
circumstances causes the failure in some cases every single time? The total
number of sectors involved with failure triggers has not exceeded 100
kilobytes, even allowing for file system overheard and the existence of
large numbers of superblocks.  The total number of bytes read, however, is
easily 200 - 300 terabytes, or more.

> It will only result in a delay if you hit the magic bad sector.   And
> on reads it cannot mark the sector bad until it successfully reads the
> sector so it tries really hard and takes a long time trying, and once
> it reads that sector successfully it will rewrite it elsewhere and
> mark the sector bad.

So why doesn't it happen when reading any file?  Why does it rarely, if ever
happen when low volumes of reading and writing are underway, but happen
extremely frequently when large numbers of reads, write, or both are
happening?  A bad sector doesn't care how many other sectors are being read
or written.  I have several times backed up the entire array, end to end, at
400+ Mbps, without a single burp.  Create one or two tiny files during the
process, and it comes to a screeching halt for 40 seconds.  Note the time is
highly regular.  Unless the array health check is underway, the halt is
always 40 seconds long, never 30 or 50.

> When you hit the next bad sector the same
> thing will happen again.

But how is it in a sea of some 19,531,250,000 sectors, multi gigabyte long
reads never hit any bad sectors, but hitting bad sectors with 1K long file
creations manage to find a bad sector sometimes 50% of the time or more?  If
the bad sectors were in the superblocks, then file reads and writes would
find them just as often as file creations.  If the errors are in the inodes,
how is it billions and billions of sectors read and written find no errors,
but the odd file creation can find them up to 50% of the time or more?  Why
is it the likelihood of hitting a bad sector in an inode or superblock - for
file creations only - is much more likely when other drive accesses are
going on?


> When the array chassis had its issue, likely the chassis decided they

The chassis didn't decide anything.  It (like the new one) was a dumb drive
chassis.  When I purchased it, it was a multilane chassis served by a
RocketRaid SAS PCI Express RAID adapter.  It had troubles from day 1, and
they grew exponentially as more drives were added to the array.  Finally,
when the array needed to grow beyond 8 drives, it required the addition of
an additional adapter.  I was never able to get two adapters to work in the
system, no matter what.  At that point, I switched to the SI adapter and
converted the chassis to port multipliers.  It would fail up to 4 drives a
day, completely trashing the RAID6 array numerous times.  Replacing the
chassis caused the reported errors to drop to virtually zero, and the system
has not failed a drive since, or even had to restart one, that I have seen.

> were bad after getting a successful read, the read came back quickly
> and the chassis decided it was bad and marked it as such, the *DRIVE*
> has to think the sector is bad to get the delay, and in the array
> chassis case the drive knew the sector was just find and the array
> chassis misinterpreted what the drive was telling it and decided it
> was bad.

Then why did SMART's reading of the sectors marked as errored on the drives
correspond closely to the reports in the kernel logs?

In any case, no offense, but this isn't really helping.  I need methods of
determining what is wrong, not hypotheses about what could be wrong,
especially when those hypotheses appear to be unsupported by the facts.  If
a drive in the array is bad, I need to know which one, and how to find it.
With ten drives, and the fact it takes over three days to rebuild the array,
I can't afford to just go around swapping drives.

