From: NeilBrown <neilb@suse.de>
Subject: Re: Full stripe write in RAID6
Date: Wed, 6 Aug 2014 16:47:20 +1000
Message-ID: <20140806164720.2aac2c5a@notabene.brown>
References: <01b101cfb0c9$e8fcf240$baf6d6c0$@calsoftinc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/n3F1Iids/3/R+SFx_.kGwg8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <01b101cfb0c9$e8fcf240$baf6d6c0$@calsoftinc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mandar Joshi <mandar.joshi@calsoftinc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/n3F1Iids/3/R+SFx_.kGwg8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Aug 2014 21:55:46 +0530 "Mandar Joshi"
<mandar.joshi@calsoftinc.com> wrote:

> Hi,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 If I am writing entire stripe then whether RAID6 md driv=
er
> need to read any of the blocks from underlying device?=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 I have created RAID6 device with default (512K) chunk si=
ze
> with total 6 RAID devices. cat /sys/block/md127/queue/optimal_io_size =3D
> 2097152 I believe this is full stripe (512K * 4 data disks).=20
> If I write 2MB data, I am expected to dirty entire stripe hence what I
> believe I need not require to read either any of the data block or parity
> blocks. Thus avoiding RAID6 penalties. Whether md/raid driver supports fu=
ll
> stripe writes by avoiding RAID 6 penalties?
>=20
> I also expected 6 disks will receive 512K writes each. (4 data disk + 2
> parity disks).=20

Your expectation is correct in theory, but it doesn't always quite work like
that in practice.
The write request will arrive at the raid6 driver in smaller chunks and it
doesn't always decide correctly whether it should wait for more writes to
arrive, or if it should start reading now.

It would certainly be good to "fix" the scheduling in raid5/raid6, but no o=
ne
have worked out how yet.

NeilBrown



>=20
> If I do IO directly on block device /dev/md127, I do observe reads happen=
ing
> on md device and underlying raid devices as well.=20
>=20
> #mdstat o/p:
> md127 : active raid6 sdah1[5] sdai1[4] sdaj1[3] sdcg1[2] sdch1[1] sdci1[0]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 41926656 blocks super 1.2 level 6, 512k ch=
unk, algorithm 2 [6/6]
> [UUUUUU]
>=20
>=20
>=20
> # time (dd if=3D/dev/zero of=3D/dev/md127 bs=3D2M count=3D1 && sync)
>=20
> # iostat::
> Device:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 tps=C2=A0=C2=A0 Blk_read/s=C2=A0=C2=A0 Blk_wrtn/s=C2=A0=C2=A0 Blk_read=C2=
=A0=C2=A0 Blk_wrtn
> sdaj1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=
9.80=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.60=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 205.20=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1026
> sdai1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A01=
8.20=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 205.20=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1026
> sdah1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3=
3.60=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 11.20=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 344.40=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 56=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1722
> sdcg1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2=
0.20=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 205.20=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1026
> sdci1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3=
1.00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3.20=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 344.40=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=
6=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1722
> sdch1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3=
4.00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 120.00=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 205.20=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 600=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 1026
> md127=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 119.20=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 134.40=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 819.20=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 672=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 4096
>=20
>=20
> So to avoid cache effect, if any (?) I am using raw device to perform IO.
> Then for one stripe write I do observe no reads happening.=20
> At the same time I also see few disks getting more writes than expected. =
Did
> not get why?
>=20
> # raw -qa
> /dev/raw/raw1:=C2=A0 bound to major 9, minor 127
>=20
> #time (dd if=3D/dev/zero of=3D/dev/raw/raw1 bs=3D2M count=3D1 && sync)
>=20
> # iostat shows:
> Device:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 tps=C2=A0=C2=A0 Blk_read/s=C2=A0=C2=A0 Blk_wrtn/s=C2=A0=C2=A0 Blk_read=C2=
=A0=C2=A0 Blk_wrtn
> sdaj1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 7.00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 205.20=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1026
> sdai1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 6.20=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 205.20=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1026
> sdah1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 9.80=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 246.80=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1234
> sdcg1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 6.80=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 205.20=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1026
> sdci1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 9.60=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 246.80=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1234
> sdch1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 6.80=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 205.20=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1026
> md127=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 0.80=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 819.20=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4096
>=20
> I assume if I perform writes in multiples of =E2=80=9Coptimal_io_size=E2=
=80=9D I would be
> doing full stripe writes thus avoiding reads. But unfortunately with two =
2M
> writes, I do see reads happening for some these drives. Same case for
> count=3D4 or 6 (equal to data disks or total disks).
> # time (dd if=3D/dev/zero of=3D/dev/raw/raw1 bs=3D2M count=3D2 && sync)
>=20
>=20
> Device:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 tps=C2=A0=C2=A0 Blk_read/s=C2=A0=C2=A0 Blk_wrtn/s=C2=A0=C2=A0 Blk_read=C2=
=A0=C2=A0 Blk_wrtn
> sdaj1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=
3.40=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 204.80=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 410.00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1024=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 2050
> sdai1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=
1.20=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 410.00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2050
> sdah1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=
5.80=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 464.40=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2322
> sdcg1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=
3.20=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 204.80=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 410.00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1024=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 2050
> sdci1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=
6.60=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 464.40=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2322
> sdch1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=
2.40=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 192.00=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 410.00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 960=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 2050
> md127=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 1.60=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 1638.40=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 8192
>=20
>=20
> I read about =E2=80=9C/sys/block/md127/md/md/preread_bypass_threshold=E2=
=80=9D.=20
> I tried setting this to 0 as well as suggested somewhere. But no help.
>=20
> I believe RAID6 penalties will exist if it=E2=80=99s a random write, but =
in case of
> seq. write, whether they will still exist in some other form in Linux
> md/raid driver?
> My aim is to maximize RAID6 Write IO rate with sequential Writes without
> RAID6 penalties.
>=20
> Rectify me wherever my assumptions are wrong. Let me know if any other
> configuration param (for block device or md device) is required to achieve
> the same.
>=20
> --
> Mandar Joshi


