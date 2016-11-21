From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md/r5cache: handle alloc_page failure
Date: Mon, 21 Nov 2016 16:05:09 +1100
Message-ID: <874m31e83e.fsf@notabene.neil.brown.name>
References: <20161119072057.1302854-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161119072057.1302854-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sat, Nov 19 2016, Song Liu wrote:

> RMW of r5c write back cache uses an extra page to store old data for
> prexor. handle_stripe_dirtying() allocates this page by calling
> alloc_page(). However, alloc_page() may fail.
>
> To handle alloc_page() failures, this patch adds a small mempool
> in r5l_log. When alloc_page fails, the stripe is added to a waiting
> list. Then, these stripes get pages from the mempool (from work queue).
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5-cache.c | 100 ++++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/md/raid5.c       |  34 +++++++++++-----
>  drivers/md/raid5.h       |   6 +++
>  3 files changed, 130 insertions(+), 10 deletions(-)

This looks *way* more complex that I feel comfortable with.  I cannot
see any obvious errors, but I find it hard to be confident there aren't
any, or that errors won't creep in.

We already have mechanisms for delaying stripes.  It would be nice to
re-use those.

Ideally, when using a mempool, a single allocation from the mempool
should provide all you need for a single transaction.  For that to work
in this case, each object in the mempool would need to hold raid_disks-1
pages.  However in many cases we don't need that many, usually fewer
than raid_disks/2.  So it would be wasteful or clumsy, or both.
So I would:

 - preallocate a single set of spare pages, and store them, one each, in
   the disk_info structures.
 - add a flag to cache_state to record if these pages are in use.
 - if alloc_page() fails and test_and_set() on the bit succeeds, then
     use pages from disk_info
 - if alloc_page() fails and test_and_set() fails, set STRIPE_DELAYED
 - raid5_activate_delayed() doesn't active stripes if the flag is set,
   showing that the spare pages are in use.

I think that would be much simpler, and should be just as effective.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYMoCFAAoJEDnsnt1WYoG5CxAQAL7mAoqdx9dbbPD7qeF4nywp
7SCNnoeMHMvbWe+5WuTSURQmDNJqqp2Uh5Lt4VgszdmTmL+puS9/MgkjnDzKt+gZ
K0NI4XXLcUFeePUgTLcCkqH8v110yyQYSaHS4Mi0AOOjfWBdQ3FRbF2fSgguZ54p
tw3OGh/wpaciqJh7rbPuWDADluL9ABJBjoxuutx97gklpXjD/tbuq1PJ0QelKaOA
74yVEjlyiow2dM+lAD+dPHnjr9i3uiIU1AClmhIH7751Hu8UN/LCtPjUcFb5GTZQ
6sPyObHZ9nOtau3y4OXiG/Y0KxVWVdiO8bF2ifz45bB9ggMTPu0TS2nIBLVwhGqp
FbQxD+IOruu4H87f/9SXFy/JFVC55u1gV0L/BLlsin56TGFisIqY2lShW/I92vj1
k3TQsHLfsSIyNepF5vyOGyxUPm565W4INFbStorKkfMNgocOfWkmIB8jkHqWMiwz
7+Wjgi31F7aENfIEsbWt3pP/Ncc59NOG+7UKRsg6GiJFrA1DKI6cFfU16gUS3gRN
exZsc7IfKUQSsO925sObc1YXnKvddHjRyySAVdzFYz34oriU+v56nCqYFfAGgDL9
RRlgHSVFYVIll1z+dEDpT/+BsgWtm96SqzUgIiFRnNfplGi0ChUCA0k1UjEk62cb
GpwCFdfnfeYRV+1JTAtq
=o2uw
-----END PGP SIGNATURE-----
--=-=-=--
