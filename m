From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: raid10,f2 Add a Controller: Which drives to move?
Date: Sun, 11 Apr 2010 14:31:41 -0700
Message-ID: <k2o4877c76c1004111431v147791a7weea96497f6d0431d@mail.gmail.com>
References: <loom.20100411T185315-118@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20100411T185315-118@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Michael McCallister <mike@mccllstr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Apr 11, 2010 at 10:08 AM, Michael McCallister <mike@mccllstr.co=
m> wrote:
> I have an existing raid10,f2 array with four drives, all running on a=
 single
> SATA controller. =A0I have a second controller to add to the system a=
nd I'd like
> to split the existing drives between the two controllers. =A0I'm hopi=
ng to make
> the configuration more robust against the possibility of a single con=
troller
> failure. =A0It would also be nice to get more performance out of the =
array, though
> I doubt having a single controller is a bottleneck with only 4 7200RP=
M drives.
>
> So with four drives sda, sdb, sdc, and sdd and two controllers C1 and=
 C2, should
> I go with
>
> =A0 =A0C1: sda, sdb
> =A0 =A0C2: sdc, sdd
>
> or
>
> =A0 =A0C1: sda, sdc
> =A0 =A0C2: sdb, sdd
>
> or some other configuration?
>
> I've looked through the last six months of messages in the archives, =
and the
> md(4) and mdadm(8) manpages, and the wiki on https://raid.wiki.kernel=
=2Eorg/ and
> didn't see anything that quite answers this question at a level I can
> understand. =A0If there is a reference I can consult, I'm happy to ke=
ep digging.
>
> If it will help, the output of /proc/mdstat and "mdadm --detail" on t=
he md
> device are included below.
>
>
> Mike McCallister
>
>
> # cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] =
[raid4]
> [raid10]
> md3 : active raid10 sda5[0] sdd5[3] sdc5[2] sdb5[1]
> =A0 =A0 =A01445318656 blocks super 1.1 256K chunks 2 far-copies [4/4]=
 [UUUU]
> =A0 =A0 =A0bitmap: 6/345 pages [24KB], 2048KB chunk
>
> # mdadm --detail /dev/md3
> /dev/md3:
> =A0 =A0 =A0 =A0Version : 01.01.03
> =A0Creation Time : Sun Nov =A09 22:47:00 2008
> =A0 =A0 Raid Level : raid10
> =A0 =A0 Array Size : 1445318656 (1378.36 GiB 1480.01 GB)
> =A0Used Dev Size : 1445318656 (689.18 GiB 740.00 GB)
> =A0 Raid Devices : 4
> =A0Total Devices : 4
> Preferred Minor : 3
> =A0 =A0Persistence : Superblock is persistent
>
> =A0Intent Bitmap : Internal
>
> =A0 =A0Update Time : Sun Apr 11 11:47:09 2010
> =A0 =A0 =A0 =A0 =A0State : active
> =A0Active Devices : 4
> Working Devices : 4
> =A0Failed Devices : 0
> =A0Spare Devices : 0
>
> =A0 =A0 =A0 =A0 Layout : near=3D1, far=3D2
> =A0 =A0 Chunk Size : 256K
>
> =A0 =A0 =A0 =A0 =A0 Name : ozark:3
> =A0 =A0 =A0 =A0 =A0 UUID : e7705941:e81cfbe1:7bf6ab9f:2b979a89
> =A0 =A0 =A0 =A0 Events : 84
>
> =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> =A0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A05 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda5
> =A0 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 21 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb5
> =A0 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 37 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdc5
> =A0 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 53 =A0 =A0 =A0 =A03 =A0 =A0 =A0=
active sync =A0 /dev/sdd5
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

I'd use smartctl to get the drive serial numbers, then move what are
currently shown as sdb5 and sdd5 to your new controller during a
coldboot.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
