From: Phil Turmel <philip@turmel.org>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Sun, 27 Jan 2013 20:14:18 -0500
Message-ID: <5105D0EA.7080100@turmel.org>
References: <20130127192656.634892005AD@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130127192656.634892005AD@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/27/2013 02:26 PM, Wolfgang Denk wrote:
> I have seen "mismatch_cnt is not 0" warnings in the past, but that has
> always been with RAID 1 arrays, and with relatively small numbers on
> /sys/block/md*/md/mismatch_cnt; my understanding was that this was not
> actually critical.
> 
> However, after updating to Fedora 18, I get this message from all
> updated
> systems that have RAID 6 arrays, and with _huge_ numbers of
> mismatch_cnt, like that:
> 
> fter updating to Fedora 18, I get this message from all updated
> systems that have RAID 6 arrays, and with _huge_ numbers of
> mismatch_cnt, like that:
> 
> # mdadm -q --detail /dev/md0
> /dev/md0:
>         Version : 1.2
>   Creation Time : Mon Jan 14 14:20:34 2013

Something is missing from this story.  Was the original system created
this month, and immediately upgraded?  Or was there a "mdadm --create"
in this story you haven't told us about?

>      Raid Level : raid6
>      Array Size : 1459617792 (1392.00 GiB 1494.65 GB)
>   Used Dev Size : 243269632 (232.00 GiB 249.11 GB)
>    Raid Devices : 8
>   Total Devices : 8
>     Persistence : Superblock is persistent
> 
>     Update Time : Sun Jan 27 02:27:28 2013
>           State : clean 
>  Active Devices : 8
> Working Devices : 8
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 16K
> 
>            Name : XXX:0  (local to host XXX)
>            UUID : da015f96:138b37bf:d5ef71dc:8970ab15
>          Events : 8
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       49        0      active sync   /dev/sdd1
>        1       8       65        1      active sync   /dev/sde1
>        2       8       81        2      active sync   /dev/sdf1
>        3       8       97        3      active sync   /dev/sdg1
>        4       8      113        4      active sync   /dev/sdh1
>        5       8      129        5      active sync   /dev/sdi1
>        6       8      145        6      active sync   /dev/sdj1
>        7       8      161        7      active sync   /dev/sdk1
> # cat /sys/block/md0/md/mismatch_cnt
> 362732152
> 
> 
> This is with mdadm v3.2.6 (mdadm-3.2.6-7.fc18.x86_64); except for the
> huge values of mismatch_cnt, I see no other indications for errors on
> the disk drives, RAID arrays or the file systems on top of these.
> 
> Is this some known (and hopefully harmless), issue, or must I worry
> about our data?

I would be worried, but there's not enough information here to say.

Please share the output of "mdadm -E /dev/sd[defghijk]1".

Please also explain/share what you've done to conclude the filesystem is
error-free.

Phil
