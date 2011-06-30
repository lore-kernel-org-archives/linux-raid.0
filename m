From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: misunderstanding of spare and raid devices?
Date: Thu, 30 Jun 2011 12:30:15 +0100
Message-ID: <4E0C5E47.5090604@anonymous.org.uk>
References: <4E0C5539.4030000@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E0C5539.4030000@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Karsten_R=F6mke?= <k.roemke@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30/06/2011 11:51, Karsten R=F6mke wrote:
> Hello,
> I'm searching some hours / minutes to create a raid5 device with 4 di=
sks
> and 1 spare:
> I tried first with the opensuse tool but no success as I want, so I
> tried mdadm
>
> Try:
> mdadm --create /dev/md0 --level=3D5 --raid-devices=3D4 --spare-device=
s=3D1
> /dev/sda3 /dev/sdb2 /dev/sdc5 /dev/sdd5 /dev/sde5
>
> leads to
> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md0 : active (auto-read-only) raid5 sdd5[5](S) sde5[4](S) sdc5[2]
> sdb2[1] sda3[0]
> 13759296 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
>
> 2 spares - I don't understand that.
>
>
> kspace9:~ # mdadm --create /dev/md0 --level=3D5 --raid-devices=3D4 /d=
ev/sda3
> /dev/sdb2 /dev/sdc5 /dev/sdd5
> leads to
> md0 : active (auto-read-only) raid5 sdd5[4](S) sdc5[2] sdb2[1] sda3[0=
]
> 13759296 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
>
> 1 spare - but why - I expect 4 active disks and 1 spare
>
> kspace9:~ # mdadm --create /dev/md0 --level=3D5 --raid-devices=3D5 /d=
ev/sda3
> /dev/sdb2 /dev/sdc5 /dev/sdd5 /dev/sde5
> leads to
> md0 : active (auto-read-only) raid5 sde5[5](S) sdd5[3] sdc5[2] sdb2[1=
]
> sda3[0]
> 18345728 blocks level 5, 64k chunk, algorithm 2 [5/4] [UUUU_]
>
> That's what I want, but I reached it more or less by random.
> Where is my "think-error" (in german).
>
> I use
> kspace9:~ # mdadm --version
> mdadm - v3.0.3 - 22nd October 2009
>
> Any hints would be nice

When you create a RAID 5 array, it starts degraded, and a resync is=20
performed from the first N-1 drives to the last one. If you create a=20
5-drive RAID-5, this shows up as 4 drives and a spare, but once the=20
resync is finished it's 5 active drives. Going back to your first=20
attempt, it'll show as 3 drives and 2 spares, but once the initial=20
resync is finished, it'll be 4 drives and 1 spare.

mdadm --detail /dev/md0 will show more information to confirm that this=
=20
is what is happening.

Hope this helps.

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
