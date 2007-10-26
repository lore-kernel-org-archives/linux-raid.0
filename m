From: Doug Ledford <dledford@redhat.com>
Subject: Re: Implementing low level timeouts within MD
Date: Fri, 26 Oct 2007 15:00:54 -0400
Message-ID: <1193425254.10336.290.camel@firewall.xsintricity.com>
References: <1193418753.4771.17.camel@w100>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yLxKUQgfvIP3H0ZnPu81"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193418753.4771.17.camel@w100>
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Alonso <alberto@ggsys.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-yLxKUQgfvIP3H0ZnPu81
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-26 at 12:12 -0500, Alberto Alonso wrote:
> I've been asking on my other posts but haven't seen
> a direct reply to this question:
>=20
> Can MD implement timeouts so that it detects problems when
> drivers don't come back?
>=20
> For me this year shall be known as "the year the array
> stood still" (bad scifi reference :-)
>=20
> After 4 different array failures all due to a single drive
> failure I think it would really be helpful if the md code
> timed out the driver.

This isn't an md problem, this is a low level disk driver problem.  Yell
at the author of the disk driver in question.  If that driver doesn't
time things out and return errors up the stack in a reasonable time,
then it's broken.  Md should not, and realistically can not, take the
place of a properly written low level driver.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-yLxKUQgfvIP3H0ZnPu81
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHIjlmTzP9PM7pjw8RAqDKAJ0WAwn4IXiQetMwfrpU6Cq8mZCwSgCeI+EG
7WL3OhCgj7UOYg55C4NoGBI=
=mkcN
-----END PGP SIGNATURE-----

--=-yLxKUQgfvIP3H0ZnPu81--

