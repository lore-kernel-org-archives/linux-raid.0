From: Jinpu Wang <jinpuwang@gmail.com>
Subject: Re: Need help with degraded raid 5
Date: Thu, 5 Mar 2020 15:53:16 +0100
Message-ID: <CAD9gYJ+3gP+6aannsjzq=L0DsQ-dC2wj4SJfU3+n-t3pG0q3pg@mail.gmail.com>
References: <CALc6PW74+m1tk4BGgyQRCcx1cU5W=DKWL1mq7EpriW6s=JajVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALc6PW74+m1tk4BGgyQRCcx1cU5W=DKWL1mq7EpriW6s=JajVg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: William Morgan <therealbrewer@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

William Morgan <therealbrewer@gmail.com> =E4=BA=8E2020=E5=B9=B43=E6=9C=885=
=E6=97=A5=E5=91=A8=E5=9B=9B =E4=B8=8A=E5=8D=881:33=E5=86=99=E9=81=93=EF=BC=
=9A
>
> Hello,
>
> I'm working with a 4 disk raid 5. In the past I have experienced a
> problem that resulted in the array being set to "inactive", but with
> some guidance from the list, I was able to rebuild with no loss of
> data. Recently I have a slightly different situation where one disk
> was "removed" and marked as "spare", so the array is still active, but
> degraded.
>
> I've been monitoring the array, and I got a "Fail event" notification
> right after a power blip which showed this mdstat:
>
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : active raid5 sdm1[4](F) sdj1[0] sdk1[1] sdl1[2]
>       23441679360 blocks super 1.2 level 5, 64k chunk, algorithm 2 [4/3] =
[UUU_]
>       bitmap: 0/59 pages [0KB], 65536KB chunk
>
> unused devices: <none>
>
> A little while later I got a "DegradedArray event" notification with
> the following mdstat:
>
> Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0]
> [raid1] [raid10]
> md0 : active raid5 sdl1[4] sdj1[1] sdk1[2] sdi1[0]
>       23441679360 blocks super 1.2 level 5, 64k chunk, algorithm 2 [4/3] =
[UUU_]
>       [>....................]  recovery =3D  0.0% (12600/7813893120)
> finish=3D113621.8min speed=3D1145K/sec
>       bitmap: 2/59 pages [8KB], 65536KB chunk
>
> unused devices: <none>
>
> which seemed to imply that sdl was being rebuilt, but then I got
> another "DegradedArray event" notification with this:
>
> Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0]
> [raid1] [raid10]
> md0 : active raid5 sdl1[4](S) sdj1[1] sdk1[2] sdi1[0]
>       23441679360 blocks super 1.2 level 5, 64k chunk, algorithm 2 [4/3] =
[UUU_]
>       bitmap: 2/59 pages [8KB], 65536KB chunk
>
> unused devices: <none>
>
>
> I don't think anything is really wrong with the removed disk however.
> So assuming I've got backups, what do I need to do to reinsert the
> disk and get the array back to a normal state? Or does that disk's
> data need to be completely rebuilt? And how do I initiate that?
>
> I'm using the latest mdadm and a very recent kernel. Currently I get this=
:
>
> bill@bill-desk:~$ sudo mdadm --detail /dev/md0
> /dev/md0:
>            Version : 1.2
>      Creation Time : Sat Sep 22 19:10:10 2018
>         Raid Level : raid5
>         Array Size : 23441679360 (22355.73 GiB 24004.28 GB)
>      Used Dev Size : 7813893120 (7451.91 GiB 8001.43 GB)
>       Raid Devices : 4
>      Total Devices : 4
>        Persistence : Superblock is persistent
>
>      Intent Bitmap : Internal
>
>        Update Time : Mon Mar  2 17:41:32 2020
>              State : clean, degraded
>     Active Devices : 3
>    Working Devices : 4
>     Failed Devices : 0
>      Spare Devices : 1
>
>             Layout : left-symmetric
>         Chunk Size : 64K
>
> Consistency Policy : bitmap
>
>               Name : bill-desk:0  (local to host bill-desk)
>               UUID : 06ad8de5:3a7a15ad:88116f44:fcdee150
>             Events : 10407
>
>     Number   Major   Minor   RaidDevice State
>        0       8      129        0      active sync   /dev/sdi1
>        1       8      145        1      active sync   /dev/sdj1
>        2       8      161        2      active sync   /dev/sdk1
>        -       0        0        3      removed
>
>        4       8      177        -      spare   /dev/sdl1

"mdadm /dev/md0 -a /dev/sdl1"  should work for you to add the disk
back to array, maybe you can check first with "mdadm -E /dev/sdl1" to
make sure.

Regards,
Jack Wang
