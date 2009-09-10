From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: mdadm and TLER (Time Limited Error Recovery)
Date: Thu, 10 Sep 2009 10:46:51 +0100
Message-ID: <20090910094651.GA9619@cthulhu.home.robinhill.me.uk>
References: <299cc2790909071735x6eefd8bsc05ad76fa782cae1@mail.gmail.com>
 <slrnhacpsm.2i5.Mario.Holbe@darkside.dyn.samba-tng.org>
 <20090908184837.GA28217@teal.hq.k1024.org>
 <4AA70604.7020709@harddata.com>
 <ABFC24E4C13D81489F7F624E14891C860D4C3553@uk-ex-mbx1.terastack.bluearc.com>
 <slrnhaf2ub.2i5.Mario.Holbe@darkside.dyn.samba-tng.org>
 <ABFC24E4C13D81489F7F624E14891C860D4C3894@uk-ex-mbx1.terastack.bluearc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ABFC24E4C13D81489F7F624E14891C860D4C3894@uk-ex-mbx1.terastack.bluearc.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Sep 10, 2009 at 10:26:35AM +0100, Simon Jackson wrote:

> Hmmm.  I do not have sdparm on my system.=20
>=20
> Linux 2.6.26-1-amd64 #1 SMP Sat Jan 10 17:57:00 UTC 2009 x86_64 GNU/Linux
>=20
> Is this the same functionality as the hdparm utility?=20
>=20
Yes - it was written for SCSI drives rather than IDE drives.  With the
different markets these were targeted for, SCSI drives have
(historically) provided a lot more low-level parameters for tweaking.
Newer ATA drives have been incorporating a lot of the same functionality
though, so it'll work (to some extent) with them as well.

The homepage is at http://sg.danny.cz/sg/sdparm.html

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkqoywoACgkQShxCyD40xBKxyACfVFRRjP3/RSfqzVJWmk65FfbT
rbEAoImcz5C/zSUB+JdiPQdoZOvczpT8
=iNe0
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
