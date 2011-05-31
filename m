From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?= <st0ff@gmx.net>
Subject: Re: Optimizing small IO with md RAID
Date: Tue, 31 May 2011 05:23:08 +0200
Message-ID: <4DE45F1C.1090305@gmx.net>
References: <BANLkTi=236kncpunzodSci-1K33u_FBkPA@mail.gmail.com>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=236kncpunzodSci-1K33u_FBkPA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "fibreraid@gmail.com" <fibreraid@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

are those LSISAS2008 in IR or in IT mode?  Software RAID performance on
those controllers is really bad with a high throw-out in IR mode, as the
IR mode is made for those "integrated RAID" types like RAID0, RAID1,
RAID1E and RAID10.

We've seen much better SoftwareRAID performance on this Controller in IT
(IniTiator) Mode.  See
http://www.lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas/internal/sas9211-8i/index.html#Product%20Brief
the downloads site.

If your controller BIOS already says: "SAS2008-IT" or "LSI 9211-IT" on
boot-up, then you already got IT Firmware on it.  That would be the
moment I'd start thinking about a 9265 Controller and not software RAID.

I mean, with a Westmere board and CPU ... you spend enough money on the
hardware, but you want to save on the real bottleneck?  Sounds a bit
irrational to me...

Cheers,
Stefan

Am 30.05.2011 09:14, schrieb fibreraid@gmail.com:
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
> Best,
> Tommy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

