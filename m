From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: RAID6 and crashes (reporting back re. --bitmap)
Date: Fri, 11 Jun 2010 10:55:21 +0600
Message-ID: <20100611105521.67c9658c@natsu>
References: <4C1128C2.4020105@meetinghouse.net>
 <20100611005743.43664e5b@natsu>
 <4C11578B.8010202@meetinghouse.net>
 <20100611034108.6a2cdbc4@natsu>
 <4C1169CB.1030903@meetinghouse.net>
 <20100611085112.5f33b06f@natsu>
 <4C11BFB7.7050907@meetinghouse.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kvqIACyZDocIU28L2Csw/4z"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C11BFB7.7050907@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@meetinghouse.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kvqIACyZDocIU28L2Csw/4z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Jun 2010 00:46:47 -0400
Miles Fidelman <mfidelman@meetinghouse.net> wrote:

> Looks like my original --bitmap internal creation set a very large chunk=
=20
> size initially
>=20
> md3 : active raid6 sda4[0] sdd4[3] sdc4[2] sdb4[1]
>        947417088 blocks level 6, 64k chunk, algorithm 2 [4/4] [UUUU]
>        bitmap: 6/226 pages [24KB], 1024KB chunk
>=20
> unless that --bitmap-chunk=3D131072 recommendation is translates to=20
> 131072KB (if so, are you really running 131MB chunks?)

Yes, this is correct.
This will only mean that after an unclean shutdown, at least 128MB-sized
areas of the array will be invalidated for a resync, and not smaller areas
with 1MB-granularity like on yours currently. 128 megabytes is just about 1
second of read throughput on modern drives, so I am okay with that. Several
128MB-windows here and there are still faster to resync than the whole arra=
y.
And this had an extemely good effect on write performance for me (increased=
 it
by more than 1.5x) compared to a small chunk. Test for yourself, first with=
out
the bitmap, then with various chunk sizes of it (ensure there's no other lo=
ad
on the array, and note the speeds):

dd if=3D/dev/zero of=3D/your-raid/zerofile bs=3D1M count=3D2048 conv=3Dnotr=
unc,fdatasync

--=20
With respect,
Roman

--Sig_/kvqIACyZDocIU28L2Csw/4z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwRwbkACgkQTLKSvz+PZwhQqgCgjm8kJeBfUDZPyUP7MzYXmUak
b4EAn31AUyO4sUHpfuGlgK2nE5S162hG
=75fx
-----END PGP SIGNATURE-----

--Sig_/kvqIACyZDocIU28L2Csw/4z--
