From: NeilBrown <neilb@suse.de>
Subject: Re: Array rebuilding over and over
Date: Sat, 18 Aug 2012 07:17:34 +1000
Message-ID: <20120818071734.09d1a2a0@notabene.brown>
References: <0622703D64D8944D9624A1C5833B7A06A99D@DLB-XCHPW02.dolby.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/iL3hmfwGNsr4SsUQNJI4leH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0622703D64D8944D9624A1C5833B7A06A99D@DLB-XCHPW02.dolby.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Singer, Benedict" <bzsing@dolby.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/iL3hmfwGNsr4SsUQNJI4leH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 17 Aug 2012 17:53:51 +0000 "Singer, Benedict" <bzsing@dolby.com>
wrote:

> Hello all,
>=20
> Got a strange issue here. The setup is as follows: 4 RAID5 arrays, 3 driv=
es (partitions - 3 drives total) each. We run some monitoring software to d=
eal with keeping them all happy, ie removing faulty drives from all arrays =
if it goes bad in one of them, partitioning and adding new drives to all of=
 them, tracking rebuild progress, etc. The situation we're in now is that i=
t's somehow possible to get an array in a state where the rebuild consisten=
tly fails; then the monitoring software detects the degraded array + availa=
ble physical disk, and starts a new rebuild, which then fails again (and ag=
ain, and again...).
>=20
> The really baffling part is that no information is present in any logs ab=
out why the rebuild fails, making this very hard to diagnose. The array app=
ears to start rebuilding, fail, and finish all within a second, suggesting =
it's not actually trying to rebuild, but something else is stopping it. The=
 smartctl short selftest reports no errors on any disks. This seems to happ=
en most of the time with md4, and the only way to get out of it is to reboo=
t the system and try the rebuild again, which suggests a kernel issue rathe=
r than a hardware issue. I have seen it once on a different array, but in t=
hat case the rebuild worked the second time, whereas in the md4 case it app=
ears to be impossible to get out of this state without rebooting. While it'=
s in this state I can remove and add the disk back to md4 and idle the othe=
r rebuild to get it to happen on command, so if there are any debugging sug=
gestions it's easy to reproduce on command at this point.
>=20
> I've checked the kernel config to see if there's any other block/md loggi=
ng to turn on, but was unsuccessful; watching the console and dmesg don't s=
how any other useful information either.
>=20
> Here's the relevant info:
>=20
> uname:
> Linux showstore-1 3.2.23 #1 SMP Mon Aug 13 21:19:58 UTC 2012 i686 GNU/Lin=
ux
>=20
> mdadm:
> mdadm - v3.1.4 - 31st August 2010
>=20
> /proc/mdstat - this is in the middle of a rebuild cycle (2/4 finished, 1/=
4 in progress, and the last one (md4) will fail and start the whole process=
 again):
> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]=20
> md4 : active raid5 sda4[3] sdc4[2] sdb4[1]
>       2096640 blocks level 5, 256k chunk, algorithm 2 [3/2] [_UU]
>       resync=3DDELAYED
>      =20
> md126 : active raid5 sda3[4] sdc3[5] sdb3[3]
>       1936479232 blocks super 1.2 level 5, 256k chunk, algorithm 2 [3/2] =
[_UU]
>       [=3D=3D=3D=3D=3D=3D=3D=3D=3D>...........]  recovery =3D 49.1% (4760=
73216/968239616) finish=3D92.8min speed=3D88333K/sec
>      =20
> md127 : active raid5 sda2[4] sdc2[5] sdb2[3]
>       8386048 blocks super 1.2 level 5, 256k chunk, algorithm 2 [3/3] [UU=
U]
>      =20
> md1 : active raid5 sda1[0] sdc1[2] sdb1[1]
>       6290944 blocks level 5, 256k chunk, algorithm 2 [3/3] [UUU]
>      =20
> unused devices: <none>
>=20
> Log entries from syslog and messages from the last time the failure occur=
red:
>=20
> syslog (covering the full rebuild cycle on all 4 arrays):
> Aug 17 05:13:20 showstore-1 mdadm[5991]: RebuildStarted event detected on=
 md device /dev/md1
> Aug 17 05:13:24 showstore-1 kernel: EXT2-fs (md1): warning: maximal mount=
 count reached, running e2fsck is recommended
> Aug 17 05:13:26 showstore-1 kernel: scsi_verify_blk_ioctl: 58 callbacks s=
uppressed
> Aug 17 05:13:26 showstore-1 kernel: grub-probe: sending ioctl 1261 to a p=
artition!
> Aug 17 05:14:00 showstore-1 kernel: last message repeated 9 times
> Aug 17 05:14:00 showstore-1 mdadm[5991]: RebuildStarted event detected on=
 md device /dev/md/status
