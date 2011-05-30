From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Optimizing small IO with md RAID
Date: Mon, 30 May 2011 05:43:45 -0500
Message-ID: <4DE374E1.8050305@hardwarefreak.com>
References: <BANLkTi=236kncpunzodSci-1K33u_FBkPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=236kncpunzodSci-1K33u_FBkPA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "fibreraid@gmail.com" <fibreraid@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 5/30/2011 2:14 AM, fibreraid@gmail.com wrote:
> Hi all,
> 
> I am looking to optimize md RAID performance as much as possible.
> 
> I've managed to get some rather strong large 4M IOps performance, but
> small 4K IOps are still rather subpar, given the hardware.
> 
> CPU: 2 x Intel Westmere 6-core 2.4GHz
> RAM: 24GB DDR3 1066
> SAS controllers: 3 x LSI SAS2008 (6 Gbps SAS)
> Drives: 24 x SSD's
> Kernel: 2.6.38 x64 kernel (home-grown)
> Benchmarking Tool: fio 1.54
> 
> Here are the results.I used the following commands to perform these benchmarks:
> 
> 4K READ: fio --bs=4k --direct=1 --rw=read --ioengine=libaio
> --iodepth=512 --runtime=60 --name=/dev/md0
> 4K WRITE: fio --bs=4k --direct=1 --rw=write--ioengine=libaio
> --iodepth=512 --runtime=60 --name=/dev/md0
> 4M READ: fio --bs=4m --direct=1 --rw=read --ioengine=libaio
> --iodepth=64 --runtime=60 --name=/dev/md0
> 4M WRITE: fio --bs=4m --direct=1 --rw=read --ioengine=libaio
> --iodepth=64 --runtime=60 --name=/dev/md0

Did you test with buffered IO?  Unless you're running Oracle or a custom
app that only uses O_DIRECT, you should probably be testing buffered IO
as well as it's a more real world test case most of the time.

> In each case below, the md chunk size was 64K. In RAID 5 and RAID 6,
> one hot-spare was specified.

IOPS and throughput tuning often traditionally have an inverse
relationship.  It may prove difficult to tune maximum performance for
both cases.

> 	raid0 24 x SSD	raid5 23 x SSD	raid6 23 x SSD	raid0 (2 * (raid5 x 11 SSD))						
> 4K read	179,923 IO/s	93,503 IO/s	116,866 IO/s	75,782 IO/s
> 4K write	168,027 IO/s	108,408 IO/s	120,477 IO/s	90,954 IO/s
> 4M read	4,576.7 MB/s	4,406.7 MB/s	4,052.2 MB/s	3,566.6 MB/s
> 4M write	3,146.8 MB/s	1,337.2 MB/s	1,259.9 MB/s	1,856.4 MB/s

> Note that each individual SSD tests out as follows:
> 
> 4k read: 56,342 IO/s
> 4k write: 33,792 IO/s
> 4M read: 231 MB/s
> 4M write: 130 MB/s

This looks like a filesystem limitation.

> My concerns:
> 
> 1. Given the above individual SSD performance, 24 SSD's in an md array
> is at best getting 4K read/write performance of 2-3 drives, which
> seems very low. I would expect significantly better linear scaling.
> 2. On the other hand, 4M read/write are performing more like 10-15
> drives, which is much better, though still seems like it could get
> better.
> 3. 4k read/write looks good for RAID 0, but drop off by over 40% with
> RAID 5. While somewhat understandable on writes, why such a
> significant hit on reads?
> 4. RAID 5 4M writes take a big hit compared to RAID 0, from 3146 MB/s
> to 1337 MB/s. Despite the RAID 5 overhead, that still seems huge given
> the CPU's at hand. Why?
> 5. Using a RAID 0 across two 11-SSD RAID 5's gives better RAID 5 4M
> write performance, but worse in reads and significantly worse in 4K
> reads/writes. Why?
> 
> Any thoughts would be greatly appreciated, especially patch ideas for
> tweaking options. Thanks!

Your filesystem interaction with mdraid levels (stripe/chunk meshing)
may be limiting your performance.  FIO does test files IIRC, not direct
block IO.  Are you using EXT3/4?  XFS?

I suggest you try the following.  Create an md raid *linear* array of
all 24 SSDs using a 4KB chunk size.  Format the resulting md device with
XFS specifying 24 allocation groups, not other options.  Something like:

~# mdadm -C /dev/md0 -n=24 -c=4 -l=linear /dev/sd[a..x]
~# mdadm -A /dev/md0 /dev/sb[a..x]
~# mkfs.xfs /dev/md0 -d agcount=24

This setup will parallelize the IO load at the file level instead of at
the stripe or chunk level of the md RAID layer.  Each file in the test
will be wholly written to and read from only one SSD, but you'll get 24
parallel streams, one to/from each SSD.  (You can do the same thing with
RAID 10, 6, etc, but files will get striped across multiple drives,
which doesn't work well for small files)

Simply specify agcount=[number of actual data devices], not including
devices, or space, consumed by redundancy.  For example, in a 10 disk
RAID 10 you'd use agcount=5.  For a 10 disk RAID 6, agcount=8, and so on.

Since you're using 2.6.38 you'll want to enable XFS delayed logging,
which speeds up large metadata write loads substantially.  To do so,
simply add 'delaylog' to your fstab mount options, such as:

/dev/md0       /test           xfs     defaults,delaylog

I'm interested to see what kind of performance increase you get with
this setup.

-- 
Stan
