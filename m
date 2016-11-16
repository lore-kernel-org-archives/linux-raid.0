From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v6 04/11] md/r5cache: caching mode of r5cache
Date: Wed, 16 Nov 2016 12:08:55 +1100
Message-ID: <878tski63c.fsf@notabene.neil.brown.name>
References: <20161110204623.3484694-1-songliubraving@fb.com> <20161110204623.3484694-5-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161110204623.3484694-5-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 11 2016, Song Liu wrote:

>=20=20
> +static void
> +r5c_return_dev_pending_writes(struct r5conf *conf, struct r5dev *dev,
> +			      struct bio_list *return_bi)
> +{
> +	struct bio *wbi, *wbi2;
> +
> +	wbi =3D dev->written;
> +	dev->written =3D NULL;
> +	while (wbi && wbi->bi_iter.bi_sector <
> +	       dev->sector + STRIPE_SECTORS) {
> +		wbi2 =3D r5_next_bio(wbi, dev->sector);
> +		if (!raid5_dec_bi_active_stripes(wbi)) {
> +			md_write_end(conf->mddev);
> +			bio_list_add(return_bi, wbi);
> +		}
> +		wbi =3D wbi2;
> +	}
> +}

This loop (with minor variations) occurs 3 times in raid5.c, and how a
fourth time in raid5-cache.c.  It would be nice if it could be factored
out (maybe as an inline, maybe not) so we only have one copy of the
code.


> +
> +/*
> + * this journal write must contain full parity,
> + * it may also contain some data pages
> + */
> +static void r5c_handle_parity_cached(struct stripe_head *sh)

I don't understand how this function name corresponds to what it does or
when it is called.
It is parts of activating the WRITE_OUT action for a stripe that has (or
may have) been cached to the journal.  None of that is particularly
about "parity".


In generally the patch looks good, but it bothers me that we need to add
tests on R5_InJournal in lots and lots of places.  It makes all those
test sites more complex and so easily misunderstood.
I wonder if there is some way we could add a new flag or something that
would subsumes several of the tests.  So instead of adding a test for InJou=
rnal,
we could replace the current test with a test for something new?
Or maybe gather several tests that appear together into an inline.
Or something.

But mostly it looks good.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYK7GnAAoJEDnsnt1WYoG5XRIP/1wIIPtMDjeMaukUqqA61sOw
tcOHmfBdoFpO8hDjssMYNEyBEH6dBIOshkAZfjigPWreAJdIEM4w0RSWxCFKi9Ns
msnZO4bWH2IpM4tEbzk5rhFUMhU3q9BE9cGf1YhlMpvZf6riTAq4ovhLFEzCi4vn
iTlgMyYYCKm4aK0M8KWWsWczR+tH4FK0TBhO09NmIBDv9I0qJxaE1V1nrfAA0vAJ
lZKH/kOGh6mJrNDPqyyFWVriO1kOehd5J3xxh6LAX43pLukcIl5k7I1W02hVu6SB
3XeC/Z0Y2aPsSMpxBZrMtAh6KsrGPXPJI6AUsqvmKIZRJW8AXmBxlylBkFx803wj
3NTU8fhmHMA57BR3nXXOBXTHQlMCKF2pearhVf08vDsfS48pWM1NMnIVEa2o3A+b
pMC/QJeCu/e6oxJrgOSTmsVBi3NA936oOKs9mYRQ1rPV+5vIf4pJS0yt/DhaWxao
FLRa3SzqU2/wmlnzy0Z2FOyMO9eabmrdukJtz/a8EWvSl0om/K+H5jnVKt3rdBDi
Hzy+VS8MqvkIQMzCOQPdIln5RBPU9lLY2mswlqhFLUFxAb+MT2P2ziI9pl4oDS0O
MKdNhz7n89BH0NDYoCY+jnEPlfFT0k/hlrQ9GyYeDRbhcchtUdXwpkT52cAtGaUD
P+W+Zkld4DVrUuHfNN7n
=IVDl
-----END PGP SIGNATURE-----
--=-=-=--
