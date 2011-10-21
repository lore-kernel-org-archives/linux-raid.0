From: NeilBrown <neilb@suse.de>
Subject: Re: How to free devices held captive by failed arrays
Date: Sat, 22 Oct 2011 09:41:56 +1100
Message-ID: <20111022094156.1a2c42ae@notabene.brown>
References: <20111021202736.GA10682@moo.nac.uci.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/637IQbbgqYbbA4yXKgemGYw"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111021202736.GA10682@moo.nac.uci.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Harry Mangalam <hjm@moo.nac.uci.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/637IQbbgqYbbA4yXKgemGYw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Oct 2011 13:27:36 -0700 Harry Mangalam <hjm@moo.nac.uci.edu> wro=
te:

> (apologies if this is a repost - sent 3 attempts into the vger void alrea=
dy)
>=20
> In doing some tests with an 8-port Supermicro/Marvell-based SATA controll=
er
> (works fine so far) and some Hitachi 3TB disks, I've run into an odd
> problem.  One of the disks failed in burn-in, so the RAID5 went into
> degraded mode.  In replacing the failed disk, I managed to bugger it up; =
not
> so awful since it's a test rig and I needed to create 2 smaller arrays for
> some testing.=20
>=20
>=20
> In trying to do that, I was able to create the first 4-disk RAID5 fine and
> it's now initializing, but the second fails with the following error:
>=20
>=20
> $ mdadm --create  --verbose /dev/md1 --level=3D5 --raid-devices=3D4
> /dev/sd[fghi]1
> mdadm: layout defaults to left-symmetric
> mdadm: layout defaults to left-symmetric
> mdadm: chunk size defaults to 512K
> mdadm: /dev/sdf1 appears to be part of a raid array:
>     level=3Draid5 devices=3D7 ctime=3DFri Sep 30 17:47:19 2011
> mdadm: layout defaults to left-symmetric
> mdadm: super1.x cannot open /dev/sdg1: Device or resource busy
> mdadm: /dev/sdg1 is not suitable for this array.
> mdadm: layout defaults to left-symmetric
> mdadm: /dev/sdh1 appears to be part of a raid array:
>     level=3Draid5 devices=3D7 ctime=3DFri Sep 30 17:47:19 2011
> mdadm: layout defaults to left-symmetric
> mdadm: create aborted
>=20
>=20
> mdstat implies that one of the disks still belongs to the previous RAID5:
>=20
>=20
> $ cat /proc/mdstat=20
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [rai=
d4]
> [raid10]=20
> md0 : active raid5 sde1[4] sdd1[2] sdc1[1] sdb1[0]
>       6442438656 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3]
> [UUU_]
>       [=3D=3D=3D=3D=3D=3D=3D=3D>............]  recovery =3D 40.1% (861382=
528/2147479552)
> finish=3D292.9min speed=3D73167K/sec
>      =20
> md_d0 : inactive sdg1[5](S)
>       2147480704 blocks
>       =20
> unused devices: <none>
>=20
>=20
>=20
>=20
> but I can't seem to convince md_d0 to surrender this device.  This behavi=
or
> survives a reboot.
>=20
>=20
> One wrinkle is that the original RAID was made with the default mdadm from
> Ubuntu 10.04.3 (2.6.7.1) and the smaller RAID5 above was created with the
> latest mdadm (v3.2.2). =20
>=20
>=20
> What do I have to do to free this device?

Doesn't
=20
   mdadm --stop /dev/md_d0

release sdg1 ??

NeilBrown


>=20
>=20
> TIA,
>=20
>=20


--Sig_/637IQbbgqYbbA4yXKgemGYw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqH1NDnsnt1WYoG5AQLgCA//Xj/v578PkCG0PhxQxYd5MqPGFKf15sSl
kX3i2YygZhkUDBQ7YsjJwhiWQGMcfg/RldEt+lYzOHgTquT0hd+RIOXPy1A/WTGR
d6cq1CGvmKAMkjRTGJBlqRsRubQd5MyJzgq38gsOd/UFLGAnSAS5Y+Mpj5ld80gt
Nwyhhe9iqsQSK0jKqouo2ylmInNdXdB1+osu+QH2OD9cP1LviRHH59tVjXzONrHD
TV2Z0LTX6iJ+KBBqUR8YfburwsrRE8avTi3sZ+rZ0bMQ8Sllt8S0jMClLfxkEwrs
b7G4MVWANSlB1Jdbv67ReWB1BdGpDteVatYwTkEfwxCKM69tbWW3wcoa2tyvzw6B
+7hd+ilfYxuv/QFfhdsMqvI1OIO5Jy47c8tT7xpoHxgc6vizotEZfoLNOLI90PEV
pBCffRr0kXgYFNIm2PNAgwLNJ6xMY+d/StoHx3awopZFzlf5b/hxFQS8Go2iW4rq
Mx8PP3C8T9o501p0tO/Xs4LfrCqzO3iv8GMflDdxidvQQMPU/Lgp8KEK2KOTx1PS
Cr3+B39/TyBj8ixn44foUBPmLg37O6c3U80kFTpc4pMEeMkXsqo8AnKCTOrb7axj
FbT/IPa+vjJApjviULXg4ekggpvK+sW0b0VXuITn94iuggzVi1eAtXuRU8lAklAL
p3n/6IWu0zk=
=/XEc
-----END PGP SIGNATURE-----

--Sig_/637IQbbgqYbbA4yXKgemGYw--
