From: Pavel Hofman <pavel.hofman@ivitera.com>
Subject: Re: Rotating RAID 1
Date: Mon, 15 Aug 2011 22:21:09 +0200
Message-ID: <4E497FB5.3030109@ivitera.com>
References: <CALJXSJq6bDoWhSY3jQa8scpMo4QzHPzUvVPnHbox=xXYPm877w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALJXSJq6bDoWhSY3jQa8scpMo4QzHPzUvVPnHbox=xXYPm877w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Dne 15.8.2011 21:56, J=C3=A9r=C3=B4me Poulin napsal(a):
> Good evening,
>=20
> I'm currently working on a project in which I use md-raid RAID1 with
> Bitmap to "clone" my data from one disk to another and I would like t=
o
> know if this could cause corruption:
>=20
> The system has 2 SATA ports which are hotplug capable.
> I created 2 partitions, 1 system (2GB), 1 data (1TB+).
> I created to RAID1 using:
> mdadm --create /dev/md0 --raid-devices=3D2 --bitmap=3Dinternal
> --bitmap-chunk=3D4096 --metadata=3D1.0 /dev/sd[ab]1
> mdadm --create /dev/md1 --raid-devices=3D2 --bitmap=3Dinternal
> --bitmap-chunk=3D65536 --metadata=3D1.0 /dev/sd[ab]2
> Forced sync_parallel on the system disk to be sure it rebuild first.
> Formatted system ext3 and data ext4.
> Both mounted using data=3Dwriteback.
>=20
> This system doesn't contain critical data but it contains backups on
> the data partition. Once the data is in sync, I removed a disk and le=
t
> udev fail and remove the disk from the array, this is ArchLinux and
> udev is set to mount the array using the incremental option, I added
> --run to make sure it mounts even when a disk is missing. As of now,
> eveything works as expected.
>=20
> Then what is different about a standard RAID1, I removed sdb and
> replaced it with a brand new disk, copied the partition template from
> the other one and added the new disk using mdadm -a on both arrays, i=
t
> synced and works, then swapping the other disk back only rebuilds
> according to the bitmap, however sometimes it appears to make a full
> rebuild which is alright. However once, after a day of modifications
> and weeks after setting-up this RAID, at least 100 GB, it took second=
s
> to rebuild and days later it appeared to have encountered corruption,
> the kernel complained about bad extents and fsck found errors in one
> of the file I know it had modified that day.

Does your scenario involve using two "external" drives, being swapped
each time? I am using such setup, but in order to gain the bitmap
performance effects, I have to run two mirrored RAID1s, i.e. two
bitmaps, each for its corresponding external disk. This setup has been
working OK for a few years now.

Best regards,

Pavel.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
