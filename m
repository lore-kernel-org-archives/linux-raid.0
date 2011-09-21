From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 08/14] Check if reshape can be restarted
Date: Wed, 21 Sep 2011 12:27:34 +1000
Message-ID: <20110921122734.338d6f59@notabene.brown>
References: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
	<20110916115448.5201.56575.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/UxayZO/0a8w2QGrtIAC/_HD"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110916115448.5201.56575.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

--Sig_/UxayZO/0a8w2QGrtIAC/_HD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Sep 2011 13:54:48 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> When reshape was invoked during initramfs start-up stage
> array is pushed in to reshape state already, so read only
> state cannot be set again. To verify if reshape continuation should
> be allowed sync_action sysfs key is tested and number of existing mdadm
> instances is checked again.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

Again, it is not at all clear to me what you are trying to protect against
here...

The "set_str ... readonly" is going to need to be changed.

In the normal case, this is where the array is activated, but it is activat=
ed
read-only to ensure no reshape automatically starts.

In the --continue case it is already running and reshape is suspended, so
there is no need to set it to readonly when Grow_continue is called from
Grow_continue_command.

NeilBrown


> ---
>=20
>  Grow.c |   19 +++++++++++++++++--
>  1 files changed, 17 insertions(+), 2 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index 4d2c361..b331287 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -3714,8 +3714,23 @@ int Grow_continue(int mdfd, struct supertype *st, =
struct mdinfo *info,
>  	int err;
> =20
>  	err =3D sysfs_set_str(info, NULL, "array_state", "readonly");
> -	if (err)
> -		return err;
> +	if (err) {
> +		/* check if array is set in to reshape stare,
> +		 * and current mdadm instance is the only one
> +		 */
> +		if ((sysfs_get_str(info, NULL, "sync_action",
> +				   buf, 40) =3D=3D 8) &&
> +		    (count_mdadms() =3D=3D 1)) {
> +			dprintf("Warning: Grow_continue() cannot set array in"
> +				"to read only state [sync_action is %s].",
> +				buf);
> +			if (strncmp(buf, "reshape", 7))
> +				return err;
> +			dprintf("Allow to continue.\n");
> +		} else
> +			return err;
> +	}
> +
>  	if (st->ss->external) {
>  		fmt_devname(buf, st->container_dev);
>  		container =3D buf;
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/UxayZO/0a8w2QGrtIAC/_HD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOeUuWG5fc6gV+Wb0RAkvIAKCTAtpQlfgOCgTjqu0SHibE4gMmdQCeIJsf
/RG2uoEr4gn9Yts2DJhwbSs=
=wwAC
-----END PGP SIGNATURE-----

--Sig_/UxayZO/0a8w2QGrtIAC/_HD--
