From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid5 on 2.4.21 and reconstruction problem
Date: Fri, 8 Aug 2003 10:51:02 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16178.62454.491319.462538@gargle.gargle.HOWL>
References: <200308071250.18543.arekm@pld-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Arkadiusz Miskiewicz on Thursday August 7
To: Arkadiusz Miskiewicz <arekm@pld-linux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday August 7, arekm@pld-linux.org wrote:
> Hi,
> 
> I have two raid 5 partitions - md0 (as for root fs) and md1 (for /home).
> 
...
> [root@perfo arekm]# mdadm -D /dev/md0
> /dev/md0:
>         Version : 00.90.00
>   Creation Time : Tue May  4 09:37:53 1999
>      Raid Level : raid5
>      Array Size : 9960064 (9.50 GiB 10.20 GB)
>     Device Size : 4980032 (4.75 GiB 5.10 GB)
>    Raid Devices : 3
>   Total Devices : 4
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>     Update Time : Thu Aug  7 12:48:34 2003
>           State : dirty, no-errors
>  Active Devices : 2
> Working Devices : 0
>  Failed Devices : 3 
>   Spare Devices : 0

"Spare Devices : 0" is the problem.  It thinks there aren't any
spares, even though there obviously is one...
The code in the kernel for keeping these counters up-to-date is very
fragile and I'm not surprised that it occasionally gets things wrong.

> 
> Both arrays was created under some 2.2 kernel. Resync doesn't happen on 2.5.25, too.
> 

2.5.25 is ancient!
2.6.0-test2 should be able to assemble it (it ignores those counts)
but there is some data corruption bug that I am hitting in
2.6.0-test2 that could well be raid5 related, so I'm not sure I
would recommend that.

I could probably knock up a patch to 2.4.21 in a couple of days that
corrects the counts when an array is assembled.
Alternatively if you can boot off a rescue disk, then
  mdadm -C /dev/md0 -l5 -c 32 -n 3 /dev/sda2 /dev/sdb2 missing
  mdadm /dev/md0 -a /dev/sdc2

should get you out of trouble.

NeilBrown
