From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/4] Plugging changes for blk/md/umem
Date: Tue, 31 Jul 2012 17:25:39 +1000
Message-ID: <20120731172539.4feea95e@notabene.brown>
References: <20120726025650.32180.65163.stgit@notabene.brown>
	<50178487.4090302@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0lS8r6Ycf=2sGyZsS1/GYnR"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50178487.4090302@kernel.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

--Sig_/0lS8r6Ycf=2sGyZsS1/GYnR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 31 Jul 2012 09:08:55 +0200 Jens Axboe <axboe@kernel.dk> wrote:

> On 07/26/2012 04:58 AM, NeilBrown wrote:
> > Hi Jens,
> >  the following series makes a number of changes to plugging, moving
> >  common code from md and umem into block, and modifying it to allow
> >  md to get more value out of it.
> >  They've been sitting in -next for a while.
> >  Are you OK with me forwarding them to Linus, or would you rather they
> >  went though your tree?
>=20
> Thanks Neil, looks good. I will apply them to my tree and do some basic
> testing, too, then push it off for this round (where I haven't pushed
> out yet).
>=20

Thanks Jens,
 However I've just today discovered that the very first patch causes a real
 regression in throughput for RAID5 and while I'm sure I can fix it with a
 subsequent patch (once I figure out exactly what it happening) it might ma=
ke
 sense to hold them all back for 3.7.

 However if you would like to take them now and fix up later (it is only a
 performance regression so it won't really affect bisection) I can work with
 that.

Thanks,
NeilBrown

--Sig_/0lS8r6Ycf=2sGyZsS1/GYnR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUBeIcznsnt1WYoG5AQKjjg//Rhzi8K5LxMwN7686lFTcmfAzLm9ypwse
cQJ/iXv33qCo1cpm3sIkIhCjoXSSb7uezbNEmHCRIh5i5QRTu9B00TANRdOtcn4R
V5k2RXf4TusmdR+417YXdnj/M7sCegQib1gY5AvKkkL79ShWmlwa23WoIUeajhQ5
c8DlqXqu7UJFXe7pxT43t10QFAxUJC8Ecc7A/WsgsUtFd80ePK0v/NjotYSV0mX6
VO1nR5RX3iRyKkC5U7bWrh6bb9sp1fFi7z7PioQmrqJGKasYi0sqcyyLcZyBT0mV
m4513at5e+kiiey850v8qZl91zBhgBjKZG6ZzE8Z+PUftkkiolwmoPILq1cxdMIV
UAmjHtxhwGWn/sHmv5bilxEhRNELgmeDJdIH/fFtETWuEBGa2/j0OQWmy7iX5pg9
ylQH6NGbivX2Mi39WkFYcw2G0v1nD2juvnhT/mlIhmSqahHKX64K5oJAfULw6JbO
lc9F65xDtLVGdMRay8onIijp+z9FfRzkT6DMp/L3l+fdvHlC+7SXY7AUiFMMsXMg
+ufJQlpeFsljV7QGhXrgTFAMRrSToURnEDL08OcEXJu6AOOfBSvfo4/eUFC4558j
hQTBg4v+gKXdsMiQY4mJXPAStXEqb8Ng4K+SWGJGVKjIVgsAySheMerntBCdehYe
4/0ktvXoCs4=
=o3w9
-----END PGP SIGNATURE-----

--Sig_/0lS8r6Ycf=2sGyZsS1/GYnR--
