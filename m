From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/8] Do not restart reshape if it is started already
Date: Mon, 3 Oct 2011 09:41:58 +1100
Message-ID: <20111003094158.36e18c5f@notabene.brown>
References: <20110927115845.4890.49289.stgit@gklab-128-013.igk.intel.com>
	<20110927120457.4890.53328.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xVajjJV=9Ye/G=YCaD+uJr8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110927120457.4890.53328.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/xVajjJV=9Ye/G=YCaD+uJr8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Sep 2011 14:04:57 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> When reshape was invoked during initrd start-up stage array is pushed
> in to reshape state already, so read only state cannot be set again during
> reshape continuation. Set previously reshape state has to be reused
> during reshape continuation.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  Grow.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index 768fc86..d9c2817 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -3773,11 +3773,17 @@ int Grow_continue(int mdfd, struct supertype *st,=
 struct mdinfo *info,
>  {
>  	char buf[40];
>  	char *container =3D NULL;
> -	int err;
> +	int err =3D 0;
> =20
> -	err =3D sysfs_set_str(info, NULL, "array_state", "readonly");
> +	/* set read only array state when there is no reshape
> +	 * in progress already
> +	 */
> +	if ((sysfs_get_str(info, NULL, "sync_action", buf, 40) !=3D 8) &&
> +	    (strncmp(buf, "reshape", 7) !=3D 0))
> +		err =3D sysfs_set_str(info, NULL, "array_state", "readonly");
>  	if (err)
>  		return err;
> +
>  	if (st->ss->external) {
>  		fmt_devname(buf, st->container_dev);
>  		container =3D buf;


This is wrong.
For a start the '&&' should be '||' or it doesn't make sense.

The reason were are setting readonly here is that the array hasn't been
activated at all, so it isn't possible to freeze anything.
So we set the array to readonly so that no reshape/resync/etc can start, th=
en
activate the array in reshape_array, then freeze, and allow it to be
read-write.

So Grow_continue really assumes that the array hasn't been started yet.
You are using it in different situation, where it has been started.
For that to be reasonably, you really need to tell Grow_continue that the
array hasn't started, not let it try to figure out for itself.

However I think it would be easier to just copy the code from Grow_continue
into the place where you called it in Grow_continue_command and then remove
the bits that you don't need.
You don't need the readonly setting and you don't need the start_mdmon and I
don't think you need the freeze(), so it becomes:

if (st->ss->external && info->reshape_active =3D=3D 2) {
  		int cfd =3D open_dev(st->container_dev);
		if (cfd < 0)
			return 1;
		st->ss->load_container(st, cfd, container);
		close(cfd);
		ret_val =3D reshape_container(container, NULL,
					 st, info, 0, backup_file,
					 0, 1, freeze_reshape);
	}
} else
	ret_val =3D reshape_array(container, mdfd, "array", st, info, 1,
			     NULL, backup_file, 0, 0, 1, freeze_reshape);

which is a better result I think.

So I won't apply this patch.  Please consider the above and submit a revised
version if you agree.

Thanks,
NeilBrown

--Sig_/xVajjJV=9Ye/G=YCaD+uJr8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOiOi2G5fc6gV+Wb0RAnpPAJ9CuiRk7EVgGG9FpkYcJbBqZ2U6xwCfRMnq
FMHHVniBCbky0SvRrd6vX+w=
=BxCT
-----END PGP SIGNATURE-----

--Sig_/xVajjJV=9Ye/G=YCaD+uJr8--
