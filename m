From: Joe Landman <joe.landman@gmail.com>
Subject: Re: very slow file deletion on an SSD
Date: Sat, 26 May 2012 19:55:17 -0400
Message-ID: <4FC16D65.8000008@gmail.com>
References: <4FBF60D1.80104@gmail.com> <20120526231838.GR25351@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120526231838.GR25351@dastard>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/26/2012 07:18 PM, Dave Chinner wrote:

> Sounds like you might be hitting the synchronous xattr removal
> problem that was recently fixed (as has been mentioned already), but
> even so 2 IOs don't take 1-2s to do, unless the MD RAID5 barrier
> implementation is really that bad. If you mount -o nobarrier, what
> happens?

Pure vanilla mkfs


[root@siFlash ~]# mkfs.xfs -f /dev/md20
meta-data=/dev/md20              isize=256    agcount=32, 
agsize=12820384 blks
          =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=410252288, imaxpct=5
          =                       sunit=4      swidth=28 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=200320, version=2
          =                       sectsz=512   sunit=4 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@siFlash ~]# mkfs.xfs -f /dev/md21
meta-data=/dev/md21              isize=256    agcount=32, 
agsize=12820384 blks
          =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=410252288, imaxpct=5
          =                       sunit=4      swidth=28 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=200320, version=2
          =                       sectsz=512   sunit=4 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
^[[A[root@siFlash ~]# mkfs.xfs -f /dev/md22
meta-data=/dev/md22              isize=256    agcount=32, 
agsize=12820384 blks
          =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=410252288, imaxpct=5
          =                       sunit=4      swidth=28 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=200320, version=2
          =                       sectsz=512   sunit=4 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


and mount

[root@siFlash ~]# mount /dev/md20 /data/1
[root@siFlash ~]# mount /dev/md21 /data/2
[root@siFlash ~]# mount /dev/md22 /data/3


Still an issue:

[root@siFlash test]# ls -l | wc -l
48
[root@siFlash test]# /usr/bin/time rm -f *
^C0.00user 5.02system 0:05.33elapsed 94%CPU (0avgtext+0avgdata 
2368maxresident)k
24inputs+0outputs (0major+179minor)pagefaults 0swaps
[root@siFlash test]# ls -l | wc -l
46
[root@siFlash test]#


though now its 3.5 seconds per file delete

1338075592.450387 ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost 
isig icanon echo ...}) = 0 <0.000020>
1338075592.450541 newfstatat(AT_FDCWD, "1.r.12.0", 
{st_mode=S_IFREG|0600, st_size=1073741824, ...}, AT_SYMLINK_NOFOLLOW) = 
0 <0.000020>
1338075592.450679 unlinkat(AT_FDCWD, "1.r.12.0", 0) = 0 <3.226394>
1338075595.677274 newfstatat(AT_FDCWD, "1.r.13.0", 
{st_mode=S_IFREG|0600, st_size=1073741824, ...}, AT_SYMLINK_NOFOLLOW) = 
0 <0.000088>
1338075595.677515 unlinkat(AT_FDCWD, "1.r.13.0", 0) = 0 <3.564176>


Remounting with nobarrier

[root@siFlash test]# mount -o remount,nobarrier /data/1
[root@siFlash test]# mount -o remount,nobarrier /data/2
[root@siFlash test]# mount -o remount,nobarrier /data/3
[root@siFlash test]# mount | grep data
/dev/md20 on /data/1 type xfs (rw,nobarrier)
/dev/md21 on /data/2 type xfs (rw,nobarrier)
/dev/md22 on /data/3 type xfs (rw,nobarrier)


doesn't look like this helped

1338075724.110941 newfstatat(AT_FDCWD, "1.r.15.0", 
{st_mode=S_IFREG|0600, st_size=1073741824, ...}, AT_SYMLINK_NOFOLLOW) = 
0 <0.000035>
1338075724.111108 unlinkat(AT_FDCWD, "1.r.15.0", 0) = 0 <3.727094>
1338075727.838380 newfstatat(AT_FDCWD, "1.r.16.0", 
{st_mode=S_IFREG|0600, st_size=1073741824, ...}, AT_SYMLINK_NOFOLLOW) = 
0 <0.000061>
1338075727.838600 unlinkat(AT_FDCWD, "1.r.16.0", 0) = 0 <2.611156>
1338075730.449949 newfstatat(AT_FDCWD, "1.r.17.0", 
{st_mode=S_IFREG|0600, st_size=1073741824, ...}, AT_SYMLINK_NOFOLLOW) = 
0 <0.000104>
1338075730.450165 unlinkat(AT_FDCWD, "1.r.17.0", 0) = 0 <2.869917>


2.6-3.7 seconds per unlink.

FWIW:  umount (which does flushes) seems to take a while (~15-20 seconds)

Raw (uncached) read/write speed to a single array is pretty good, so I 
don't think the array is a problem.

Run status group 0 (all jobs):
    READ: io=81424MB, aggrb=2606.7MB/s, minb=2606.7MB/s, 
maxb=2606.7MB/s, mint=31244msec, maxt=31244msec


Run status group 0 (all jobs):
   WRITE: io=55025MB, aggrb=939053KB/s, minb=939053KB/s, 
maxb=939053KB/s, mint=60002msec, maxt=60002msec


-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615

