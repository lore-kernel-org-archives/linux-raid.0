From: Phil Turmel <philip@turmel.org>
Subject: Re: SRaid with 13 Disks crashed
Date: Wed, 08 Jun 2011 16:32:07 -0400
Message-ID: <4DEFDC47.3010606@turmel.org>
References: <20110608200246.135930@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110608200246.135930@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Dragon <Sunghost@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Dragon,

On 06/08/2011 04:02 PM, Dragon wrote:
[...]

> Please share the output of "mdadm -E /dev/sd[abcdefghijklm]"
> 
> Phil
> -------------------
> Sorry my misstake, of course "resize2fs".
> "Was /dev/sdk supposed to be in this list?"
> ->yes was a part of the raid, but i think something happends with the uuid and now its the system and boot disk. for explanation the raid is stand alone 
> "This is suspicious.  Looks like sda was added as a spare?"
> ->last i wanted to downgrade the raid from 13 to 12 and there for take a disk and marked it as spare, but it was the sda, uuid problem?
> ->
>  mdadm -E /dev/sda
> /dev/sda:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 975d6eb2:285eed11:021df236:c2d05073
>   Creation Time : Tue Oct 13 23:26:17 2009
>      Raid Level : raid5
>   Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
>      Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
>    Raid Devices : 13
>   Total Devices : 12
> Preferred Minor : 0
> 
>     Update Time : Fri Jun  3 23:47:53 2011
>           State : clean
>  Active Devices : 11
> Working Devices : 12
>  Failed Devices : 2
>   Spare Devices : 1
>        Checksum : 1dee418e - correct
>          Events : 156864
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this    13       8        0       13      spare   /dev/sda
> 
>    0     0       8      112        0      active sync   /dev/sdh
>    1     1       0        0        1      faulty removed
>    2     2       8      128        2      active sync   /dev/sdi
>    3     3       8      144        3      active sync   /dev/sdj
>    4     4       8      176        4      active sync   /dev/sdl
>    5     5       8      192        5      active sync   /dev/sdm
>    6     6       8       16        6      active sync   /dev/sdb
>    7     7       0        0        7      faulty removed
>    8     8       8       32        8      active sync   /dev/sdc
>    9     9       8       48        9      active sync   /dev/sdd
>   10    10       8       64       10      active sync   /dev/sde
>   11    11       8       80       11      active sync   /dev/sdf
>   12    12       8       96       12      active sync   /dev/sdg
>   13    13       8        0       13      spare   /dev/sda
>  mdadm -E /dev/sdb
> /dev/sdb:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 975d6eb2:285eed11:021df236:c2d05073
>   Creation Time : Tue Oct 13 23:26:17 2009
>      Raid Level : raid5
>   Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
>      Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
>    Raid Devices : 13
>   Total Devices : 12
> Preferred Minor : 0
> 
>     Update Time : Fri Jun  3 23:47:53 2011
>           State : clean
>  Active Devices : 11
> Working Devices : 12
>  Failed Devices : 2
>   Spare Devices : 1
>        Checksum : 1dee4196 - correct
>          Events : 156864
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     6       8       16        6      active sync   /dev/sdb
> 
>    0     0       8      112        0      active sync   /dev/sdh
>    1     1       0        0        1      faulty removed
>    2     2       8      128        2      active sync   /dev/sdi
>    3     3       8      144        3      active sync   /dev/sdj
>    4     4       8      176        4      active sync   /dev/sdl
>    5     5       8      192        5      active sync   /dev/sdm
>    6     6       8       16        6      active sync   /dev/sdb
>    7     7       0        0        7      faulty removed
>    8     8       8       32        8      active sync   /dev/sdc
>    9     9       8       48        9      active sync   /dev/sdd
>   10    10       8       64       10      active sync   /dev/sde
>   11    11       8       80       11      active sync   /dev/sdf
>   12    12       8       96       12      active sync   /dev/sdg
>   13    13       8        0       13      spare   /dev/sda
>  mdadm -E /dev/sdc
> /dev/sdc:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 975d6eb2:285eed11:021df236:c2d05073
>   Creation Time : Tue Oct 13 23:26:17 2009
>      Raid Level : raid5
>   Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
>      Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
>    Raid Devices : 13
>   Total Devices : 12
> Preferred Minor : 0
> 
>     Update Time : Fri Jun  3 23:47:53 2011
>           State : clean
>  Active Devices : 11
> Working Devices : 12
>  Failed Devices : 2
>   Spare Devices : 1
>        Checksum : 1dee41aa - correct
>          Events : 156864
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     8       8       32        8      active sync   /dev/sdc
> 
>    0     0       8      112        0      active sync   /dev/sdh
>    1     1       0        0        1      faulty removed
>    2     2       8      128        2      active sync   /dev/sdi
>    3     3       8      144        3      active sync   /dev/sdj
>    4     4       8      176        4      active sync   /dev/sdl
>    5     5       8      192        5      active sync   /dev/sdm
>    6     6       8       16        6      active sync   /dev/sdb
>    7     7       0        0        7      faulty removed
>    8     8       8       32        8      active sync   /dev/sdc
>    9     9       8       48        9      active sync   /dev/sdd
>   10    10       8       64       10      active sync   /dev/sde
>   11    11       8       80       11      active sync   /dev/sdf
>   12    12       8       96       12      active sync   /dev/sdg
>   13    13       8        0       13      spare   /dev/sda
>  mdadm -E /dev/sdd
> /dev/sdd:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 975d6eb2:285eed11:021df236:c2d05073
>   Creation Time : Tue Oct 13 23:26:17 2009
>      Raid Level : raid5
>   Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
>      Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
>    Raid Devices : 13
>   Total Devices : 12
> Preferred Minor : 0
> 
>     Update Time : Fri Jun  3 23:47:53 2011
>           State : clean
>  Active Devices : 11
> Working Devices : 12
>  Failed Devices : 2
>   Spare Devices : 1
>        Checksum : 1dee41bc - correct
>          Events : 156864
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     9       8       48        9      active sync   /dev/sdd
> 
>    0     0       8      112        0      active sync   /dev/sdh
>    1     1       0        0        1      faulty removed
>    2     2       8      128        2      active sync   /dev/sdi
>    3     3       8      144        3      active sync   /dev/sdj
>    4     4       8      176        4      active sync   /dev/sdl
>    5     5       8      192        5      active sync   /dev/sdm
>    6     6       8       16        6      active sync   /dev/sdb
>    7     7       0        0        7      faulty removed
>    8     8       8       32        8      active sync   /dev/sdc
>    9     9       8       48        9      active sync   /dev/sdd
>   10    10       8       64       10      active sync   /dev/sde
>   11    11       8       80       11      active sync   /dev/sdf
>   12    12       8       96       12      active sync   /dev/sdg
>   13    13       8        0       13      spare   /dev/sda

