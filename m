From: 002@tut.by
Subject: Re: mdadm stuck at 0% reshape after grow
Date: Tue, 05 Dec 2017 18:55:29 +0300
Message-ID: <1865221512489329@web5g.yandex.ru>
References: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeremy Graham <jeremy@doghouse.agency>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

A well known reason for this behavior are bad blocks in device's BBL, which you happen to have:


> $ mdadm --examine /dev/sd[bcdefg]1

> /dev/sde1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0xc
>      Array UUID : f39f89d2:1bcd3d55:d173d206:d85b8bbc
>            Name : homer2:1
>   Creation Time : Sun Dec 2 12:04:24 2012
>      Raid Level : raid5
>    Raid Devices : 6
>
>  Avail Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
>      Array Size : 14651317760 (13972.59 GiB 15002.95 GB)
>   Used Dev Size : 5860527104 (2794.52 GiB 3000.59 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=1960 sectors, after=1024 sectors
>           State : active
>     Device UUID : a33aacb4:00d283ef:5715be52:a0678279
>
>   Reshape pos'n : 491520 (480.00 MiB 503.32 MB)
>   Delta Devices : 1 (5->6)
>
>     Update Time : Tue Dec 5 18:30:50 2017
>   Bad Block Log : 512 entries available at offset 72 sectors - bad
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> blocks present.
^^^^^^^^^^^^^^^^^
>        Checksum : 978e30 - correct
>          Events : 4830578
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 3
>    Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sdf1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0xc
>      Array UUID : f39f89d2:1bcd3d55:d173d206:d85b8bbc
>            Name : homer2:1
>   Creation Time : Sun Dec 2 12:04:24 2012
>      Raid Level : raid5
>    Raid Devices : 6
>
>  Avail Dev Size : 5860528128 (2794.52 GiB 3000.59 GB)
>      Array Size : 14651317760 (13972.59 GiB 15002.95 GB)
>   Used Dev Size : 5860527104 (2794.52 GiB 3000.59 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=1960 sectors, after=1024 sectors
>           State : active
>     Device UUID : cabeb84a:b5df18c9:cb378062:be0f8998
>
>   Reshape pos'n : 491520 (480.00 MiB 503.32 MB)
>   Delta Devices : 1 (5->6)
>
>     Update Time : Tue Dec 5 18:30:50 2017
>   Bad Block Log : 512 entries available at offset 72 sectors - bad
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> blocks present.
^^^^^^^^^^^^^^^^^
>        Checksum : 9f01ea9c - correct
>          Events : 4830578
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 0
>    Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)

This feature generally shouldn't be used, because its implementation is unfinished. Empty BBL's can be removed from every device by giving "--update=no-bbl" option to mdadm on assemble, but before that you must manually regenerate content for each block in BBL's and then manually zero the lists in superblocks.
