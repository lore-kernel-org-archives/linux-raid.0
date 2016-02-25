From: NeilBrown <neilb@suse.de>
Subject: Re: live lock regression in raid5 reshape
Date: Fri, 26 Feb 2016 09:01:52 +1100
Message-ID: <87d1rkla9b.fsf@notabene.neil.brown.name>
References: <20160225190712.GA2390@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160225190712.GA2390@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, yuanhan.liu@linux.intel.com
Cc: linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Feb 26 2016, Shaohua Li wrote:

> Hi,
>
> I hit a live lock in reshape test, which is introduced by:
>
> e9e4c377e2f563892c50d1d093dd55c7d518fc3d(md/raid5: per hash value and exclusive wait_for_stripe)
>
> The problem is get_active_stripe waits on conf->wait_for_stripe[hash]. Assume
> hash is 0. My test release stripes in this order:
> - release all stripes with hash 0
> - get_active_stripe still sleeps since active_stripes > max_nr_stripes * 3 / 4
> - release all stripes with hash other than 0. active_stripes becomes 0
> - get_active_stripe still sleeps, since nobody wakes up wait_for_stripe[0]
>
> The system live locks. The problem is active_stripes isn't a per-hash count.
> Revert the patch makes the lock go away.
>
> I didn't come out a solution yet except reverting the patch. Making
> active_stripes per-hash is a candidate, but not sure if there is thundering
> herd problem because each hash will have less stripes. On the other hand, I'm
> wondering if the patch makes sense now. The commit log declares the issue
> happens with limited stripes, but now stripe count is automatically increased.
>

->active_stripes does seem to be the core of the problem here.

The purpose of the comparison with max_nr_stripes*3/4 was to encourage
requests to be handled in large batches rather than dribbling out one at
a time.  That should encourage the creation of full stripe writes.  I
think it does (or at least: did) help but we know it isn't perfect.
There might be a better way.

If two threads are each writing full stripes of data, we would prefer
one could allocate a full set of stripe_heads and the other one get
nothing for a little while, rather than each get half of the number of
stripe_heads that they need.

Possibly we would could impose this restriction only on the first
stripe_head in a stripe (i.e. the start of a chunk).  That should have
much the same effect but wouldn't cause the problem you are seeing.

Certainly backing this out is simplest (particularly if you want to send
it to -stable).  I suspect it would be best to ultimately keep the
hashed wait queues if we can avoid the livelock.

thanks,
NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWz3nQAAoJEDnsnt1WYoG5pqUP/RvMf++lsIKtXXs7GXM80uAf
E+WHUxttsOwiK2O/DuI9HxZ//WxNEN3zh3qjHRql3TVVxsNSU5RXSqQLTJzdgKkE
vmrefq/8BT5CWAK0Q+UXHZ3BTRvCPzLLXn0AER+ieytgkaR09Z/8IHO3SRi4GCx5
ErenS6P95aWh53XvsQRI7pQSMxuYvzlr3MPF+86ZqgdGKg2a1se7HlrLOdBJjoIF
vCDYvBcHInlDdg+E2JWRkDMNaEJ+UE3nDq+BWs7IBMAZUeTV5e3K/fek94rH/hLX
WwkZWRNQG1i6tywGlTXd2XRR+oeU7Dnww5qu2dumiksc2D1DxLauw++SiHwPBiNW
5Dw33UqQoQTdT6dr7bHc3aS3C7u8aiw7yZbBcS5/9BPBUSyhJNxv+rld4VJSFU5b
Myf4YMDGEZ1BKpGQJq1A9utTXRdQTX8N/JNOrwQ0zlWVCYHdqOkzIK0T7c1ute9l
svrSA9TU7R+5cdgV6jv/WH84SSWbPqSzlh597yIXsFUNP5Srpzaf6Y7xpZhucI9F
icwjwx9AQvQ13JC5/RFHO7eiqRjy+fOd4G/Me/TEP7wtx4/wi4WeBIk47oyPPj1g
u/VPi33SkJJYzAT1OSJIqnF+5oGag6F7IlqBRhawdg9jW+MMJaYxEC8/57dDin0E
XYgoeGKpSPOHyY6FzRC4
=8mFp
-----END PGP SIGNATURE-----
--=-=-=--