> Aug 17 05:14:00 showstore-1 mdadm[5991]: RebuildFinished event detected o=
n md device /dev/md1
> Aug 17 05:14:01 showstore-1 mdadm[5991]: SpareActive event detected on md=
 device /dev/md1, component device /dev/sda1
> Aug 17 05:14:29 showstore-1 kernel: EXT2-fs (md1): warning: maximal mount=
 count reached, running e2fsck is recommended
> Aug 17 05:14:29 showstore-1 kernel: scsi_verify_blk_ioctl: 612 callbacks =
suppressed
> Aug 17 05:14:29 showstore-1 kernel: grub-probe: sending ioctl 1261 to a p=
artition!
> Aug 17 05:14:49 showstore-1 kernel: last message repeated 9 times
> Aug 17 05:14:49 showstore-1 mdadm[5991]: RebuildStarted event detected on=
 md device /dev/md/content
> Aug 17 05:14:49 showstore-1 mdadm[5991]: RebuildFinished event detected o=
n md device /dev/md/status
> Aug 17 05:14:49 showstore-1 mdadm[5991]: SpareActive event detected on md=
 device /dev/md/status
> Aug 17 05:48:10 showstore-1 mdadm[5991]: Rebuild20 event detected on md d=
evice /dev/md/content
> Aug 17 06:38:10 showstore-1 mdadm[5991]: Rebuild48 event detected on md d=
evice /dev/md/content
> Aug 17 07:11:31 showstore-1 mdadm[5991]: Rebuild66 event detected on md d=
evice /dev/md/content
> Aug 17 07:44:51 showstore-1 mdadm[5991]: Rebuild82 event detected on md d=
evice /dev/md/content
> Aug 17 08:29:41 showstore-1 kernel: md/raid:md4: Disk failure on sda4, di=
sabling device.
> Aug 17 08:29:41 showstore-1 kernel: md/raid:md4: Operation continuing on =
2 devices.
> Aug 17 08:29:41 showstore-1 mdadm[5991]: FailSpare event detected on md d=
evice /dev/md4, component device /dev/sda4
> Aug 17 08:29:41 showstore-1 mdadm[5991]: RebuildFinished event detected o=
n md device /dev/md/content
> Aug 17 08:29:41 showstore-1 mdadm[5991]: SpareActive event detected on md=
 device /dev/md/content
>=20
> messages (also covering the full rebuild cycle):
> Aug 17 05:13:20 showstore-1 kernel: md: bind<sda1>
> Aug 17 05:13:20 showstore-1 kernel: md: recovery of RAID array md1
> Aug 17 05:13:20 showstore-1 kernel: md: minimum _guaranteed_  speed: 2000=
0 KB/sec/disk.
> Aug 17 05:13:20 showstore-1 kernel: md: using maximum available idle IO b=
andwidth (but not more than 200000 KB/sec) for recovery.
> Aug 17 05:13:20 showstore-1 kernel: md: using 128k window, over a total o=
f 3145472k.
> Aug 17 05:13:21 showstore-1 kernel: md: bind<sda2>
> Aug 17 05:13:21 showstore-1 kernel: md: delaying recovery of md127 until =
md1 has finished (they share one or more physical units)
> Aug 17 05:13:21 showstore-1 kernel: md: bind<sda3>
> Aug 17 05:13:22 showstore-1 kernel: md: delaying recovery of md126 until =
md127 has finished (they share one or more physical units)
> Aug 17 05:13:22 showstore-1 kernel: md: delaying recovery of md127 until =
md1 has finished (they share one or more physical units)
> Aug 17 05:13:22 showstore-1 kernel: md: bind<sda4>
> Aug 17 05:13:22 showstore-1 kernel: md: delaying recovery of md4 until md=
126 has finished (they share one or more physical units)
> Aug 17 05:13:22 showstore-1 kernel: md: delaying recovery of md127 until =
md1 has finished (they share one or more physical units)
> Aug 17 05:13:22 showstore-1 kernel: md: delaying recovery of md126 until =
md127 has finished (they share one or more physical units)
> Aug 17 05:13:26 showstore-1 kernel: grub-probe[21583]: segfault at 18 ip =
08049057 sp bfa87b60 error 4 in grub-probe[8048000+1f000]
> Aug 17 05:13:59 showstore-1 kernel: md: md1: recovery done.
> Aug 17 05:14:00 showstore-1 kernel: md: delaying recovery of md126 until =
md127 has finished (they share one or more physical units)
> Aug 17 05:14:00 showstore-1 kernel: md: recovery of RAID array md127
> Aug 17 05:14:00 showstore-1 kernel: md: minimum _guaranteed_  speed: 2000=
0 KB/sec/disk.
> Aug 17 05:14:00 showstore-1 kernel: md: using maximum available idle IO b=
andwidth (but not more than 200000 KB/sec) for recovery.
> Aug 17 05:14:00 showstore-1 kernel: md: using 128k window, over a total o=
f 4193024k.
> Aug 17 05:14:00 showstore-1 kernel: md: delaying recovery of md4 until md=
126 has finished (they share one or more physical units)
> Aug 17 05:14:49 showstore-1 kernel: md: md127: recovery done.
> Aug 17 05:14:49 showstore-1 kernel: md: delaying recovery of md4 until md=
126 has finished (they share one or more physical units)
> Aug 17 05:14:49 showstore-1 kernel: md: recovery of RAID array md126
> Aug 17 05:14:49 showstore-1 kernel: md: minimum _guaranteed_  speed: 2000=
0 KB/sec/disk.
> Aug 17 05:14:49 showstore-1 kernel: md: using maximum available idle IO b=
andwidth (but not more than 200000 KB/sec) for recovery.
> Aug 17 05:14:49 showstore-1 kernel: md: using 128k window, over a total o=
f 968239616k.
> Aug 17 05:40:27 showstore-1 rsyslogd: -- MARK --
> Aug 17 06:00:27 showstore-1 rsyslogd: -- MARK --
> Aug 17 06:20:28 showstore-1 rsyslogd: -- MARK --
> Aug 17 06:40:28 showstore-1 rsyslogd: -- MARK --
> Aug 17 07:00:28 showstore-1 rsyslogd: -- MARK --
> Aug 17 07:20:28 showstore-1 rsyslogd: -- MARK --
> Aug 17 07:40:28 showstore-1 rsyslogd: -- MARK --
> Aug 17 08:00:28 showstore-1 rsyslogd: -- MARK --
> Aug 17 08:20:28 showstore-1 rsyslogd: -- MARK --
> Aug 17 08:29:41 showstore-1 kernel: md: md126: recovery done.
> Aug 17 08:29:41 showstore-1 kernel: md: recovery of RAID array md4
> Aug 17 08:29:41 showstore-1 kernel: md: minimum _guaranteed_  speed: 2000=
0 KB/sec/disk.
> Aug 17 08:29:41 showstore-1 kernel: md: using maximum available idle IO b=
andwidth (but not more than 200000 KB/sec) for recovery.
> Aug 17 08:29:41 showstore-1 kernel: md: using 128k window, over a total o=
f 1048320k.
> Aug 17 08:29:41 showstore-1 kernel: md: md4: recovery done.
>=20
> Any suggestions gratefully received!