OK, something is odd here:

>  mdadm -E /dev/sde
> /dev/sde:
       ^^^
You request /dev/sde

>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 975d6eb2:285eed11:021df236:c2d05073
>   Creation Time : Tue Oct 13 23:26:17 2009
>      Raid Level : raid5
>   Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
>      Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
>    Raid Devices : 13
>   Total Devices : 12
> Preferred Minor : 0
> 
>     Update Time : Fri Jun  3 23:47:53 2011
>           State : clean
>  Active Devices : 11
> Working Devices : 12
>  Failed Devices : 2
>   Spare Devices : 1
>        Checksum : 1dee41ea - correct
>          Events : 156864
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     0       8      112        0      active sync   /dev/sdh

We get a report for /dev/sdh  (did you scramble the report?)   ^^^

>    0     0       8      112        0      active sync   /dev/sdh
>    1     1       0        0        1      faulty removed
>    2     2       8      128        2      active sync   /dev/sdi
>    3     3       8      144        3      active sync   /dev/sdj
>    4     4       8      176        4      active sync   /dev/sdl
>    5     5       8      192        5      active sync   /dev/sdm
>    6     6       8       16        6      active sync   /dev/sdb
>    7     7       0        0        7      faulty removed
>    8     8       8       32        8      active sync   /dev/sdc
>    9     9       8       48        9      active sync   /dev/sdd
>   10    10       8       64       10      active sync   /dev/sde
>   11    11       8       80       11      active sync   /dev/sdf
>   12    12       8       96       12      active sync   /dev/sdg
>   13    13       8        0       13      spare   /dev/sda

And again here, and for all the rest:

