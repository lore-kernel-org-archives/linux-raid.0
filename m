From: Lan Huang <lanhuang@cs.sunysb.edu>
Subject: high CPU utilization of RAID or JBOD
Date: Thu, 15 Aug 2002 22:41:34 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0208152230170.13408-100000@compserv3>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: Lan Huang <lanhuang@cs.sunysb.edu>
List-Id: linux-raid.ids


Hi,

I am confused about the numbers regarding CPU utilization I got
lately on a RAID or JBOD.

With linux 2.4.18 kernel, Intel motherboard, 4 IBM DTLA 7200rpm
disk connected to system through Promise Ultra100 card.
I used vmstat to get CPU utilization. It is quite high.

One testing program open a raw device and sequentially read 64k chunk from
it. I got 40% CPU utilization by sequential read one ide disk at 64K size.
The throughput is about 37 MB/sec.
100% when accessing four disk as JBOD, i.e., four testing program
accessing four  disk separately.
40% when accessing these 4 drives as one RAID-5 disk array.


It is just too high. Similar high numbers of CPU utilziation can be seen
from others' tests like http://www.nobell.org/~gjm/linux/ide-raid/

What does the kernel do then? DMA is on. Is it memcpy? call back funtions?
I don't think it is memcpy, as I simulate the amount of bytes to be
memcpyed in use-level, it takes less than 5% CPU.

Thanks,
Lan

