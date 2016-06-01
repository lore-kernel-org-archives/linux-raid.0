From: NeilBrown <nfbrown@novell.com>
Subject: Re: [RFC 4/5] r5cache: write part of r5cache
Date: Wed, 01 Jun 2016 13:12:53 +1000
Message-ID: <87zir5r496.fsf@notabene.neil.brown.name>
References: <1464326983-3798454-1-git-send-email-songliubraving@fb.com> <1464326983-3798454-5-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1464326983-3798454-5-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, dan.j.williams@intel.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, May 27 2016, Song Liu wrote:

> This is the write part of r5cache. The cache is integrated with
> stripe cache of raid456. It leverages code of r5l_log to write
> data to journal device.
>
> r5cache split current write path into 2 parts: the write path
> and the reclaim path. The write path is as following:
> 1. write data to journal
> 2. call bio_endio
>
> Then the reclaim path is as:
> 1. Freeze the stripe (no more writes coming in)
> 2. Calcualte parity (reconstruct or RMW)
> 3. Write parity to journal device (data is already written to it)
> 4. Write data and parity to RAID disks
>
> With r5cache, write operation does not wait for parity calculation
> and write out, so the write latency is lower (1 write to journal
> device vs. read and then write to raid disks). Also, r5cache will
> reduce RAID overhead (multipile IO due to read-modify-write of
> parity) and provide more opportunities of full stripe writes.
>
> r5cache adds a new state of each stripe: enum r5c_states. The write
> path runs in state CLEAN and RUNNING (data in cache). Cache writes
> start from r5c_handle_stripe_dirtying(), where bit R5_Wantcache is
> set for devices with bio in towrite. Then, the data is written to
> the journal through r5l_log implementation. Once the data is in the
> journal, we set bit R5_InCache, and presue bio_endio for these
> writes.

I don't think this new state field is a good idea.  We already have
plenty of state information and it would be best to fit in with that.
When handle_stripe() runs it assesses the state of the stripe and
decides what to do next.  The sh->count is incremented and it doesn't
return to zero until all the actions that were found to be necessary
have completely.  When it does return to zero, handle_stripe() runs
again to see what else is needed.

You may well need to add sh->state or dev->flags flags to record new
aspects of the state, such as whether data is safe in the log or safe in
the RAID, but I don't think a new state variable will really help.

>
> The reclaim path starts by freezing the stripe (no more writes).
> This stripes back to raid5 state machine, where
> handle_stripe_dirtying will evaluate the stripe for reconstruct
> writes or RMW writes (read data and calculate parity).
>
> For RMW, the code allocates extra page for prexor. Specifically,
> a new page is allocated for r5dev->page to do prexor; while
> r5dev->orig_page keeps the cached data. The extra page is freed
> after prexor.

It isn't at all clear to me why you need the extra page.  Could you
explain when and why the ->page and the ->orig_page would contain
different content and both of the content would be needed?

>
> r5cache naturally excludes SkipCopy. With R5_Wantcache bit set,
> async_copy_data will not skip copy.
>
> Before writing data to RAID disks, the r5l_log logic stores
> parity (and non-overwrite data) to the journal.
>
> Instead of inactive_list, stripes with cached data are tracked in
> r5conf->r5c_cached_list. r5conf->r5c_cached_stripes tracks how
> many stripes has dirty data in the cache.
>
> Two sysfs entries are provided for the write cache:
> 1. r5c_cached_stripes shows how many stripes have cached data.
>    Writing anything to r5c_cached_stripes will flush all data
>    to RAID disks.
> 2. r5c_cache_mode provides knob to switch the system between
>    write-back or write-through (only write-log).
>
> There are some known limitations of the cache implementation:
>
> 1. Write cache only covers full page writes (R5_OVERWRITE). Writes
>    of smaller granularity are write through.
> 2. Only one log io (sh->log_io) for each stripe at anytime. Later
>    writes for the same stripe have to wait. This can be improved by
>    moving log_io to r5dev.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5-cache.c | 399 +++++++++++++++++++++++++++++++++++++++++=
++++--
>  drivers/md/raid5.c       | 172 +++++++++++++++++---
>  drivers/md/raid5.h       |  38 ++++-
>  3 files changed, 577 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 5f0d96f..66a3cd5 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -40,7 +40,19 @@
>   */
>  #define R5L_POOL_SIZE	4
>=20=20
> +enum r5c_cache_mode {
> +	R5C_MODE_NO_CACHE =3D 0,
> +	R5C_MODE_WRITE_THROUGH =3D 1,
> +	R5C_MODE_WRITE_BACK =3D 2,
> +};
> +
> +static char *r5c_cache_mode_str[] =3D {"no-cache", "write-through", "wri=
te-back"};
> +
>  struct r5c_cache {
> +	int flush_threshold;		/* flush the stripe when flush_threshold buffers =
are dirty  */
> +	int mode;			/* enum r5c_cache_mode */

 why isn't this just "enum r5c_cache_mode mode;" ??

Clearly this structure is more than just statistics.  But now I wonder
why these fields aren't simply added to struct r5conf.  Or maybe in
r5l_log.


NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXTlK1AAoJEDnsnt1WYoG5K+4QAIMnrF6WDOvEnQx+sPPZ7Qyf
HniEwMC5wICRdnr6ofMqMeI7uhNKWebHdTma4V1zDPo73WAEdZtDHh215usxa/st
f+Wi2CKb2MXzm/PJNPVagpr1qK+CAMQ0YfPODO8nSNTOKi3+6CwriFW8JkSdLRFJ
XURFdYcvyv1R9b0oxFbNRL8bMgxzOxhGRg35IwlXOeCdF7hzOYRKg9Z5TKw1ZWtl
AxVY28gn2+d5zOqOgLEjZZHyX3xz/FYtdgwJ1n1Be9Jmz4tn2aaLnxhxZho/m7PF
yVPfNKMZ733dHfiPLkzpbVHaot4wo8NNpNQpVivDBKZGW5W1+bpTEv//ZgU0/i/8
fmVRTocOEYG4CW2g1LGOBU029yAjX10J5ePIhyRauVY+S8mw6WO9EmwuKgRva/vU
GXtHTG7Or2hmGegbMchG0oAX2Lk9tkCKI8FdqRknSXTfXNMRA4MCRE9TgpqINHNU
UZ1wCeNH8JHgu+rrItNt8Xa4C6lzA26G6BGKIL5d3diR6fWrCTu3mbjflh2ulomq
N0LeV+NqLF+qo0+HG390MTZ8jB6RcfD3ELR7GGeKUYyoVhArIi0mHfpgJ2ubs/3b
LiyNqgWbdeTJKjCosNB8anFgMKm93kgMnRO+0BZF8BJ3xyTTmKLn95NBIc346axX
33VKMylD4jBXTscIdgqv
=EuCx
-----END PGP SIGNATURE-----
--=-=-=--
