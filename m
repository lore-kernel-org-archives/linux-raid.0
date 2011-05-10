From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5 -> RAID6 conversion, please help
Date: Wed, 11 May 2011 09:31:55 +1000
Message-ID: <20110511093155.5b1a203e@notabene.brown>
References: <002a01cc0f68$1c851180$558f3480$@priv.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <002a01cc0f68$1c851180$558f3480$@priv.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Kovari <peter@kovari.priv.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 11 May 2011 01:15:11 +0200 "Peter Kovari" <peter@kovari.priv.hu=
>
wrote:

> Dear all,
>=20
> I tried to convert my existing 5 disks RAID5 array to a 6 disks RAID6=
 array.
> This was my existing array:
> ---------------------------------------------------------------------=
-------
> -----------------------------------
> /dev/md0:
> =A0 Version : 0.90
> =A0 Raid Level : raid5
> =A0 Array Size : 5860548608 (5589.05 GiB 6001.20 GB)
> =A0 Used Dev Size : 1465137152 (1397.26 GiB 1500.30 GB)
> =A0 Raid Devices : 5
> =A0Total Devices : 5
> =A0 Persistence : Superblock is persistent
> =A0 State : clean
> =A0Active Devices : 5
> =A0Working Devices : 5
> =A0 Layout : left-symmetric
> =A0 Chunk Size : 512K
> =A0 Events : 0.156
>=20
> =A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
> =A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 17=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdb1
> =A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 81=A0=A0=A0=
=A0=A0=A0=A0 1=A0=A0=A0=A0 =A0active sync=A0=A0 /dev/sdf1
> =A0=A0=A0=A0=A0=A0 2=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 33=A0=A0=A0=
=A0=A0=A0=A0 2=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdc1
> =A0=A0=A0=A0=A0=A0 3=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 97=A0=A0=A0=
=A0=A0=A0=A0 3=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdg1
> =A0=A0=A0=A0=A0=A0 4=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 65=A0=A0=A0=
=A0=A0=A0=A0 4=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sde1
> ---------------------------------------------------------------------=
-------
> -------------------------------
>=20
> I did the conversion according to "howtos", so:
> $ mdadm -add /dev/md0 /dev/sdd1
> then:
> $ mdadm --grow /dev/md0 --level=3D6 --raid-devices=3D6
> --backup-file=3D/mnt/mdadm-raid5-to-raid6.backup
>=20
> Instead of starting the reshape process, mdadm responded this:
> mdadm: /dev/md0: changed level to 6 (or something like that, i dont r=
emember
> the exact words, but it was about changing the level).
> mdadm: /dev/md0: Cannot get array details from sysfs
>=20
> And the array became this:
> ---------------------------------------------------------------------=
-------
> -------------------------------
> /dev/md0:
> =A0 Raid Level : raid6
> =A0 Array Size : 5860548608 (5589.05 GiB 6001.20 GB)
> =A0 Used Dev Size : 1465137152 (1397.26 GiB 1500.30 GB)
> =A0 Raid Devices : 6
> Total Devices : 6
> Persistence : Superblock is persistent
> State : clean, degraded
> Active Devices : 5
> Working Devices : 6
> Failed Devices : 0
> Spare Devices : 1
> Events : 0.170
>=20
> =A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
> =A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 17=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdb1
> =A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 81=A0=A0=A0=
=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdf1
> =A0=A0=A0=A0=A0=A0 2=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 33=A0=A0=A0=
=A0=A0=A0=A0 2=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdc1
> =A0=A0=A0=A0=A0=A0 3=A0=A0=A0=A0=A0=A0 8=A0 =A0=A0=A0=A0=A097=A0=A0=A0=
=A0=A0=A0=A0 3=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdg1
> =A0=A0=A0=A0=A0=A0 4=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 65=A0=A0=A0=
=A0=A0=A0=A0 4=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sde1
> =A0=A0=A0=A0=A0=A0 5=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=
=A0=A0=A0=A0=A0 5=A0=A0=A0=A0=A0 removed
> =A0=A0=A0=A0=A0=A0 6=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 49=A0=A0=A0=
=A0=A0=A0=A0 -=A0=A0=A0=A0=A0 spare=A0=A0 /dev/sdd1
> ---------------------------------------------------------------------=
-------
> -------------------------------
>=20
> At this point I realized that /dev/sdd previously was a member of ano=
ther
> raid array in an other machine, and however I re-partitioned the disk=
, I
> didn't remove the old superblock. So maybe this was the reason for th=
e mdadm
> error. Since the state of /dev/sdd1 was spare, i removed it:
>=20
> $ mdadm -remove /dev/md0 /dev/sdd1
>=20
> then cleared remaining superblock
> $ mdadm --zero-superblock /dev/sdd1
>=20
> then added it back to the array:
> mdadm --add /dev/md0 /dev/sdd1
>=20
> and started the grow process again:
> $ mdadm --grow /dev/md0 --level=3D6 --raid-devices=3D6
> --backup-file=3D/mnt/mdadm-raid5-to-raid6.backup
> mdadm: /dev/md0: no change requested
>=20
> Mdadm stated no change, however, it started to rebuild the array. It'=
s
> currently rebuilding:
> ---------------------------------------------------------------------=
-------
> -------------------------------
> /dev/md0:
> =A0 Version : 0.90
> =A0 Raid Level : raid6
> =A0 Array Size : 5860548608 (5589.05 GiB 6001.20 GB)
> =A0 Used Dev Size : 1465137152 (1397.26 GiB 1500.30 GB)
> =A0 Raid Devices : 6
> =A0Total Devices : 6
> =A0 Persistence : Superblock is persistent
> =A0 State : clean, degraded, recovering
> =A0Active Devices : 5
> =A0 Working Devices : 6
> =A0Failed Devices : 0
> =A0 Spare Devices : 1
> =A0 Layout : left-symmetric-6
> =A0Chunk Size : 512K
> =A0Rebuild Status : 2% complete
> =A0 Events : 0.186
>=20
> =A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
> =A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 17=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdb1
> =A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 81=A0=A0=A0=
=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdf1
> =A0=A0=A0=A0=A0=A0 2=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 33=A0=A0=A0=
=A0=A0=A0=A0 2=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdc1
> =A0=A0=A0=A0=A0=A0 3=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 97=A0=A0=A0=
=A0=A0=A0=A0 3=A0 =A0=A0=A0=A0active sync=A0=A0 /dev/sdg1
> =A0=A0=A0=A0=A0=A0 4=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 65=A0=A0=A0=
=A0=A0=A0=A0 4=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sde1
> =A0=A0=A0=A0=A0=A0 6=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 49=A0=A0=A0=
=A0=A0=A0=A0 5=A0=A0=A0=A0=A0 spare rebuilding=A0=A0 /dev/sdd1
> ---------------------------------------------------------------------=
-------
> -------------------------------
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] =
[raid4]
> [raid10]
> md0 : active raid6 sdd1[6] sde1[4] sdc1[2] sdf1[1] sdg1[3] sdb1[0]
> =A0=A0=A0=A0=A0 5860548608 blocks level 6, 512k chunk, algorithm 18 [=
6/5] [UUUUU_]
> =A0=A0=A0=A0=A0 [>....................]=A0 recovery =3D=A0 2.3% (3443=
8272/1465137152)
> finish=3D1074.5min speed=3D22190K/sec
>=20
> unused devices: <none>
> ---------------------------------------------------------------------=
-------
> -------------------------------
>=20
> Mdadm didn't create the backup file, and the process seems too fast t=
o me
> for a raid5->raid6 conversion.
> Please help me to understand what's happening now.

You have a RAID6 array in a non-standard config where there Q block (th=
e
second parity block) is always on the last device rather than rotated a=
round
the various devices.

The array is simply recovering that 6th drive to the spare.

When it finished you will have a perfectly functional RAID6 array with =
full
redundancy.  It might perform slightly differently to a standard layout=
 -
I've never performed any measurements to see how differently.

If you want to (after the recovery completes) you could convert to a re=
gular
RAID6 with
  mdadm -G /dev/md0 --layout=3Dnormalise   --backup=3D/some/file/on/a/d=
ifferent/device

but you probably don't have to.

The old meta on sdd will not have been a problem.

What version of mdadm did you use to try to start the reshape?

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
