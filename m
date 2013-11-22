From: joystick <joystick@shiftmail.org>
Subject: Re: Triple parity and beyond
Date: Fri, 22 Nov 2013 12:24:51 +0100
Message-ID: <528F3F03.9020803@shiftmail.org>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com>	<CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com>	<528BCA2D.5010500@redhat.com>	<73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu>	<528D61C5.70902@hardwarefreak.com>	<CAJBj3vf7Ot2oUkk6LtkWRouFqrSCKecz0yD4Ds5UGT1BL1ds5A@mail.gmail.com>	<528DADB1.8010604@hardwarefreak.com>	<CAJBj3vcE07FYi-+xMxwd+u6dVfFU0ryU=j+ekmG8p=cgMhU74g@mail.gmail.com>	<528E8FEC.2070204@hardwarefreak.com> <CAJBj3veHCTbGstLoUec67sMWuyHQMmZNY4A6bwcb+HQOgjJ_Ew@mail.gmail.com> <528F2575.80605@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <528F2575.80605@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 22/11/2013 10:35, Stan Hoeppner wrote:
> This is precisely why I proposed "RAID 15".  It gives you the single
> disk cloning rebuild speed of RAID 10.  When parity hits 5P then RAID 15
> becomes very competitive for smaller arrays.

Fair enough for smaller arrays, and you can already do that because 
raid15 needs no additional code in the kernel.
What about big arrays?
Your solution is to double the price, and without calculations I'd bet 
is less resilient than 4P for up to at least 200 disks.
So you propose to buy 100 more disks to save some rebuild time?

Note that the rebuild time depends on:
1: disks capacity vs linear read/write speeds, which is the same for 
raid51 and 3+P cases
2: cpu power. But 500MB/sec claimed by Andrea is already pretty good and 
parallelizable on multiple cores. By the time the disks will reach 8TB, 
we will also have many more cores on CPUs. Additionally, probably for 1 
failure only, just the 1st parity would be used for computation, and in 
that case the rebuild speed would approach that of raid5 which is pretty 
fast.

Your solution is also less extensible. After raid15 you only have 
raid16. Additional levels don't follow your philosophy.


