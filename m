From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: allow changing set_name of running array
Date: Fri, 01 Sep 2017 10:07:29 +1000
Message-ID: <87tw0ne0xq.fsf@notabene.neil.brown.name>
References: <429c2b1c84c44b0c09ea7aa8dfa86846885441f7.1504044125.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <429c2b1c84c44b0c09ea7aa8dfa86846885441f7.1504044125.git.mirq-linux@rere.qmqm.pl>
Sender: linux-raid-owner@vger.kernel.org
To: =?utf-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 30 2017, Micha=C5=82 Miros=C5=82aw wrote:

> Allow changing active array's set_name. This is the only way to
> safely update superblock on an array which carries a mounted fs.

Do you really need to change the set_name of an active array?

The name is only used when the array is actived, so wait until the next
time the array is stopped, and change the name then.

You can boot with a rescue CD or similar and use "--assemble
=2D-update=3Dname", or with a bit of effort you could get the normal boot
sequence to change the name.

I wouldn't object to adding something to mdadm so that it would read
something from mdadm.conf, and update the set name at boot time.

What is the underlying problem that you are trying to solve here?

Thanks,
NeilBrown


>
> Signed-off-by: Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.qmqm.pl>
> ---
>  drivers/md/md.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 79 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index caca5d689cdc..59aa10669bef 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5051,6 +5051,84 @@ static struct md_sysfs_entry md_consistency_policy=
 =3D
>  __ATTR(consistency_policy, S_IRUGO | S_IWUSR, consistency_policy_show,
>         consistency_policy_store);
>=20=20
> +static ssize_t
> +set_name_show(struct mddev *mddev, char *page)
> +{
> +	struct mdp_superblock_1 *sb;
> +	struct md_rdev *rdev;
> +	int err;
> +
> +	err =3D mddev_lock(mddev);
> +	if (err)
> +		return err;
> +
> +	/* only version-1 superblocks carry a MD set's name */
> +	err =3D -ENXIO;
> +	if (mddev->major_version !=3D 1)
> +		goto out_unlock;
> +
> +	err =3D -EINVAL;
> +	rdev_for_each(rdev, mddev) {
> +		if (WARN_ON(!rdev->sb_loaded))
> +			continue;
> +
> +		sb =3D page_address(rdev->sb_page);
> +		err =3D sprintf(page, "%.32s\n", sb->set_name);
> +		break;
> +	}
> +
> +out_unlock:
> +	mddev_unlock(mddev);
> +	return err;
> +}
> +
> +static ssize_t
> +set_name_store(struct mddev *mddev, const char *buf, size_t buflen)
> +{
> +	struct mdp_superblock_1 *sb;
> +	struct md_rdev *rdev;
> +	size_t len =3D buflen;
> +	int err;
> +
> +	if (len && buf[len - 1] =3D=3D '\n')
> +		--len;
> +
> +	if (len > sizeof(sb->set_name))
> +		return -ENOSPC;
> +
> +	err =3D mddev_lock(mddev);
> +	if (err)
> +		return err;
> +
> +	/* only version-1 superblocks carry a MD set's name */
> +	err =3D -ENXIO;
> +	if (mddev->major_version !=3D 1)
> +		goto out_unlock;
> +
> +	err =3D -EROFS;
> +	if (mddev->ro)
> +		goto out_unlock;
> +
> +	rdev_for_each(rdev, mddev) {
> +		if (WARN_ON(!rdev->sb_loaded))
> +			continue;
> +
> +		sb =3D page_address(rdev->sb_page);
> +		memcpy(sb->set_name, buf, len);
> +		memset(&sb->set_name[len], 0, sizeof(sb->set_name) - len);
> +	}
> +
> +	md_update_sb(mddev, 1);
> +	err =3D buflen;
> +
> +out_unlock:
> +	mddev_unlock(mddev);
> +	return err;
> +}
> +
> +static struct md_sysfs_entry md_set_name =3D
> +__ATTR(set_name, S_IRUGO | S_IWUSR, set_name_show, set_name_store);
> +
>  static struct attribute *md_default_attrs[] =3D {
>  	&md_level.attr,
>  	&md_layout.attr,
> @@ -5067,6 +5145,7 @@ static struct attribute *md_default_attrs[] =3D {
>  	&md_array_size.attr,
>  	&max_corr_read_errors.attr,
>  	&md_consistency_policy.attr,
> +	&md_set_name.attr,
>  	NULL,
>  };
>=20=20
> --=20
> 2.11.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmopMMACgkQOeye3VZi
gbmJCRAAlhzEalaVOOSlL82cO483zW2CL/GvbIPq6dWk2mq23YOjfxIExvWcZH40
I0QuRNNT0AVA7xJCg/87YTts8OTNqSj4uYfKucR5v5jPnTO5caFovSINAcTtTo2D
cD1JdaiBCnDvGDxxm3iFBUhP0Ig9wlt+Ia+ixyQ+o4np39uQhH56XGXb6pKXJbfX
nhASGIXbf0riWIGlAcWGJXQljLyWNoEfCkdKJlGTYuUdohHirAiW9+uCaEXK2BK/
8uR2DZWWzGHAx5JczSmazCOzs//3QDCMXgCnZmFD6zd9eDcX9BY7T55ZCQiGm6Va
cgk6MI9UtdQXUrRtinFVi50j+MVWfNt09v+rt1iSaCFYgWXBCCeU8+aqI1E7vSv6
p73nhlIUyyJ3yN8lYRs3MkJrEl91L6NkzPIbaxn4vIaQi2yj8rZZBmhmJwQpKMZU
iRCj22NAIoi9K9FX2ed79XsqBjVzSabm0LaT5o0Eh+rBEc7Idsc4nP13m2j6pTeU
yJLMIno1V4njLBwrpIXKHJrsfrTXb2SliOmglZGi8k6cinIi6ZLfZ+eK/ermcZl/
Xq50MJ6MMvuCnF72E1ha5KTJslM2xhGKXCs3PVnIYUlYOP/YxdV/BjXOzHvChOCV
2joRdA6V0p6GLrvVNoKOZcODM4T4exxlqTUnu0iYeMNiN0iHbUc=
=7g1M
-----END PGP SIGNATURE-----
--=-=-=--
