From: David Brown <david@westcontrol.com>
Subject: Re: Optimizing small IO with md RAID
Date: Mon, 30 May 2011 13:20:56 +0200
Message-ID: <irvuj1$rc3$1@dough.gmane.org>
References: <BANLkTi=236kncpunzodSci-1K33u_FBkPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=236kncpunzodSci-1K33u_FBkPA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30/05/2011 09:14, fibreraid@gmail.com wrote:
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
>
> In each case below, the md chunk size was 64K. In RAID 5 and RAID 6,
> one hot-spare was specified.
>
> 	raid0 24 x SSD	raid5 23 x SSD	raid6 23 x SSD	raid0 (2 * (raid5 x 11 SSD))						
> 4K read	179,923 IO/s	93,503 IO/s	116,866 IO/s	75,782 IO/s
> 4K write	168,027 IO/s	108,408 IO/s	120,477 IO/s	90,954 IO/s
> 4M read	4,576.7 MB/s	4,406.7 MB/s	4,052.2 MB/s	3,566.6 MB/s
> 4M write	3,146.8 MB/s	1,337.2 MB/s	1,259.9 MB/s	1,856.4 MB/s
>
> Note that each individual SSD tests out as follows:
>
> 4k read: 56,342 IO/s
> 4k write: 33,792 IO/s
> 4M read: 231 MB/s
> 4M write: 130 MB/s
>
>
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
>
> Any thoughts would be greatly appreciated, especially patch ideas for
> tweaking options. Thanks!
>

(This is in addition to what Stan said about filesystems, etc.)

If my mental calculations are correct, writing 4M to this raid5/raid6 
setup takes about 1.5 stripes.  Typically that will mean two partial 
stripe writes (or even two partials and one full).  Partial stripe 
writes on raid5/6 means reading in most of the old stripe, calculating 
the new parity, and writing out the new data and parity.  When you tried 
with a raid0 of two raid5 groups, this effect was less because more of 
the writes were full stripes.

With SSDs, you have very low latency between a read system call and the 
data being accessed - that's what gives it a high IOps.  But it also 
means that layers of indirection such as more complex raid or layered 
raid have more effect.

Try your measurements with a raid10,far setup.  It costs more on data 
space, but should, I think, be quite a bit faster.

