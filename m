From: Forrest Taylor <ftaylor@redhat.com>
Subject: Re: LVM tutorial for RAID-5 Array Setup?
Date: Wed, 12 Apr 2006 12:09:49 -0600
Message-ID: <1144865389.3600.2.camel@x1-6-00-0d-60-fd-e8-4c>
References: <6d5bedd80604121037k699223a8p28b6db566994216@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-r9tZh68Pxto89nT7woxV"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6d5bedd80604121037k699223a8p28b6db566994216@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ewan Grantham <ewan.grantham@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-r9tZh68Pxto89nT7woxV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2006-04-12 at 12:37 -0500, Ewan Grantham wrote:
> Am getting ready to setup a new machine with Kubuntu (Dapper Drake
> Flight 6 to be specific), and am thinking that I might want to use LVM
> this time to setup my RAID array of disks (Six external USB-2 300 Gig
> HDs to be specific).
>=20
> Is LVM going to make my life easier or more difficult? Any good
> tutorial y'all can recommend?

Doesn't the installer allow LVM on top of RAID?  If so, that is the
simplest approach.  There are even GUI apps that let you create/resize
logical volumes and their filesystems, so it is quite simple.

I have found LVM to be very useful--shrinking or expanding partitions
can come in handy when you are running low on disk space.

Forrest

--=-r9tZh68Pxto89nT7woxV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBEPUJtaUnzBifbsNQRAiETAJ9O1MAjPXNIYLLC+urFgDX246btKwCaAuHc
tSIFCjZQxUgJ3ciF+opmIyA=
=mISQ
-----END PGP SIGNATURE-----

--=-r9tZh68Pxto89nT7woxV--

