From: Neil Brown <neilb@suse.com>
Subject: Re: [PATCH] MD: fix missing cpu_to_le32 for MD_FEATURE_JOURNAL
Date: Thu, 15 Oct 2015 17:37:06 +1100
Message-ID: <87d1wgwsbx.fsf@notabene.neil.brown.name>
References: <1444888404-994890-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444888404-994890-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Song Liu <songliubraving@fb.com>, shli@fb.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Song Liu <songliubraving@fb.com> writes:

> sb->feature_map is __le32, add missing cpu_to_le32()
>
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/md.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 378b9f0..163b548 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1812,7 +1812,7 @@ retry:
>  		sb->dev_roles[i] =3D cpu_to_le16(MD_DISK_ROLE_FAULTY);
>=20=20
>  	if (test_bit(MD_HAS_JOURNAL, &mddev->flags))
> -		sb->feature_map |=3D MD_FEATURE_JOURNAL;
> +		sb->feature_map |=3D cpu_to_le32(MD_FEATURE_JOURNAL);
>=20=20
>  	rdev_for_each(rdev2, mddev) {
>  		i =3D rdev2->desc_nr;
> --=20
> 2.4.6

Thanks.
I just emrged this in rather than create a new patch.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWH0mSAAoJEDnsnt1WYoG5KKYP/10q7O6PlQmQwhEj206lb7Rv
I4UXoCG0EZCGH5vmWQX1Fo6r38VTnRiqSp8ib4pkIL7NJDThEZsWEWrJ/CE9w2kx
UNxd1Tp1HwXpGQ93JWVbafDViglTFQMRBSFiUKalrFDMqPKzc87VrpkM1qwCcRVS
pzZ651oe1BnLrU2xiYxGZmDrDxFpDun2FHej9xPKyhTEi5RbxA/i/yuxQgjqPxYf
WBm/v6k8d3WioSzU8z2K+ZcjWgsdIyC+MnOZJPtBP/ylc6j9JlIhOqcY6N9liwM7
825aq/ef+KLwCnAp4NZtn/9C9e1PuM33KXdY6+PX/i40FxUASlt8ZQ8aSJQscsv4
YdZqjQYehg0fkbk6JBCwQMqKYreNu0x+0eS87FYZM4tphQl5AUNLCR4narsHldMF
wgfT3HxDg7vor8riXuzKmgOZNqn6muaAQBWGwUU4fdroRNaEHxBLVf7ZVgDA/95Q
t/sA1yT7d0sV7SGhOwSGOIk6LWqBl0la2ASY41s3UOlCAJzggXaqFdnrFAx4lGCg
UtMSajduDRKAvJ0O+PKPpumtOaq4F4cjrOYFoEg+jA6IZTobmchXpd9p10RWB89U
VtLynQUdfykcV2tRmycaL7WfIsjl1y2e67MEgpnNdWN8GiYPzAlyW6CEEkE9lORJ
FDHJLjGaxTA3L/vOg/4+
=2FTY
-----END PGP SIGNATURE-----
--=-=-=--
