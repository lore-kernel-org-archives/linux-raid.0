From: keld@keldix.com
Subject: Re: Why are reads not balanced across my RAID-1?
Date: Sat, 25 Jan 2014 02:48:24 +0100
Message-ID: <20140125014824.GA28036@www5.open-std.org>
References: <20140124120448.GA19163@www5.open-std.org> <20140124133326.27671.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140124133326.27671.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 24, 2014 at 08:33:26AM -0500, George Spelvin wrote:
> > The reading is not balanced because it does not make sense to do balanced
> > reads for sequential reading. In RAID-1 the disk sectors are consequitive.
> > So if you would read one sector from one disk, and the following sector
> > from the other disk, then the next read from disk 1 would need to skip
> > a full resolvation of the disk, which may cost something like 8 ms.
> > So better read contigously from the same disk, and hope for some other
> > IO request that can use disk 2.
> 
> Actually I don't think that's true once reads get big enough.
> 7200 RPM is 120 rotations pers second, so there is about 1 MB
> of data per track.  At the end of that, the drive has to switch
> heads or do a track-to-track seek to get more.  If we knew where
> the track boundaries were, we could interleave reads on those
> boundaries and get good speedup.

I am not sure that there is 1 MB per track, or per rotation, but on 7200 RPM disks, a rotation is
about 8 miliseconds. In 8 ms you can read something like (on the drive you describe below)
150 MB/s or 150 kB/s, and in 8 ms this you can then read 1.2 MB. As you say, with big
block sizes you can minimize the impact of this loss, eg using 10 MB block sizes.

But for databases it would be quite a waste to read 10 MB per record access. 
Raid10,far then gives a good performance both for sequential reading and for database access,
with .block sizes of about only 1 MB.

> But it's also possible to take advantage if the reads are
> sufficiently larger than this 1 MB threshold.  Alternating
> at 8 MB boundaries would probably be a speedup.
> 
> Actually, I should do some timing to find out....
> 
> Reading every odd block from the first 8 GiB of sdd (4 GiB of data read)
> using a block size of:
> 256 MiB: 25.917s (165.7 MB/s)
> 128 MiB: 25.293s (169.8 MB/s)
>  64 MiB: 26.341s (163.1 MB/s)
>  32 MiB: 26.029s (165.0 MB/s)
>  16 MiB: 27.327s (157.2 MB/s)
>   8 MiB: 28.210s (152.2 MB/s)
>   4 MiB: 31.371s (136.9 MB/s)
>   2 MiB: 36.560s (117.5 MB/s)
>   1 MiB: 51.325s ( 83.7 MB/s)
> 
> So 1 MB striping would be barely faster than single-drive reading,
> but 2MB offers a speedup, and 8MB sould actually be quite nice.
> (Reading the first 4 GiB of the drive, with no seeking, also takes
> 25.something seconds.)

With raid10,far you should get the full speed of about 160 MB/s with
a block size of just 1 MB, for seqyential reading.

> ... but even ignoring that, shouldn't reads change drives when there's a
> jump in the sequential read?  ext4 (with flex_bg) divides the disk into
> 2 GB "block groups", with reserved inode space at the start of each one,
> and can't allocate contiguous data larger than that.  And the files
> I was reading were all in the 50-150 MB range anyway.
>
> Should the md driver switch drives when there is a jump in the address
> being fetched?  But for minutes, I *never* saw any sde activity.

Well, it could. I did find some differences between raid1 and raid10,n2 
in some tests I did, which could be due to different balancing in
the raid1 and raid10 driver.

best regards
keld
