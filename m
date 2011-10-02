From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/3] Move code to check_mdmon_version() function
Date: Mon, 3 Oct 2011 10:45:56 +1100
Message-ID: <20111003104556.4b640532@notabene.brown>
References: <20110929154756.22854.13187.stgit@gklab-128-013.igk.intel.com>
	<20110929155336.22854.2583.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/r_ZwJ6_RJw+WcI2.MPPk4X."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110929155336.22854.2583.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/r_ZwJ6_RJw+WcI2.MPPk4X.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 29 Sep 2011 17:53:36 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> Move code to function for code reuse.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

Applied, thanks.

though it might be better for "check_mdmon_version" also took a version
number to compare against.

NeilBrown

> ---
>=20
>  msg.c |   59 ++++++++++++++++++++++++++++++++++++-----------------------
>  1 files changed, 36 insertions(+), 23 deletions(-)
>=20
> diff --git a/msg.c b/msg.c
> index a10c930..98d6d13 100644
> --- a/msg.c
> +++ b/msg.c
> @@ -281,6 +281,40 @@ int block_subarray(struct mdinfo *sra)
> =20
>  	return rc;
>  }
> +
> +/* check mdmon version if it supports
> + * array blocking mechanism
> + */
> +int check_mdmon_version(char *container)
> +{
> +	char *version =3D NULL;
> +	int devnum =3D devname2devnum(container);
> +
> +	if (!mdmon_running(devnum)) {
> +		/* if mdmon is not active we assume that any instance that is
> +		 * later started will match the current mdadm version, if this
> +		 * assumption is violated we may inadvertantly rebuild an array
> +		 * that was meant for reshape, or start rebuild on a spare that
> +		 * was to be moved to another container
> +		 */
> +		/* pass */;
> +	} else {
> +		int ver;
> +
> +		version =3D ping_monitor_version(container);
> +		ver =3D version ? mdadm_version(version) : -1;
> +		free(version);
> +		if (ver < 3002000) {
> +			fprintf(stderr, Name
> +				": mdmon instance for %s cannot be disabled\n",
> +				container);
> +			return -1;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  /**
>   * block_monitor - prevent mdmon spare assignment
>   * @container - container to block
> @@ -302,34 +336,13 @@ int block_subarray(struct mdinfo *sra)
>   */
>  int block_monitor(char *container, const int freeze)
>  {
> -	int devnum =3D devname2devnum(container);
>  	struct mdstat_ent *ent, *e, *e2;
>  	struct mdinfo *sra =3D NULL;
> -	char *version =3D NULL;
>  	char buf[64];
>  	int rv =3D 0;
> =20
> -	if (!mdmon_running(devnum)) {
> -		/* if mdmon is not active we assume that any instance that is
> -		 * later started will match the current mdadm version, if this
> -		 * assumption is violated we may inadvertantly rebuild an array
> -		 * that was meant for reshape, or start rebuild on a spare that
> -		 * was to be moved to another container
> -		 */
> -		/* pass */;
> -	} else {
> -		int ver;
> -
> -		version =3D ping_monitor_version(container);
> -		ver =3D version ? mdadm_version(version) : -1;
> -		free(version);
> -		if (ver < 3002000) {
> -			fprintf(stderr, Name
> -				": mdmon instance for %s cannot be disabled\n",
> -				container);
> -			return -1;
> -		}
> -	}
> +	if (check_mdmon_version(container))
> +		return -1;
> =20
>  	ent =3D mdstat_read(0, 0);
>  	if (!ent) {



--Sig_/r_ZwJ6_RJw+WcI2.MPPk4X.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOiPe0G5fc6gV+Wb0RAqLHAKDW+mI+oIdUdHH2S2NuWU9cn3qh6QCfczuE
G/eAlVgdLQGh8DCasNnFLg4=
=y30n
-----END PGP SIGNATURE-----

--Sig_/r_ZwJ6_RJw+WcI2.MPPk4X.--
