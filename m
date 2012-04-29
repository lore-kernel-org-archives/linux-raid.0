From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] Fix sign extension of bitmap_offset in super1.c
Date: Mon, 30 Apr 2012 09:55:31 +1000
Message-ID: <20120430095531.4c10bc02@notabene.brown>
References: <1335453177-8515-1-git-send-email-Jes.Sorensen@redhat.com>
	<1335453177-8515-2-git-send-email-Jes.Sorensen@redhat.com>
	<4F99674B.7070900@redhat.com>
	<4F996800.2050603@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/d+xmraw7wkorU/s6dyeRSx8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F996800.2050603@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Doug Ledford <dledford@redhat.com>, joe.lawrence@stratus.com, linux-raid@vger.kernel.org, Richard Henderson <rth@twiddle.net>
List-Id: linux-raid.ids

--Sig_/d+xmraw7wkorU/s6dyeRSx8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Apr 2012 17:21:36 +0200 Jes Sorensen <Jes.Sorensen@redhat.com>
wrote:

> On 04/26/12 17:18, Doug Ledford wrote:
> > On 04/26/2012 11:12 AM, Jes.Sorensen@redhat.com wrote:
> >> > From: Jes Sorensen <Jes.Sorensen@redhat.com>
> >> >=20
> >> > fbdef49811c9e2b54e2064d9af68cfffa77c6e77 incorrectly tried to fix si=
gn
> >> > extension of the bitmap offset. However mdinfo->bitmap_offset is a u=
32
> >> > and needs to be converted to a 32 bit signed integer before the sign
> >> > extension.
> >> >=20
> >> > Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> > I was scratching my head over this patch, saying to myself "But won't
> > that cause us to truncate large values of bitmap_offset?"  And it will,
> > but I see your point now, that's *exactly* the problem if we don't do
> > the sign conversion before the extension, the actual bitmap_offset
> > should really be signed in order to support negative offsets, but since
> > it isn't, when we save a negative offset into bitmap_offset it appears
> > as a really large positive offset, and then when we sign extend to long,
> > it keeps the large size positive offset instead of picking up the
> > negative offset.  Gotcha.  So, I see why this works, but do you think it
> > should be fixed this way, or by converting bitmap_offset to type int32
> > instead of uint32?
>=20
> Heh, I have to admit I cheated too and asked Richard Henderson for help
> as I couldn't figure out why the sign conversion failed. Otherwise I
> would probably still have been scratching my head over it :)
>=20
> I noticed other parts of the code already handled it this way, so my fix
> is consistent with that, but we could do both. Neil?

The reason that "bitmap_offset" in 'mdp_superblock_1' is '__u32' is simply
that there is no '__s32'.
I wouldn't be against changing it, but I think you've concluded that it kee=
ps
the byte swapping simpler if we don't.

But then I read recently that Rob Pike thinks byte swapping is always wrong

http://commandcenter.blogspot.com/2012/04/byte-order-fallacy.html

so maybe we shouldn't be todo that....

I'll just take your patches as they are I think - they look good.

Thanks,
NeilBrown

--Sig_/d+xmraw7wkorU/s6dyeRSx8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT53U8znsnt1WYoG5AQI3jg/+KFR1k6w95MB+Z5x1Dup3Favw/lBTqTnI
pROeeJmlpxDZal7r47EQb2oLMb9RERf+0rKewrf3vZhOlUSxlCP58qeOw1hyQfhP
pKlDvuBKYDLso19RRr0W8qJpXiN/A6wZgFa6PJwspidLjLTTDMHdPq20xuunOUQP
MEpiJTz79l9VM4Vnnj9iww9mfCX/r1tpcZ9ge4FYYKP3JSLcyjkxL7nnTDg4xcIC
dGoIJm6ApeBAMMlJ2vGKllPAkyoWgGVm5uGI0MgR4aO8w17GlBaEfDY5GaP17K4t
9XDKZYTk7WUOvfwDQnfAGQwG9Kkl+J6Zl14aGSD/W0wVxzJ4He6bVXUmVMAp6acq
v2W5Dcrs+Wv0FtuNe5mPVEbMKPhjxUhZSr6XBWNkki3RjBSWAvdK5kunZaPSfvVR
ddv1mdDCFiKnxTRo4eGdNbLLHj2/S4a6NoZZxYU1tmg0szmZMEIk5qypNCSXDqqR
tqU6zy/FMqnwvDjGj/NUFxf32M/Xasr7wlhWD3mM05JhD3eWcORXeFcUKwT73sJm
KPbbTF/3e3PG48HBUhibXgMGCLfp8qZ8xx19yRlkoDImh9ZVz3Yp7uUZMh5z6Gll
ctfxsJ2/nWvYWhpfjmnxS7CAqstS4TzeVLBzIu2bhRIaZXqy4tQw/+nRCfYDsxsA
iL9tE21cOMM=
=7QD2
-----END PGP SIGNATURE-----

--Sig_/d+xmraw7wkorU/s6dyeRSx8--
