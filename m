From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid5: Add compensation in sysfs for raid456.
Date: Tue, 21 Jan 2014 13:00:14 +1100
Message-ID: <20140121130014.00f429d3@notabene.brown>
References: <201401141340162970440@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_hJ9lYvb2mmJYXGjy_EWRa/"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201401141340162970440@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/_hJ9lYvb2mmJYXGjy_EWRa/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Jan 2014 13:40:20 +0800 majianpeng <majianpeng@gmail.com> wrote:

> For non-fullstripe-write, raid456 need read some old data no matter how
> rcw or rmw. We use compensation to recored the value about the
> additional read-data.The unit of compenstaion is PAGE_SIZE.
> Using the formula compensation*PAGE_SIZE/write_count_for_md, we can know
> the efficiency.Using this we can tune the write mode to get the best
> efficiency.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/raid5.c |   16 ++++++++++++++++
>  drivers/md/raid5.h |    5 +++++
>  2 files changed, 21 insertions(+)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index cc055da..e456134 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3116,6 +3116,7 @@ static void handle_stripe_dirtying(struct r5conf *c=
onf,
>  						 "%d for r-m-w\n", i);
>  					set_bit(R5_LOCKED, &dev->flags);
>  					set_bit(R5_Wantread, &dev->flags);
> +					atomic_inc(&conf->compensation);
>  					s->locked++;
>  				} else {
>  					set_bit(STRIPE_DELAYED, &sh->state);
> @@ -3144,6 +3145,7 @@ static void handle_stripe_dirtying(struct r5conf *c=
onf,
>  						"%d for Reconstruct\n", i);
>  					set_bit(R5_LOCKED, &dev->flags);
>  					set_bit(R5_Wantread, &dev->flags);
> +					atomic_inc(&conf->compensation);
>  					s->locked++;
>  					qread++;
>  				} else {
> @@ -5426,12 +5428,25 @@ static struct md_sysfs_entry
>  raid5_group_thread_cnt =3D __ATTR(group_thread_cnt, S_IRUGO | S_IWUSR,
>  				raid5_show_group_thread_cnt,
>  				raid5_store_group_thread_cnt);
> +static ssize_t
> +compensation_show(struct mddev *mddev, char *page)
> +{
> +	struct r5conf *conf =3D mddev->private;
> +	if (conf)
> +		return sprintf(page, "%d\n", atomic_read(&conf->compensation));
> +	else
> +		return 0;
> +}
> +
> +static struct md_sysfs_entry
> +raid5_compensation =3D __ATTR_RO(compensation);
> =20
>  static struct attribute *raid5_attrs[] =3D  {
>  	&raid5_stripecache_size.attr,
>  	&raid5_stripecache_active.attr,
>  	&raid5_preread_bypass_threshold.attr,
>  	&raid5_group_thread_cnt.attr,
> +	&raid5_compensation.attr,
>  	NULL,
>  };
>  static struct attribute_group raid5_attrs_group =3D {
> @@ -5686,6 +5701,7 @@ static struct r5conf *setup_conf(struct mddev *mdde=
v)
>  	atomic_set(&conf->active_stripes, 0);
>  	atomic_set(&conf->preread_active_stripes, 0);
>  	atomic_set(&conf->active_aligned_reads, 0);
> +	atomic_set(&conf->compensation, 0);
>  	conf->bypass_threshold =3D BYPASS_THRESHOLD;
>  	conf->recovery_disabled =3D mddev->recovery_disabled - 1;
> =20
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 01ad8ae..8fa538d 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -494,6 +494,11 @@ struct r5conf {
>  	struct r5worker_group	*worker_groups;
>  	int			group_cnt;
>  	int			worker_cnt_per_group;
> +
> +	/*For non-fullstripe-write, it need read some data
> +	 * using this filed to acount the additional data.
> +	 * The unit of compensation is PAGE_SIZE*/
> +	atomic_t		compensation;
>  };
> =20
>  /*

I have no idea what this patch is supposed to provide.  It seems to count
something.  What use is that?

If you want to be taken seriously, you need to explain clearly what benefit
the brings.  The comments you did provide say something about tuning.  Maybe
some step-by-step instructions on how you would use this new functionality =
to
tune something, and some results indication how something performed better
after the tuning.

NeilBrown

--Sig_/_hJ9lYvb2mmJYXGjy_EWRa/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUt3Urjnsnt1WYoG5AQI0Qw/9FawPrzcMdSJR5LczcZYinGEf595Q6tQO
hYskaf5Dcv40+0FusOHN2RiewU9Sg7lkdELqZDNbt3cIdm1EtxZ+of8OxqGm2Hgk
hnnxbpUb1obR7K9FjbiHd50OhLx7w3pOS6i9gk5sQmONA/nBBBr02FssFAYA/FlK
VBsRTOcQhI3PuVRHaJPh6bnDy6CgrLmbm1vIIlB9e30PYQZehSmgziG1Iv1fwbuE
/hGNQ1HjUYdlLL6P+bm+5GmtgENnrWGtBN8ATBDjciF7TRvbbQZ7yNKhn37Wncod
PgeySA9PNTJ1qMYHH+7cI8EOWGCqeFt2B0kRgYz+ejnJwgfC0hs7YgFRUwfd2YpJ
n1Tsv5YpDlPNWXHsXh6vWdWh5qtIZpH4txdQnmztAPmbZJdBXcSBeNxGnjcdlZHW
qH0y+IEvqAKHky8GdlTnXBl4WOEd2ZtDQZdkllONkWhkUwKQ2/w1YlKfhsfpykVz
lTcPJbeQEaKYVYcQEuCQCpzQ3odP4SvmtEu/W9KDCGx71f6JFwEzetaGTjM9RaR5
jh/45Lnm0faZRrK1BPMel1e5e1rmkpwidm234qO5+rzQgpfPwh2N21G2x0jh3tUL
MtCz3CkDX1WhWNUDcbh8zOwCXXCmuUeniUeEVJeSDfm4418L8Gd8bC3Xh14AcZf9
rf/fHEfuDnU=
=2sff
-----END PGP SIGNATURE-----

--Sig_/_hJ9lYvb2mmJYXGjy_EWRa/--