>  mdadm -E /dev/sdf
> /dev/sdf:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 975d6eb2:285eed11:021df236:c2d05073
>   Creation Time : Tue Oct 13 23:26:17 2009
>      Raid Level : raid5
>   Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
>      Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
>    Raid Devices : 13
>   Total Devices : 12
> Preferred Minor : 0
> 
>     Update Time : Fri Jun  3 23:47:53 2011
>           State : clean
>  Active Devices : 11
> Working Devices : 12
>  Failed Devices : 2
>   Spare Devices : 1
>        Checksum : 1dee41fe - correct
>          Events : 156864
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     2       8      128        2      active sync   /dev/sdi
> 
>    0     0       8      112        0      active sync   /dev/sdh
>    1     1       0        0        1      faulty removed
>    2     2       8      128        2      active sync   /dev/sdi
>    3     3       8      144        3      active sync   /dev/sdj
>    4     4       8      176        4      active sync   /dev/sdl
>    5     5       8      192        5      active sync   /dev/sdm
>    6     6       8       16        6      active sync   /dev/sdb
>    7     7       0        0        7      faulty removed
>    8     8       8       32        8      active sync   /dev/sdc
>    9     9       8       48        9      active sync   /dev/sdd
>   10    10       8       64       10      active sync   /dev/sde
>   11    11       8       80       11      active sync   /dev/sdf
>   12    12       8       96       12      active sync   /dev/sdg
>   13    13       8        0       13      spare   /dev/sda
>  mdadm -E /dev/sdg
> /dev/sdg:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 975d6eb2:285eed11:021df236:c2d05073
>   Creation Time : Tue Oct 13 23:26:17 2009
>      Raid Level : raid5
>   Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
>      Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
>    Raid Devices : 13
>   Total Devices : 12
> Preferred Minor : 0
> 
>     Update Time : Fri Jun  3 23:47:53 2011
>           State : clean
>  Active Devices : 11
> Working Devices : 12
>  Failed Devices : 2
>   Spare Devices : 1
>        Checksum : 1dee4210 - correct
>          Events : 156864
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     3       8      144        3      active sync   /dev/sdj
> 
>    0     0       8      112        0      active sync   /dev/sdh
>    1     1       0        0        1      faulty removed
>    2     2       8      128        2      active sync   /dev/sdi
>    3     3       8      144        3      active sync   /dev/sdj
>    4     4       8      176        4      active sync   /dev/sdl
>    5     5       8      192        5      active sync   /dev/sdm
>    6     6       8       16        6      active sync   /dev/sdb
>    7     7       0        0        7      faulty removed
>    8     8       8       32        8      active sync   /dev/sdc
>    9     9       8       48        9      active sync   /dev/sdd
>   10    10       8       64       10      active sync   /dev/sde
>   11    11       8       80       11      active sync   /dev/sdf
>   12    12       8       96       12      active sync   /dev/sdg
>   13    13       8        0       13      spare   /dev/sda

This one is odd:

> mdadm -E /dev/sdh
> /dev/sdh:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 975d6eb2:285eed11:021df236:c2d05073
>   Creation Time : Tue Oct 13 23:26:17 2009
>      Raid Level : raid5
>   Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
>      Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
>    Raid Devices : 13
>   Total Devices : 12
> Preferred Minor : 0
> 
>     Update Time : Fri Jun  3 22:49:22 2011
>           State : clean
>  Active Devices : 11
> Working Devices : 12
>  Failed Devices : 2
>   Spare Devices : 1
>        Checksum : 1dee3313 - correct
>          Events : 156606
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this    13       8      160       13      spare   /dev/sdk

