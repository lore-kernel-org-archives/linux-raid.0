From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 018 of 29] md: Support changing rdev size on running
 arrays.
Date: Mon, 26 Mar 2012 09:15:18 +1100
Message-ID: <20120326091518.6d56d1c6@notabene.brown>
References: <20080627164503.9671.patches@notabene>
	<200806271809.29768.Markus@hochholdinger.net>
	<18533.31375.280387.666514@notabene.brown>
	<201203242147.23273.Markus@hochholdinger.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/q1_kx7vWoAaOh5Yxi7TgO+m"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203242147.23273.Markus@hochholdinger.net>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Hochholdinger <Markus@hochholdinger.net>
Cc: linux-raid@vger.kernel.org, Chris Webb <chris@arachsys.com>
List-Id: linux-raid.ids

--Sig_/q1_kx7vWoAaOh5Yxi7TgO+m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 24 Mar 2012 21:47:15 +0100 Markus Hochholdinger
<Markus@hochholdinger.net> wrote:

> Hello,
>=20
> it's been a long time, but today I tried again and had success!
>=20
> Am 28.06.2008 um 01:41 Uhr schrieb Neil Brown <neilb@suse.de>:
> > On Friday June 27, Markus@hochholdinger.net wrote:
> > > Am Freitag, 27. Juni 2008 08:51 schrieb NeilBrown:
> > > > From: Chris Webb <chris@arachsys.com>
> [..]
> > You don't want to "mdadm --grow" until everything has been resized.
> > First lvresize one disk, then write '0' to the .../size file.
> > Then do the same for the other disk.
> > Then "mdadm --grow /dev/mdX --size max".
>=20
> it works for me, if I do:
>   echo 0 > /sys/block/md2/md/rd0/size
>   mdadm --grow /dev/md2 --size=3Dmax
>   # till here, nothing happens
>   echo 0 > /sys/block/md2/md/rd1/size
>   mdadm --grow /dev/md2 --size=3Dmax
>   # rebuild of the added space begins
>=20
> If I do only:
>   echo 0 > /sys/block/md2/md/rd0/size
>   echo 0 > /sys/block/md2/md/rd1/size
>   mdadm --grow /dev/md2 --size=3Dmax
> nothing will change.

That is odd.. it certainly should.

And the current 'mdadm' will do the "echo 0 > size" for you so you just need
to "mdadm --grow  --size=3Dmax" command.

>=20
> As I understand, with "echo 0" md sees the new size and only with --grow =
the=20
> superblock will be moved.

No, the superblock is moved with the "echo 0", but the space isn't used unt=
il
the "--grow".


>=20
> I'm doing this with 2.6.32-5-xen-686 within Debian (squeeze) 6.0.
>=20
> Many thanks to you and all the other linux-raid developers for this featu=
re!
>=20
> I'm very happy about this :-)

Excellent!

Thanks,
NeilBrown


>=20
>=20


--Sig_/q1_kx7vWoAaOh5Yxi7TgO+m
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT2+Y9jnsnt1WYoG5AQJMnQ//XDmlSK6cBH1bp3vrpjItv2djC2S5f+fp
tqcll2mxUUrNwaEtkktj4uPvWQSVrXCvjp4+qrhahW+AUxER6riRxR3arzLY3CuJ
Y+VSWSab6y8m7TcoUW5mZfEIBY67kZ/2buo+BuvRknzyqyhpX6RYNCF9b5IpnDNl
UBXdD/vXQFcTOXlHA4caeAnreJWNJjKB8J3CNX5KU+smh75U8zmnVbwrAbHoZ6aE
tdvk4MD9cZntA+ywXlyVUUJ3uWFuI6eu6kuNiaJHVAr5s+qXMA5h9OA/+IX6NaYv
Pp3b/RJN+8GagM/B9Xva1vM+iqoj17W4YYQv49lIjUAIfjSGe5j2iYmzn4JM8in5
FQng/7kt+RUQxC3GG5Cagss1/Wfe6Fhuuz/1vIKCkQrMvPloa2/hFpeXDWHJejaZ
YA3I55FFKGArcCGJcd/Vlkv/XL9CKVY2ab9sNs79Bd/q82oklPtvav1GlW8g+w5c
ky14WAvDEcj9tkIiP/fxqhx4adVj5qHUwa4mUJ/tDMQPsA3a5GCo8U2f36n61Gin
+c5IcA4hP78qkZyePeFZyfYUqCMmZjV9rKc4PXnuIbO7wSUf47pgbf3wilOi9egO
pYqgRRplCGA+eWOCZCG5xPiI4HYLo4YN4YbB2g5y6F7i7y7AExwtYNE414nt4Rx7
Dlu2XV1HKoQ=
=9fxM
-----END PGP SIGNATURE-----

--Sig_/q1_kx7vWoAaOh5Yxi7TgO+m--
