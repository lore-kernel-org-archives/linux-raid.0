From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 03/10 v3] raid5: add a per-stripe lock
Date: Mon, 2 Jul 2012 17:39:53 +1000
Message-ID: <20120702173953.7bee26cb@notabene.brown>
References: <20120625072447.268095276@kernel.org>
	<20120625072613.620625574@kernel.org>
	<20120702105046.56cd47ec@notabene.brown>
	<20120702031626.GE29770@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/T7QcsnNFjTyojet9kFFl_H5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120702031626.GE29770@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/T7QcsnNFjTyojet9kFFl_H5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 2 Jul 2012 11:16:26 +0800 Shaohua Li <shli@kernel.org> wrote:


> > Then I could see what is being added and what is being removed all in t=
he one
> > patch and I can be sure that they balance.
>=20
> reworked the patch 3-5 to two patches as you suggested, and sent to you. =
please check.

Thanks.  That's looking really good.

However I think we can do better.  I've been looking more closely at the co=
de
and I think that the only things that we need stripe_lock to protect are
->toread and ->towrite, together with the following bios.  e.g.
->toread->bi_next etc.

->read and ->written don't need stripe_lock protection, as they are only
manipulated by the handle_stripe state machine which uses STRIPE_ACTIVE=20
and refcounts for exclusion.

So add_stripe_bio need to take the lock while adding a bio to the
->toread and  ->towrite lists, and ops_run_biodrain() and ops_run_biofill
need to take the lock while the move the list from ->to{read,write} to
->{read,written}.  But we don't need it anywhere else.  e.g. analyse_stripe
shouldn't need the lock at all.  Any change that could happen during the lo=
op
could equally happen after the lock was released so we don't lose by not
having the lock.

There is another current user of the lock, but I think that should be
discarded as a false optimisation.
We currently try to optimise out extra calls to bitmap_startwrite and
bitmap_endwrite when we see back-to-back writes to the one stripe.  However=
 I
suspect that is extremely unlikely and it just imposes and pointless need f=
or
synchronisation in raid5.

We just simply call bitmap_startwrite whenever ->towrite changes from NULL =
to
non-NULL, and call bitmap_endwrite whenever we clear ->written, reguardless
what value ->towrite now has.

Would you like to experiment with that?  If I haven't described it well
enough I can write a patch to show what I mean.

Thanks,
NeilBrown

--Sig_/T7QcsnNFjTyojet9kFFl_H5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/FQSTnsnt1WYoG5AQJG8w//eaC5Tsgq3OcxfKJopNGxbTaFT1oRjQ/E
xwYtrAi0C5a5lb5KM4zHGdXqvlYe/29Zey87j8Lp/h1pVdT2pDY+hYxph+IO1XdL
5CQrRdaBdC5knq+FNP1GhVkqfqLosOIwodDw26q9ABhmm1pACpHMCgznnvVJFubi
n9Kw/QgUfGXRoB1eWkLheuj9gVzMg9mDaoh9ovxNuhtSNzTXtUCEDVoiuBiggbzx
L2FV2rcuVZT24hESv8evnA99Cc9wz8fXO0KrJSmCYW5OM+Mr8USBn33AOD7hCxtf
fVqCvx8dll/dWff8QH3lr0e3HVvyRoXD79ZqqjwZuOFNkNwEkvZ2NTEoj4FbYFoG
6AlnqQicb4lN/Y+T3rNC/LlptBbe8FKOaQeDQA2wmPOx337Zic/feQL8N+nyIBlY
Tsf2QjPPv2RuZbnqynM+73jnzESlIxeqpw1KDsHX3d522jlTGjeM8QRVEqUaNSMQ
8H9qbjHBeIlznjZWXMnjvrP2cBAMl3yA3euzsALh8fx6w1enBGrgFQHJIlFi7DsP
NXCYParib5+6mkbEQXVYbMZc7yqI9a0oZ43/CJIjlNEhWQ8rdAiuW9jsVKc/ki4K
K8X7etue5gLl2rSpThHa8Mhim6Nkla8iob9v/zy7DJW9i0ua1UnjZwROoo7WZfgP
xgrTNdQW8sw=
=yFgr
-----END PGP SIGNATURE-----

--Sig_/T7QcsnNFjTyojet9kFFl_H5--