Supposed requested /dev/sdh, shows report for /dev/sdk, which is not a raid device, but shows as a spare here.
> 
>    0     0       8      112        0      active sync   /dev/sdh
>    1     1       0        0        1      faulty removed
>    2     2       8      128        2      active sync   /dev/sdi
>    3     3       8      144        3      active sync   /dev/sdj
>    4     4       8      176        4      active sync   /dev/sdl
>    5     5       8      192        5      active sync   /dev/sdm
>    6     6       8       16        6      active sync   /dev/sdb
>    7     7       0        0        7      faulty removed
>    8     8       8       32        8      active sync   /dev/sdc
>    9     9       8       48        9      active sync   /dev/sdd
>   10    10       8       64       10      active sync   /dev/sde
>   11    11       8       80       11      active sync   /dev/sdf
>   12    12       8       96       12      active sync   /dev/sdg
>   13    13       8      160       13      spare   /dev/sdk
>  mdadm -E /dev/sdi
> /dev/sdi:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 975d6eb2:285eed11:021df236:c2d05073
>   Creation Time : Tue Oct 13 23:26:17 2009
>      Raid Level : raid5
>   Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
>      Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
>    Raid Devices : 13
>   Total Devices : 12
> Preferred Minor : 0
> 
>     Update Time : Fri Jun  3 23:47:53 2011
>           State : clean
>  Active Devices : 11
> Working Devices : 12
>  Failed Devices : 2
>   Spare Devices : 1
>        Checksum : 1dee4232 - correct
>          Events : 156864
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     4       8      176        4      active sync   /dev/sdl
> 
>    0     0       8      112        0      active sync   /dev/sdh
>    1     1       0        0        1      faulty removed
>    2     2       8      128        2      active sync   /dev/sdi
>    3     3       8      144        3      active sync   /dev/sdj
>    4     4       8      176        4      active sync   /dev/sdl
>    5     5       8      192        5      active sync   /dev/sdm
>    6     6       8       16        6      active sync   /dev/sdb
>    7     7       0        0        7      faulty removed
>    8     8       8       32        8      active sync   /dev/sdc
>    9     9       8       48        9      active sync   /dev/sdd
>   10    10       8       64       10      active sync   /dev/sde
>   11    11       8       80       11      active sync   /dev/sdf
>   12    12       8       96       12      active sync   /dev/sdg
>   13    13       8        0       13      spare   /dev/sda
>  mdadm -E /dev/sdj
> /dev/sdj:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 975d6eb2:285eed11:021df236:c2d05073
>   Creation Time : Tue Oct 13 23:26:17 2009
>      Raid Level : raid5
>   Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
>      Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
>    Raid Devices : 13
>   Total Devices : 12
> Preferred Minor : 0
> 
>     Update Time : Fri Jun  3 23:47:53 2011
>           State : clean
>  Active Devices : 11
> Working Devices : 12
>  Failed Devices : 2
>   Spare Devices : 1
>        Checksum : 1dee4244 - correct
>          Events : 156864
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     5       8      192        5      active sync   /dev/sdm
> 
>    0     0       8      112        0      active sync   /dev/sdh
>    1     1       0        0        1      faulty removed
>    2     2       8      128        2      active sync   /dev/sdi
>    3     3       8      144        3      active sync   /dev/sdj
>    4     4       8      176        4      active sync   /dev/sdl
>    5     5       8      192        5      active sync   /dev/sdm
>    6     6       8       16        6      active sync   /dev/sdb
>    7     7       0        0        7      faulty removed
>    8     8       8       32        8      active sync   /dev/sdc
>    9     9       8       48        9      active sync   /dev/sdd
>   10    10       8       64       10      active sync   /dev/sde
>   11    11       8       80       11      active sync   /dev/sdf
>   12    12       8       96       12      active sync   /dev/sdg
>   13    13       8        0       13      spare   /dev/sda

Now, this is significant:

>  mdadm -E /dev/sdk
> mdadm: No md superblock detected on /dev/sdk.

As we see below, this is not one of your 1.5T drives.

