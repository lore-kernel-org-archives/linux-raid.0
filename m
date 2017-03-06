From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 2/3] md/raid5-cache: bump flush stripe batch size
Date: Mon, 06 Mar 2017 17:23:00 +1100
Message-ID: <87efyakjp7.fsf@notabene.neil.brown.name>
References: <cover.1487373517.git.shli@fb.com> <52a5e6f8924b9a19d4ec4ad73f6e7087f36f139d.1487373517.git.shli@fb.com> <87mvd3m58c.fsf@notabene.neil.brown.name> <20170303174138.iecwisogdkkdh6iy@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170303174138.iecwisogdkkdh6iy@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, songliubraving@fb.com, kernel-team@fb.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 03 2017, Shaohua Li wrote:

> On Fri, Mar 03, 2017 at 02:03:31PM +1100, Neil Brown wrote:
>> On Fri, Feb 17 2017, Shaohua Li wrote:
>>=20
>> > Bump the flush stripe batch size to 2048. For my 12 disks raid
>> > array, the stripes takes:
>> > 12 * 4k * 2048 =3D 96MB
>> >
>> > This is still quite small. A hardware raid card generally has 1GB size,
>> > which we suggest the raid5-cache has similar cache size.
>> >
>> > The advantage of a big batch size is we can dispatch a lot of IO in the
>> > same time, then we can do some scheduling to make better IO pattern.
>> >
>> > Last patch prioritizes stripes, so we don't worry about a big flush
>> > stripe batch will starve normal stripes.
>> >
>> > Signed-off-by: Shaohua Li <shli@fb.com>
>> > ---
>> >  drivers/md/raid5-cache.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
>> > index 3f307be..b25512c 100644
>> > --- a/drivers/md/raid5-cache.c
>> > +++ b/drivers/md/raid5-cache.c
>> > @@ -43,7 +43,7 @@
>> >  /* wake up reclaim thread periodically */
>> >  #define R5C_RECLAIM_WAKEUP_INTERVAL (30 * HZ)
>> >  /* start flush with these full stripes */
>> > -#define R5C_FULL_STRIPE_FLUSH_BATCH 256
>> > +#define R5C_FULL_STRIPE_FLUSH_BATCH 2048
>>=20
>> Fixed numbers are warning signs... I wonder if there is something better
>> we could do?   "conf->max_nr_stripes / 4" maybe?  We use that sort of
>> number elsewhere.
>> Would that make sense?
>
> The code where we check the batch size (in r5c_do_reclaim) already a chec=
k:
> total_cached > conf->min_nr_stripes * 1 / 2
> so I think that's ok, no?

I'm not sure what you are saying.

I'm suggesting that we get rid of R5C_FULL_STRIPE_FLUSH_BATCH and use a
number like "conf->max_nr_stripes / 4"
Are you agreeing, or are you saying that you don't think we need to get
rid of R5C_FULL_STRIPE_FLUSH_BATCH??

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAli9AEUACgkQOeye3VZi
gbn7mhAAjiLiwbbWToOokBqJTE09mxLRVi4HxB2+sAmHfN7IPg3LTpTgeEHSGv9r
l7DmmnWq7+z6FPXJsehd8yQS5pdgVqWR8wGFS/bJOuWXqpXEGQzKVabysNwn8tpE
4AZ3bVxq1fvNaQiw3GfAwLjqsc7PUeTVmkdxK44JAO2QqIbayhswFat+7BXKMzuX
P8jBMHwVlbFG5F81LtWdIPZO/AcYzDnXh6k8DDUNTgbg80fFocbcVagXRq/e0S7W
k1YaoW+0Rfbkl++BXJYMwV07S0sPeYq3IH+OhXCpINc8GRSGipHMRV+jHLKZvPK9
wbozGwzjZAIvQjfPsten1nVPfsqCnRgsq1N8dpDRYy35K9gymL4zaPaacR37aoJn
ZklWytsyyn+q9UJHdL4Xw9RcGRHdD5evMAUfnw+DmqbHbSWNEOuwQVE4Qv2g1MyI
04kUZjC+5makMyLpyLrWmf6b13FQKbyhHovT74mZgxT1MEw//1H95FbnMQ2MnhpQ
e42mQlb892kvgyAWATCgwjU79qoMVXDfJf1z/2erPJbr7TCg8Z6D9//hiAv3jMMd
Q4QtLV6LQbs0n7aceoo8KPtPW4fFg4yh45soHEoWZU3UkBxfzLhiffXLI4k8/19L
LilQX/aY5WkMWFmaiHrxuiKIReT8adXMA/Kpd7l94V0jF1zYSLI=
=AggB
-----END PGP SIGNATURE-----
--=-=-=--
