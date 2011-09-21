From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/3] Create: Allow to create two volumes of different
 sizes within one container
Date: Wed, 21 Sep 2011 13:31:23 +1000
Message-ID: <20110921133123.05d03613@notabene.brown>
References: <20110919165220.9239.2939.stgit@gklab-128-192.igk.intel.com>
	<20110919165230.9239.4775.stgit@gklab-128-192.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8RTBvazUV=EqD4YJmpEaD_y"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110919165230.9239.4775.stgit@gklab-128-192.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Orlowski <lukasz.orlowski@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/8RTBvazUV=EqD4YJmpEaD_y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Sep 2011 18:52:31 +0200 Lukasz Orlowski
<lukasz.orlowski@intel.com> wrote:

> Allows to create RAID 5 volume on 3 disks and then RAID 1 volume on 2
> disks withing the same container.
>=20
> Signed-off-by: Lukasz Orlowski <lukasz.orlowski@intel.com>
> ---
>  super-intel.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index a78d723..616853b 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5041,6 +5041,12 @@ static int validate_geometry_imsm_volume(struct su=
pertype *st, int level,
>  	if (!super)
>  		return 0;
> =20
> +	if (mpb->num_raid_devs > 0 && mpb->num_disks !=3D raiddisks) {
> +		fprintf(stderr, Name ": the option-rom requires all "
> +			"member disks to be a member of all volumes.\n");
> +		return 0;
> +	}
> +
>  	if (!validate_geometry_imsm_orom(super, level, layout, raiddisks, chunk=
, verbose)) {
>  		fprintf(stderr, Name ": RAID gemetry validation failed. "
>  			"Cannot proceed with the action(s).\n");
>=20

This patch doesn't make sense.

Firstly the description seems backwards.  The purpose of this patch seems to
disallow the creation of two volumes with different numbers of devices, but
the description seems to say that it allows it.  But that is a small point.

->num_disks is the number of devices in the container including spares.  Th=
is
patch would allow the first array in a container to have fewer devices than
the container with the rest being spares.  However the second array would h=
ave
to have the same number of devices as the container - even if this is more
than the first array.

Presumably what you really want to do is:
  if num_raid_devs > 0, then find the relevant imsm_map, and then check if
     map->num_members =3D=3D raiddisks
  and fail if they are not equal.

??

NeilBrown

--Sig_/8RTBvazUV=EqD4YJmpEaD_y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOeVqLG5fc6gV+Wb0RAvXdAJ9XmKG0iOiu6rebvgQbL6qZzlmzswCfcWjw
EqwTSIJYxgrU9keQcCIdhB0=
=iYIU
-----END PGP SIGNATURE-----

--Sig_/8RTBvazUV=EqD4YJmpEaD_y--
