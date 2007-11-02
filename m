From: =?ISO-8859-1?Q?Ralf_M=FCller?= <ralf@bj-ig.de>
Subject: Re: Very small internal bitmap after recreate
Date: Fri, 2 Nov 2007 11:29:59 +0100
Message-ID: <D3CFB98D-A540-4A8A-863B-C83A631537B9@bj-ig.de>
References: <58CC73B2-35E8-412A-A7ED-8CACE786CE00@bj-ig.de> <18218.60496.499724.710572@notabene.brown> <70E97204-84DA-404E-9426-BDED1D4A1FE4@bj-ig.de>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=ISO-8859-1;
	delsp=yes	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70E97204-84DA-404E-9426-BDED1D4A1FE4@bj-ig.de>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Am 02.11.2007 um 11:22 schrieb Ralf M=FCller:

>
> # mdadm -E /dev/sdg1
> /dev/sdg1:
>           Magic : a92b4efc
>         Version : 01
>     Feature Map : 0x1
>      Array UUID : e1a335a8:fc0f0626:d70687a6:5d9a9c19
>            Name : 1
>   Creation Time : Wed Oct 31 14:30:55 2007
>      Raid Level : raid5
>    Raid Devices : 5
>
>   Used Dev Size : 625137008 (298.09 GiB 320.07 GB)
>      Array Size : 2500547584 (1192.35 GiB 1280.28 GB)
>       Used Size : 625136896 (298.09 GiB 320.07 GB)
>    Super Offset : 625137264 sectors
>           State : clean
>     Device UUID : 95afade2:f2ab8e83:b0c764a0:4732827d
>
> Internal Bitmap : 2 sectors from superblock
>     Update Time : Fri Nov  2 07:46:38 2007
>        Checksum : 4ee307b3 - correct
>          Events : 408088
>
>          Layout : left-symmetric
>      Chunk Size : 128K
>
>     Array Slot : 3 (0, 1, failed, 2, 3, 4)
>    Array State : uuUuu 1 failed
>
> This time I'm getting nervous - Array State failed doesn't sound good=
!

Just to make it clear - the array is still reported active by in /=20
proc/mdstat and behaves well - no failed devices:
md1 : active raid5 sdd1[0] sdh1[5] sdf1[4] sdg1[3] sde1[1]
       1250273792 blocks super 1.0 level 5, 128k chunk, algorithm 2 =20
[5/5] [UUUUU]
       bitmap: 0/10 pages [0KB], 16384KB chunk

Regards
Ralf
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
