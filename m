From: NeilBrown <neilb@suse.de>
Subject: Re: unable to recover RAID 5 due to bad block
Date: Fri, 11 Nov 2011 07:11:42 +1100
Message-ID: <20111111071142.383f10f0@notabene.brown>
References: <4EBBF60F.4030606@northfolk.ca>
	<20111110172003.Horde.byVZeZk8pphOu-mzTQXxKL8@cakebox.homeunix.net>
	<4EBC00E6.3030404@northfolk.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/oHoZn67ThgNJS3uz0kTFd0I"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EBC00E6.3030404@northfolk.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Purves <chris@northfolk.ca>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Alexander =?ISO-8859-1?B?S/xobg==?= <alexander.kuehn@nagilum.de>, jeromepoulin@gmail.com
List-Id: linux-raid.ids

--Sig_/oHoZn67ThgNJS3uz0kTFd0I
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Nov 2011 12:50:46 -0400 Chris Purves <chris@northfolk.ca> wrote:

> On 2011-11-10 12:20, Alexander K=FChn wrote:
> > ddrescue to the rescue!
> > Get a another new disk, then ddrescue the one with the read error to th=
e new disk.
> > Assemble the array using the new disk instead of the one with the read =
error.
> > You will loose the blocks that can't be read of course.
> > And in the future do run raid check/scrubbing at regular intervals. ;)
>=20
> I have tried this already.  After cloning the disk with errors, I replace=
d it with the clone and tried to re-start the array using
>=20
> mdadm --assemble --force /dev/md1
>=20
> mdadm assigned the new disk as a spare and said there were only three dis=
ks to start the array and so couldn't start it.
>=20
> After I clone the disk with the error, how precisely should I re-start th=
e array?
>=20
>=20

This should have worked.  So presumably some unstated requirement wasn't me=
t.

Give details.  Names of devices, sizes of devices, "mdadm --examine" of
device.  Are you using partitions or whole disk ....

The best assemble command would be:
  mdadm --assemble /dev/md1 -vv ...list...of.devices..you...want.it.to.incl=
ude.=20


NeilBrown

--Sig_/oHoZn67ThgNJS3uz0kTFd0I
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrwv/jnsnt1WYoG5AQIB5Q/+MVT34tuE7s7QpVJu6TL/GFmY9QZCfQpb
uwETJqsj+uf4wPs4jJVoGHb88u5U9DgQouiQX5DEjllx0FPbUaH9qfGIJHr2k5IJ
Sn2DzQ+qROaZZpJW8sHE1kFmoqa2tcTsciGg+SX/uRXeHOkihCULcVxSuXtYCNAx
VQmcYJsPeT+Z7LKO53quDkonJTccouqzheFvZBsaQMxP260cWfetTvPav/PVy1Do
9wxIIrrDqHgq2AQwKbCj1k48gI66EpE0uMJgjHGest/gDccNPo6Bm17s5EhMGnXn
j1rxUNxXY7XOu0UN2eHw2OEoTKM2YODxcVaa+tsVgS0+8i/MqFZ1tSstMMEiQMqp
5rL6yDhC8PkwjWiPmJi0KSA9+5VuBkJUS2JAX7oYwlUMRGtEGd4ghLdxkJdsHQZX
7Jvsz+fdVFD0YiKpcZn5pXLvaXmps0ZcL8w0OOgs1e8lleKw7rXoZDQ7IAN0Y+Jb
svVfu0Fp8EgMyhO+f9hU7k8IZFV+xjuGcw4eh/0shQV9DcjQCtYD/KqAjo17+Kub
mmoWgUiLva5g6YnY0l7f9Qa1FJG+DD1wYqSAbVLRJjea/EOSu6ybJLgaG+aoMoqf
j5+2Kzz7LBb7fymENr4mWQrEdF51Bf1tCC3atiiHLusQUkWvLG8ap1d6zCkdbRcs
7YPVBsGEqfg=
=6H6e
-----END PGP SIGNATURE-----

--Sig_/oHoZn67ThgNJS3uz0kTFd0I--