--Sig_/n3F1Iids/3/R+SFx_.kGwg8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+HPeDnsnt1WYoG5AQIsBQ/5AVta0wHZJShoOeCGuhsBTcBl78yhuRQ5
cKYYDgHZ7L2QNw5eixH06PrO7eWbet/G0+GqXzykCJtHMpyAuM7I/XsUiVnn5E6e
v+r8bFLEuqNThuA1jcLplEJws4c6CwaHuzPv138Xx9+QgNfhM/ARk/CPOjIZTgrm
4pfy624IIM436egCTIxrwIYjXGaLFj2LZmM4pxN1bjd2w19fhdYI5kav7KLXWP11
JwZRosf4iaSKOY1C4v0isM6tMiIelivb3aAXWhnY7r+6EX2Fz6MDqrBQo+M9XFO6
9r9aAqGHBZqUAu5e45W6eS2xDtQwEiR371eZcMSwGi7tzNiTWoWIjJmRnaB7hW9G
kjZ6Aqgd3KnAtzmUIm4CffsbrYVIzj/U48lqqEvdGt0Bz2qJgzNt3ddabxAjlwvx
glmm1kWzvW/0SdNJXJSTzUuk02hP0vxRh81JrHippS2rKyvq9lFavjvYSqQZNn8C
/CG5F1sJEPMsgINfi7EMRgnCzXHhpSJnAuz8+PqwjVkw41CuXL+iKOCXERW0k1je
e1uIObGflMr357bwYsjqkzfcnsWsGda6c8vzr4sK00hOT6wwFuWUua+6kF8d8WlK
WtN1Ub/wJuVSwGRnALAygtpFtqV3IQk3vjP5SXgFirko8BMzoRZ3zMauzPMkChRz
RsanEnHK2y8=
=VyjV
-----END PGP SIGNATURE-----

--Sig_/n3F1Iids/3/R+SFx_.kGwg8--
