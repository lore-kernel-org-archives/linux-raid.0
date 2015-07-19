From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: Raid5 fails to assemble automatically
Date: Sun, 19 Jul 2015 17:09:55 +0200
Message-ID: <55ABBDC3.2070305@grumpydevil.homelinux.org>
References: <BLU437-SMTP68684C478276C82E113DE6CE860@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU437-SMTP68684C478276C82E113DE6CE860@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Marc Desharnais <marcdesharnais@hotmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Marc,

On 19-07-15 16:26, Marc Desharnais wrote:
> Hi,
>
> I'm new to this mailing list but I subscribed because of this problem 
> with my raid5.
> I really don't want to mess this up and it was clearly suggested to 
> not rush things on the wiki. So I'm looking for help :)
> My raid has been running great for a long time now but I think it 
> needs so serious maintenance.
> I have a 4 disks raid 5 on ArchLinux, mdadm version 3.3.1.
>
> First, the raid status :
>
> /dev/sda:
>
>    1     1       0        0        1      faulty removed
>
> /dev/sdb:
>
>    1     1       0        0        1      faulty removed
>    3     3       0        0        3      faulty removed
> /dev/sdd:
>
>       Number   Major   Minor   RaidDevice State
> this     1       8       16        1      active sync   /dev/sdb
>
>    0     0       8       32        0      active sync   /dev/sdc
>    1     1       8       16        1      active sync   /dev/sdb
>    2     2       8       48        2      active sync   /dev/sdd
>    3     3       8       64        3      active sync   /dev/sde
> /dev/sde:
>
>
>       Number   Major   Minor   RaidDevice State
> this     0       8       64        0      active sync   /dev/sde
>
>    0     0       8       64        0      active sync   /dev/sde
>    1     1       0        0        1      faulty removed
>    2     2       8       16        2      active sync   /dev/sdb
>    3     3       0        0        3      faulty removed
>
>
>
> Obvisously the event count is wrong on 2 disks. One disk has been gone 
> for a long time now...
>
> 1 - First question : how can I safely assemble the raid to the latest 
> sync state? I don't want to mess this up.
> 2 - Does this mean my hard drives are dead, or simply desync?
>
>
> Also I tried to force assemble :
>  mdadm --assemble --force /dev/md0 /dev/sda /dev/sdb /dev/sde
>
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

First:
- what information is in dmesg or kern.log, or whererever your distro 
stores disk messages? Asking only for the relevant parts about the disks :)
- Do  you have any idea when the disks were kicked out?
- can you give the output of smartctl -a for each disk?
- output of cat /proc/mdstat?

The assemble you tried is probably failing because the raid is assembled 
but not started. Doing a "mdadm -S /dev/md0" should take care of that.

Cheers

Rudy
