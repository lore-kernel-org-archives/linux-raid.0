From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Tue, 10 Nov 2009 16:15:27 +0000
Message-ID: <20091110161527.GB2380@cthulhu.home.robinhill.me.uk>
References: <4AF7066C.1040507@tmr.com>
 <70ed7c3e0911081713m7184356buadd6b102fe4755e8@mail.gmail.com>
 <f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
 <70ed7c3e0911090842i167175a0q44fc5ad50a2f1759@mail.gmail.com>
 <f3177b9e0911090859j40a87433r342d2c49b46d015c@mail.gmail.com>
 <1257846132.22155.155.camel@localhost>
 <f3177b9e0911100739p56a98992p26f9a42e8b689dcf@mail.gmail.com>
 <70ed7c3e0911100743y55a1eef5p5705cd9cd1f1aa51@mail.gmail.com>
 <f3177b9e0911100758n2a663d16hc15a6c90e88346b7@mail.gmail.com>
 <70ed7c3e0911100801j2880965p7a5d6e03c74248dd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <70ed7c3e0911100801j2880965p7a5d6e03c74248dd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Nov 10, 2009 at 07:01:02PM +0300, Majed B. wrote:

> Which disks can provide 2ms response with a read of 250 MB/s and write
> of 170 MB/s other than SSDs?!
>=20
> Are you saying that it doesn't matter whether we use Linux or Windows
> with SSDs because the limitation is coming from the disk's controller
> itself?
>=20
Not exactly - without TRIM support, the drive performance will degrade
over time.  Windows 7 has TRIM implemented for deletes (and formats),
which prevents this degradation.  Initial performance will be the same
on both systems though (as performance is limited by the interface -
SATA 6G is starting to appear though, which will definitely help).

Currently, AFAIK, none of the Linux filesystems support TRIM.  This is
largely due to discussions about the implementation - a TRIM call
requires a full flush of all pending writes (as it's a non-queueable
call) which results in severe performance issues if done synchronously
on deletes.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkr5kZ8ACgkQShxCyD40xBKpLQCfedXghLI/TvAJnNOcl5mtwfIg
FpUAoKSKOMnm6eIYyeId20sRKDZ/zROk
=nlik
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
