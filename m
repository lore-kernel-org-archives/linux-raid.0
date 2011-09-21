From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/3] Create: Unnecessary prompt about device being busy
Date: Wed, 21 Sep 2011 13:36:15 +1000
Message-ID: <20110921133615.05d336ee@notabene.brown>
References: <20110919165220.9239.2939.stgit@gklab-128-192.igk.intel.com>
	<20110919165238.9239.1701.stgit@gklab-128-192.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/mHd.mVU__ZsQrkN+YBe9USY"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110919165238.9239.1701.stgit@gklab-128-192.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Orlowski <lukasz.orlowski@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/mHd.mVU__ZsQrkN+YBe9USY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Sep 2011 18:52:38 +0200 Lukasz Orlowski
<lukasz.orlowski@intel.com> wrote:

> Should the geometry validation fail, mdadm exits with error code 2 if the
> style of metadata is not explicitly set to imsm. Prior to that however it
> attempts to exclusively open a device block file. If it succeeds it says
> that the device is not suitable for any kind of array, otherwise it just
> says that the device is busy. The file opened is not closed afterwards.
>=20
> Signed-off-by: Lukasz Orlowski <lukasz.orlowski@intel.com>

I'm confused.  What exactly is the problem here?

If geometry validation fails, we need to exit because there is nothing usef=
ul
we can do.
We simply check if the problem is that the device is already in use, or if =
it
is an unusable device and report that.  Then exit.
Seeing we are about the exit there is point closing the file.

What is the scenario when you get incorrect behaviour?

NeilBrown


> ---
>  Create.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
>=20
> diff --git a/Create.c b/Create.c
> index 8d88aa1..47e5fc8 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -346,15 +346,15 @@ int Create(struct supertype *st, char *mddev,
> =20
>  			if (!st) {
>  				int dfd =3D open(dname, O_RDONLY|O_EXCL);
> -				if (dfd < 0) {
> -					fprintf(stderr, Name ": cannot open %s: %s\n",
> -						dname, strerror(errno));
> -					exit(2);
> +				if (dfd >=3D 0) {
> +					fprintf(stderr,
> +						Name ": device %s not suitable"
> +						" for any style of array\n",
> +						dname);
> +					close(dfd);
>  				}
> -				fprintf(stderr, Name ": device %s not suitable "
> -					"for any style of array\n",
> -					dname);
> -				exit(2);
> +				fail =3D 1;
> +				break;
>  			}
>  			if (st->ss !=3D &super0 ||
>  			    st->minor_version !=3D 90)
> @@ -443,7 +443,7 @@ int Create(struct supertype *st, char *mddev,
>  			close(fd);
>  		}
>  	}
> -	if (raiddisks + sparedisks > st->max_devs) {
> +	if (st && raiddisks + sparedisks > st->max_devs) {
>  		fprintf(stderr, Name ": Too many devices:"
>  			" %s metadata only supports %d\n",
>  			st->ss->name, st->max_devs);
>=20
> ---------------------------------------------------------------------
> Intel Technology Poland sp. z o.o.
> z siedziba w Gdansku
> ul. Slowackiego 173
> 80-298 Gdansk
>=20
> Sad Rejonowy Gdansk Polnoc w Gdansku,=20
> VII Wydzial Gospodarczy Krajowego Rejestru Sadowego,=20
> numer KRS 101882
>=20
> NIP 957-07-52-316
> Kapital zakladowy 200.000 zl
>=20
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.


--Sig_/mHd.mVU__ZsQrkN+YBe9USY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOeVuvG5fc6gV+Wb0RAgAQAJ4rWql5wRmqEAky+60ibhHAR7OHPwCdFRdl
FZXVtzzfRzKkyTvI0CMU4as=
=dJ9H
-----END PGP SIGNATURE-----

--Sig_/mHd.mVU__ZsQrkN+YBe9USY--
