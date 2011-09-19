From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] udev rules: use $tempnode, check for supported types,
 comments
Date: Mon, 19 Sep 2011 13:12:50 +1000
Message-ID: <20110919131250.070a5002@notabene.brown>
References: <1315140164-6991-1-git-send-email-soltys@ziu.info>
	<1315466708-5431-1-git-send-email-soltys@ziu.info>
	<1315466708-5431-2-git-send-email-soltys@ziu.info>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1j1O6h9DAM4p8=G6gLH0s1u"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1315466708-5431-2-git-send-email-soltys@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <soltys@ziu.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/1j1O6h9DAM4p8=G6gLH0s1u
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu,  8 Sep 2011 09:25:08 +0200 Michal Soltys <soltys@ziu.info> wrote:

> Few things adjusted in addition to
> 0f82fe603a42f37f1e2a6f826b4164811bf2d188:
>=20
> - keep strict tests for supported types
> - when accessing the device, use $tempnode
> - few more comments
>=20
> Signed-off-by: Michal Soltys <soltys@ziu.info>
> ---
>  udev-md-raid.rules |   17 +++++++++++++----
>  1 files changed, 13 insertions(+), 4 deletions(-)
>=20
> diff --git a/udev-md-raid.rules b/udev-md-raid.rules
> index e251ac5..f564f70 100644
> --- a/udev-md-raid.rules
> +++ b/udev-md-raid.rules
> @@ -2,10 +2,19 @@
> =20
>  SUBSYSTEM!=3D"block", GOTO=3D"md_end"
> =20
> -# handle potential components of arrays
> -ENV{ID_FS_TYPE}=3D=3D"*_raid_member", ENV{ID_PATH}!=3D"", ACTION=3D=3D"r=
emove", RUN+=3D"/sbin/mdadm -If $name --path $env{ID_PATH}"
> -ENV{ID_FS_TYPE}=3D=3D"*_raid_member", ENV{ID_PATH}=3D=3D"", ACTION=3D=3D=
"remove", RUN+=3D"/sbin/mdadm -If $name"
> -ENV{ID_FS_TYPE}=3D=3D"*_raid_member", ACTION=3D=3D"add", RUN+=3D"/sbin/m=
dadm --incremental $env{DEVNAME}"
> +# handle potential components of arrays (the ones supported by md)
> +ENV{ID_FS_TYPE}=3D=3D"ddf_raid_member|isw_raid_member|linux_raid_member"=
, GOTO=3D"md_inc"
> +GOTO=3D"md_inc_skip"
> +
> +LABEL=3D"md_inc"
> +
> +# remember you can limit what gets auto/incrementally assembled by
> +# mdadm.conf(5)'s 'AUTO' and selectively whitelist using 'ARRAY'
> +ACTION=3D=3D"add", RUN+=3D"/sbin/mdadm --incremental $tempnode"
> +ACTION=3D=3D"remove", ENV{ID_PATH}=3D=3D"?*", RUN+=3D"/sbin/mdadm -If $n=
ame --path $env{ID_PATH}"
> +ACTION=3D=3D"remove", ENV{ID_PATH}!=3D"?*", RUN+=3D"/sbin/mdadm -If $nam=
e"
> +
> +LABEL=3D"md_inc_skip"
> =20
>  # handle md arrays
>  ACTION!=3D"add|change", GOTO=3D"md_end"

Thanks.
I've applied this... though I must admit that I don't really like all the
GOTOs - but that is reall

y the fault of udev I expect.

What was the rational for changing=20
   =3D=3D""
to
   !=3D"?*"

??

NeilBrown

--Sig_/1j1O6h9DAM4p8=G6gLH0s1u
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOdrMyG5fc6gV+Wb0RAjKuAKDaC4J6QBmjlmHs4uyXcWSkC/7+qQCdFCs6
IahBgJVsRZeUQQCdHutY+88=
=fwYF
-----END PGP SIGNATURE-----

--Sig_/1j1O6h9DAM4p8=G6gLH0s1u--
