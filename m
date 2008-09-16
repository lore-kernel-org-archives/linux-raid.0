From: Andre Noll <maan@systemlinux.org>
Subject: Re: Raid6 array crashed-- 4-disk failure...(?)
Date: Tue, 16 Sep 2008 15:12:28 +0200
Message-ID: <20080916131228.GB17966@skl-net.de>
References: <48CE250C.8000603@ultratux.net> <18638.13844.94632.293014@notabene.brown> <48CE8E28.8030705@ultratux.net> <48CECC53.6010004@ultratux.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <48CECC53.6010004@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: Maarten <maarten@ultratux.net>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--wq9mPyueHGvFACwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 22:57, Maarten wrote:

> apoc ~ # mdadm --assemble --force /dev/md5  /dev/sd[fhijkl]1
> mdadm: forcing event count in /dev/sdl1(0) from 1057343 upto 1057345
> mdadm: forcing event count in /dev/sdj1(1) from 1057343 upto 1057345
> mdadm: forcing event count in /dev/sdf1(3) from 1057343 upto 1057345
> mdadm: forcing event count in /dev/sdi1(5) from 1057343 upto 1057345
> mdadm: /dev/md5 has been started with 6 drives (out of 7).

So four of the six disks were not uptodate. As Neil said, the
difference might just be the sb updates, so I'd guess the array
is fine.

> But: The array did not resync. I think this may be correct but my=20
> understanding of raid-6 is still a bit flaky. It is degraded, but not=20
> fully degraded, that would mean two drives missing as it is raid-6. So=20
> there is indeed parity information now.

Yes, there is parity information. Raid6 uses two parities, freqently
called P and Q, where P is the ordinary xor parity that is also used
in raid5. So each 6-tuple of corresponding disk blocks has exactly
one of the following possible contents:

	D, D, D, D, D, P (Q is missing)
	D, D, D, D, D, Q (P is missing)
	D, D, D, D, P, Q (one of the D's is missing)

Only in the last case, one of the five data blocks is missing. In
this case the raid code uses the P parity to compute the contents of
the missing data block, which is cheap.

IOW, you're as safe as with raid5 ATM. However, there are other reasons
for not running a degraded raid6 array for longer than absolutely
necessary. One of them being that writes to a degraded raid6 array
are significantly slower.

Before adding the seventh disk you might want to check the parities
using mdadm --update=3Dresync. From the mdadm man page:

	The resync option will cause the array to be marked dirty
	meaning that any redundancy in the array (e.g. parity for
	raid5, copies for raid1) may be incorrect.  This will cause
	the raid system to perform a "resync" pass to make sure that
	all redundant information is correct.

I wonder why raid6 isn't mentioned there. Neil, are there any reasons
for this?

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIz7C8Wto1QDEAkw8RAntIAJ9DHut5AQ+UvPCIRnfJdgjiicJh0QCgoRww
/w05jZBZSOcG2OGkp9wT3cU=
=mpnH
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--
