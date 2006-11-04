From: martin f krafft <madduck@madduck.net>
Subject: Re: RAID5/10 chunk size and ext2/3 stride parameter
Date: Sat, 4 Nov 2006 13:00:49 +0100
Message-ID: <20061104120049.GA16979@piper.madduck.net>
References: <20061024160306.GA15393@lapse.madduck.net> <Pine.LNX.4.64.0611031103520.26057@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0611031103520.26057@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach dean gaudet <dean@arctic.org> [2006.11.03.2019 +0100]:
> > I cannot find authoritative information about the relation between
> > the RAID chunk size and the correct stride parameter to use when
> > creating an ext2/3 filesystem.
>=20
> you know, it's interesting -- mkfs.xfs somehow gets the right sunit/swidt=
h=20
> automatically from the underlying md device.

i don't know enough about xfs to be able to agree or disagree with
you on that.

> # mdadm --create --level=3D5 --raid-devices=3D4 --assume-clean --auto=3Dy=
es /dev/md0 /dev/sd[abcd]1
> mdadm: array /dev/md0 started.

with 64k chunks i assume...

> # mkfs.xfs /dev/md0
> meta-data=3D/dev/md0               isize=3D256    agcount=3D32, agsize=3D=
9157232=20
> blks
>          =3D                       sectsz=3D4096  attr=3D0
> data     =3D                       bsize=3D4096   blocks=3D293031424, ima=
xpct=3D25
>          =3D                       sunit=3D16     swidth=3D48 blks, unwri=
tten=3D1

sunit seems like the stride width i determined (64k chunks / 4k
bzise), but what is swidth? Is it 64 * 3/4 because of the four
device RAID5?

> # mdadm --create --level=3D10 --layout=3Df2 --raid-devices=3D4 --assume-c=
lean --auto=3Dyes /dev/md0 /dev/sd[abcd]1
> mdadm: array /dev/md0 started.
> # mkfs.xfs -f /dev/md0
> meta-data=3D/dev/md0               isize=3D256    agcount=3D32, agsize=3D=
6104816 blks
>          =3D                       sectsz=3D512   attr=3D0
> data     =3D                       bsize=3D4096   blocks=3D195354112, ima=
xpct=3D25
>          =3D                       sunit=3D16     swidth=3D64 blks, unwri=
tten=3D1

okay, so as before, 16 stride size and 64 stripe width, because
we're now dealing with mirrors.

> # mdadm --create --level=3D10 --layout=3Dn2 --raid-devices=3D4 --assume-c=
lean --auto=3Dyes /dev/md0 /dev/sd[abcd]1
> mdadm: array /dev/md0 started.
> # mkfs.xfs -f /dev/md0
> meta-data=3D/dev/md0               isize=3D256    agcount=3D32, agsize=3D=
6104816 blks
>          =3D                       sectsz=3D512   attr=3D0
> data     =3D                       bsize=3D4096   blocks=3D195354112, ima=
xpct=3D25
>          =3D                       sunit=3D16     swidth=3D64 blks, unwri=
tten=3D1

why not? in this case, -n2 and -f2 aren't any different, are they?

> in a "near 2" layout i would expect sunit=3D16, swidth=3D32 ...  but swid=
th=3D64
> probably doesn't hurt.

why?

> that's how i think it works -- i don't think ext[23] have a concept of "s=
tripe
> width" like xfs does.  they just want to know how to avoid putting all the
> critical data on one disk (which needs only the chunk size).  but you sho=
uld
> probably ask on the linux-ext4 mailing list.

once i understand everything...

--=20
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
=20
spamtraps: madduck.bogus@madduck.net
=20
if you find a spelling mistake in the above, you get to keep it.

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature (GPG/PGP)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFTIDxIgvIgzMMSnURAnq+AKCH1RvXFZ3GRnbHJXJ0CM60ExiDSgCfc7yF
mW77NBGx9pup0triYZPhxvg=
=6GT3
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
