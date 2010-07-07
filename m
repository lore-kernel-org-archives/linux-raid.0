From: Neil Brown <neilb@suse.de>
Subject: Re: convert raid10 to raid0
Date: Thu, 8 Jul 2010 08:50:34 +1000
Message-ID: <20100708085034.2bc8272e@notabene.brown>
References: <4C34D5AD.5020305@i3rendszerhaz.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C34D5AD.5020305@i3rendszerhaz.hu>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?VMOzdGg=?= Csaba <csaba.toth@i3rendszerhaz.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 07 Jul 2010 21:29:49 +0200
T=C3=B3th Csaba <csaba.toth@i3rendszerhaz.hu> wrote:

> Hey List,
>=20
> i have a serious problem: have a file server with 4 disk (4x750GB),
> using them in a software RAID10 array. One of the HDDs have a bad sec=
tor
> (because some administration problems, i cannot replace them), and th=
e
> motherboard sometimes drops the connection with two HDDs. Not with th=
e
> same as the bad sector has, but with a resync i always managed the
> problem. But now 3 drive form the RAID10 array dropped.
>=20
> In the past the sdc6 and the sdd6 partitions were the partitions i
> resynced the others, so i know exactly where to look for the proper
> datas. Can i use them as a RAID0 array somehow?

It should be sufficient to:
  mdadm -S /dev/md5
  mdadm -C /dev/md5 --level raid0 --raid-devices 2 --chunk 512 \
      --metadata=3D1.1 /dev/sdc6 /dev/sdd6

to get your data available.
There is a possible small complication though.  If you use a different
version of mdadm to the one you used to create the array at first, it m=
ight
choose a different 'data offset'.
To be sure this doesn't happen, use

 mdadm -E /dev/sdc6

and take note of the "Data Offset".  It would probably be a good idea t=
o keep
a copy of "mdadm -E" of all of the devices, just to be on the same side=
=2E

Then after you create the raid0, use the same command
   mdadm -E /dev/sdc6
to check the Data Offset again and make sure it is the same.
I suspect it will be, so everything will be fine.
However if it isn't don't try to access the array.   Post the details a=
nd I'll
figure out what to do next.

NeilBrown


> In past mdadm warning letters i saw the config:
>=20
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
> [raid4] [multipath] [faulty]
> md5 : active raid10 sdc6[0] sdd6[3] sdb6[1](F) sda6[2](F)
>       1434619904 blocks super 1.1 512K chunks 2 near-copies [4/2] [U_=
_U]
>=20
> md1 : active raid1 sdb5[0] sdc5[1]
>       14763635 blocks super 1.1 [2/2] [UU]
>=20
> md0 : active raid1 sdd5[0] sda5[2](F)
>       14659200 blocks [2/1] [U_]
>=20
> unused devices: <none>
>=20
>=20
> Now i have:
>=20
> minerva ~ # cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
> [raid4] [multipath] [faulty]
> md5 : inactive sdd6[3]
>       717310119 blocks super 1.1
>=20
> md1 : active raid1 sdc5[0] sdb5[1]
>       14763635 blocks super 1.1 [2/2] [UU]
>=20
> md0 : active raid1 sda5[1] sdd5[0]
>       14659200 blocks [2/2] [UU]
>=20
> unused devices: <none>
> minerva ~ # mdadm --detail /dev/md5
> /dev/md5:
>         Version : 1.1
>   Creation Time : Thu Nov 26 14:50:07 2009
>      Raid Level : raid10
>   Used Dev Size : 717309952 (684.08 GiB 734.53 GB)
>    Raid Devices : 4
>   Total Devices : 1
>     Persistence : Superblock is persistent
>=20
>     Update Time : Wed Jul  7 10:34:32 2010
>           State : active, FAILED, Not Started
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : near=3D2
>      Chunk Size : 512K
>=20
>            Name : minerva:5  (local to host minerva)
>            UUID : a73f5902:accc2488:aecfdc14:05a6e2f4
>          Events : 3981420
>=20
>     Number   Major   Minor   RaidDevice State
>        0       0        0        0      removed
>        1       0        0        1      removed
>        2       0        0        2      removed
>        3       8       54        3      active sync   /dev/sdd6
>=20
>=20
>=20
>=20
> If i try to add sdc6 to the md5 array it fails, because it tries to a=
dd
> as a fifth device:
>=20
> minerva ~ # mdadm /dev/md5 -a /dev/sdc6
> mdadm: add new device failed for /dev/sdc6 as 4: Invalid argument
>=20
>=20
>=20
> Please help, i don't want to destroy the datas, and i have never job
> with RAID10 under linux.
>=20
> thanks in advance,
> regards,
> Csaba
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
