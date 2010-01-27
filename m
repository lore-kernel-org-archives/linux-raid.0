From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Building RAID5 w/o a Hot Spare
Date: Wed, 27 Jan 2010 14:53:13 +0000
Message-ID: <20100127145313.GA31715@cthulhu.home.robinhill.me.uk>
References: <d80f793f1001270626s3ec1791ma0b5da4b87a31e34@mail.gmail.com>
 <1264603577.1928.4.camel@test.apertos.eu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1264603577.1928.4.camel@test.apertos.eu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Jan 27, 2010 at 03:46:17PM +0100, Micha=C5=82 Sawicz wrote:

> Dnia 2010-01-27, =C5=9Bro o godzinie 09:26 -0500, Carlos Williams pisze:
> > I am building a Linux system which has 4 identical 'fd' partitions on
> > each of the 4 drives. I don't want to use the 4th partition or disk if
> > you would like to call it as a 'hot spare'. I would like to span the
> > entire array over the 4 drives. My question is does my command look
> > correct for doing so?
>=20
> I'm not sure I understand what you want to achieve. A 'spare' disk is
> one that isn't used until any of the other fail, then the spare replaces
> the failed one. The term 'hot spare' is used to identify a disk that is
> a mirror of one of the other drives, but there's no support for that in
> Linux Software-RAID.
>=20
A hot spare is one that's plugged in, powered up, and available for use
(a cold spare is sat on a shelf).  At least, that's the only way I've
ever heard the terminology used.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAktgU1gACgkQShxCyD40xBLgBgCg0/UNTGRridK++gbVcpOqolma
RDkAni8DxARcZ8CwJ0PUQOlJCzu3uU2P
=RPnP
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
