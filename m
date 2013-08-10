From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Recovering from two almost simultaneously failed devices in RAID1
Date: Sat, 10 Aug 2013 18:45:28 +0100
Message-ID: <CADNH=7G=MFJuwrTQ=r4uFgTji87iVr3ou04q7yN50tCojJGKfA@mail.gmail.com>
References: <52066A7A.5050007@aei.mpg.de>
	<52066B43.1010901@aei.mpg.de>
	<52067ADB.8080100@aei.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52067ADB.8080100@aei.mpg.de>
Sender: linux-raid-owner@vger.kernel.org
To: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

What's the smartctl -a output for both drives? You might have bad SATA
cables. Also smartctl -t long (takes 1 minute) might be worth it. Not
sure how useful that is on SSDs.

Mathias

On 10 August 2013 18:39, Carsten Aulbert <Carsten.Aulbert@aei.mpg.de> wrote:
> *sigh*
>
> Thanks to me being at home and only IPMI access with relatively high
> latencies, I did not manage to boot into single user mode and the system
> booted up normally - luckily for me, both md and ext4 tell me, the file
> system is safe and ok.
>
>
> # mdadm --detail /dev/md2
> /dev/md2:
>         Version : 1.2
>   Creation Time : Fri Jul 27 11:58:50 2012
>      Raid Level : raid1
>      Array Size : 250050533 (238.47 GiB 256.05 GB)
>   Used Dev Size : 250050533 (238.47 GiB 256.05 GB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
>
>     Update Time : Sat Aug 10 19:38:01 2013
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>
>            Name : gitmaster:2  (local to host gitmaster)
>            UUID : 7cb262a7:54496605:238cc0bf:6fa6a3e9
>          Events : 61
>
>     Number   Major   Minor   RaidDevice State
>        0       8       49        0      active sync   /dev/sdd1
>        1       8       33        1      active sync   /dev/sdc1
>
>
> I think I got really lucky (still running checks on the git repositories
> on this md).
>
> Anyone who experienced such a problem with SSDs (or HDDs) being
> disconnected like this?
>
> Cheers
>
> Carsten
>
