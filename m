From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: do not fail load_container when first 2 disks are
 missing
Date: Tue, 6 Dec 2011 11:08:09 +1100
Message-ID: <20111206110809.00828921@notabene.brown>
References: <3F8F31A3BFD1664EAB894D1BD6AF32B9053871@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jUFyLEYl6frI7AoleCqN0/M"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F8F31A3BFD1664EAB894D1BD6AF32B9053871@IRSMSX102.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

--Sig_/jUFyLEYl6frI7AoleCqN0/M
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Nov 2011 11:24:16 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:

> Failure to find migration record should not fail the whole load_container.
> It causes that degraded raid10 with first 2 disks missing cannot be assem=
bled.
>=20
> Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
> ---
>  super-intel.c |   10 ++--------
>  1 files changed, 2 insertions(+), 8 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index a0672bf..21147c2 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -3953,15 +3953,9 @@ static int load_super_imsm_all(struct supertype *s=
t, int fd, void **sbp,
>  		goto error;
>  	}
> =20
> -	/* load migration record */
> -	err =3D load_imsm_migr_rec(super, NULL);
> -	if (err) {
> -		err =3D 4;
> -		goto error;
> -	}
> -
>  	/* Check migration compatibility */
> -	if (check_mpb_migr_compatibility(super) !=3D 0) {
> +	if (load_imsm_migr_rec(super, NULL) =3D=3D 0 &&
> +	    check_mpb_migr_compatibility(super) !=3D 0) {
>  		fprintf(stderr, Name ": Unsupported migration detected");
>  		if (devname)
>  			fprintf(stderr, " on %s\n", devname);

Sorry for the long delay in replying.  The last two weeks have held lots of
interruptions and distractions.

There are two things about this that don't make sense to me.  Perhaps you c=
an
clarify.

Firstly, imsm raid10 only supports a 4-device layout with the first two
devices effectively mirrors, same for the second two, and data striped over
the 2 pairs.  i.e. an 'n2' layout on 4 devices.
So if the first 2 disks are missing, then you have lost half your data and =
it
would be wrong to successfully assemble the array.

Secondly, if the migration record is missing, then presumably you do not kn=
ow
the full state of the array so again - assembling the array would be wrong.

So I cannot see how this patch can be correct.  If it is, please explain.

Thanks,
NeilBrown

--Sig_/jUFyLEYl6frI7AoleCqN0/M
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt1c7jnsnt1WYoG5AQL6ABAAn5q6X24BC+Dp74P3Mv7vz/yRr/V2zg+a
e01qTebY6wHmQgRwlSh0GcwRhE7bYBlv1dPnPUDZIe+XUaQGT0idsvqE+IWzw3VE
nayhpd1v4Ew14yajpglALPBb+bAoHQFB9D5vtE/pMIP9WatcMcPJOoqwjHkkhjex
vTeSPC7LBJSVKdl9tIyWvX1bhJ0cvt9Ho8QNw18luQtlCVMuzU2HtO5o0tJ6DcXS
JGh12ki5jeYmoG7GU5vYnrckOPWE4n/PkKzQm1IhkhuxC8IOJftaykcDUPGM7aoT
qx5Y6+lZDw9UmF1N386kb04mQrGxR5cj76HluaBjznwM0BdBs2HCz+lkIY31JanH
9f1UTCVbKbUUs99tHAyINo6bTYparAWvBmQUeYNUGPtDrq3AsWUqkfhacs52bTJo
o2kTswu1G9SsMIQQXJq4qvJZhGN/kRCnoGmQBVKp1/Q/QsEddqpYonB8bUXfQC1P
FggzvBg9+myYkvnka2rhybJAAWJSRXbyQ8obyu1ngt8r4HEU36BMPHR0hSh7pib0
fKJ89qYiXdDDKSb5iXZBD/QND1DY4Jqd8Wr/04fdpNMFtY91+6cY7oiW2Sbg0x2q
IszzXicquk4Kr0IPcd5bctJOVpT4z7iR9P1b+7enPt5QrsWdq549+RpW/n6pLzxQ
LJ+NNkx1Jd0=
=hc8o
-----END PGP SIGNATURE-----

--Sig_/jUFyLEYl6frI7AoleCqN0/M--
