From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: Please help- raid1 recovery after disk failure
Date: Mon, 18 Oct 2004 18:22:05 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1098141725.5229.47.camel@MIKETRAN.austin.ibm.com>
References: <20041018225652.GC29864@sam.triumf.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041018225652.GC29864@sam.triumf.ca>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I would re-create md0 array with a missing disk as follows:

mdadm -C /dev/md0 -l 1 -n 2 /dev/hdc2 missing

Later you can hot add a disk to make it a normal 2-way mirror array.

--
Regards,
Mike T.

On Mon, 2004-10-18 at 17:56, Konstantin Olchanski wrote:
> Dear Linux raiders- I ran into a problem with raid1 recovery after
> a disk failure (running Fedora2, kernel 2.6.8-1.521smp).
> 
> 1) I had a raid1 filesystem mirrored across /dev/hda2 and /dev/hdc2.
> 2) Disk hda died (unreadable sectors, fails SMART tests)
> 3) A new blank hda was installed and partitionned exactly like hdc.
> 4) I cannot restart and rebuild the raid1 volume because hdc2 is
>    in a funny "spare" state (see below)
> 
> How do I mark hdc2 as "active"?
> Once "active", I assume then I will be able to restart md0,
> hot-add /dev/hda2 as usual. (And the mirror will resync and rebuild itself?
> Hopefully?)
> 
> [root@tw04 root]# mdadm -E /dev/hdc2
> /dev/hdc2:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : aade8782:20122089:4f496788:228d85b9
>   Creation Time : Fri Oct  8 17:12:56 2004
>      Raid Level : raid1
>     Device Size : 124158208 (118.41 GiB 127.14 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 0
> 
>     Update Time : Mon Oct 18 06:04:35 2004
>           State : clean, no-errors
>  Active Devices : 1
> Working Devices : 2
>  Failed Devices : 1
>   Spare Devices : 1
>        Checksum : 7041db42 - correct
>          Events : 0.312429
> 
> 
>       Number   Major   Minor   RaidDevice State
> this     2      22        2        2      spare   /dev/hdc2
>    0     0       3        2        0      active sync   /dev/hda2
>    1     1       0        0        1      faulty removed
>    2     2      22        2        2      spare   /dev/hdc2
> [root@tw04 root]# 

