From: "NeilBrown" <neilb@suse.de>
Subject: Re: properly configure degraded array
Date: Fri, 24 Jul 2009 07:54:51 +1000 (EST)
Message-ID: <7f9b256f460f6a4b57505d0969480bcf.squirrel@neil.brown.name>
References: <3d22fc520907231150m70f24365xcd0544f29a03bc12@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3d22fc520907231150m70f24365xcd0544f29a03bc12@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Aldo Foot <lunixer@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, July 24, 2009 4:50 am, Aldo Foot wrote:
> I have a raid setup from which I physically removed a hard drive.
> The array has three good active physical devices.
> The output from mdadm shows "Raid Devices : 4" and "Total Devices : 3"
> My objective is to removed all indications of the removed device. Note
> that
> the removed drive has no device name associated with it, so I cannot
> remove it with mdadm.
> Is it as simple as editing the /etc/mdadm.conf to "num-devices=3"? Would
> that change the "State : clean, degraded " to just clean?
> Is there something else that needs to be done to do this correctly?
>
> Here's what the config looks like at the moment:
>
> # mdadm -D /dev/md0
> /dev/md0:
>         Version : 0.90
>   Creation Time : Fri Jul 10 02:39:32 2009
>      Raid Level : raid1
>      Array Size : 24000 (23.44 MiB 24.58 MB)
>   Used Dev Size : 24000 (23.44 MiB 24.58 MB)
>    Raid Devices : 4
>   Total Devices : 3
> Preferred Minor : 0
>     Persistence : Superblock is persistent
>
>     Update Time : Thu Jul 23 04:18:18 2009
>           State : clean, degraded
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
>
>            UUID : fafe2b90:7ae3cb68:2011742e:3cbab095 (local to host
> xxxxxxxxxx)
>          Events : 0.82
>
>     Number   Major   Minor   RaidDevice State
>        0       8       17        0      active sync   /dev/sdb1
>        1       8       33        1      active sync   /dev/sdc1
>        2       8        8        2        active sync   /dev/sda8
>        3       0        0        3       removed
>
> # mdadm --detail --scan
> ARRAY /dev/md0 level=raid1 num-devices=4 metadata=0.90
> UUID=fafe2b90:7ae3cb68:2011742e:3cbab095
>
> any thoughts appreciated,

mdadm --grow /dev/md0 --raid-devices=3

NeilBrown


> ~af
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

