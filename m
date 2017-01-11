From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2 2/2] md/r5cache: enable chunk_aligned_read with write back cache
Date: Wed, 11 Jan 2017 15:10:17 +1100
Message-ID: <87bmvei6dy.fsf@notabene.neil.brown.name>
References: <20170111014251.3236610-1-songliubraving@fb.com> <20170111014251.3236610-2-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170111014251.3236610-2-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Song Liu <songliubraving@fb.com>, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Jan 11 2017, Song Liu wrote:

> Chunk aligned read significantly reduces CPU usage of raid456.
> However, it is not safe to fully bypass the write back cache.
> This patch enables chunk aligned read with write back cache.
>
> For chunk aligned read, we track stripes in write back cache at
> a bigger granularity, "big_stripe". Each chunk may contain more
> than one stripe (for example, a 256kB chunk contains 64 4kB-page,
> so this chunk contain 64 stripes). For chunk_aligned_read, these
> stripes are grouped into one big_stripe, so we only need one lookup
> for the whole chunk.
>
> For each big_stripe, struct big_stripe_info tracks how many stripes
> of this big_stripe are in the write back cache. We count how many
> stripes of this big_stripe are in the write back cache. These
> counters are tracked in a radix tree (big_stripe_tree).
> r5c_tree_index() is used to calculate keys for the radix tree.
>
> chunk_aligned_read() calls r5c_big_stripe_cached() to look up
> big_stripe of each chunk in the tree. If this big_stripe is in the
> tree, chunk_aligned_read() aborts. This look up is protected by
> rcu_read_lock().
>
> It is necessary to remember whether a stripe is counted in
> big_stripe_tree. Instead of adding new flag, we reuses existing flags:
> STRIPE_R5C_PARTIAL_STRIPE and STRIPE_R5C_FULL_STRIPE. If either of these
> two flags are set, the stripe is counted in big_stripe_tree. This
> requires moving set_bit(STRIPE_R5C_PARTIAL_STRIPE) to
> r5c_try_caching_write(); and moving clear_bit of
> STRIPE_R5C_PARTIAL_STRIPE and STRIPE_R5C_FULL_STRIPE to
> r5c_finish_stripe_write_out().
>
> Signed-off-by: Song Liu <songliubraving@fb.com>

Thanks, this looks quite good.

One thing I wonder about is reshape.  If the chunksize is being
reshaped, that would confused things.
But maybe reshaped isn't supported when the journal is in use, in
which case it wouldn't matter.

Reviewed-by: NeilBrown <neilb@suse.com>

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlh1sCkACgkQOeye3VZi
gbl5eRAAn+Mh9ZlQPsaMIvP+wXvF1m0UrnJPxLNuB3PVnNtoRl/2SXu7KyRFQPBA
E8iHWj/kGoozmqgJS5kabLjfjZWTgzq6EfDVJZ4jTSYD3aPAiTwLsyYDwo7enTkp
kMNf3CCIYDXUs6M6SSd5GxTEzkgx34OjkRNdKL2ADF8cjBDyaO/XtZ7LKeuFJ87o
tAqaZBHFPn+OZeqKJKomZXvfMWIvJU5KvTIABKEduR1gMYT8bFNmNtdb59XpOFOJ
yZUPunJvstxDAAm7fNNfVaZZGBx6AJYxApJzURjJTsjAx7WuQfje3O/zzI07rycu
Enl+P3hnsHOvZUmKoxlBQQwvevOZneKIM7v62dxqMkheey2RgzoD3Pg+WX03N5Hz
AhXoOiZyRNQ4yUZwAQM5CFSRSC3qeUcp7E4pGNsbWHGKlSntat0C5fGSmZDLSYxf
lSE7jhWnDSK4Ma7R62KQeIQRSPeYu9Tgn7pNPjGDLVvMwNgOs99D3nwzVjWxCKTO
Vp3DZuAirb47ubOtpLIdVW0ml9nuZldF0oT9ylcx6ugIhkyhMt2HcecYLhjpAkgC
bl66PQnfqufPsjuDp2OD/CZdNGI2DOmOhC1wkPVy82k/Yvk4N7viszgP989/C5KX
Y/lGtWeG29lJE34HJ5ggmeDtV1Q7kIgRIaQ/o709gzwlUwRj9iE=
=xmVW
-----END PGP SIGNATURE-----
--=-=-=--
