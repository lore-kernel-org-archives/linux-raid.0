From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 3/3] raid5: relieve lock contention in
 get_active_stripe()
Date: Tue, 27 Aug 2013 13:17:52 +1000
Message-ID: <20130827131752.4d5ba375@notabene.brown>
References: <20130812022434.507702228@kernel.org>
	<20130812022549.013010221@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6vfFSTul2bpck7pwM16OpVB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130812022549.013010221@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, djbw@fb.com
List-Id: linux-raid.ids

--Sig_/6vfFSTul2bpck7pwM16OpVB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Aug 2013 10:24:37 +0800 Shaohua Li <shli@kernel.org> wrote:

> get_active_stripe() is the last place we have lock contention. It has two
> paths. One is stripe isn't found and new stripe is allocated, the other is
> stripe is found.

Hi Shaohua Li,
 thanks for the patch.  I think it is a good idea but it needs more work.
But first we will need to fix some bugs ... in md.c and in your patch.

>=20
> The first path basically calls __find_stripe and init_stripe. It accesses
> conf->generation, conf->previous_raid_disks, conf->raid_disks,
> conf->prev_chunk_sectors, conf->chunk_sectors, conf->max_degraded,
> conf->prev_algo, conf->algorithm, the stripe_hashtbl and inactive_list. E=
xcept
> stripe_hashtbl and inactive_list, other fields are changed very rarely.

Yes, those fields don't change very often, but our current locking doesn't
properly protect against them changing.
In particular in "make_request()", if  raid5_start_reshape() changes these
fields between the point where reshape_progress is seen to be MaxSector, and
where get_active_stripe() is called, get_active_stripe will return the wrong
stripe.

I think we should probably introduce a seqlock to protect these fields.
It is very cheap to get a read-lock on a seqlock so we can do that every ti=
me
we enter make_request.

Then get_active_stripe wouldn't need to worry about device_lock at all and
would only need to get the hash lock for the particular sector.  That should
make it a lot simpler.

Also your new shrink_stripes() and similar code in resize_stripes is wrong.
It seems to assume that the stripe_heads will be evenly distributed over all
hash values, which isn't the case.

In particular, shrink_stripes() will stop calling drop_one_stripe() as soon
as any inactive_list is empty, but it must continue until all inactive lists
are empty.

I'll add the seqlock and push that out to my for-next branch, and then you
can rebase this patch on top of that.

Thanks,
NeilBrown


--Sig_/6vfFSTul2bpck7pwM16OpVB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUhwaYDnsnt1WYoG5AQLMCA//b6Z+eLX66X2j/11Ph9Y4eFdjKViiumEZ
6VBOjp7qP6KngqEqevyMiCXMHDDEEycq1ELDE8ZmBufxikn15rS4cyvySQmjkd0D
rCCJ1LwjMVdsj2+AeAiS7Tzechc/fecUwRWqn+Px3NGIi/0Ik38+drpFKFnFw7HS
JbT4gtS/qLqA1b6wePEAjB36Y8M8kMc214TX7l+ipmMMQls01CDtz75DIjWZaORx
A9D6S+ZG7bucrVq4iG7cI2XSjPlVaJUnslKGg58CN70+YMk3TJb49Y9s3RQ+JEcW
25FesBGZXCJAO9+vTup0073F9BSgU4+B12lbgozvY4M4tr4UJVXW84Hjj4BpdiON
jDpQchODRuHIhZaurxzTG7q29RlJege4MKDTijMGPT79INL6h8oBaTQCzjHl63Eq
l7gym7Ir/eqRqJMjOrm0y2iezHKiq8POx7Z/pkZRXMNMB60gtswkDaMPAdhLm0a3
qVLp0NzrkVwmsc+Wnx70n3cGdhGhMNMYF7PXhVVliBj7nUTkW5G2b3nzTUEL552m
8EUV8FMMwT+uGlQPGflYapLCBdVNRiFhLu2VqLukTF/dAqIo1boAH+j0UX4FaZu6
Pp3yXzzhCj25D27NIpKSbHsVKRtlzTTUaZoPV5stXNbmHeg+qYBE8v5Ly4XL9d1F
N5pZ6FyBGtE=
=xOgv
-----END PGP SIGNATURE-----

--Sig_/6vfFSTul2bpck7pwM16OpVB--
