From: NeilBrown <neilb@suse.de>
Subject: Re: RFC: use TRIM data from filesystems to speed up array rebuild?
Date: Wed, 5 Sep 2012 06:24:05 +1000
Message-ID: <20120905062405.3741239a@notabene.brown>
References: <50464322.3010509@genband.com>
	<5046525E.10500@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/k.4P3hsjynA0knc9xJliFp5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5046525E.10500@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: Chris Friesen <chris.friesen@genband.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/k.4P3hsjynA0knc9xJliFp5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 04 Sep 2012 15:11:26 -0400 Ric Wheeler <ricwheeler@gmail.com> wrote:

> On 09/04/2012 02:06 PM, Chris Friesen wrote:
> >
> > Hi,
> >
> > I'm not really a filesystem guy so this may be a really dumb question.
> >
> > We currently have an issue where we have a ~1TB RAID1 array that is mos=
tly=20
> > given over to LVM.  If we swap one of the disks it will rebuild everyth=
ing,=20
> > even though we may only be using a small fraction of the space.
> >
> > This got me thinking.  Has anyone given thought to using the TRIM infor=
mation=20
> > from filesystems to allow the RAID code to maintain a bitmask of used d=
isk=20
> > blocks and only sync the ones that are actually used?
> >
> > Presumably this bitmask would itself need to be stored on the disk.
> >
> > Thanks,
> > Chris
> >
>=20
> Device mapper has a "thin" target now that tracks blocks that are allocat=
ed or=20
> free (and works with discard).
>=20
> That might be a basis for doing an focused RAID rebuild,

I wonder how....=20
Maybe the block-later interface could grow something equivalent to
"SEEK_HOLE" and friends so that the upper level can find "holes" and
"allocated space" in the underlying device.
I wonder if it is time to discard the 'block device' abstraction and just u=
se
files every .... but I seriously doubt it.

NeilBrown

--Sig_/k.4P3hsjynA0knc9xJliFp5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUEZjZTnsnt1WYoG5AQIwLQ/6A7gJGBrUIg7gN9487ctvPvfUIbq1X1EP
B/LuqWvXI5CrC1fj7n/K/XQ/Pt+RS6a6bue73XgARvg4Xa8YjqF1UqCmJrYSPYYu
IC4tTtlX/gBQzuxudtvwJL7WFXE6tQmrolzuIqkN5D14XUhXR+5hdyffrqLACG5B
kfHCNaHiGatEiVlpN/l5+hZ2azBDJmqYDd6oDeTQ/JA1fBf0EWSbrvaact21RlgJ
bK73PXl6PeObN4ZX81VRtqYB9SmI+4dUEOikVywgMkMv0dJPqRrCJXxQLVmKm8jI
5PwTiwWetMkId8R74J2R/17ZlxGGp7PYikje0chyiEA/PzJmLtKQ8JbvgXSVGxqx
QGTCi1Ws8ygPwbjr+pmj5tF3KObly7XedY1ATX5UjO0RMkENzP+6EPa8L96V6sz/
Sp5hZXoW8ny2O9R6nkV8ltYTesrg+26jHUOEFvnIxh4kAEHZZ20yUTJDz9vy6Ssd
TCrINYHWjRpJGDcvftgjAbfz+i5xEb5lPWLgha9jA3uHlqFlV/FBcIRHTVR/LUzo
LWnUN71eRS5taLGhDRu+S1YquWxt4tH0UAQ9JWER8eODXZsIYVQt0jDXdzsVE8al
pT0LaiEe2+lKKkspZWIBKzYwSUr41HWNbryoPOIB9v2jBf5n+clDdcHyAP/ItMmw
o1/tiyzeFM4=
=HCqK
-----END PGP SIGNATURE-----

--Sig_/k.4P3hsjynA0knc9xJliFp5--
