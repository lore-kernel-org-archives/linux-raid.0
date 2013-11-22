From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: ARC-1120 and MD very sloooow
Date: Fri, 22 Nov 2013 14:17:41 -0600
Message-ID: <528FBBE5.80404@hardwarefreak.com>
References: <1385118796.8091.31.camel@bews002.euractiv.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1385118796.8091.31.camel@bews002.euractiv.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jimmy Thrasibule <thrasibule.jimmy@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>
List-Id: linux-raid.ids

[CC'ing XFS]

On 11/22/2013 5:13 AM, Jimmy Thrasibule wrote:

Hi Jimmy,

This may not be an md problem.  It appears you've mangled your XFS
filesystem alignment.  This may be a contributing factor to the low
write throughput.

>         md3 : active raid10 sdc1[0] sdf1[3] sde1[2] sdd1[1]
>               7813770240 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
...
>         /dev/md3 on /srv type xfs (rw,nosuid,nodev,noexec,noatime,attr2,delaylog,inode64,sunit=2048,swidth=4096,noquota)

Beyond having a ridiculously unnecessary quantity of mount options, it
appears you've got your filesystem alignment messed up, still.  Your
RAID geometry is 512KB chunk, 1MB stripe width.  Your override above is
telling the filesystem that the RAID geometry is chunk size 1MB and
stripe width 2MB, so XFS is pumping double the IO size that md is
expecting.

>         # xfs_info /dev/md3 
>         meta-data=/dev/md3               isize=256    agcount=32, agsize=30523648 blks
>                  =                       sectsz=512   attr=2
>         data     =                       bsize=4096   blocks=976755712, imaxpct=5
>                  =                       sunit=256    swidth=512 blks
>         naming   =version 2              bsize=4096   ascii-ci=0
>         log      =internal               bsize=4096   blocks=476936, version=2
>                  =                       sectsz=512   sunit=8 blks, lazy-count=1

You created your filesystem with stripe unit of 128KB and stripe width
of 256KB which don't match the RAID geometry.  I assume this is the
reason for the fstab overrides.  I suggest you try overriding with
values that match the RAID geometry, which should be sunit=1024 and
swidth=2048.  This may or may not cure the low write throughput but it's
a good starting point, and should be done anyway.  You could also try
specifying zeros to force all filesystem write IOs to be 4KB, i.e. no
alignment.

Also, your log was created with a stripe unit alignment of 4KB, which is
128 times smaller than your chunk.  The default value is zero, which
means use 4KB IOs.  This shouldn't be a problem, but I do wonder why you
manually specified a value equal to the default.

mkfs.xfs automatically reads the stripe geometry from md and sets
sunit/swidth correctly (assuming non-nested arrays).  Why did you
specify these manually?

> The issue is that disk access is very slow and I cannot spot why. Here
> is some data when I try to access the file system.
> 
> 
>         # dd if=/dev/zero of=/srv/test.zero bs=512K count=6000
>         6000+0 records in
>         6000+0 records out
>         3145728000 bytes (3.1 GB) copied, 82.2142 s, 38.3 MB/s
>         
>         # dd if=/srv/store/video/test.zero of=/dev/null
>         6144000+0 records in
>         6144000+0 records out
>         3145728000 bytes (3.1 GB) copied, 12.0893 s, 260 MB/s

What percent of the filesystem space is currently used?

>         First run:
>         $ time ls /srv/files
>         [...]
>         real	9m59.609s
>         user	0m0.408s
>         sys	0m0.176s

This is a separate problem and has nothing to do with the hardware, md,
or XFS.  I assisted with a similar, probably identical, ls completion
time issue last week on the XFS list.  I'd guess you're storing user and
group data on a remote LDAP server and it is responding somewhat slowly.
 Use 'strace -T' with ls and you'll see lots of poll calls and the time
taken by each.  17,189 files at 35ms avg latency per LDAP query yields
10m02s, if my math is correct, so 35ms is your current avg latency per
query.  Be aware that even if you get the average LDAP latency per file
down to 2ms, you're still looking at 34s for ls to complete on this
directory.  Much better than 10 minutes, but nothing close to the local
speed you're used to.

>         Second run:
>         $ time ls /srv/files
>         [...]
>         real	0m0.257s
>         user	0m0.108s
>         sys	0m0.088s

Here the LDAP data has been cached.  Wait an hour, run ls again, and
it'll be slow again.

>         $ ls -l /srv/files | wc -l
>         17189

> I guess the controller is what's is blocking here as I encounter the
> issue only on servers where it is installed. I tried many settings like
> enabling or disabling cache but nothing changed.

The controller is not the cause of the 10 minute ls delay.  If you see
the ls delay only on servers with this controller it is coincidence.
The cause lay elsewhere.

Areca are pretty crappy controllers generally, but I doubt they're at
fault WRT your low write throughput, though it is possible.

> Any advise would be appreciated.

I hope I've steered you in the right direction.

-- 
Stan
