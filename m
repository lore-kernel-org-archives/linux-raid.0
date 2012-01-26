From: NeilBrown <neilb@suse.de>
Subject: Re: sb->resync_offset value after resync failure
Date: Thu, 26 Jan 2012 11:41:26 +1100
Message-ID: <20120126114126.02c1c1ac@notabene.brown>
References: <CAGRgLy44uKSggEsrU4Fx7op7iVjoPPq-doMdYjxnSGDm6krf9A@mail.gmail.com>
	<CAGRgLy5B7kGDVYVqtnSUxdN9s89mPiYAp-TS7+=BirS2WhM74Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SsFAA6h_HQCTjY=SKe.n=8_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5B7kGDVYVqtnSUxdN9s89mPiYAp-TS7+=BirS2WhM74Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/SsFAA6h_HQCTjY=SKe.n=8_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Jan 2012 16:25:04 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hello Neil,
> I hope you can find some time to look at my doubts in the email below.
> Meanwhile I realized I have more doubts about resync. Hopefully, you
> will be able to give some information on those too...
>=20
> # I am looking at "--force" parameter for assembly, and also for
> "start_dirty_degraded" kernel parameters. They are actually very
> different:
> "force" marks the array as clean (sets sb->resync_offset=3DMaxSector).
> While if start_dirty_degraded=3D=3D1, kernel actually starts resyncing the
> array. For RAID5, it starts and stops immediately (correct?) But for
> RAID6 coming up with one missing drive, kernel will do the resync
> using the remaining redundant drive.
> So start_dirty_degraded=3D=3D1 is "better" then just forgetting about
> resync with "--force", isn't it? Because we will still have one parity
> block correct.

Correct.  Degraded RAID5  is either clean or faulty.  There is no sense in
which such an array can be simply "dirty" as there is no redundancy.

Singly-degraded RAID6 can be "dirty" as it still has one disk of redundancy=
=20
which could be inconsistent with the rest.  So there is an extra state that
we need to handle which we currently do no.

>=20
> Do you think the following logic is appropriate: always set
> start_dirty_degraded=3D1 kernel parameter. In mdadm during assembly
> detect dirty+degraded, and if "force" is not given - abort. If "force"
> is given, don't knock off sb->resync_offset (like code does today),
> assemble the array and let the kernel start resync (if there is still
> a redundant drive).

I would rather export mddev->ok_start_degraded via sysfs. Then mdadm can
respond to the --force flag on a dirty/degraded RAID6 by either setting the
flag if it exists, or marking the array 'clean' and starting a 'repair'.

>=20
> # I saw an explanation on the list, that for RAID6 always a full
> stripe is rewritten. Given this, I think I don't understand why the
> initial resync of the array is needed. For those areas
> never written to, the parity may remain incorrect, because reading
> data from there is not expected to return anything meaningful. For
> those areas written, the parity will be
> recalculated while writing. So reading from those areas should have
> correct parity in degraded mode. I must be missing something here for
> sure, can you tell me what?

The initial sync isn't needed and you are free to specify --assume-clean if
you like.
However I don't guarantee that RAID6 will always perform reconstruct-write
(rather than read-modify-write).
Also, most people scrub their arrays periodically and if you haven't done an
initial sync, the first time you do a scrub you will likely get a high
mismatch count, which might be confusing.

So I resync by default because it is safest.  If you know what you are doin=
g,
then explicitly disabling that is perfectly OK.

NeilBrown

--Sig_/SsFAA6h_HQCTjY=SKe.n=8_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTyChNjnsnt1WYoG5AQJglQ//QJyV4gHmLrKetrZ5wEyFwVLrG71Fsztl
reoi8rXVe8For6r1AkLHU33alDJnfm7NcgSKx7tdlCF8p7223/jI3BZm1lqkld+f
4wE4de3KLJVgNejimpWL4r1kXITufeUeFf7PIVXl2GPZGkUm3pl2D0jQjwkm6vCl
U8JmyGwM1s7BxpBpapV2ykMnnFe6BU0SlaoGGnP5FkCiebXrZSI7Zigh54n1lRWR
eX6yAVKMAYudgKbl9HXJQPzlCtI3BQSc5Xv67FDNR2amHaKGr9K5jJhngl3Db3mu
KQvSIVU1w8gnbV2atjRcSLwsO7nuo5uRWQ6MTuT+yAxT5La7Z8FeYF+0frrPkY27
7cCG749NIL42b1Csh+6YAe99w2Xwte5nSV4e6CzkLOHWM/C15Z/xHe7Y6RU0Qp4e
uH0s4ikhbQp7WhqCAkaXoqaBEvlQXtuMCxhYCahm05bmYlH8XqoqDhCmIZelZy5x
ciBnIvFqTTw0GKPlUrnUw6atwkamkTSL1jPGY4ygZzk1rqC12A9xeSFJANJ8Wgzm
EpiEn9XN10Gr16F3F7XGjvdO7euLJyPq895tPPGHkmRMQV5AAxMEvaph1V1XaGLI
4QqgTI6hU0t4i+dA5+TyGORIYGXaow63mMwEUHTIY8dZuRLzgcjhedc/cF5PDiGP
JlHpCyC61No=
=Xk1s
-----END PGP SIGNATURE-----

--Sig_/SsFAA6h_HQCTjY=SKe.n=8_--
