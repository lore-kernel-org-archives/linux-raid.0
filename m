From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Fri, 19 Oct 2007 12:15:34 -0400
Message-ID: <1192810534.1666.68.camel@firewall.xsintricity.com>
References: <18200.49267.763509.924873@stoffel.org>
	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	 <18200.53593.687483.120827@stoffel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-780V31ybN5axYdVIm3N3"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18200.53593.687483.120827@stoffel.org>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-780V31ybN5axYdVIm3N3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-19 at 11:46 -0400, John Stoffel wrote:
> >>>>> "Justin" =3D=3D Justin Piszcz <jpiszcz@lucidpixels.com> writes:
>=20
> Justin> On Fri, 19 Oct 2007, John Stoffel wrote:
>=20
> >>=20
> >> So,
> >>=20
> >> Is it time to start thinking about deprecating the old 0.9, 1.0 and
> >> 1.1 formats to just standardize on the 1.2 format?  What are the
> >> issues surrounding this?

1.0, 1.1, and 1.2 are the same format, just in different positions on
the disk.  Of the three, the 1.1 format is the safest to use since it
won't allow you to accidentally have some sort of metadata between the
beginning of the disk and the raid superblock (such as an lvm2
superblock), and hence whenever the raid array isn't up, you won't be
able to accidentally mount the lvm2 volumes, filesystem, etc.  (In worse
case situations, I've seen lvm2 find a superblock on one RAID1 array
member when the RAID1 array was down, the system came up, you used the
system, the two copies of the raid array were made drastically
inconsistent, then at the next reboot, the situation that prevented the
RAID1 from starting was resolved, and it never know it failed to start
last time, and the two inconsistent members we put back into a clean
array).  So, deprecating any of these is not really helpful.  And you
need to keep the old 0.90 format around for back compatibility with
thousands of existing raid arrays.

> >> It's certainly easy enough to change mdadm to default to the 1.2
> >> format and to require a --force switch to  allow use of the older
> >> formats.
> >>=20
> >> I keep seeing that we support these old formats, and it's never been
> >> clear to me why we have four different ones available?  Why can't we
> >> start defining the canonical format for Linux RAID metadata?
> >>=20
> >> Thanks,
> >> John
> >> john@stoffel.org
> >> -
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>=20
>=20
> Justin> I hope 00.90.03 is not deprecated, LILO cannot boot off of
> Justin> anything else!
>=20
> Are you sure?  I find that GRUB is much easier to use and setup than
> LILO these days.  But hey, just dropping down to support 00.09.03 and
> 1.2 formats would be fine too.  Let's just lessen the confusion if at
> all possible.
>=20
> John
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-780V31ybN5axYdVIm3N3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHGNgmTzP9PM7pjw8RAm9LAJ4z8GPDk9H9CO1XIGBK94tT87MPUQCcCEmG
CTqmRC3lKF/2/VdwQXS5RpE=
=Gg3r
-----END PGP SIGNATURE-----

--=-780V31ybN5axYdVIm3N3--

