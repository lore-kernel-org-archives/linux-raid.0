From: NeilBrown <neilb@suse.de>
Subject: Re: Small short question Was: Re: Recovering from the kernel bug,
 Neil?
Date: Thu, 20 Sep 2012 12:22:18 +1000
Message-ID: <20120920122218.07f89443@notabene.brown>
References: <5030F07F.7000303@schinagl.nl>
	<504CFA7B.7090606@schinagl.nl>
	<20120910090829.19100cdf@notabene.brown>
	<504DA85C.6080000@schinagl.nl>
	<20120911161622.0b0fcf8c@notabene.brown>
	<505301E1.10707@schinagl.nl>
	<50531A52.7060205@schinagl.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/sZSgwI3Ha4NxUyJucZokuHs"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50531A52.7060205@schinagl.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/sZSgwI3Ha4NxUyJucZokuHs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 14 Sep 2012 13:51:46 +0200 Oliver Schinagl <oliver+list@schinagl.nl>
wrote:

> Since I had only one valid device to check with etc, I assume that if=20
> fsck -n -f /dev/md2 runs sucessfully, it is 100% safe to assume the=20
> array is perfectly healthy?

I might be a bit late here but....

No, not 100% safe.
I would at least mount the filesystem and have a look around - take a random
sample and see if it all looks credible.  If it does then that is as good as
it gets.

>=20
> E.g. it should be perfectly safe to mdadm --zero-superblock on /dev/sda6=
=20
> and add it to /dev/md2 (missing /dev/sdb6)?
>=20
> I know technically this all works out fine, and the bug shouldn't have=20
> broken anything in that regard. Or is it absolutly recommended to simply=
=20
> create a new array, with a new FS on it, and copy all data over=20
> (Logically also with /dev/md2, /dev/sda6 missing and later adding sdb6)?

Creating a new array shouldn't be necessary.  In general I would avoid
copying data when convenient.

NeilBrown


--Sig_/sZSgwI3Ha4NxUyJucZokuHs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFp92jnsnt1WYoG5AQLM7w//fFeMJhgmo3nJ8UIa+RbFOBhFHWCFRXxU
KRLB+okAwgAiUr+oROlb7/XILTK/zCjsQHM1TyPXhtXyQHvotN8kjMIOutKw7/q2
FCHLAl14yAixwtlI0Gcg5kzyE57H7QYDxdW/PyOTPI8OyF5nxWPooer2k2Rh/nvh
rnKH9BGbdlmGXCOU+Ofcs3YZljJkRWf7ORcsdWgqyMPO4Thk8Gp2bYYdn61mRLkN
oSqVtgh2u5Nq4TYM7n5o+5YYfKo1j03Pj5tJebddgmyt41mT7hCsXHrTuYfPgSPB
UFOt743qS9bgZESXxLEDHBzm3ukePaQxC9QJd08z1V5NQJSYih6xOZtQ2qhNcuXd
+pk6o4IdgmgNbQWEjIh0AIQ3PR7O3+U2ogtYwIcLTP384M0bHhm6DwCL2i9IxFEp
HTQSC23cenYJyV1XpmwaMu80Pu5iJuV53Iam25I+HhRLm+/A6M4KJ8+48nuQLc6v
vvT6f58VEMihkHjUaRbfkw3TCnZwlgLanE1B6FhObXrJw603ilDIfDmsgUhGdGtz
ZLHSZKM4o8iANpXw0PHfl/fviDHTHUppre6EUDsglJcvtga3r8BpdKriCII3Y6fR
tT21qZSKprfm3jCRbjHnrWWvayvEGkNwl8eylH25Mjqxx6Y+8INMn7nNnADZF/TH
+N1Eg11Rgx4=
=EvT2
-----END PGP SIGNATURE-----

--Sig_/sZSgwI3Ha4NxUyJucZokuHs--
