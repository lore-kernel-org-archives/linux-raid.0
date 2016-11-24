From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v4] md/r5cache: handle alloc_page failure
Date: Thu, 24 Nov 2016 17:18:33 +1100
Message-ID: <87y4099z9i.fsf@notabene.neil.brown.name>
References: <20161124051404.1969242-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161124051404.1969242-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Nov 24 2016, Song Liu wrote:

> +void r5c_use_extra_page(struct stripe_head *sh)
> +{
> +	struct r5conf *conf = sh->raid_conf;
> +	int i;
> +	struct r5dev *dev;
> +	struct page *p;
> +
> +	for (i = sh->disks; i--; ) {
> +		dev = &sh->dev[i];
> +		if (dev->orig_page != dev->page) {
> +			p = dev->orig_page;
> +			dev->orig_page = dev->page;
>  			put_page(p);
>  		}
> +		dev->orig_page = conf->disks[i].extra_page;

It seems a bit pointless to assign to dev->orig_page twice.
Why not:

  if (dev->orig_page != dev->page)
      put_page(dev->orig_page);
  dev->orig_page = conf->......

??

> @@ -2255,8 +2258,27 @@ static int resize_stripes(struct r5conf *conf, int newsize)
>  	if (ndisks) {
>  		for (i=0; i<conf->raid_disks; i++)
>  			ndisks[i] = conf->disks[i];
> -		kfree(conf->disks);
> -		conf->disks = ndisks;
> +
> +		/* allocate extra_page for ndisks */
> +		for (i = 0; i < newsize; i++) {
> +			ndisks[i].extra_page = alloc_page(GFP_NOIO);
> +			if (!ndisks[i].extra_page)
> +				err = -ENOMEM;
> +		}
> +
> +		if (err) {
> +			/* if any error, free extra_page for ndisks */
> +			for (i = 0; i < newsize; i++)
> +				if (ndisks[i].extra_page)
> +					put_page(ndisks[i].extra_page);
> +			kfree(ndisks);
> +		} else {
> +			/* if no error, free extra_page for old disks */
> +			for (i = 0; i < conf->previous_raid_disks; i++)
> +				put_page(ndisks[i].extra_page);
> +			kfree(conf->disks);
> +			conf->disks = ndisks;
> +		}

This looks a bit odd too.  We never reduce conf->pool_size, so we never
need to free anything.

 for (i = conf->pool_size; i < newsize; i++)
     if ((ndisks[i].extra_page = alloc_page(GFP_NOIO)) == NULL)
         err = -ENOMEM;
 for (i = conf->pool_size; err == -ENOMEM && i < newsize; i++)
     if (ndisks[i].extra_page)
         put_page(ndisks[i].extra_page);


Maybe that it a little terse, but something like that would be better I
think.
Certainly you don't need to free ndisks.  If the allocation succeeds,
just use the new array whether other allocations succeed or fail.

> @@ -6466,6 +6515,12 @@ static void free_conf(struct r5conf *conf)
>  	free_thread_groups(conf);
>  	shrink_stripes(conf);
>  	raid5_free_percpu(conf);
> +	for (i = 0; i < conf->raid_disks; i++)
> +		if (conf->disks[i].extra_page) {
> +			put_page(conf->disks[i].extra_page);
> +			conf->disks[i].extra_page = NULL;

There is no point setting extra_page to NULL, as the whole array is
freed on the next line.


Apart from those few little things, it looks good.  Thanks.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYNoY5AAoJEDnsnt1WYoG5ha8P/2lLNhy7lhF+afnIy0S1Ikdo
r/g3PIMOpbIrCXWYI+RDSTBF5OpBCx8fYb9TX3AqJeRtwZS6hC9+u3RAH4gY8bCt
XmFi4kj7bjojC64uQggXCUoIAurvEnDi8+BXQBV/UAhZUQ987Tzi4YMVkPhX24aj
YBktqWvDvrmEfpd+KuMn9vv+Tea9sLHUoCr2rJXctMiT6U2ZjQ2VzU+AinIi6cIB
8q+Fit4fpnEXRGrQ7ZeOF5kgEVhx7AGusJjtREQIl8GYFygLsOKvUmszc/LVv8hq
KuMzwu0kzhaTVP+AszbcqjRRkHf042I+VzZCrljljvxzYr5h5FtRviFMTNEGAc/G
zmrOUeVs4+a6dGu3O0fDT+5BQLR/si5nMQVjv1oOUdGp6dCZI82cICtuhb/jObk0
dW4WK8SnWPbdiLBezdi0S2clTKOkjk2kPmAbuATGsEUvfSnzLxtpvPY07yb7E/7r
Fsal8s3AR0ItzF5aiK05Dg6PYV+yZ06DFY38PrE/EXSoa6oLdoIGzKzfY34NMxel
fKEmY/I+v6hIkOZlQvYoYg44f8fHiRSWfeMi0CPvSb7OIieJW6hJeHYlM+GqVZ4N
xe3do5PiN5SCuArlcOrvl7nlIxhvVfdrX5h+w291qoXs77P/4i5z1N27pQXyH4AX
sO7/lmj1mfGwb0+ZhKp1
=OwhU
-----END PGP SIGNATURE-----
--=-=-=--
