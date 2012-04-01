From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID5 created by 8 disks works with xfs
Date: Sat, 31 Mar 2012 23:52:47 -0500
Message-ID: <4F77DF1F.6080103@hardwarefreak.com>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com> <CADNH=7H_rgiY4fkB0SHo0yPhSBib7Gq-E_fu18yuJx=enn-eGg@mail.gmail.com> <4F776492.4070600@hardwarefreak.com> <CACwgYDOSrEYUps2VLpFSZ-irH7Mn_-BWrOYYDgXS=ULrmVuEPw@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACwgYDOSrEYUps2VLpFSZ-irH7Mn_-BWrOYYDgXS=ULrmVuEPw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: daobang wang <wangdb1981@gmail.com>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Flaky mouse button cause a premature send.  Sorry for the duplicate.

On 3/31/2012 8:16 PM, daobang wang wrote:
> Thanks to Mathias and stan, Here is the detail of the configuration.
> 
> 1. RAID5 with 8 2TB ST32000644NS disks , i can extend to 16 disks.
> the RAID5 created with Chunk Size of 64K and left-symmetric
> 
> 2. Volume Group on RAID5 with full capacity
> 
> 3. Logical Volume on the Volume Group with full capacity

LVM will create unnecessary overhead for this workload.  Do not use it.
 Directly format the md device with XFS and proper alignment.  Again,
mkfs.xfs will do this automatically.

> 4. XFS filesystem created on the Logical Volume with option "-f -i
> size=512", and mount option is "-t xfs -o
> defaults,usrquota,grpquota,noatime,nodiratime,nobarrier,delaylog,logbsize=262144",

What kernel version are you using?  logbsize=262144 has been the default
for quite some time now.

NEVER disable barriers unless you have a quality BBWC RAID controller
and a good working UPS.  Are these 8 disks connected to a BBWC RAID
card?  Have you verified the write back cache is working properly?

> 5. The real application is 200 D1(2Mb/s) video streams write 500MB
> files on the XFS.

This is a 50 MB/s raw stream rate with 200 writers to 200 target files.
 It is very likely that neither 8 nor 16 disks in RAID5 will be able to
sync this rate due to excessive head seeking, as I previously mentioned.
 Having LVM layered between XFS and mdraid will make this situation even
worse.

> This is the pressure testing, just verify the reliability of the
> system, we will not use it in real envrionment, 100 video streams
> writen is our goal. 

So now you have an aggregate 25 MB/s random write workload with 100
writers.  This is still going to likely be too much for an 8 or 16 disk
RAID5 array for the same reason as 200 threads--too many disk seeks.

> is there any clue for optimize the application?

This is the Linux-raid list.  We can help you optimize your RAID, and
since many of us use XFS, we can help you there as well.  I've never
seen your application so it is impossible to suggest how to optimize it.
 As far as optimizing your 16 disks with mdraid and XFS, I've already
given you pointers on how you need to configure your storage for optimal
performance with this workload.  However, experience tells me you simply
don't have enough spindles to sync all these parallel writers if you
also need redundancy.

The fact that you're disabling barriers likely in lieu of BBWC seems to
indicate you're not terribly worried about losing all your data in the
event of a drive failure.  If this is the case, 16 x 7.2k spindles with
6 parallel writers per spindle at .25 MB/s each might work.  Simply
create an md linear array with 16 disks, no LVM, format it with

$ mkfs.xfs -d agcount=48 /dev/md0

and configure your application to write each video stream file to a
different directory.  Writing to multiple directories is what drives XFS
parallelism.  This will allow for 96 parallel write streams, 6 to each
drive concurrently, for 6*.25 MB/s = 1.5MB/s per drive, 24 MB/s
aggregate.  This might keep seeks low enough to achieve the parallel
throughput you need.

I'm guessing since you didn't comment on my previous recommendation that
you don't yet understand the benefits of linear concatenation, and using
XFS allocation groups to drive parallelism, instead of blindly assuming
striping will do the job--it often cannot.  XFS on linear array can
decrease the seek rate on each drive substantially vs striped RAID.
Keeping the seek rate low increases throughput of parallel writers.

-- 
Stan
