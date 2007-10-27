From: Doug Ledford <dledford@redhat.com>
Subject: Re: Implementing low level timeouts within MD
Date: Sat, 27 Oct 2007 19:55:29 -0400
Message-ID: <1193529329.10336.366.camel@firewall.xsintricity.com>
References: <1193418753.4771.17.camel@w100>
	 <1193425254.10336.290.camel@firewall.xsintricity.com>
	 <1193521561.7690.14.camel@w100>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fPW1y+OXJrKIOGC/O9vL"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193521561.7690.14.camel@w100>
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Alonso <alberto@ggsys.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-fPW1y+OXJrKIOGC/O9vL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-10-27 at 16:46 -0500, Alberto Alonso wrote:
> On Fri, 2007-10-26 at 15:00 -0400, Doug Ledford wrote:
> >=20
> > This isn't an md problem, this is a low level disk driver problem.  Yel=
l
> > at the author of the disk driver in question.  If that driver doesn't
> > time things out and return errors up the stack in a reasonable time,
> > then it's broken.  Md should not, and realistically can not, take the
> > place of a properly written low level driver.
> >=20
>=20
> I am not arguing whether or not MD is at fault, I know it isn't.=20
>=20
> Regardless of the fact that it is not MD's fault, it does make
> software raid an invalid choice when combined with those drivers. A
> single disk failure within a RAID5 array bringing a file server down
> is not a valid option under most situations.

Without knowing the exact controller you have and driver you use, I
certainly can't tell the situation.  However, I will note that there are
times when no matter how well the driver is written, the wrong type of
drive failure *will* take down the entire machine.  For example, on an
SPI SCSI bus, a single drive failure that involves a blown terminator
will cause the electrical signaling on the bus to go dead no matter what
the driver does to try and work around it.

> I wasn't even asking as to whether or not it should, I was asking if
> it could.

It could, but without careful control of timeouts for differing types of
devices, you could end up making the software raid less reliable instead
of more reliable overall.

>  Should is a relative term, could is not. If the MD code
> can not cope with poorly written drivers then a list of valid drivers
> and cards would be nice to have (that's why I posted my ... when it
> works and when it doesn't, I was trying to come up with such a list).

Generally speaking, most modern drivers will work well.  It's easier to
maintain a list of known bad drivers than known good drivers.

> I only got 1 answer with brand specific information to figure out when
> it works and when it doesn't work. My recent experience is that too
> many drivers seem to have the problem so software raid is no longer
> an option for any new systems that I build, and as time and money
> permits I'll be switching to hardware/firmware raid all my legacy
> servers.

Be careful which hardware raid you choose, as in the past several brands
have been known to have the exact same problem you are having with
software raid, so you may not end up buying yourself anything.  (I'm not
naming names because it's been long enough since I paid attention to
hardware raid driver issues that the issues I knew of could have been
solved by now and I don't want to improperly accuse a currently well
working driver of being broken)

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-fPW1y+OXJrKIOGC/O9vL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHI8/xTzP9PM7pjw8RAvl8AJwJEnhy9s75Yx9B5lWPA4TjKylJuACfS97g
Kf2POs0bB7NWYNxDRWV/mKE=
=TTgi
-----END PGP SIGNATURE-----

--=-fPW1y+OXJrKIOGC/O9vL--

