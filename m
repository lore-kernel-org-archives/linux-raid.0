From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: unbelievably bad performance: 2.6.27.37 and raid6
Date: Sun, 1 Nov 2009 13:41:40 -0600
Message-ID: <200911011241.40735.tfjellstrom@shaw.ca>
References: <cccedfc60910310855l5ca6c42aj503fb0e4fd6232ad@mail.gmail.com> <200910311243.35126.tfjellstrom@shaw.ca> <4AEDE38F.3080408@gmail.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AEDE38F.3080408@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Dunn <andrew.g.dunn@gmail.com>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>, pernegger@gmail.com
List-Id: linux-raid.ids

On Sun November 1 2009, Andrew Dunn wrote:
> Are we to expect some resolution in newer kernels?

I assume all of the new per-bdi-writeback work going on in .33+ will have a 
large impact. At least I'm hoping.

> I am going to rebuild my array (backup data and re-create) to modify the
> chunk size this week. I hope to get a much higher performance when
> increasing from 64k chunk size to 1024k.
> 
> Is there a way to modify chunk size in place or does the array need to
> be re-created?

This I'm not sure about. I'd like to be able to reshape to a new chunk size 
for testing.

> Thomas Fjellstrom wrote:
> > On Sat October 31 2009, Jon Nelson wrote:
> >> I have a 4 disk raid6. The disks are individually capable of (at
> >> least) 75MB/s on average.
> >> The raid6 looks like this:
> >>
> >> md0 : active raid6 sda4[0] sdc4[5] sdd4[4] sdb4[6]
> >>       613409536 blocks super 1.1 level 6, 64k chunk, algorithm 2 [4/4]
> >>  [UUUU]
> >>
> >> The raid serves basically as an lvm physical volume.
> >>
> >> While rsyncing a file from an ext3 filesystem to a jfs filesystem, I
> >> am observing speeds in the 10-15MB/s range.
> >> That seems really really slow.
> >>
> >> Using vmstat, I see similar numbers (I'm averaging a bit, I'll see
> >> lows of 6MB/s and highs of 18-20MB/s, but these are infrequent.)
> >> The system is, for the most part, otherwise unloaded.
> >>
> >> I looked at stripe_cache_size and increased it to 384 - no difference.
> >> blockdev --getra reports 256 for all involved raid components.
> >> I'm using the deadline I/O scheduler.
> >>
> >> Am I crazy?  Is 12.5MB/s (average) what I should expect, here?  What
> >> might I look at here?
> >
> > I can't say I see numbers that bad.. But I do get 1/3 or less of the
> > performance with .29, .30, .31, and .32 than I get with .26. I haven't
> > tried any other kernels as these are the only ones I've been able to
> > grab from apt ;)
> >
> > I get something on the order of 100MB/s write and read with newer
> > kernels, with really bursty behaviour, and with .26, its not as fast as
> > it COULD be, but at least I get 200-300MB/s, which is reasonable.
> >
> > Now if your two file systems are on the same LVM VG, that could have an
> > impact on performance.
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
