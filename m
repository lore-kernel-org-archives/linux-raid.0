From: NeilBrown <neilb@suse.de>
Subject: Re: Help needed recovering from raid failure
Date: Wed, 29 Apr 2015 08:26:03 +1000
Message-ID: <20150429082603.56fb9aa9@notabene.brown>
References: <4D8713B5-39E7-4EE2-898C-35DC0948B4CA@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/W29c53c76tuHp1.Kvh9w42/"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D8713B5-39E7-4EE2-898C-35DC0948B4CA@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter van Es <vanes.peter@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/W29c53c76tuHp1.Kvh9w42/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 27 Apr 2015 11:35:09 +0200 Peter van Es <vanes.peter@gmail.com> wro=
te:

> Sorry for the long post...
>=20
> I am running Ubuntu LTS 14.04.02 Server edition, 64 bits, with 4x 2.0TB d=
rives in a raid-5 array.
>=20
> The 4th drive was beginning to show read errors. Because it was weekend, =
I could not go out
> and buy a spare 2TB drive to replace the one that was beginning to fail.
>=20
> I first got a fail event:
>=20
> This is an automatically generated mail message from mdadm
> running on bali
>=20
> A Fail event had been detected on md device /dev/md/1.
>=20
> It could be related to component device /dev/sdd2.
>=20
> Faithfully yours, etc.
>=20
> P.S. The /proc/mdstat file currently contains the following:
>=20
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [rai=
d4] [raid10]=20
> md1 : active raid5 sdc2[2] sdb2[1] sda2[0] sdd2[3](F)
>     5854290432 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [U=
UU_]
>=20
> md0 : active raid5 sdc1[2] sdd1[3] sdb1[1] sda1[0]
>     5850624 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]
>=20
> unused devices: <none>
>=20
> And then subsequently, around 18 hours later:
>=20
> This is an automatically generated mail message from mdadm
> running on bali
>=20
> A DegradedArray event had been detected on md device /dev/md/1.

This isn't really reporting anything new.
There is probably a daily cron job which reports all degraded arrays.  This
message is reported by that job.

>=20
> Faithfully yours, etc.
>=20
> P.S. The /proc/mdstat file currently contains the following:
>=20
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [rai=
d4] [raid10]=20
> md1 : active raid5 sdc2[2] sdb2[1] sda2[0] sdd2[3](F)
>     5854290432 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [U=
UU_]
>=20
> md0 : active raid5 sdc1[2] sdd1[3] sdb1[1] sda1[0]
>     5850624 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]
>=20
> unused devices: <none>
>=20
> The server had taken the array off line at that point.

Why do you think the array is off-line?  The above message doesn't suggest
that.


>=20
> Needless to say, I can't boot the system anymore as the boot drive is /de=
v/md0, and GRUB can't
> get at it. I do need to recover data (I know, but there's stuf on there I=
 have no backup for--yet).

You boot off a RAID5?  Does grub support that?  I didn't know.
But md0 hasn't failed, has it?

Confused.



>=20
> I booted Linux from a USB stick (which is on /dev/sdc1 hence changing the=
 numbering),
> in recovery mode. Below is the output of /proc/mdstat and=20
> mdadm --examine. It looks like somehow the /dev/sdd2 and /dev/sde2 drives=
 took on the=20
> super block of the /dev/md127 device (my swap file). May that have been d=
one by the boot from
> the Ubuntu USB stick?

There is something VERY sick here.  I suggest that you tread very carefully.

All your '1' partitions should be about 2GB and the '2' parititions about 2=
TB

But the --examine output suggests sda2 and sdb2 are 2TB, while sdd2 and sde2
are 2GB.

That really really shouldn't happen.  Maybe check your partition table
(fdisk).
I really cannot see how this would happen.
>=20
> My plan... assemble a degraded array, with /dev/sde2 (the 4th drive, form=
erly known as /dev/sdd2) not in it.
> Because the fail event put the file system in RO mode, I expect /dev/sdd2=
 (formerly /dev/sdc2) to be ok.
> Then insert new 2TB drive in slot 4. Let system resync and recover.
>=20
> I'm running xfs on the /dev/md1 device.
>=20
> Questions:
>=20
> 1. is this the wise course of action ?
> 2. how exactly do I reassemble the array (/etc/mdadm.conf is inaccessible=
 in recovery mode)
> 3. what command line options do I use exactly from the --examine output b=
elow without screwing things up
>=20
> And help or pointers gratefully accepted

Can you
  mdadm -Ss

to stop all the arrays, then

  fdisk -l /dev/sd?

then=20

  mdadm -Esvv

and post all of that.  Hopefully some of it will make sense.

NeilBrown


--Sig_/W29c53c76tuHp1.Kvh9w42/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUAI+znsnt1WYoG5AQLoRA/6A0ewVGDCJN9FvrPISGvbmv0O9XZQUnHO
Lw8KSSU/1rFNfGL9FwZw0bxfWZE+ePBJWkAj1xBGjqZOg7OfMoBaUJ0mlPXvwyJh
mDaxX1zaZcWmLxJRKVUe2zzXN8H4/eERvylM8LcR90DOG7J0zri0QK1PZxBgjdWi
4pm9D42VxdTESyAvUjY8hBsCodhKc1Lg7IOlcxnQa2OMCUhFuhE2abt8JyYGAa6l
VzAOc+2gDA3t9LZuw9DP6/9fJDUnVAMnkbOiKGRXJJ1G1g/WYOEGyfcg6dSZFsrZ
PNpWfGT+9edSIwnDwP92UmiLKcnRPy1aYPjfwRbKld3W4NxJIILD27xpeMc1WGRE
iS8Zleu+LigMM3YEo4wsqJa4KwUWdPapvJZ3Ay4eLCl3mD7BYZQBp+Y6PEMt2Qb3
lzLDs+v0x5oD4p2KgPj86VBlzwRR2Kb+XCl/P9WUrxOhvnAqFC/hlBezXX+MwQys
qgsBUcCdyrV0GBU5t8zbSRPjMWXNqVXRx5vYWOP6H8nFLq+ybfgQTv7SANVn28oE
NYXyJrVaiIppMakFZiaHLQtM58X2pLQTzClD/z4L30ZY4NdX7qrsDWMMmSLArNju
HF5hMC5Rh0buQSzuw0FgSKcy8cOWTg257+hciKV0gwq92xNSFQh9N46E6oZ324nN
O6vXvosIMMQ=
=WFZ7
-----END PGP SIGNATURE-----

--Sig_/W29c53c76tuHp1.Kvh9w42/--
