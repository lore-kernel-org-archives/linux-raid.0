From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: RAID5 up, but one drive removed, one says spare building, what
 now?
Date: Fri, 10 Nov 2017 11:31:49 +0000
Message-ID: <5A058E25.1020608@youngman.org.uk>
References: <CAA4aoFaEwv=EPcotAbjzkgXWoOFwxo2XAoMzN1Zfb62k4Fngxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA4aoFaEwv=EPcotAbjzkgXWoOFwxo2XAoMzN1Zfb62k4Fngxw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jun-Kai Teoh <kai.teoh@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>, Phil Turmel <philip@turmel.org>
List-Id: linux-raid.ids

On 10/11/17 03:09, Jun-Kai Teoh wrote:
> Hi all,
> 
> I managed to get my RAID drive back up, content looks like it's still
> there, but it's not resyncing or reshaping and my parity drive was
> removed (I did it when I tried to get it back up).
> 
> So what should I do now? I'm afraid of doing anything else at this point.
> 
> /dev/md126:
>         Version : 1.2
>   Creation Time : Thu Jun 30 07:57:36 2016
>      Raid Level : raid5
>      Array Size : 23441323008 (22355.39 GiB 24003.91 GB)
>   Used Dev Size : 3906887168 (3725.90 GiB 4000.65 GB)
>    Raid Devices : 8
>   Total Devices : 7
>     Persistence : Superblock is persistent
> 
>   Intent Bitmap : Internal
> 
>     Update Time : Thu Nov  9 18:57:18 2017
>           State : clean, FAILED
>  Active Devices : 6
> Working Devices : 7
>  Failed Devices : 0
>   Spare Devices : 1
> 
>          Layout : left-symmetric
>      Chunk Size : 512K
> 
>   Delta Devices : 1, (7->8)
> 
>            Name : livingrm-server:2  (local to host livingrm-server)
>            UUID : f7333d4f:8300969d:55148d64:93c8afc8
>          Events : 650582
> 
>     Number   Major   Minor   RaidDevice State
>        0       8      112        0      active sync   /dev/sdh
>        1       8       48        1      active sync   /dev/sdd
>        7       8       64        2      spare rebuilding   /dev/sde
>        3       8       96        3      active sync   /dev/sdg
>        4       8       32        4      active sync   /dev/sdc
>        5       8       80        5      active sync   /dev/sdf
>        6       8       16        6      active sync   /dev/sdb
>       14       0        0       14      removed

Okay. I was hoping someone else would chime in, but I'd say this looks
well promising. You have seven drives of eight so you have no redundancy :-(

You say your data is still there - does that mean you've mounted it, and
it looks okay?

sde is rebuilding, which means the array is sorting itself out.

You need that eighth drive. If a fsck says you have no (or almost no)
filesystem corruption, and you have a known-good drive, add it in. The
array will then sort itself out.

I would NOT recommend mounting it read-write until it comes back and
says "eight drives of eight working".

Cheers,
Wol

