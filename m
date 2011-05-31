From: Joe Landman <joe.landman@gmail.com>
Subject: Re: Optimizing small IO with md RAID
Date: Mon, 30 May 2011 23:48:50 -0400
Message-ID: <4DE46522.1060705@gmail.com>
References: <BANLkTi=236kncpunzodSci-1K33u_FBkPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=236kncpunzodSci-1K33u_FBkPA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "fibreraid@gmail.com" <fibreraid@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/30/2011 03:14 AM, fibreraid@gmail.com wrote:
> Hi all,
>
> I am looking to optimize md RAID performance as much as possible.
>
> I've managed to get some rather strong large 4M IOps performance, but
> small 4K IOps are still rather subpar, given the hardware.

Understand that much of what passes for realistic test cases for SSDs 
are ... well ... not that good.  Write something other than zeros, and 
turn off write caching on the SSDs.  Then you get similar results to 
what you see.

[...]

> In each case below, the md chunk size was 64K. In RAID 5 and RAID 6,
> one hot-spare was specified.
>
> 	raid0 24 x SSD	raid5 23 x SSD	raid6 23 x SSD	raid0 (2 * (raid5 x 11 SSD))						
> 4K read	179,923 IO/s	93,503 IO/s	116,866 IO/s	75,782 IO/s
> 4K write	168,027 IO/s	108,408 IO/s	120,477 IO/s	90,954 IO/s

A 4k random read/write? Or a sequential?  The 4k sequential reads/writes 
will be merged into a larger size.

A 4k write is going to result in a read-modify-write cycle for this 
config.

These results suggest a 7k IOP 4k write performance, and about 7.5k IOP 
4k read performance.  Are these Intel drives?  These numbers are in line 
with what I've measured for them.

> 4M read	4,576.7 MB/s	4,406.7 MB/s	4,052.2 MB/s	3,566.6 MB/s
> 4M write	3,146.8 MB/s	1,337.2 MB/s	1,259.9 MB/s	1,856.4 MB/s
>
> Note that each individual SSD tests out as follows:
>
> 4k read: 56,342 IO/s
> 4k write: 33,792 IO/s
> 4M read: 231 MB/s
> 4M write: 130 MB/s

Is write caching on in this case but not the other?

>
>
> My concerns:
>
> 1. Given the above individual SSD performance, 24 SSD's in an md array
> is at best getting 4K read/write performance of 2-3 drives, which
> seems very low. I would expect significantly better linear scaling.

You've got lots of RMW cycles going on for the write side, I wouldn't 
expect million IOP performance out of a system like this.


> 2. On the other hand, 4M read/write are performing more like 10-15
> drives, which is much better, though still seems like it could get
> better.

These controllers are often on PCIe-x8 gen 2 ports.  Thats 4GB/s maximum 
in each direction.  After the overhead on the bus,  you get 86% of the 
remaining bandwidth.  This is 3.4 GB/s.  So your 4+ GB/s results are 
either the result of caching, or multiple controllers. Since I see the 
direct=1, I am guessing multiple controllers.   Unless you have a single 
controller in a PCIe-x16 gen 2 slot ...



-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics, Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
