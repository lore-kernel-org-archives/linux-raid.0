From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [BUG?] count of "Spare Devices" wrong after fail/remove/add
Date: Wed, 22 Jan 2003 15:23:14 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15918.7346.888218.690481@notabene.cse.unsw.edu.au>
References: <3E2CA044.5030202@fl.priv.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Friedrich Lobenstock on Tuesday January 21
To: Linux RAID Mailing Liste <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday January 21, fl@fl.priv.at wrote:
> Hi!
> 
> While experimenting with fail/remove/add of mdadm
> 
> # mdadm --detail /dev/md0
> /dev/md0:
>          Version : 00.90.00
>    Creation Time : Mon Jan 20 22:53:28 2003
>       Raid Level : raid1
>       Array Size : 40209024 (38.35 GiB 41.22 GB)
>      Device Size : 40209024 (38.35 GiB 41.22 GB)
>     Raid Devices : 2
>    Total Devices : 2
> Preferred Minor : 0
>      Persistence : Superblock is persistent
> 
>      Update Time : Tue Jan 21 00:49:47 2003
>            State : dirty, no-errors
>   Active Devices : 2
> Working Devices : 2
>   Failed Devices : 0
>    Spare Devices : 2
> 
> 
>      Number   Major   Minor   RaidDevice State
>         0       3        1        0      active sync   /dev/hda1
>         1      22        1        1      active sync   /dev/hdc1
>             UUID : d876333b:694e852b:e9a6f40f:0beb90f9
> 
> I do wounder why I've got 2 spare drives despite the fact that I
> did not add any. I've just got two drives in this raid1 that's it.

Yes, it's probably a bug in the kernel code. The counting in the 2.4 code is very
clumsy.  I think it is benign so it wont be fixed.  The code in 2.5 is
very different and shouldn't have this problem.

> 
> Kernel is 2.4.19.
> mdadm is 1.0.1
> 
> I tried to reproduce this by recreating the array and running
> fail/remove/add on it but did not succeed. No reboot.
> 
> 
> PS: Array Size : 40209024 (38.35 GiB 41.22 GB)
> should IMHO be
>      Array Size : 40209024 (38.35 GiB 40.21 GB)

I disgree. An array side of 40209024 means that many kibibytes.
i.e. 40209024 * 1024 which is
   41174040576  bytes.

Hmm. It is still wrong,  It sholdbe 41.17 GB

The line:
			(long)((((bytes/1000)%1000000)+50000)/10000)
at the end of human_size in util.c should be
			(long)((((bytes/1000)%1000000)+5000)/10000)

NeilBrown
