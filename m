From: "George Spelvin" <linux@horizon.com>
Subject: Re: Why are reads not balanced across my RAID-1?
Date: 24 Jan 2014 08:33:26 -0500
Message-ID: <20140124133326.27671.qmail@science.horizon.com>
References: <20140124120448.GA19163@www5.open-std.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140124120448.GA19163@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com, linux@horizon.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> The reading is not balanced because it does not make sense to do balanced
> reads for sequential reading. In RAID-1 the disk sectors are consequitive.
> So if you would read one sector from one disk, and the following sector
> from the other disk, then the next read from disk 1 would need to skip
> a full resolvation of the disk, which may cost something like 8 ms.
> So better read contigously from the same disk, and hope for some other
> IO request that can use disk 2.

Actually I don't think that's true once reads get big enough.
7200 RPM is 120 rotations pers second, so there is about 1 MB
of data per track.  At the end of that, the drive has to switch
heads or do a track-to-track seek to get more.  If we knew where
the track boundaries were, we could interleave reads on those
boundaries and get good speedup.

But it's also possible to take advantage if the reads are
sufficiently larger than this 1 MB threshold.  Alternating
at 8 MB boundaries would probably be a speedup.

Actually, I should do some timing to find out....

Reading every odd block from the first 8 GiB of sdd (4 GiB of data read)
using a block size of:
256 MiB: 25.917s (165.7 MB/s)
128 MiB: 25.293s (169.8 MB/s)
 64 MiB: 26.341s (163.1 MB/s)
 32 MiB: 26.029s (165.0 MB/s)
 16 MiB: 27.327s (157.2 MB/s)
  8 MiB: 28.210s (152.2 MB/s)
  4 MiB: 31.371s (136.9 MB/s)
  2 MiB: 36.560s (117.5 MB/s)
  1 MiB: 51.325s ( 83.7 MB/s)

So 1 MB striping would be barely faster than single-drive reading,
but 2MB offers a speedup, and 8MB sould actually be quite nice.
(Reading the first 4 GiB of the drive, with no seeking, also takes
25.something seconds.)


... but even ignoring that, shouldn't reads change drives when there's a
jump in the sequential read?  ext4 (with flex_bg) divides the disk into
2 GB "block groups", with reserved inode space at the start of each one,
and can't allocate contiguous data larger than that.  And the files
I was reading were all in the 50-150 MB range anyway.

Should the md driver switch drives when there is a jump in the address
being fetched?  But for minutes, I *never* saw any sde activity.
