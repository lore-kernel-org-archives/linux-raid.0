From: "NeilBrown" <neilb@suse.de>
Subject: Re: mdadm raid1 stops to work after kernel panic
Date: Mon, 5 May 2008 21:41:54 +1000 (EST)
Message-ID: <54900.192.168.1.70.1209987714.squirrel@neil.brown.name>
References: <26c008d70805042347g1afaa67em5a7af935bed434ca@mail.gmail.com>
    <56088.192.168.1.70.1209979931.squirrel@neil.brown.name>
    <26c008d70805050256q65972fa7jb86c6d5254828fc1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <26c008d70805050256q65972fa7jb86c6d5254828fc1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Federico <undicizeri@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[please don't drop the list from the cc: line - I've re-added it]

On Mon, May 5, 2008 7:56 pm, Federico wrote:
> wax@persifae:~$sudo !!
> sudo mdadm --examine /dev/sda1 /dev/sdc1

Thanks.  That looks fairly normal.  sda1 is thought to be out-of-date
so you would expect mdadm to assemble the array with just sdc1
as a member.  You would then need to add sda1 as a spare and it would
rebuild.
I wonder why it isn't including sdc1 at first.

What happens if you:
  mdadm -S /dev/md2
  mdadm -A /dev/md2 /dev/sda1 /dev/sdc1
??

NeilBrown


> Parola d'ordine:
> /dev/sda1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 62a5cb51:36ca61a3:1298e6c2:30fde3ba
>   Creation Time : Mon May  5 04:39:59 2008
>      Raid Level : raid1
>   Used Dev Size : 293049600 (279.47 GiB 300.08 GB)
>      Array Size : 293049600 (279.47 GiB 300.08 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 2
>
>     Update Time : Mon May  5 06:15:31 2008
>           State : active
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 27e6bd76 - correct
>          Events : 0.9
>
>
>       Number   Major   Minor   RaidDevice State
> this     0       8        1        0      active sync   /dev/sda1
>
>    0     0       8        1        0      active sync   /dev/sda1
>    1     1       8       33        1      active sync   /dev/sdc1
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 62a5cb51:36ca61a3:1298e6c2:30fde3ba
>   Creation Time : Mon May  5 04:39:59 2008
>      Raid Level : raid1
>   Used Dev Size : 293049600 (279.47 GiB 300.08 GB)
>      Array Size : 293049600 (279.47 GiB 300.08 GB)
>    Raid Devices : 2
>   Total Devices : 1
> Preferred Minor : 0
>
>     Update Time : Mon May  5 09:16:19 2008
>           State : active
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 27e6e7e5 - correct
>          Events : 0.11
>
>
>       Number   Major   Minor   RaidDevice State
> this     1       8       33        1      active sync   /dev/sdc1
>
>    0     0       0        0        0      removed
>    1     1       8       33        1      active sync   /dev/sdc1
>

