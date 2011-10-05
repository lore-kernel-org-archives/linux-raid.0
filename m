From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/3] Monitor reshaped array
Date: Wed, 5 Oct 2011 13:59:56 +1100
Message-ID: <20111005135956.34bf4620@notabene.brown>
References: <20111004155129.27434.81564.stgit@gklab-128-013.igk.intel.com>
	<20111004155356.27434.65439.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SugJglSyJBUwe4LtGeCtiUe"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111004155356.27434.65439.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/SugJglSyJBUwe4LtGeCtiUe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 04 Oct 2011 17:53:56 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> Reshape can be run for monitored arrays only /external metadata case/.
> Before reshape can be executed, make sure that just starter array/contain=
er
> is monitored. If not, run mdmon for it.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  Assemble.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>=20
> diff --git a/Assemble.c b/Assemble.c
> index 0d3730b..2000dd0 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1570,6 +1570,12 @@ int assemble_container_content(struct supertype *s=
t, int mdfd,
>  			if (err)
>  				return 1;
> =20
> +			if (st->ss->external) {
> +				if (!mdmon_running(st->container_dev))
> +					start_mdmon(st->container_dev);
> +				ping_monitor_by_id(st->container_dev);
> +			}
> +
>  			err =3D Grow_continue(mdfd, st, content, backup_file,
>  					    freeze_reshape);
>  		} else switch(content->array.level) {
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Applied, thanks.

NeilBrown


--Sig_/SugJglSyJBUwe4LtGeCtiUe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOi8gsG5fc6gV+Wb0RAk4SAKDYj3ksJfNMvC4/I69xDvxUDqfsggCfXHu6
mv1cMmbWEj20tjdilPLMUik=
=i5wv
-----END PGP SIGNATURE-----

--Sig_/SugJglSyJBUwe4LtGeCtiUe--
