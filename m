From: Dave Chinner <david@fromorbit.com>
Subject: Re: ARC-1120 and MD very sloooow
Date: Tue, 26 Nov 2013 13:52:10 +1100
Message-ID: <20131126025210.GL8803@dastard>
References: <1385118796.8091.31.camel@bews002.euractiv.com>
 <528FBBE5.80404@hardwarefreak.com>
 <1385369796.2076.16.camel@bews002.euractiv.com>
 <5293EF32.9090301@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5293EF32.9090301@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Jimmy Thrasibule <thrasibule.jimmy@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>
List-Id: linux-raid.ids

On Mon, Nov 25, 2013 at 06:45:38PM -0600, Stan Hoeppner wrote:
> On 11/25/2013 2:56 AM, Jimmy Thrasibule wrote:
> > Hello Stan,
> > 
> >> This may not be an md problem.  It appears you've mangled your XFS
> >> filesystem alignment.  This may be a contributing factor to the low
> >> write throughput.
> >>
> >>>         md3 : active raid10 sdc1[0] sdf1[3] sde1[2] sdd1[1]
> >>>               7813770240 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
> >> ...
> >>>         /dev/md3 on /srv type xfs (rw,nosuid,nodev,noexec,noatime,attr2,delaylog,inode64,sunit=2048,swidth=4096,noquota)
> >>
> >> Beyond having a ridiculously unnecessary quantity of mount options, it
> >> appears you've got your filesystem alignment messed up, still.  Your
> >> RAID geometry is 512KB chunk, 1MB stripe width.  Your override above is
> >> telling the filesystem that the RAID geometry is chunk size 1MB and
> >> stripe width 2MB, so XFS is pumping double the IO size that md is
> >> expecting.
> > 
> > The nosuid, nodev, noexec, noatime and inode64 options are mine, the
> > others are added by the system.
> 
> Right.  It's unusual to see this many mount options.  FYI, the XFS
> default is relatime, which is nearly identical to noatime.  Specifying
> noatime won't gain you anything.  Do you really need nosuid, nodev, noexec?
> 
> >>>         # xfs_info /dev/md3 
> >>>         meta-data=/dev/md3               isize=256    agcount=32, agsize=30523648 blks
> >>>                  =                       sectsz=512   attr=2
> >>>         data     =                       bsize=4096   blocks=976755712, imaxpct=5
> >>>                  =                       sunit=256    swidth=512 blks
> >>>         naming   =version 2              bsize=4096   ascii-ci=0
> >>>         log      =internal               bsize=4096   blocks=476936, version=2
> >>>                  =                       sectsz=512   sunit=8 blks, lazy-count=1
> >>
> >> You created your filesystem with stripe unit of 128KB and stripe width
> >> of 256KB which don't match the RAID geometry.  I assume this is the

sunit/swidth is in filesystem blocks, not sectors. Hence
sunit is 1MB, swidth = 2MB. While it's not quite correct
(su=512k,sw=1m), it's not actually a problem...

> >> reason for the fstab overrides.  I suggest you try overriding with
> >> values that match the RAID geometry, which should be sunit=1024 and
> >> swidth=2048.  This may or may not cure the low write throughput but it's
> >> a good starting point, and should be done anyway.  You could also try
> >> specifying zeros to force all filesystem write IOs to be 4KB, i.e. no
> >> alignment.
> >>
> >> Also, your log was created with a stripe unit alignment of 4KB, which is
> >> 128 times smaller than your chunk.  The default value is zero, which
> >> means use 4KB IOs.  This shouldn't be a problem, but I do wonder why you
> >> manually specified a value equal to the default.
> >>
> >> mkfs.xfs automatically reads the stripe geometry from md and sets
> >> sunit/swidth correctly (assuming non-nested arrays).  Why did you
> >> specify these manually?
> > 
> > It is said to trust mkfs.xfs, that's what I did. No options have been
> > specified by me and mkfs.xfs guessed everything by itself.

Well, mkfs.xfs just uses what it gets from the kernel, so it
might have been told the wrong thing by MD itself.  However, you can
modify sunit/swidth by mount options, so you can't directly trust
what is reported from xfs_info to be what mkfs actually set
originally.

> So the mkfs.xfs defaults in Wheezy did this.  Maybe I'm missing
> something WRT the md/RAID10 near2 layout.  I know the alternate layouts
> can play tricks with the resulting stripe width but I'm not sure if
> that's the case here.  The log sunit of 8 blocks may be due to your
> chunk being 512KB, which IIRC is greater than the XFS allowed maximum
> for the log.  Hence it may have been dropped to 4KB for this reason.

Again, lsunit is in filesystem blocks, so it is 32k, not 4k. And
yes, the default lsunit when the sunit > 256k is 32k. So, nothing
wrong there, either.


> >>> The issue is that disk access is very slow and I cannot spot why. Here
> >>> is some data when I try to access the file system.
> >>>
> >>>
> >>>         # dd if=/dev/zero of=/srv/test.zero bs=512K count=6000
> >>>         6000+0 records in
> >>>         6000+0 records out
> >>>         3145728000 bytes (3.1 GB) copied, 82.2142 s, 38.3 MB/s
> >>>         
> >>>         # dd if=/srv/store/video/test.zero of=/dev/null
> >>>         6144000+0 records in
> >>>         6144000+0 records out
> >>>         3145728000 bytes (3.1 GB) copied, 12.0893 s, 260 MB/s
> >>
> >> What percent of the filesystem space is currently used?
> > 
> > Very small, 3GB / 6TB, something like 0.05%.

The usual: "iostat -x -d -m 5" output while the test is running.
Also, you are using buffered IO, so changing it to use direct IO
will tell us exactly what the disks are doing when Io is issued.
blktrace is your friend here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
