From: Mark Knecht <markknecht@gmail.com>
Subject: Re: RAID6 chunk size change?
Date: Sun, 23 Jan 2011 11:10:40 -0800
Message-ID: <AANLkTimRZgzDd5Na_F3XR8x6YE5wTyDjkBnQSCeCFbWe@mail.gmail.com>
References: <AANLkTimzLwmtMsrUdsLe9svywTFLbs_pZ8SXTCSyG4f4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimzLwmtMsrUdsLe9svywTFLbs_pZ8SXTCSyG4f4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Jan 23, 2011 at 10:53 AM, Mark Knecht <markknecht@gmail.com> wr=
ote:
> Hi,
> =C2=A0 I've got an existing (and well backed up as of a couple of min=
utes
> ago) 5-drive RAID6 shown here:
>
> c2stable ~ # mdadm --detail /dev/md7
> /dev/md7:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 1.2
> =C2=A0Creation Time : Sun Jan 16 17:02:24 2011
> =C2=A0 =C2=A0 Raid Level : raid6
> =C2=A0 =C2=A0 Array Size : 395387904 (377.07 GiB 404.88 GB)
> =C2=A0Used Dev Size : 131795968 (125.69 GiB 134.96 GB)
> =C2=A0 Raid Devices : 5
> =C2=A0Total Devices : 5
> =C2=A0 =C2=A0Persistence : Superblock is persistent
>
> =C2=A0 =C2=A0Update Time : Sun Jan 23 10:25:41 2011
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
> =C2=A0Active Devices : 5
> Working Devices : 5
> =C2=A0Failed Devices : 0
> =C2=A0Spare Devices : 0
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
> =C2=A0 =C2=A0 Chunk Size : 512K
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Name : c2stable:7 =C2=A0(local to =
host c2stable)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : ded5e0c6:1a5a73ad:01949557:=
bb4e015a
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 17
>
> =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice State
> =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =C2=
=A07 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sda7
> =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 23=
 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdb7
> =C2=A0 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 39=
 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdc7
> =C2=A0 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 50=
 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdd2
> =C2=A0 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 66=
 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sde2
> c2stable ~ #
>
> =C2=A0 I would like to change this RAID to a smaller chunk size. (16K=
 for
> now) What is the right command to use?
>
> =C2=A0 From Google and the mdadm man pages I'm coming up with somethi=
ng like:
>
> mdadm --grow /dev/md7 --level=3D6 --chunk=3D16 --backup-file=3D/root/=
backup-md7
>
> Maybe I don't need --level because the level isn't changing? Neither
> is the number of drives.
>
> Thanks in advance,
> Mark
>

OK, I found a blog of Neil's in which I had read the top but hadn't
gone through the comments:

http://neil.brown.name/blog/20090817000931
It seems he answers my question further down in the comments.

Looks like

mdadm --grow /dev/md7 --chunk=3D16

would be enough.

Cheers,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
