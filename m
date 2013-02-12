From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Unable to reactivate a RAID10 mdadm device
Date: Tue, 12 Feb 2013 19:32:06 +1100
Message-ID: <5119FE06.5070300@websitemanagers.com.au>
References: <CAHhM8gBza3j-3qE3dRkZy14_cO-6EjOjW-zU8mtHVxhy6EWrtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHhM8gBza3j-3qE3dRkZy14_cO-6EjOjW-zU8mtHVxhy6EWrtw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Arun Khan <knura9@gmail.com>
Cc: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/02/13 18:16, Arun Khan wrote:
> Recovery OS -- System Rescue CD v 2.8.0
>
> Production OS - Debian Squeeze (6) 2.6.32 stock kernel, using mdadm raid
>
> /dev/md0 in raid level RAID10 - members /dev/sdb1, /dev/sdc1,
> /dev/sdd1, /dev/sde1 all with partion id=fd
>
> HDD /dev/sdb went bad, replaced it with another disk with same size
> partion (id=fd)
> using System Rescue CD v2.8.0
>
> 1. System Rescue CD recognized the md devices but it comes up as 'inactive'
>
> Searched for possible solutions and I have tried several things including
> zeroing the super block and adding them back to the array.
>
> Still unable to bring back /dev/md0 with all 4 partions in active mode.
>
> I have included below, the entire transcript of the commands I have
> tried to recover /dev/md0
>
> I have data on /dev/md0 that I need. I do have back ups of critical
> files (but not all).
>
> I prefer solving the problem v/s recreating the /dev/md0 from scratch.
>
> Any help in solving this problem would be highly appreciated.
>
> TIA,
> -- Arun Khan
>
> ---------------  transcript of mdadm activity  with System Rescue CD
> v2.8.0  ----------------
>
> # mdadm -V
> mdadm - v3.1.4 - 31st August 2010
>
> # cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : inactive sdd1[2] sde1[3]
>       312574512 blocks super 1.0
>
> # mdadm -S /dev/md0
> mdadm: stopped /dev/md0
>
> # cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> unused devices: <none>
>
>
> # mdadm -v -v -A /dev/md0 -R /dev/sd[bcde]1
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
> mdadm: added /dev/sdb1 to /dev/md0 as 0
> mdadm: added /dev/sdc1 to /dev/md0 as 1
> mdadm: added /dev/sde1 to /dev/md0 as 3
> mdadm: added /dev/sdd1 to /dev/md0 as 2
> mdadm: failed to RUN_ARRAY /dev/md0: Input/output error
> mdadm: Not enough devices to start the array.

Within the last month or thereabouts, I saw a patch go past the list
which indicated that this might happen. Perhaps you need either a newer,
or older version of md (linux kernel) or mdadm.

The issue was failing to start an array which had enough members to
start while a member was marked failed or something like that....

You didn't mention the kernel version (or I've missed it) but that is my
suggestion, certainly before you try anything destructive....

Or someone else may have a more sensible solution for you (hopefully).

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