>  mdadm -E /dev/sdl
> /dev/sdl:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 975d6eb2:285eed11:021df236:c2d05073
>   Creation Time : Tue Oct 13 23:26:17 2009
>      Raid Level : raid5
>   Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
>      Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
>    Raid Devices : 13
>   Total Devices : 12
> Preferred Minor : 0
> 
>     Update Time : Fri Jun  3 23:47:53 2011
>           State : clean
>  Active Devices : 11
> Working Devices : 12
>  Failed Devices : 2
>   Spare Devices : 1
>        Checksum : 1dee41ce - correct
>          Events : 156864
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this    10       8       64       10      active sync   /dev/sde
> 
>    0     0       8      112        0      active sync   /dev/sdh
>    1     1       0        0        1      faulty removed
>    2     2       8      128        2      active sync   /dev/sdi
>    3     3       8      144        3      active sync   /dev/sdj
>    4     4       8      176        4      active sync   /dev/sdl
>    5     5       8      192        5      active sync   /dev/sdm
>    6     6       8       16        6      active sync   /dev/sdb
>    7     7       0        0        7      faulty removed
>    8     8       8       32        8      active sync   /dev/sdc
>    9     9       8       48        9      active sync   /dev/sdd
>   10    10       8       64       10      active sync   /dev/sde
>   11    11       8       80       11      active sync   /dev/sdf
>   12    12       8       96       12      active sync   /dev/sdg
>   13    13       8        0       13      spare   /dev/sda
>  mdadm -E /dev/sdm
> /dev/sdm:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 975d6eb2:285eed11:021df236:c2d05073
>   Creation Time : Tue Oct 13 23:26:17 2009
>      Raid Level : raid5
>   Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
>      Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
>    Raid Devices : 13
>   Total Devices : 12
> Preferred Minor : 0
> 
>     Update Time : Fri Jun  3 23:47:53 2011
>           State : clean
>  Active Devices : 11
> Working Devices : 12
>  Failed Devices : 2
>   Spare Devices : 1
>        Checksum : 1dee41e0 - correct
>          Events : 156864
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this    11       8       80       11      active sync   /dev/sdf
> 
>    0     0       8      112        0      active sync   /dev/sdh
>    1     1       0        0        1      faulty removed
>    2     2       8      128        2      active sync   /dev/sdi
>    3     3       8      144        3      active sync   /dev/sdj
>    4     4       8      176        4      active sync   /dev/sdl
>    5     5       8      192        5      active sync   /dev/sdm
>    6     6       8       16        6      active sync   /dev/sdb
>    7     7       0        0        7      faulty removed
>    8     8       8       32        8      active sync   /dev/sdc
>    9     9       8       48        9      active sync   /dev/sdd
>   10    10       8       64       10      active sync   /dev/sde
>   11    11       8       80       11      active sync   /dev/sdf
>   12    12       8       96       12      active sync   /dev/sdg
>   13    13       8        0       13      spare   /dev/sda
>  mdadm -E /dev/sdn
> /dev/sdn:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 975d6eb2:285eed11:021df236:c2d05073
>   Creation Time : Tue Oct 13 23:26:17 2009
>      Raid Level : raid5
>   Used Dev Size : 1465138496 (1397.26 GiB 1500.30 GB)
>      Array Size : 17581661952 (16767.18 GiB 18003.62 GB)
>    Raid Devices : 13
>   Total Devices : 12
> Preferred Minor : 0
> 
>     Update Time : Fri Jun  3 23:47:53 2011
>           State : clean
>  Active Devices : 11
> Working Devices : 12
>  Failed Devices : 2
>   Spare Devices : 1
>        Checksum : 1dee41f2 - correct
>          Events : 156864
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this    12       8       96       12      active sync   /dev/sdg
> 
>    0     0       8      112        0      active sync   /dev/sdh
>    1     1       0        0        1      faulty removed
>    2     2       8      128        2      active sync   /dev/sdi
>    3     3       8      144        3      active sync   /dev/sdj
>    4     4       8      176        4      active sync   /dev/sdl
>    5     5       8      192        5      active sync   /dev/sdm
>    6     6       8       16        6      active sync   /dev/sdb
>    7     7       0        0        7      faulty removed
>    8     8       8       32        8      active sync   /dev/sdc
>    9     9       8       48        9      active sync   /dev/sdd
>   10    10       8       64       10      active sync   /dev/sde
>   11    11       8       80       11      active sync   /dev/sdf
>   12    12       8       96       12      active sync   /dev/sdg
>   13    13       8        0       13      spare   /dev/sda
>  mdadm -E /dev/sdo
> mdadm: No md superblock detected on /dev/sdo.
> nassrv01:~# fdisk -l |grep sd
> Disk /dev/sda: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdb: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdc: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdd: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sde: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdf: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdg: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdh: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdi: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdj: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdk: 20.4 GB, 20409532416 bytes
> /dev/sdk1   *           1        2372    19053058+  83  Linux
> /dev/sdk2            2373        2481      875542+   5  Extended
> /dev/sdk5            2373        2481      875511   82  Linux swap / Solaris
> Disk /dev/sdl: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdm: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdn: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdo: 1500.3 GB, 1500301910016 bytes
> /dev/sdo1               1      182401  1465136001   83  Linux

Uh, oh.  /dev/sdo has a partition table.  Please show "mdadm -E /dev/sdo1"

I'm guessing that drive letters have changed since you first put this together.  Could you please get my "lsdrv" script from:

http://github.com/pturmel/lsdrv

and show us the output.  This will help make sure we don't lose track of the roles of each of these drives.

My first impression from the above output is that the shrink from 13 back to 12 did not actually happen.  Shrinking is dangerous enough that mdadm stays in test mode unless you set a sysfs variable with the new size before trying to shrink.

Another question:  Do you have a backup?

Phil
