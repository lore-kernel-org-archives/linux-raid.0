From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: when read error ,where do we rewrite?
Date: Fri, 8 Jan 2010 10:03:36 +0000
Message-ID: <20100108100336.GA21358@cthulhu.home.robinhill.me.uk>
References: <6c394cc31001070441r1287f635q9c58dc836ce488b7@mail.gmail.com>
 <20100107131855.GA10915@cthulhu.home.robinhill.me.uk>
 <6c394cc31001072054v7368cc05kb7005b39d00c1c07@mail.gmail.com>
 <6c394cc31001072059t2669afa8l5fed42ff77b3c134@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6c394cc31001072059t2669afa8l5fed42ff77b3c134@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Jan 08, 2010 at 12:59:26PM +0800, dong wu wrote:

> In the source code of raid5,when write error,it faulty the disk,not remap
> the block. why do it use "remap the block"?
>=20
There's two separate error cases - read error and write error.

If the RAID layer gets a read error from the disk, it uses the parity to
recalculate the data and then writes it back to the disk.  If the disk
(internally) gets an error when writing this block, it should silently
mark it as faulty and map a spare block in to replace it, writing to
that instead,

If the RAID layer gets a write error from the disk, this indicates that
it's failed to do this remapping, so it marks the disk as faulty.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAktHAvcACgkQShxCyD40xBLTxgCcCLvxtrlMh6ICd+STda+JIESu
/lkAn2/LcY2JNOf8PMJ8DTMF1sTedQ+F
=rRhW
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
