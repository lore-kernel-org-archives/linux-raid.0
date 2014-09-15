From: NeilBrown <neilb@suse.de>
Subject: Re: dmadm question
Date: Mon, 15 Sep 2014 10:31:54 +1000
Message-ID: <20140915103154.59bc7293@notabene.brown>
References: <661E720A-B65C-4C24-B6A4-A4439596DEB9@lukeodom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/VSakQxntXP/FLd_/HA1pymn"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <661E720A-B65C-4C24-B6A4-A4439596DEB9@lukeodom.com>
Sender: linux-raid-owner@vger.kernel.org
To: Luke Odom <luke@lukeodom.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/VSakQxntXP/FLd_/HA1pymn
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12 Sep 2014 18:49:54 -0700 Luke Odom <luke@lukeodom.com> wrote:

>   I had a raid1 subarray running within an imsm container. One of the dri=
ves died so I replaced it. I can get the new drive into the imsm container =
but I can=E2=80=99t add it to the raid1 array within that container. I=E2=
=80=99ve read the man page and can=E2=80=99t see to figure it out. Any help=
 would be greatly appreciated. Using mdadm 3.2.5 on debian squeeze.=C2=A0

This  should just happen automatically.  As soon as you add the device to t=
he
container, mdmon notices and adds it to the raid1.

However it appears not to have happened...

I assume the new drive is exactly the same size as the old drive?
Try removing the new device from md127, run "mdadm --zero" on it, then add =
it
back again.
Do any messages appear in the kernel logs when you do that?

Is "mdmon md127" running?

NeilBrown


>=20
>=20
>=20
>=20
> root@ds6790:~# cat /proc/mdstat
> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md126 : active raid1 sda[0]
> =C2=A0 =C2=A0 =C2=A0 976759808 blocks super external:/md127/0 [2/1] [U_]
>=20
>=20
>=20
>=20
> md127 : inactive sdb[0](S) sda[1](S)
> =C2=A0 =C2=A0 =C2=A0 4901 blocks super external:imsm
>=20
>=20
>=20
>=20
> unused devices: <none>
>=20
>=20
>=20
>=20
>=20
>=20
> root@ds6790:~# mdadm --detail /dev/md126
> /dev/md126:
> =C2=A0 =C2=A0 =C2=A0 Container : /dev/md127, member 0
> =C2=A0 =C2=A0 =C2=A0Raid Level : raid1
> =C2=A0 =C2=A0 =C2=A0Array Size : 976759808 (931.51 GiB 1000.20 GB)
> =C2=A0 Used Dev Size : 976759940 (931.51 GiB 1000.20 GB)
> =C2=A0 =C2=A0Raid Devices : 2
> =C2=A0 Total Devices : 1
>=20
>=20
>=20
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : active, degraded=C2=A0
> =C2=A0Active Devices : 1
> Working Devices : 1
> =C2=A0Failed Devices : 0
> =C2=A0 Spare Devices : 0
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UUID : 1be60edf:5c16b945:86434b6=
b:2714fddb
> =C2=A0 =C2=A0 Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice State
> =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/sda
> =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0removed
>=20
>=20
>=20
>=20
>=20
>=20
> root@ds6790:~# mdadm --examine /dev/md127
> /dev/md127:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : Intel Raid ISM Cfg Sig.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.1.00
> =C2=A0 =C2=A0 Orig Family : 6e37aa48
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Family : 6e37aa48
> =C2=A0 =C2=A0 =C2=A0Generation : 00640a43
> =C2=A0 =C2=A0 =C2=A0Attributes : All supported
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UUID : ac27ba68:f8a3618d:3810d44=
f:25031c07
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : 513ef1f6 correct
> =C2=A0 =C2=A0 MPB Sectors : 1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Disks : 2
> =C2=A0 =C2=A0RAID Devices : 1
>=20
>=20
>=20
>=20
> =C2=A0 Disk00 Serial : 9XG3RTL0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : active
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Id : 00000002
> =C2=A0 =C2=A0 Usable Size : 1953519880 (931.51 GiB 1000.20 GB)
>=20
>=20
>=20
>=20
> [Volume0]:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UUID : 1be60edf:5c16b945:86434b6=
b:2714fddb
> =C2=A0 =C2=A0 =C2=A0RAID Level : 1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Members : 2
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Slots : [U_]
> =C2=A0 =C2=A0 Failed disk : 1
> =C2=A0 =C2=A0 =C2=A0 This Slot : 0
> =C2=A0 =C2=A0 =C2=A0Array Size : 1953519616 (931.51 GiB 1000.20 GB)
> =C2=A0 =C2=A0Per Dev Size : 1953519880 (931.51 GiB 1000.20 GB)
> =C2=A0 Sector Offset : 0
> =C2=A0 =C2=A0 Num Stripes : 7630936
> =C2=A0 =C2=A0 =C2=A0Chunk Size : 64 KiB
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Reserved : 0
> =C2=A0 Migrate State : idle
> =C2=A0 =C2=A0 =C2=A0 Map State : degraded
> =C2=A0 =C2=A0 Dirty State : dirty
>=20
>=20
>=20
>=20
> =C2=A0 Disk01 Serial : XG3RWMF
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : failed
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Id : ffffffff
> =C2=A0 =C2=A0 Usable Size : 1953519880 (931.51 GiB 1000.20 GB)
>=20
>=20
>=20
>=20
>=20


--Sig_/VSakQxntXP/FLd_/HA1pymn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBYzejnsnt1WYoG5AQIt1w//dRlqNt7l86brqHRgLz9WLD2Ez2zp0S3u
ChFhYOIL5GaoyAfgsfkZRshRnIaDfNdbXbn6/YVlMLt4b5Agu2gqZDTwxPRHqjem
UpjAKcfaJdwM9NDFQ2XHpDA1SGWYWaeFkceC+B1b6cK4CX+nftF7lmq3BkEXahw5
DGQaT73+eWISfKX+A/Cmk0LInT02YaO7jjKeZ7perwlP6dpGXQmcgPPHGCVftHXi
fFZ0cIfq6UaNk2XH7HhEt+I1vMXgI7kUe8MRTnuVC3A/MIaTtu4JqRhjaDd/jiEK
rPgv4CfNxngOGstGZYJ+RrmvNxJTdNjkh/VldaCI+XMLnGGBGQxyP235MUeVqKL3
nMRCCsW4FnuW8E/+jOAIY90EeJiLFhdLkkZsfMbazaijzLlKMmc++55jq/40AB20
00MB7mk0RFbvL/zI7SyN0olDThrZqLx9PlZ0qjWWWBbt7RjiK3ScTube6pJmIPJc
hJzXSCUGq75SZlnLjC1n4ZgwOl+7FMVGhrLnKa79Hoy19gMkOqtUR55PWj69fW/Q
mZD+nuZbD888uZkqVJYVv3B1W3su9xF7d6IqMrVWoRiH/EgwMHQA2H8mMjx475Gj
1SODxqtYWiOg8znji4QwvVXWDSsumGOs+etsfamseTkYLnnaghLwGHriRiQFG2D9
WGBXKjeaiLE=
=r7un
-----END PGP SIGNATURE-----

--Sig_/VSakQxntXP/FLd_/HA1pymn--
