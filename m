From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: failing a drive while RAID5 is initializing
Date: Wed, 23 Feb 2011 16:33:54 +0000
Message-ID: <20110223163354.GA25777@cthulhu.home.robinhill.me.uk>
References: <4D6533D2.3020600@cdf.toronto.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D6533D2.3020600@cdf.toronto.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Iordan Iordanov <iordan@cdf.toronto.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Feb 23, 2011 at 11:20:34AM -0500, Iordan Iordanov wrote:

> Hi guys,
>=20
> I just wanted to make sure that the behaviour I observed is as expected.=
=20
> With kernel 2.6.35.11, under Debian Lenny, I created a RAID5 array with=
=20
> 5 drives, partitioned it, formatted a partition with ext3 and mounted=20
> it. Then, I put some load onto the filesystem with:
>=20
> dd if=3D/dev/urandom of=3D/mnt/testfile
>=20
> The array started initializing. At that point, I needed to fail and=20
> replace a drive for some unrelated testing, so I did that with:
>=20
> mdadm /dev/md0 -f /dev/sdc
>=20
> The result was a broken filesystem which was remounted read-only, and a=
=20
> bunch of errors in dmesg. Theoretically, one would imagine that failing=
=20
> a drive on a RAID5 even during initialization should render the array=20
> without redundancy but workable. Am I wrong? Is there something special=
=20
> about the initialization stage of RAID5 that makes drive failure fatal=20
> during the initialization? If not, then I have a bug to report and I'll=
=20
> try to reproduce it for you.
>=20
The array is created in a degraded state, then recovered onto the final
disk.  Pulling any disk bar the final one will results in a broken array
and lost data, until this recovery is completed.

> If initialisation is special, does that mean that when creating RAID5,=20
> it is advisable to *wait* until the array has fully initialized before=20
> using it, otherwise one risks losing any data that was put onto the=20
> array during the initialization phase if a drive fails at that point?
>=20
That depends.  It's advisable not to use it for critical, non-backed up
data (the same as it is during a recovery following a drive failure).
The alternative is to wait until the array is fully initialised before
making it available to the user (which could take a considerable amount
of time) or manually zeroing all the drives and then creating the array
using --assume-clean (in which case the zeroing means the parity data is
correct by default).

Some of the features on Neil's current roadmap should allow for "lazy
initialisation" where the recovery data is added only as the drive is
written to, which should mean the array is available immediately but
still retains full recoverability.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk1lNvEACgkQShxCyD40xBKAnQCfcQUHu/l8d7+RR1DtJ7nfWyqC
nLkAoL3sLx+JiZUUU311aHHIG7OXj9K1
=fjN3
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
