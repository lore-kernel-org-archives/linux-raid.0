From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Re: Linux 3.3.1 resync speed
Date: Mon, 02 Apr 2012 16:28:01 -0500
Message-ID: <4F7A19E1.4050102@nuclearwinter.com>
References: <CADNH=7H3ejuJSLymMoxiFtnY90Ur5_e8D71UK5eDWqXRX1-oHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7H3ejuJSLymMoxiFtnY90Ur5_e8D71UK5eDWqXRX1-oHQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a known issue and a patch has been submitted. I'm not sure when
it is scheduled to appear in the kernel.

There will be no actual disk I/O during the raid check and the array
will not actually be checked.

--Larkin

On 4/2/2012 4:21 PM, Mathias Bur=C3=A9n wrote:
> Hi mailing list,
>
> On my old
>
> model name	: Intel(R) Atom(TM) CPU  330   @ 1.60GHz
>
> I'm currently seeing a resync speed of around 200MB/s!
>
> ~ $ cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid6 sdg1[0] sde1[7] sdh1[8] sdf1[5] sdc1[3] sdd1[4] sd=
b1[9]
>       9751756800 blocks super 1.2 level 6, 64k chunk, algorithm 2
> [7/7] [UUUUUUU]
>       [=3D=3D=3D=3D=3D=3D>..............]  check =3D 32.6% (636923520=
/1950351360)
> finish=3D111.2min speed=3D196740K/sec
>
> unused devices: <none>
>
> This ia almost 10 times higher than what I used to see on 3.2 and
> earlier. What's that about? The array is a 7 drive RAID6:
>
> $ sudo mdadm -D /dev/md0
> /dev/md0:
>         Version : 1.2
>   Creation Time : Tue Oct 19 08:58:41 2010
>      Raid Level : raid6
>      Array Size : 9751756800 (9300.00 GiB 9985.80 GB)
>   Used Dev Size : 1950351360 (1860.00 GiB 1997.16 GB)
>    Raid Devices : 7
>   Total Devices : 7
>     Persistence : Superblock is persistent
>
>     Update Time : Mon Apr  2 22:18:14 2012
>           State : clean, checking
>  Active Devices : 7
> Working Devices : 7
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>    Check Status : 32% complete
>
>            Name : ion:0  (local to host ion)
>            UUID : e6595c64:b3ae90b3:f01133ac:3f402d20
>          Events : 6773811
>
>     Number   Major   Minor   RaidDevice State
>        0       8       97        0      active sync   /dev/sdg1
>        9       8       17        1      active sync   /dev/sdb1
>        4       8       49        2      active sync   /dev/sdd1
>        3       8       33        3      active sync   /dev/sdc1
>        5       8       81        4      active sync   /dev/sdf1
>        8       8      113        5      active sync   /dev/sdh1
>        7       8       65        6      active sync   /dev/sde1
>
> Best regards,
> Mathias
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
