From: =?utf-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>
Subject: problem with bio handling on raid5 and pblk
Date: Thu, 22 Mar 2018 15:34:37 +0100
Message-ID: <66350920-EC5E-447F-B5DF-0F3C2CDEAA65@javigon.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: multipart/signed;
        boundary="Apple-Mail=_7E61F688-60F6-4A74-827F-1A88F10C6422";
        protocol="application/pgp-signature";
        micalg=pgp-sha512
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, shli@kernel.org
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Huaicheng Li <huaicheng@cs.uchicago.edu>
List-Id: linux-raid.ids


--Apple-Mail=_7E61F688-60F6-4A74-827F-1A88F10C6422
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

Hi,

I have been looking into a bug report when using pblk and raid5 on top
and I am having problems understanding if the problem is in pblk's bio
handling or on raid5's bio assumptions on the completion path.

The problem occurs on the read path. In pblk, we take a reference to
every read bio as it enters, and release it after completing the bio.

   generic_make_request()
   pblk_submit_read()
     bio_get()
     ...
     bio_endio()
     bio_put()

The problem seems to be that on raid5's bi_end_io completion path,
raid5_end_read_request(), bio_reset() is called. When put together
with pblk's bio handling:

   generic_make_request()
   pblk_submit_read()
     bio_get()
     ...
     bio_endio()
     raid5_end_read_request()
       bio_reset()
     bio_put()

it results in the newly reset bio being put immediately, thus freed.
When the bio is reused then, we have an invalid pointer. In the report
we received things crash at BUG_ON(bio->bi_next) at
generic_make_request().

As far as I understand, it is part of the bio normal operation for
drivers under generic_make_request() to be able to take references and
release them after bio completion. Thus, in this case, the assumption
made by raid5, that it can issue a bio_reset() is incorrect. But I might
be missing an implicit cross layer rule that we are violating in pblk.
Any ideas?

This said, after analyzing the problem from pblk's perspective, I see
not reason to use bio_get()/bio_put() in the read path as it is at the
pblk level that we are submitting bio_endio(), thus we cannot risk the
bio being freed underneath us. Is this reasoning correct? I remember I
introduced these at the time there was a bug on the aio path, which was
not cleaning up correctly and could trigger an early bio free, but
revisiting it now, it seems unnecessary.

Thanks for the help!

Javier


--Apple-Mail=_7E61F688-60F6-4A74-827F-1A88F10C6422
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEU1dMZpvMIkj0jATvPEYBfS0leOAFAlqzvv0ACgkQPEYBfS0l
eOCKNw//QmOPW7HQftRvCqGo7EGFfnFPmtDbwrSwFBAKMv3QJtgONYGlw/jfGW5w
w9Gm9smOTGzcpDNjZR6sYwgO28Tdg+dkce+CbR99tsLgxhlvVUQD7lDDD9g7elow
N0Nf5O7o8Zrm2jks3fMIf6tkPMcJry/35wF1xtZX1ZQ25e3RwK0qzmhovkFuW9Od
rfLlOrW32/pYjt5VeIy4JTiidmEhq86gpdF6gdU7adPqBoiCBSD0Xw44izkw0Ewh
J8MvYO11dCwmBjAsufaqnUYc2nswqoP8/rCBSdYjCUBU71dCSp+65fSp8NhqKcfl
ZlKmzf3WoflvExIp5lZnHgRIzLYILzHlQVrdotnM/qz3M5OHw1Sg9om3bfWR7Qwq
9c3Q73U4m7Wsl99idrItSDjNFESUQoT+Zp1UIxF48CiA2uRdYC8o4ldI90IFxyeS
7j0fDjtZZjXnDla5d1rlIAVIZr9Ehhl4O3zLldrKxfdNz9XrqiOhgFJAc27heCW3
g1+ENKmojNrYmtONpV2i4466ieAShPd6ZhsYZM3VubuAhJebvsy6XHamuW5+TQvk
k43stHv9NYXl1S6d9Z6kDt2I1GnZxk6hpDNqfEge8jAnG1+3y4trfr7Q8E1r4tE1
7oqEuzpWFRZwJbsw66Rb3N01hVokQuW832j+RsU4/pXqIqTy8VM=
=6EuD
-----END PGP SIGNATURE-----

--Apple-Mail=_7E61F688-60F6-4A74-827F-1A88F10C6422--
