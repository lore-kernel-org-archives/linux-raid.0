From: NeilBrown <neilb@suse.com>
Subject: Re: "creative" bio usage in the RAID code
Date: Mon, 14 Nov 2016 10:03:20 +1100
Message-ID: <87shqvj83r.fsf@notabene.neil.brown.name>
References: <20161110194636.GA32241@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20161110194636.GA32241@infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Nov 11 2016, Christoph Hellwig wrote:
>
> Another not quite as urgent issue is how the RAID5 code abuses
> ->bi_phys_segments as and outstanding I/O counter, and I have no
> really good answer to that either.

I would suggest adding a "bi_dev_private" field to the bio which is for
use by the lowest-level driver (much as bi_private is for use by the
top-level initiator).
That could be in a union with any or all of:
	unsigned int		bi_phys_segments;
	unsigned int		bi_seg_front_size;
	unsigned int		bi_seg_back_size;

(any driver that needs those, would see a 'request' rather than a 'bio'
and so could use rq->special)

raid5.c could then use bi_dev_private (or bi_special, or whatever it is call).

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYKPE4AAoJEDnsnt1WYoG5nfsP/j6jz/Y4rExEKTkkLuNo4jOY
r7oItn6k/XAcFfkpTTZDve3ESKLPnSdIIUBKsmzaV4N3qUzslaJLlowVSA7UMnov
9CO+Z5Dk302h6NRlIb7TcpjUO4eGfqHw6KXJwcNEMqGzRw/I+wki9i6R9E6sKbnN
M10kAAaf6XHYodBL36agxwy5+VzSXKzo3H3mkN9CxkqShkajwz5sTsAM/txTQSuy
bvCb6DjWsAo8AvxFSuCZxg0PHcLM3oZvBuZoK+P0327pM2Z0Ud2UFKkNkx5XaljD
F2vCgVrbOkfuSBb4rA7sTR4rJfaP19kw9Oh5B8Lmds3rh+xSLky+qp62w8+7NMq7
03tkKCkalQciptlMzXII/pMLqoCuutUSdYSPlYaENq+PwC+oTV9ba58mXiNSqDmy
Ap/v8jAlt0L7uCMLDmrZwZxmZSZZgYyw3pgt0UDy7eJdDpZLXkFcFZuTfj/4J0Kz
OUZsRHOc73sAhm1uxsFiz+lVGkOASQF0tDDEMBc85+hOO6eHCODAHVsJyuSLW5BN
HOFc6IjB0HrC26PxPXsOgeEw/tsM5WfklhC67dLzP8xqsOVQTShJZBnqF2Mqtd8U
K/4PRcsjdfYIYQaSSQE2KjIaI3rME4XSbTsOWypyVNTAi+2y3qSe1Uw8nZ7pCA+0
AkjtNOEgoXgeoO35WgvV
=mCSP
-----END PGP SIGNATURE-----
--=-=-=--
