From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 03/10 v3] raid5: add a per-stripe lock
Date: Wed, 4 Jul 2012 09:56:24 +1000
Message-ID: <20120704095624.7307c6cd@notabene.brown>
References: <20120625072447.268095276@kernel.org>
	<20120625072613.620625574@kernel.org>
	<20120702105046.56cd47ec@notabene.brown>
	<20120702031626.GE29770@kernel.org>
	<20120702173953.7bee26cb@notabene.brown>
	<201207032016270001820@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Xq5C850n468Fyjr_nDUVe_H"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201207032016270001820@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: shli <shli@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, axboe <axboe@kernel.dk>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--Sig_/Xq5C850n468Fyjr_nDUVe_H
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Jul 2012 20:16:31 +0800 majianpeng <majianpeng@gmail.com> wrote:

> On 2012-07-02 15:39 NeilBrown <neilb@suse.de> Wrote:
> >On Mon, 2 Jul 2012 11:16:26 +0800 Shaohua Li <shli@kernel.org> wrote:
> >
> >
> >> > Then I could see what is being added and what is being removed all i=
n the one
> >> > patch and I can be sure that they balance.
> >>=20
> >> reworked the patch 3-5 to two patches as you suggested, and sent to yo=
u. please check.
> >
> >Thanks.  That's looking really good.
> >
> >However I think we can do better.  I've been looking more closely at the=
 code
> >and I think that the only things that we need stripe_lock to protect are
> >->toread and ->towrite, together with the following bios.  e.g.
> >->toread->bi_next etc.
> >
> >->read and ->written don't need stripe_lock protection, as they are only
> >manipulated by the handle_stripe state machine which uses STRIPE_ACTIVE=
=20
> >and refcounts for exclusion.
> >
> >So add_stripe_bio need to take the lock while adding a bio to the
> >->toread and  ->towrite lists, and ops_run_biodrain() and ops_run_biofill
> >need to take the lock while the move the list from ->to{read,write} to
> >->{read,written}. =20

> How about xchg()?

(it would help a little if you made your comments stand out more, and maybe
be a bit more verbose).

bio_add_stripe() can insert a new bio into a list that starts are ->towrite
or ->toread.
You cannot do that with a simple xchg.  You really need a lock.

NeilBrown


--Sig_/Xq5C850n468Fyjr_nDUVe_H
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/OGqDnsnt1WYoG5AQKDBQ//bYxmy26S3YUPt880/oMW+io8+ww1w2Gv
Fm9yB1LVhyaFxE5PTWj2498bM7x0mTdwJ0dlMJ1b9js1rmiR4rhl1TFLZAJYbwf6
m60En92VPGz/DaZl+hyDZqmKh7QlhwPjcIAiY3NMEcS3K5B9EQGGeU3M/BKrbPb8
EOP4rKa2yKpFE8HsrqbcXbCE5bcrQL3QE1Ipu6r01WqqUnWQpbBrJb3lfHcX2Ax1
QIR2X/lXts4w4/yN9QIGUr9Pw3WV/OCXIQ7TBkgosv5rncVZxy2sbjnSEsoMf2+O
rxtdWdJ7Kf7/7ew9zbt95L6X+vRIa8Js25P1vTeb1fczfuD9zjmOHt1f0VH2Bxt8
FIydSuGBEkalhrEaaGTbmWrgglxthQMBrpn82Fi0enhBx2Wwj1BBRacuuaBvWznr
prXaWKqcNnKWjo7HEmEv88Jzb/J1edJ2lRbdbszEyfDVS9+raSso5NGt/FD9cMCk
cqFYGbAUQIWiFr0eabeGiicO3OOa9RJvB1NGQCu8Djxe/LlNZN6vbSLXZW+C3k8f
5U+jl9m15sXQBtPbnReT7DyARO9AU5xQL3Zo2apqABGbfjhJk9GCax9/Ed8EcrXU
p2vXf7voYLD8IFT9LMKmXri9vLWdbXEoP96KxraajOJz7jqbanI4xiB2WKibVtpC
cQaCY7OW0tU=
=tBa7
-----END PGP SIGNATURE-----

--Sig_/Xq5C850n468Fyjr_nDUVe_H--
