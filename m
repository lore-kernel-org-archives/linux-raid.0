From: NeilBrown <neilb@suse.de>
Subject: Re: is "replaceable" in 3.2 considered stable
Date: Mon, 5 Nov 2012 19:42:10 +1100
Message-ID: <20121105194210.7f053192@notabene.brown>
References: <alpine.DEB.2.00.1211050546420.13802@uplift.swm.pp.se>
	<20121105162227.7bc5c103@notabene.brown>
	<alpine.DEB.2.00.1211050909540.13802@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lBRaTfKQIKO2h0H9GrOxRpq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1211050909540.13802@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/lBRaTfKQIKO2h0H9GrOxRpq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 5 Nov 2012 09:11:54 +0100 (CET) Mikael Abrahamsson <swmike@swm.pp.s=
e>
wrote:

> On Mon, 5 Nov 2012, NeilBrown wrote:
>=20
> > Try it.  If it works for you, we can be more confident that it is stabl=
e=20
> > :-)
>=20
> root:~# cat /sys/block/md0/md/dev-sdh/state
> in_sync
> root:~# echo replaceable > /sys/block/md0/md/dev-sdh/state
> -bash: echo: write error: Invalid argument
> root:~# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] [rai=
d1] [raid10]
> md0 : active raid6 sdi[10](S) sdg[11] sdj[15] sdh[14] sdk[13] sde[12] sdd=
[9] sdb[6] sdf[7] sdc[2]
>        13674601024 blocks super 1.2 level 6, 64k chunk, algorithm 2 [9/9]=
 [UUUUUUUUU]
>        bitmap: 0/15 pages [0KB], 65536KB chunk
>=20
> unused devices: <none>
>=20
> Does this mean Ubuntu decided to not support this option in their kernel,=
=20
> or am I misunderstanding something?
>=20

You want
   echo want_replacement > ..../state

I changed that from replaceable at some point, so I guess you are looking at
old code :-(

NeilBrown

--Sig_/lBRaTfKQIKO2h0H9GrOxRpq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUJd74jnsnt1WYoG5AQJNeg/9Gi7jb3RFLJla5IQHJ2t/KDsiHKKVghaY
FO20OnQkuCcyRDpN6p6lCkgT95kZpqWDvTZWeHZFK00unfgzUjwLMHio8PbAdPxB
W1Z0l9KHS3WEEaSt6yvlsFo3wo9O4CO949UXqsVYf1p9AVSHW8v94pFLWCm/DSVW
SDeD8psODoFcbjLh7ya/E7q3dbRGJisdfZvyS/+sHVjw+nldh7tKLFnWZfPZlwaD
evzeYssin56sexHa+e4bhgvGJ+s4puKGrmVdmBh/QUxxrK6gZ2XWDYc5An5Xit2B
dpcSpzE+hZVL9536F4CKCeIkw0UuxXMnxJ5Scz9kDFGDsirAKi+nRyFQHQUUpjye
HuryrhaLvfFffADWine+0P9fA2zC1epLYYbBxK5CYKJu5N4WOZ7HUjVvabITK4Ez
zhoWlhbD/V9BXo4bkLArPhE2KIywvcIUfICtI8VTb2Q9MFmQ+csWW5QIc5Aldalr
PUSgulxKWQetGNUE3pKSdqX8yijGyneFs0DvB9EGGe5iv76iOQuxAvcPTPla7EDW
n4cQlzn58/5G5WA9i4O2izBLfa1m+/tgYI/yoJs8pEfprlDJE1pUW/M4aeiZKpR+
y+8K8GYxCq0mhkg0CX3HiooLWUxUTHM+FMUzb0QxH2hJwJvIAL0UhAdJZVs6ahlR
cv0oLVopKiM=
=B8sS
-----END PGP SIGNATURE-----

--Sig_/lBRaTfKQIKO2h0H9GrOxRpq--
