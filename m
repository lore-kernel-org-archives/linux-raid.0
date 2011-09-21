From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/3] Create: Incorrect message when creating a volume
 with explicit md dev name
Date: Wed, 21 Sep 2011 13:48:20 +1000
Message-ID: <20110921134820.24593401@notabene.brown>
References: <20110919165220.9239.2939.stgit@gklab-128-192.igk.intel.com>
	<20110919165245.9239.28871.stgit@gklab-128-192.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4oq_rHz8qWWBv+CgHiZUzu5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110919165245.9239.28871.stgit@gklab-128-192.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Orlowski <lukasz.orlowski@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/4oq_rHz8qWWBv+CgHiZUzu5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Sep 2011 18:52:45 +0200 Lukasz Orlowski
<lukasz.orlowski@intel.com> wrote:

> Appears when one attempts to create RAID 1 volume on 2 disks within a
> container with an existing RAID 5 volume on 3 disks and specifies the
> md device explicitly (e.g. /dev/md127). Instead of saying that such volume
> cannot be created it says that the devices have insufficient size.

I cannot reproduce this and I don't really understand what problem you are
trying to solve (seems to be happening a lot today :-(  )

Could you give me a simple list of commands that produce undesirable result=
s?

Thanks,
NeilBrown



>=20
> Signed-off-by: Lukasz Orlowski <lukasz.orlowski@intel.com>
> ---
>  Create.c      |    8 ++++++--
>  super-intel.c |   10 +++++++---
>  2 files changed, 13 insertions(+), 5 deletions(-)
>=20
> diff --git a/Create.c b/Create.c
> index 47e5fc8..baadd9f 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -262,9 +262,13 @@ int Create(struct supertype *st, char *mddev,
>  	if (size && chunk && chunk !=3D UnSet)
>  		size &=3D ~(unsigned long long)(chunk - 1);
>  	newsize =3D size * 2;
> -	if (st && ! st->ss->validate_geometry(st, level, layout, raiddisks,
> -					      &chunk, size*2, NULL, &newsize, verbose>=3D0))
> +	if (st && !
> +		st->ss->validate_geometry(
> +				st, level, layout, raiddisks, &chunk,
> +				size*2, NULL, &newsize, verbose >=3D 0)) {
> +		fprintf(stderr, Name ": create aborted.\n");
>  		return 1;
> +	}
> =20
>  	if (chunk && chunk !=3D UnSet) {
>  		newsize &=3D ~(unsigned long long)(chunk*2 - 1);
> diff --git a/super-intel.c b/super-intel.c
> index 616853b..51874ae 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5223,9 +5223,13 @@ static int reserve_space(struct supertype *st, int=
 raiddisks,
>  		/* chunk is in K */
>  		minsize =3D chunk * 2;
> =20
> -	if (cnt < raiddisks ||
> -	    (super->orom && used && used !=3D raiddisks) ||
> -	    maxsize < minsize ||
> +	if (cnt < raiddisks || (super->orom && used && used !=3D raiddisks)) {
> +		fprintf(stderr, Name ": the option-rom requires all "
> +			"member disks to be a member of all volumes.\n");
> +		return 0;
> +	}
> +
> +	if (maxsize < minsize ||
>  	    maxsize =3D=3D 0) {
>  		fprintf(stderr, Name ": not enough devices with space to create array.=
\n");
>  		return 0; /* No enough free spaces large enough */
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


--Sig_/4oq_rHz8qWWBv+CgHiZUzu5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOeV6EG5fc6gV+Wb0RAuNRAKC5hGfbr0WZrblQiEfbUDK3cK+VSACcCeNl
adGa25kaQ36qu+sORoyxKj4=
=A8XF
-----END PGP SIGNATURE-----

--Sig_/4oq_rHz8qWWBv+CgHiZUzu5--
