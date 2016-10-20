From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v5 7/8] md/r5cache: r5c recovery
Date: Thu, 20 Oct 2016 14:03:13 +1100
Message-ID: <87vawnwwlq.fsf@notabene.neil.brown.name>
References: <20161013054944.1038806-1-songliubraving@fb.com> <20161013054944.1038806-8-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161013054944.1038806-8-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Oct 13 2016, Song Liu wrote:

> This is the recovery part of raid5-cache.
>
> With cache feature, there are 2 different scenarios of recovery:
> 1. Data-Parity stripe: a stripe with complete parity in journal.
> 2. Data-Only stripe: a stripe with only data in journal (or partial
>    parity).
>
> The code differentiate Data-Parity stripe from Data-Only stripe with
> flag (STRIPE_R5C_WRITTEN).
>
> For Data-Parity stripes, we use the same procedure as raid5 journal,
> where all the data and parity are replayed to the RAID devices.
>
> For Data-Only strips, we need to finish complete calculate parity and
> finish the full reconstruct write or RMW write. For simplicity, in
> the recovery, we load the stripe to stripe cache. Once the array is
> started, the stripe cache state machine will handle these stripes
> through normal write path.
>
> r5c_recovery_flush_log contains the main procedure of recovery. The
> recovery code first scans through the journal and loads data to
> stripe cache. The code keeps tracks of all these stripes in a list
> (use sh->lru and ctx->cached_list), stripes in the list are
> organized in the order of its first appearance on the journal.
> During the scan, the recovery code assesses each stripe as
> Data-Parity or Data-Only.
>
> During scan, the array may run out of stripe cache. In these cases,
> the recovery code will also call raid5_set_cache_size to increase
> stripe cache size.
>
> At the end of scan, the recovery code replays all Data-Parity
> stripes, and sets proper states for Data-Only stripes. The recovery
> code also increases seq number by 10 and rewrites all Data-Only
> stripes to journal. This is to avoid confusion after repeated
> crashes. More details is explained in raid5-cache.c before
> r5c_recovery_rewrite_data_only_stripes().
>
> Signed-off-by: Song Liu <songliubraving@fb.com>


This patch seems to do a number of different things.
I think it re-factors the journal reading code.
It adds code to write a new "empty" journal metadata block
and it adds support for recovery of cached data.

All this together makes it hard to review.  I'd rather more smaller
patches.


> +	/* stripes only have parity are already flushed to RAID */
> +	if (data_count == 0)
> +		goto out;

Can you explain why that is?  When were they flushed to the RAID, and
how was the parity determined?


> +
> +static void
> +r5l_recovery_create_emtpy_meta_block(struct r5l_log *log,

"empty"

> +				     struct page *page,
> +				     sector_t pos, u64 seq)

> +/* returns 0 for match; 1 for mismtach */

No, please don't do that.
You can return an negative error if you like, and call it as
   function_name() < 0
 or
   function_name() == 0

or give the function a name that describes what it tests
i.e.
   r5l_data_checksum_is_correct()
or
   r5l_data_checksum_does_not_match()

and then return 0 if the test fails and 1 if it succeeds.

> +static int
> +r5l_recovery_verify_data_checksum(struct r5l_log *log, struct page *page,
> +				  sector_t log_offset, __le32 log_checksum)



Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYCDPxAAoJEDnsnt1WYoG5hiIP/3UERlPXN6hw+m0YMxZrrzDs
1gRnT8QacFrvGknvcK+KDVQSXhDIrKN3ubC+ZqDPpSZsJN6q0gDCUUd16mjx89iX
52nJpp0QhjS/nih6/QopgMm0RPpXZ5t0oXeUARiadnQ9o3bzoMAzKdBCrv+tOvNs
Guz9ZQtGkQxbtxsc6WA1bdSbsNL7J8ofGVSxjccI+eHIV2PcvuE/X79w1rtHnwwA
+1+TdJjDZ79G/bkW6e8g1KgR6dbwOHIrA/fpJfZFInFXJ5MDlwB0GiBwZ2bxliKp
a2nCuvXbCcmwEN4pHHkqPP8zDpod/Xx67+kVpqU2L2I/aVnKA5Qpr46G4YcOVvQp
d7uwgMeyRBk33sTnS5aJtK5iP3siq7vCHd18JScB/gXl6vLP3MjO3OsU7H6HrJTH
DAr0O03peoE4/AdwFz4v+YdG8v59ceZYD/OjkVXDt8DKnQ+XS7Xwb/yHFgRfh7t4
TuII1t/DK1CXD8WfqDTCTpV9ve6pxqR8Tu0rj2suKFDIWLzQaVnGhBYV7VupvbaL
ZzY3zLvr1VefORAJnv2nOBmGJY60uIVO63WQVyjEay1aSDew1NwPsMAAFS+RGfbT
v8g/fCJXawt9ISy5cuW16uJlTq+Wdw/8hvWDATwwUpTqq+8jYVLJdfhgNapNEo7F
/b1ZipATaSvs1JWTLfcd
=P3mV
-----END PGP SIGNATURE-----
--=-=-=--
