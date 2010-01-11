From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: raid failure question
Date: Mon, 11 Jan 2010 20:53:32 +0000
Message-ID: <20100111205332.GA24486@cthulhu.home.robinhill.me.uk>
References: <1263232840.8962.193.camel@kije>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1263232840.8962.193.camel@kije>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Jan 11, 2010 at 11:00:40AM -0700, Tim Bock wrote:

> Hello,
>=20
> Excluding the obvious multi-disk or bus failures, can anyone describe
> what type of disk failure a raid cannot detect/recover from?
>=20
> I have had two disk failures over the last three months, and in spite of
> having a hot spare, manual intervention was required each time to make
> the raid usable again.  I'm just not sure if I'm not setting something
> up right, or if there is some other issue.
>=20
> Thanks for any comments or suggestions.
>=20
Any failure where the disk doesn't actually return an error (within a
reasonable time).  For example, consumer grade disks often have very
long retry times - this can mean the array in unusable for a long time
until the disk eventually fails the read.

If the disk actually returns an error then, AFAIK, the RAID array should
always be able to recover from it.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAktLj8wACgkQShxCyD40xBI2nACgow3izNiczvDlwHi8ZTcU8Z8z
PngAniUgcTDqq84pIMkJNGSQTdNY5Akh
=Oe7R
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
