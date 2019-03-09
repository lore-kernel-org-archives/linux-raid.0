From: Michael Leun <linux-raid-20190308@newton.leun.net>
Subject: Re: Raid 5 painfully slow with linux 5.0.0
Date: Sat, 9 Mar 2019 15:06:35 +0100
Message-ID: <a970bfdc-97c1-53c6-0966-f83743a6190e@jill.leun.net>
References: <35ddef28-a449-72a8-933f-341e3535546a@newton.leun.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <35ddef28-a449-72a8-933f-341e3535546a@newton.leun.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-raid.ids

Hello,

Am 08.03.19 um 20:53 schrieb linux-raid-20190308@newton.leun.net:

since Linux 5.0 my md raid5 is painfully slow, ~100 kb/s, bisected that,
bisect blames

5d2ee7122c73be6a3b6bfe90d237e8aed737cfaa is the first bad commit
commit 5d2ee7122c73be6a3b6bfe90d237e8aed737cfaa
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Nov 29 17:36:41 2018 -0700


when trying to revert that from v5.0 I get a conflict and do not know
how to resolve that. Please help/fix.

Best Regards,

Michael Leun


> Hello,
> 
> I have a raid5 array consisting of 4 8TB disks connected via USB3.
> 
> [ml@xenia ~]$ cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md127 : active raid5 sde1[4] sdc1[1] sdd1[2] sdb1[0]
>       23441682432 blocks super 1.2 level 5, 512k chunk, algorithm 2
> [4/4] [UUUU]
>       bitmap: 0/59 pages [0KB], 65536KB chunk
> 
> unused devices: <none>
> [ml@xenia ~]$
> 
> Up to and including kernel 4.20.13-arch1 everything is fine and I get
> reasonable performance:
> 
> [root@xenia ml]# dd if=/dev/md127 of=/dev/null bs=2M status=progress
> 3078619136 bytes (3,1 GB, 2,9 GiB) copied, 13 s, 237 MB/s^C
> 1516+0 Datensätze ein
> 1515+0 Datensätze aus
> 3177185280 bytes (3,2 GB, 3,0 GiB) copied, 13,4403 s, 236 MB/s
> 
> [root@xenia ml]# uname -a
> Linux xenia.leun.net 4.20.13-arch1-1-ARCH #1 SMP PREEMPT Wed Feb 27
> 19:10:28 UTC 2019 x86_64 GNU/Linux
> [root@xenia ml]#
> 
> 
> With kernel 5.0.0-arch1-1-ARCH (also verified that with kernel.org
> 5.0.0) I get PAINFULLY slow performance on the raid, but the performance
> of the disks the array consists of is ok:
> 
> [root@xenia ml]# dd if=/dev/md127 of=/dev/null bs=2M status=progress
> 6291456 bytes (6,3 MB, 6,0 MiB) copied, 41 s, 154 kB/s^C
> 4+0 Datensätze ein
> 3+0 Datensätze aus
> 6291456 bytes (6,3 MB, 6,0 MiB) copied, 59,0605 s, 107 kB/s
> 
> [root@xenia ml]# dd if=/dev/sdb1 of=/dev/null bs=2M status=progress
> 1642070016 bytes (1,6 GB, 1,5 GiB) copied, 8 s, 205 MB/s^C
> 806+0 Datensätze ein
> 805+0 Datensätze aus
> 1688207360 bytes (1,7 GB, 1,6 GiB) copied, 8,23402 s, 205 MB/s
> 
> [root@xenia ml]#
> 
> (The other 3 disks show the same speed)
> 
> Any idea why it is THAT slow?
> 
> Best Regards,
> 
> Michael Leun
> 
