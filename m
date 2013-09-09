From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] DDF: handle fake RAIDs with changing subarray UUIDs
Date: Tue, 10 Sep 2013 09:48:55 +1000
Message-ID: <20130910094855.21bab8dc@notabene.brown>
References: <522E13EF.3080001@arcor.de>
	<1378752014-8366-1-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rJyDPIAY1AZ4lFxFkcuSP5c"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1378752014-8366-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/rJyDPIAY1AZ4lFxFkcuSP5c
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon,  9 Sep 2013 20:40:14 +0200 mwilck@arcor.de wrote:

> Some fake RAID BIOSes (in particular, LSI ones) change the
> VD GUID at every boot. These GUIDs are not suitable for
> identifying an array. Luckily the header GUID appears to
> remain constant.
>=20
> We construct a pseudo-UUID from the header GUID and those
> properties of the subarray that we expect to remain constant.
> This is only array name and index; all else might change e.g.
> during grow.
>=20
> Don't do this for all non-MD arrays, only for those known
> to use varying volume GUIDs.
>=20
> This patch obsoletes my previous patch "DDF: new algorithm
> for subarray UUID"
>=20
> Signed-off-by: Martin Wilck <mwilck@arcor.de>

Thanks.  Applied.

NeilBrown


> ---
>  super-ddf.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++---=
--
>  1 files changed, 50 insertions(+), 5 deletions(-)
>=20
> diff --git a/super-ddf.c b/super-ddf.c
> index 72a8351..19d8494 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -1583,6 +1583,7 @@ static void brief_examine_subarrays_ddf(struct supe=
rtype *st, int verbose)
>  			continue;
>  		memcpy(vcl.conf.guid, ve->guid, DDF_GUID_LEN);
>  		ddf->currentconf =3D&vcl;
> +		vcl.vcnum =3D i;
>  		uuid_from_super_ddf(st, info.uuid);
>  		fname_from_uuid(st, &info, nbuf1, ':');
>  		memcpy(namebuf, ve->name, sizeof(ve->name));
> @@ -1682,6 +1683,52 @@ static void detail_super_ddf(struct supertype *st,=
 char *homehost)
>  	 */
>  }
> =20
> +static const char *vendors_with_variable_volume_UUID[] =3D {
> +	"LSI      ",
> +};
> +
> +static int volume_id_is_reliable(const struct ddf_super *ddf)
> +{
> +	int n =3D sizeof(vendors_with_variable_volume_UUID) /=20
> +		sizeof(vendors_with_variable_volume_UUID[0]);
> +	int i;
> +	for (i =3D 0; i < n; i++)
> +		if (!memcmp(ddf->controller.guid,
> +			vendors_with_variable_volume_UUID[i], 8))
> +		return 0;
> +	return 1;
> +}
> +
> +static void uuid_of_ddf_subarray(const struct ddf_super *ddf,
> +				 unsigned int vcnum, int uuid[4])
> +{
> +	char buf[DDF_GUID_LEN+18], sha[20], *p;
> +	struct sha1_ctx ctx;
> +	if (volume_id_is_reliable(ddf)) {
> +		uuid_from_ddf_guid(ddf->virt->entries[vcnum].guid, uuid);
> +		return;
> +	}
> +	/*
> +	 * Some fake RAID BIOSes (in particular, LSI ones) change the
> +	 * VD GUID at every boot. These GUIDs are not suitable for
> +	 * identifying an array. Luckily the header GUID appears to
> +	 * remain constant.
> +	 * We construct a pseudo-UUID from the header GUID and those
> +	 * properties of the subarray that we expect to remain constant.
> +	 */
> +	memset(buf, 0, sizeof(buf));
> +	p =3D buf;
> +	memcpy(p, ddf->anchor.guid, DDF_GUID_LEN);
> +	p +=3D DDF_GUID_LEN;
> +	memcpy(p, ddf->virt->entries[vcnum].name, 16);
> +	p +=3D 16;
> +	*((__u16 *) p) =3D vcnum;
> +	sha1_init_ctx(&ctx);
> +	sha1_process_bytes(buf, sizeof(buf), &ctx);
> +	sha1_finish_ctx(&ctx, sha);
> +	memcpy(uuid, sha, 4*4);
> +}
> +
>  static void brief_detail_super_ddf(struct supertype *st)
>  {
>  	struct mdinfo info;
> @@ -1693,7 +1740,7 @@ static void brief_detail_super_ddf(struct supertype=
 *st)
>  	else if (vcnum =3D=3D DDF_NOTFOUND)
>  		return;
>  	else
> -		uuid_from_ddf_guid(ddf->virt->entries[vcnum].guid, info.uuid);
> +		uuid_of_ddf_subarray(ddf, vcnum, info.uuid);
>  	fname_from_uuid(st, &info, nbuf,':');
>  	printf(" UUID=3D%s", nbuf + 5);
>  }
> @@ -1836,13 +1883,11 @@ static void uuid_from_super_ddf(struct supertype =
*st, int uuid[4])
>  	 */
>  	struct ddf_super *ddf =3D st->sb;
>  	struct vcl *vcl =3D ddf->currentconf;
> -	char *guid;
> =20
>  	if (vcl)
> -		guid =3D vcl->conf.guid;
> +		uuid_of_ddf_subarray(ddf, vcl->vcnum, uuid);
>  	else
> -		guid =3D ddf->anchor.guid;
> -	uuid_from_ddf_guid(guid, uuid);
> +		uuid_from_ddf_guid(ddf->anchor.guid, uuid);
>  }
> =20
>  static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *i=
nfo, char *map);


--Sig_/rJyDPIAY1AZ4lFxFkcuSP5c
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUi5eZznsnt1WYoG5AQKOww/8DiKP9ygCSJ9pn3f++1IbdaBpnZBAHqCq
D+14+OAKfzDynVsRleZaZ4MAMMk7QyMH7qX+fXQCgfkHIq2HjZLnjgwXMT4r/1cP
820pM+0joWkBlScUaXL4LU/oCTAk4+mIFnq5JrPU30RqxXeBI5mCAYCWuAGo5MaA
0Q/bSxsAxWYRahnxKnYrcUOBHqzehGLpJj8dovoqBTmY4rpatbo//XuDO/0Vtd0f
HQeNF3AABM97mebu7QGEYF0EHTpzkbwTzLT5/WXUvfea2b+w86VYbDbWuNLWh9xO
Kodt9LA6QOVSEmea9h5tNEO3BU8USuVUFF/akcJ0krJJqezLkmMeVs7GMS4pFdnu
Ib8eTYMwER2Ii+gLWmLGjFKchFLmKhr+PFxsLUhPzuYdSaxDXdAAOoneFGJaqyVk
+iBMe4mwmfZIjwseWHPdgwo5uuNbfCFTPTvt4sVd5EMK44mR6x8kgrruQz8NPZMm
40C3EUz1OHohAOo1UYfg8md/lGRF+vFQSztXn1sqt3s+TZPuUXB2KUHfEhweOqUG
RI/A+WT04UdFf4ZN3/vHBb84fNfjQJMN6A33w3bvZfDQhNsXCSJHdypJY8JI5kUT
zQbkIpAwlLrqESi/HOEfhvhGUEdj6osDyiPopgOntPDxUnl8VhCh2JjSjQM7QdxW
r76Plh5tK7E=
=T+jR
-----END PGP SIGNATURE-----

--Sig_/rJyDPIAY1AZ4lFxFkcuSP5c--
