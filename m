From: Joe Landman <joe.landman@gmail.com>
Subject: Re: very slow file deletion on an SSD
Date: Sat, 26 May 2012 19:25:55 -0400
Message-ID: <4FC16683.9060800@gmail.com>
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
> On Fri, May 25, 2012 at 06:37:05AM -0400, Joe Landman wrote:
>> Hi folks:
>>
>>    Just ran into this (see posted output at bottom).  3.2.14 kernel,
>> MD RAID 5, xfs file system.  Not sure (precisely) where the problem
>> is, hence posting to both lists.
>>
>>   [root@siFlash ~]# cat /proc/mdstat
>> Personalities : [raid1] [raid6] [raid5] [raid4]
>> md22 : active raid5 sdl[0] sds[7] sdx[6] sdu[5] sdk[4] sdz[3] sdw[2] sdr[1]
>>        1641009216 blocks super 1.2 level 5, 32k chunk, algorithm 2
>> [8/8] [UUUUUUUU]
>>
>> md20 : active raid5 sdh[0] sdf[7] sdm[6] sdd[5] sdc[4] sde[3] sdi[2] sdg[1]
>>        1641009216 blocks super 1.2 level 5, 32k chunk, algorithm 2
>> [8/8] [UUUUUUUU]
>>
>> md21 : active raid5 sdy[0] sdq[7] sdp[6] sdo[5] sdn[4] sdj[3] sdv[2] sdt[1]
>>        1641009216 blocks super 1.2 level 5, 32k chunk, algorithm 2
>> [8/8] [UUUUUUUU]
>>
>> md0 : active raid1 sdb1[1] sda1[0]
>>        93775800 blocks super 1.0 [2/2] [UU]
>>        bitmap: 1/1 pages [4KB], 65536KB chunk
>>
>>
>> md2* are SSD RAID5 arrays we are experimenting with.  Xfs file
>> systems atop them:
>>
>> [root@siFlash ~]# mount | grep md2
>> /dev/md20 on /data/1 type xfs (rw)
>> /dev/md21 on /data/2 type xfs (rw)
>> /dev/md22 on /data/3 type xfs (rw)
>>
>> vanilla mount options (following Dave Chinner's long standing advice)
>>
>> meta-data=/dev/md20              isize=2048   agcount=32,
>> agsize=12820392 blks
>>           =                       sectsz=512   attr=2
>> data     =                       bsize=4096   blocks=410252304, imaxpct=5
>>           =                       sunit=8      swidth=56 blks
>> naming   =version 2              bsize=65536  ascii-ci=0
>> log      =internal               bsize=4096   blocks=30720, version=2
>>           =                       sectsz=512   sunit=8 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>
> But you haven't followed my advice when it comes to using default
> mkfs options, have you? You're running 2k inodes and 64k directory
> block size, which is not exactly a common config

We were experimenting.  Easy to set it back and demonstrate the problem 
again.

>
> The question is, why do you have these options configured, and are
> they responsible for things being slow?
>

We saw it before we experimented with some mkfs options.  Will rebuild 
FS and demo it again.


>> All this said, deletes from this unit are taking 1-2 seconds per file ...
>
> Sounds like you might be hitting the synchronous xattr removal
> problem that was recently fixed (as has been mentioned already), but
> even so 2 IOs don't take 1-2s to do, unless the MD RAID5 barrier
> implementation is really that bad. If you mount -o nobarrier, what
> happens?

[root@siFlash test]# ls -alF  | wc -l
59
[root@siFlash test]# /usr/bin/time rm -f *
^C0.00user 8.46system 0:09.55elapsed 88%CPU (0avgtext+0avgdata 
2384maxresident)k
25352inputs+0outputs (0major+179minor)pagefaults 0swaps
[root@siFlash test]# ls -alF  | wc -l
48

Nope, still an issue:

1338074901.531554 ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost 
isig icanon echo ...}) = 0 <0.000021>
1338074901.531701 newfstatat(AT_FDCWD, "1.r.12.0", 
{st_mode=S_IFREG|0600, st_size=1073741824, ...}, AT_SYMLINK_NOFOLLOW) = 
0 <0.000022>
1338074901.531840 unlinkat(AT_FDCWD, "1.r.12.0", 0) = 0 <2.586999>
1338074904.119032 newfstatat(AT_FDCWD, "1.r.13.0", 
{st_mode=S_IFREG|0600, st_size=1073741824, ...}, AT_SYMLINK_NOFOLLOW) = 
0 <0.000033>

2.6 seconds for an unlink.

Rebuilding absolutely vanilla file system now, and will rerun checks.

>
> CHeers,
>
> Dave.

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

