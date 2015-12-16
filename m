From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] raid5-cache: add journal hot add/remove support
Date: Thu, 17 Dec 2015 09:50:34 +1100
Message-ID: <87bn9q9fet.fsf@notabene.neil.brown.name>
References: <2f750625c6c016754fabfab98b84e6f2719bb0e5.1450300354.git.shli@fb.com> <2b10b1d8988431c43f013fecc28008fb4585c888.1450300354.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2b10b1d8988431c43f013fecc28008fb4585c888.1450300354.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Dec 17 2015, Shaohua Li wrote:

> Add support for journal disk hot add/remove. Mostly trival checks in md
> part. The raid5 part is a little tricky. For hot-remove, we can't wait
> pending write as it's called from raid5d. The wait will cause deadlock.
> We simplily fail the hot-remove. A hot-remove retry can success
> eventually since if journal disk is faulty all pending write will be
> failed and finish. For hot-add, since an array supporting journal but
> without journal disk will be marked read-only, we are safe to hot add
> journal without stopping IO (should be read IO, while journal only
> handles write IO).

This and previous patch both applied - thanks.
(will push things out to for-next next later today I hope)

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWceq6AAoJEDnsnt1WYoG5+fcP/04fR0lkfWwN0JdYke2oedIO
NNxCyFN3Mtxkg7ULv+hd3M1eb649sQIbfSXt//M6R5YQKpflMhjHPHCOsZNF4HFF
bhMS/eu9cKrFswezZp2mEjbTSQ2b1QluEMLawmHU2a/6qJliIpACW6/rOEV5W9JB
R/5PfASM/FG2snRUKGey3ARHWMOie3KP+KdP0MibpT2Nnq5yNM4rxbkR6WGZGi/A
Owmq01degpjxju/bMhDe8NqmlY+/ToAsQFaQ9dZ2wZ+pIydZ+LJlA73yiyOgqSSG
/oo2HBpovNfVnD9dNY+NKpUHKbiR1OsigD1bkznxdre/HIhxwfGtBNLV5izJ55Pz
ukAvCQben3kj3rfo37jsCt12iHxAoxigJCnP2bJAGEJcH7fuS70/8OKyno42+ryg
rZ8rk9TNwn6x+paY4fiJg3BXPfesu1p2nalcmfrdY7CRkxpXhlgEAA9H2K6ZdejQ
k7mhE+WCkeBAAiyfP6MJB7VMNxmWSk3K9pqJprSIOzoq4Qx+WVa8m1+9r/zX6DqC
e/IRPXKcUMtFAgFdvbL9FUEaZG//gSUhygTtJsAgeBL+lE/bW0RqA43QvUzAl1uG
kA5WPg74KLLPZQF9WJL5zmd7+ZIpKn/qDYZxkJBCODOv+JYX49g8/VVM+PKPELPc
wD81LDKjpluwVTbWd1Zr
=0wrP
-----END PGP SIGNATURE-----
--=-=-=--