Very strange indeed.

I assume you've tried disabling all of your monitoring code and can still
reproduce the problem with md4??

If you have dynamic debugging enabled in the kernel you could try

 echo file raid5.c +p > /sys/kernel/debug/dynamic_debug/control

(I think that is the right syntax), then reproduce the problem, then

 echo file raid5.c -p > /sys/kernel/debug/dynamic_debug/control

and post the debugging messages that appeared in the kernel.  There might a
hint there.

I can't think of anything else at the moment, though maybe posting the
  mdadm -E
output of the devices in md4 might help.

NeilBrown


--Sig_/iL3hmfwGNsr4SsUQNJI4leH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUC607jnsnt1WYoG5AQJ0Aw/+MzSTk1jBb7d0ViZwz0EbqCdQ7eFWmAHY
8MG+oK5eZmK9xNTBcR8Hk7LnWPk82GjMW33UEuaRlZw3avIGSF+4G7eV+77rEjzY
rFXTB4Tl0ZlYFAGKS7mlha8rCKPZUGvyQohm1jnOmaEZGrL4ZfMvNBWRdD1Fs+36
G9RLeoMVzRv8LJtZfhVK2/HXFpNYuRNc+G7cUbBwrVM+bit5SG/V7cKi8XvKEMr/
kpKvE2Bq4iYX1K84hmS/uGpMzxbArLeK5xifWQJVnbqVi9Vtr8V2j/vXiJKzFpkR
3OyFy3gOfXZxaLxBL+pSpHaj8Ot/Wuv9fPewvBHcD+yGcscxyTgJq2U6/jo/SsuB
6FuJYGQER0U8KtzogatRideiCKX9RWP4MtCXDPCfldETOUaJbkr0W9Bai2EbIIY6
0FTrfCSMf3hjyXMJg7Bvl28j18T4+YvU/TfOQA8io+pQ3j/I35/YZgSJrrOssmpR
qFUAyXf9XS68qlv+75E4piXjGfl+HkykzHCOWnADLrOLdV+lDmV+HyutltPc+zWn
f1U5WfwBHexI4G//tpHyUDP9mHx4kLBxP54P5nUPLuCa0k80Zo6de2ABdlKClAet
Hakq774/u0aqH//ZaAUJ8Bjsf80FaiYPX84ywvW+IgjTenGBl5UtCIQe/Q4ZWV/0
bXPlCtZpHkE=
=Lzw1
-----END PGP SIGNATURE-----

--Sig_/iL3hmfwGNsr4SsUQNJI4leH--
