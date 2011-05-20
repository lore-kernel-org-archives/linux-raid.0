From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: HBA Adaptor advice
Date: Fri, 20 May 2011 18:34:13 +0600
Message-ID: <20110520183413.64fe3ccc@natsu>
References: <4DD50C89.8060006@wildgooses.com>
	<20110520020853.GC4759@bitfolk.com>
	<4DD61948.8050302@wildgooses.com>
	<4DD65C18.5090804@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kqizuy6QLji7ji1Q9K/QBAK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD65C18.5090804@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: Ed W <lists@wildgooses.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kqizuy6QLji7ji1Q9K/QBAK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 20 May 2011 08:18:32 -0400
Joe Landman <joe.landman@gmail.com> wrote:

> Second off, you can turn any of the expensive RAID cards into an 'JBOD'=20
> by doing something like this:
>=20
> 1) have the unit configured in RAID mode
>=20
> 2) build virtual disks out of single drives, as RAID0.
>=20
> 3) iterate 2 until you exhaust your drives.
>=20
> 4) make sure you prevent these drives from messing with your boot drive=20
> order ... some bioses "helpfully" reorganize new drives for you by=20
> messing with this list.
>=20
> Once the drive is a 1 disk RAID0, you get the cache, and the BBU for the=
=20
> cache.  Yeah, its a little weird.  But it does work (we've done this=20
> with some LSI8888's).

But can you then access SMART of the individual drives?
Or will you see only some bogus block devices which do not accept SMART
commands, do not return real drive identity, and present themselves as RAID0
#1, RAID0 #2 etc. instead?

--=20
With respect,
Roman

--Sig_/kqizuy6QLji7ji1Q9K/QBAK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3WX8UACgkQTLKSvz+PZwghQgCfVEt341GRIBm/T5kQjkXnoFjK
uj8An1kqnsQvjttVUoBh6j+jjA1fSse4
=aabW
-----END PGP SIGNATURE-----

--Sig_/kqizuy6QLji7ji1Q9K/QBAK--
