From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Linux 3.3.1 resync speed
Date: Mon, 2 Apr 2012 22:23:55 +0100
Message-ID: <CADNH=7F3=6tE2kzaoxCVbNxabaNA32CWnRgJpSJzL7myUn1rGw@mail.gmail.com>
References: <CADNH=7H3ejuJSLymMoxiFtnY90Ur5_e8D71UK5eDWqXRX1-oHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7H3ejuJSLymMoxiFtnY90Ur5_e8D71UK5eDWqXRX1-oHQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2 April 2012 22:21, Mathias Bur=C3=A9n <mathias.buren@gmail.com> wro=
te:
> Hi mailing list,
>
> On my old
>
> model name =C2=A0 =C2=A0 =C2=A0: Intel(R) Atom(TM) CPU =C2=A0330 =C2=A0=
 @ 1.60GHz
>
> I'm currently seeing a resync speed of around 200MB/s!
>
> ~ $ cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid6 sdg1[0] sde1[7] sdh1[8] sdf1[5] sdc1[3] sdd1[4] sd=
b1[9]
> =C2=A0 =C2=A0 =C2=A09751756800 blocks super 1.2 level 6, 64k chunk, a=
lgorithm 2
> [7/7] [UUUUUUU]
> =C2=A0 =C2=A0 =C2=A0[=3D=3D=3D=3D=3D=3D>..............] =C2=A0check =3D=
 32.6% (636923520/1950351360)
> finish=3D111.2min speed=3D196740K/sec
>
> unused devices: <none>
>
> This ia almost 10 times higher than what I used to see on 3.2 and
> earlier. What's that about? The array is a 7 drive RAID6:
>
> $ sudo mdadm -D /dev/md0
> /dev/md0:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 1.2
> =C2=A0Creation Time : Tue Oct 19 08:58:41 2010
> =C2=A0 =C2=A0 Raid Level : raid6
> =C2=A0 =C2=A0 Array Size : 9751756800 (9300.00 GiB 9985.80 GB)
> =C2=A0Used Dev Size : 1950351360 (1860.00 GiB 1997.16 GB)
> =C2=A0 Raid Devices : 7
> =C2=A0Total Devices : 7
> =C2=A0 =C2=A0Persistence : Superblock is persistent
>
> =C2=A0 =C2=A0Update Time : Mon Apr =C2=A02 22:18:14 2012
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean, checking
> =C2=A0Active Devices : 7
> Working Devices : 7
> =C2=A0Failed Devices : 0
> =C2=A0Spare Devices : 0
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
> =C2=A0 =C2=A0 Chunk Size : 64K
>
> =C2=A0 Check Status : 32% complete
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Name : ion:0 =C2=A0(local to host =
ion)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : e6595c64:b3ae90b3:f01133ac:=
3f402d20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 6773811
>
> =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice State
> =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 97=
 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdg1
> =C2=A0 =C2=A0 =C2=A0 9 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 17=
 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdb1
> =C2=A0 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 49=
 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdd1
> =C2=A0 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 33=
 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdc1
> =C2=A0 =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 81=
 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdf1
> =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0113=
 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdh1
> =C2=A0 =C2=A0 =C2=A0 7 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 65=
 =C2=A0 =C2=A0 =C2=A0 =C2=A06 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sde1
>
> Best regards,
> Mathias

It was actually capped at 200000 KB/s in
/sys/block/md0/md/sync_speed_max . I raised that by a factor of 100,
and I am now seeing:

 $ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdg1[0] sde1[7] sdh1[8] sdf1[5] sdc1[3] sdd1[4] sdb1=
[9]
      9751756800 blocks super 1.2 level 6, 64k chunk, algorithm 2
[7/7] [UUUUUUU]
      [=3D=3D=3D=3D=3D=3D>..............]  check =3D 34.8% (679312336/1=
950351360)
finish=3D70.2min speed=3D301438K/sec

unused devices: <none>

I'm not complaining, just very surprised and I'm wondering if
everything is OK. Usually a check takes around 20-24 hours.

Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
