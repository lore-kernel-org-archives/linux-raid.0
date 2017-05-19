From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] super1: fix sb->max_dev when adding a new disk in linear array
Date: Fri, 19 May 2017 14:36:53 +1000
Message-ID: <87pof5laxm.fsf@notabene.neil.brown.name>
References: <20170516045129.21815-1-lzhong@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170516045129.21815-1-lzhong@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lidong Zhong <lzhong@suse.com>, linux-raid@vger.kernel.org
Cc: colyli@suse.com, Jes.Sorensen@gmail.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, May 16 2017, Lidong Zhong wrote:

> The value of sb->max_dev will always be increased by 1 when adding
> a new disk in linear array. It causes an inconsistence between each
> disk in the array and the "Array State" value of "mdadm --examine DISK"
> is wrong. For example, when adding the first new disk into linear array
> it will be:
>
> Array State : RAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
> ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D replacing)
>
> Adding the second disk into linear array it will be
>
> Array State : .AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
> ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D replacing)
>
> Signed-off-by: Lidong Zhong <lzhong@suse.com>
> ---
>  super1.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/super1.c b/super1.c
> index 87a74cb..3d49bee 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1184,8 +1184,10 @@ static int update_super1(struct supertype *st, str=
uct mdinfo *info,
>  				break;
>  		sb->dev_number =3D __cpu_to_le32(i);
>  		info->disk.number =3D i;
> -		if (max >=3D __le32_to_cpu(sb->max_dev))
> +		if (i >=3D __le32_to_cpu(sb->max_dev)) {

This change is correct - thanks.  Though
    if (i >=3D max) {

might be clearer and simpler.


>  			sb->max_dev =3D __cpu_to_le32(max+1);
> +			sb->dev_roles[sb->max_dev] =3D __cpu_to_le16(MD_DISK_ROLE_SPARE);

This change is wrong.
At the very least, the dev_roles[] array needs to be indexed by a
host-order number, not a little-endian number.
But the change is not needed because dev_roles[max_dev] is never used.
See role_from_sb().
dev_rols[max_dev - 1] does need to be set, but the line

		sb->dev_roles[i] =3D __cpu_to_le16(info->disk.raid_disk);

almost certainly does that.
It might be better to do
  if (i >=3D max) {
     while (max <=3D i) {
        sb->dev_roles[max] =3D __cpu_to_le16(MD_DISK_ROLE_SPARE);
        max +=3D 1;
     }
     sb->max_dev =3D __cpu_to_le32(max);
  }

> +		}
>=20=20
>  		random_uuid(sb->device_uuid);
>=20=20
> @@ -1214,6 +1216,10 @@ static int update_super1(struct supertype *st, str=
uct mdinfo *info,
>  		sb->raid_disks =3D __cpu_to_le32(info->array.raid_disks);
>  		sb->dev_roles[info->disk.number] =3D
>  			__cpu_to_le16(info->disk.raid_disk);
> +		if (sb->raid_disks+1 >=3D __le32_to_cpu(sb->max_dev)) {
> +			sb->max_dev =3D __cpu_to_le32(sb->raid_disks+1);
> +			sb->dev_roles[sb->max_dev] =3D __cpu_to_le16(MD_DISK_ROLE_SPARE);

Again, max_dev is little-endian, so cannot be used as an index.
And I think you are updating the wrong element in the dev_roles array.

Thanks,
NeilBrown


> +		}
>  	} else if (strcmp(update, "resync") =3D=3D 0) {
>  		/* make sure resync happens */
>  		sb->resync_offset =3D 0ULL;
> --=20
> 2.12.0

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkedmcACgkQOeye3VZi
gbnGEhAAtECCQuD9npUJjTYn2/7r2cBOENlTzzwedLwW8ECA1Oycsl83JEWNJg+e
pWbG/neomcXTiOPeoyQDFc/AW//2yzV+xPt82fEoYuqlRYvlrjFYovJ1HJQQ0dmr
1/NuVN3ljk2Pdyyhxyw/0XjAVy6ggkmm3YsPvWD0RK6pp3dD5gHOvLkLgtYnzk7n
t7gdt0hS7VY3HQz2obWdFZrWpr2ucCbrlB4XGnqGAae6jGB5FM9EMOGXRb/DyBun
kRQa73MKfPcn9Q188S1kFnNM9EWKYKUhS+rwOJveE8yj20dATO0A2yYG7lZi9r/x
BvsRidkUTIbJT9GrMqQftTqmRU5ngmFI8J6nx3NWj5mtoxQuSe2FOHGc/d2ffP6+
3HpYAMFRHx1G0zc3vEUHBjq0OOfb4Zn7LgCOslV6FYkfpjehLjGKEPGsQuhRmR+2
UhFPadEceUN3ADHURzymg9/m2GufbK1Ec/caaucDg7w45l6WmwiaJyzMP+dFS2/E
wb/XaprS9FGeVM4nPk75ts7SCQE+iKbkFznlTYmZtEm2K9HSoOhSx06I1GyBl+Z4
a4OT/GwufJErwc16wQNr9y+Ej9OwN2HRGWlLcP0BLMIvcxFL6UfmyuC4nHYOE2ih
rlV05sW3Vmf8PGDC8isO1e7Lb2AbttDZmYT/Vn90kMiLFhetZAw=
=5atf
-----END PGP SIGNATURE-----
--=-=-=--
