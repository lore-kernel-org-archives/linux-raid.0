From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Problem with RAID-5 not adding disks
Date: Tue, 22 Jul 2014 19:10:17 -0500
Message-ID: <CAAMCDed1o8Ta80sdvefhrLhnmAfeQd5SBmYuWH4Xby6a+m6C2Q@mail.gmail.com>
References: <53CEE0E4.4070906@gmail.com> <53CEE193.60409@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53CEE193.60409@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Theophanis Kontogiannis <tkonto@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

mdadm --stop /dev/mdXX stop
mdadm --assemble --force /dev/mdXX <list all devices good or bad that
were previously in the array>

The assemble with force should make it turn it on with enough disks.
Then re-add the remaining.

I have had to do this a number of times when a subset of my sata ports =
acted up.

On Tue, Jul 22, 2014 at 5:11 PM, Theophanis Kontogiannis
<tkonto@gmail.com> wrote:
>
> Dear List.
>
> Hello.
>
> I have the following problem with my CEntOS 6.5 RAID-5
>
> Array of five disks.
>
> At some point in time I added the fifth disk, however I do not rememb=
er
> if I added it as a spare or to go up to RAID-6.
>
> The power and faulty UPS caught me so my RAID-5 has failed (alongside
> with the on board controller :) )
>
> After replacing the MB, I am in the following situation:
>
>         /dev/md0:
>                 Version : 1.2
>           Creation Time : Fri Feb 21 18:06:31 2014
>              Raid Level : raid5
>           Used Dev Size : 976630272 (931.39 GiB 1000.07 GB)
>            Raid Devices : 5
>           Total Devices : 2
>             Persistence : Superblock is persistent
>
>             Update Time : Sat Jul 12 22:11:39 2014
>                   State : active, FAILED, Not Started
>          Active Devices : 2
>         Working Devices : 2
>          Failed Devices : 0
>           Spare Devices : 0
>
>                  Layout : left-symmetric
>              Chunk Size : 512K
>
>                    Name : tweety.example.com:0  (local to host
>         tweety.example.com)
>                    UUID : 953836cd:23314476:5db06922:c886893d
>                  Events : 16855
>
>             Number   Major   Minor   RaidDevice State
>                0       0        0        0      removed
>                1       8       32        1      active sync   /dev/sd=
c
>                2       0        0        2      removed
>                4       8       64        3      active sync   /dev/sd=
e
>                4       0        0        4      removed
>
>
>
> Every effort to add at least one more disk ends up in error:
>
> [root ~]# mdadm /dev/md0 --re-add /dev/sdd
> mdadm: --re-add for /dev/sdd to /dev/md0 is not possible
>
> I also made sure that the devices are in the correct physical order.
>
>
>     mdadm --examine /dev/sd[b-f]
>
>
>         /dev/sdb:
>                   Magic : a92b4efc
>                 Version : 1.2
>             Feature Map : 0x2
>              Array UUID : 953836cd:23314476:5db06922:c886893d
>                    Name : tweety.example.com:0  (local to host
>         tweety.example.com)
>           Creation Time : Fri Feb 21 18:06:31 2014
>              Raid Level : raid5
>            Raid Devices : 5
>
>          Avail Dev Size : 1953260911 (931.39 GiB 1000.07 GB)
>              Array Size : 3906521088 (3725.55 GiB 4000.28 GB)
>           Used Dev Size : 1953260544 (931.39 GiB 1000.07 GB)
>             Data Offset : 262144 sectors
>            Super Offset : 8 sectors
>         Recovery Offset : 0 sectors
>                   State : active
>             Device UUID : 7117d844:783abda5:093ee4d9:ba0ac2f0
>
>             Update Time : Sat Jul 12 21:32:42 2014
>                Checksum : 31569c40 - correct
>                  Events : 16845
>
>                  Layout : left-symmetric
>              Chunk Size : 512K
>
>            Device Role : Active device 0
>            Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing=
)
>         /dev/sdc:
>                   Magic : a92b4efc
>                 Version : 1.2
>             Feature Map : 0x0
>              Array UUID : 953836cd:23314476:5db06922:c886893d
>                    Name : tweety.example.com:0  (local to host
>         tweety.example.com)
>           Creation Time : Fri Feb 21 18:06:31 2014
>              Raid Level : raid5
>            Raid Devices : 5
>
>          Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
>              Array Size : 3906521088 (3725.55 GiB 4000.28 GB)
>           Used Dev Size : 1953260544 (931.39 GiB 1000.07 GB)
>             Data Offset : 262144 sectors
>            Super Offset : 8 sectors
>                   State : active
>             Device UUID : 18bf4347:08c262ec:694eba7f:eb8e6b26
>
>             Update Time : Sat Jul 12 22:11:39 2014
>                Checksum : 55e8716a - correct
>                  Events : 16855
>
>                  Layout : left-symmetric
>              Chunk Size : 512K
>
>            Device Role : Active device 1
>            Array State : .AAAA ('A' =3D=3D active, '.' =3D=3D missing=
)
>         /dev/sdd:
>                   Magic : a92b4efc
>                 Version : 1.2
>             Feature Map : 0x0
>              Array UUID : 953836cd:23314476:5db06922:c886893d
>                    Name : tweety.example.com:0  (local to host
>         tweety.example.com)
>           Creation Time : Fri Feb 21 18:06:31 2014
>              Raid Level : raid5
>            Raid Devices : 5
>
>          Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
>              Array Size : 3906521088 (3725.55 GiB 4000.28 GB)
>           Used Dev Size : 1953260544 (931.39 GiB 1000.07 GB)
>             Data Offset : 262144 sectors
>            Super Offset : 8 sectors
>                   State : active
>             Device UUID : 4f77c847:2f567632:66bb5600:9fb2eeba
>
>             Update Time : Sat Jul 12 21:32:42 2014
>                Checksum : b19f455b - correct
>                  Events : 16855
>
>                  Layout : left-symmetric
>              Chunk Size : 512K
>
>            Device Role : Active device 2
>            Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing=
)
>         /dev/sde:
>                   Magic : a92b4efc
>                 Version : 1.2
>             Feature Map : 0x0
>              Array UUID : 953836cd:23314476:5db06922:c886893d
>                    Name : tweety.example.com:0  (local to host
>         tweety.example.com)
>           Creation Time : Fri Feb 21 18:06:31 2014
>              Raid Level : raid5
>            Raid Devices : 5
>
>          Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
>              Array Size : 3906521088 (3725.55 GiB 4000.28 GB)
>           Used Dev Size : 1953260544 (931.39 GiB 1000.07 GB)
>             Data Offset : 262144 sectors
>            Super Offset : 8 sectors
>                   State : active
>             Device UUID : 51b43b6e:7bb8a070:f6375540:28e0b75c
>
>             Update Time : Sat Jul 12 22:11:39 2014
>                Checksum : f80197e3 - correct
>                  Events : 16855
>
>                  Layout : left-symmetric
>              Chunk Size : 512K
>
>            Device Role : Active device 3
>            Array State : .A.AA ('A' =3D=3D active, '.' =3D=3D missing=
)
>         /dev/sdf:
>                   Magic : a92b4efc
>                 Version : 1.2
>             Feature Map : 0x0
>              Array UUID : 953836cd:23314476:5db06922:c886893d
>                    Name : tweety.example.com:0  (local to host
>         tweety.example.com)
>           Creation Time : Fri Feb 21 18:06:31 2014
>              Raid Level : raid5
>            Raid Devices : 5
>
>          Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
>              Array Size : 3906521088 (3725.55 GiB 4000.28 GB)
>           Used Dev Size : 1953260544 (931.39 GiB 1000.07 GB)
>             Data Offset : 262144 sectors
>            Super Offset : 8 sectors
>                   State : clean
>             Device UUID : 9f7b1355:936e12f2:813c83a0:13854a6b
>
>             Update Time : Sat Jul 12 22:11:39 2014
>                Checksum : cf0bbec1 - correct
>                  Events : 16855
>
>                  Layout : left-symmetric
>              Chunk Size : 512K
>
>            Device Role : Active device 4
>            Array State : .A.AA ('A' =3D=3D active, '.' =3D=3D missing=
)
>
>
> Any chance to revive this array?
>
>
> --
>
> Kind Regards,
> Theophanis Kontogiannis
>
> =CC=D6=D7
> =C8=CA
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
