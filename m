From: NeilBrown <neilb@suse.de>
Subject: Re: commit backport request
Date: Mon, 9 Jul 2012 15:19:15 +1000
Message-ID: <20120709151915.360e44c0@notabene.brown>
References: <20120709140230.3cf926ec@notabene.brown>
	<CA+sTkh5j-eGSs7idLib-DroCD100RJec3pxQz0FciDG3o=pXCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/82j9xBf890UjLtJ_f/4cGrr"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sTkh5j-eGSs7idLib-DroCD100RJec3pxQz0FciDG3o=pXCQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Igor M Podlesny <for.poige+lsr@gmail.com>
Cc: stable@vger.kernel.org, Jose Manuel dos Santos Calhariz <jose.calhariz@netvisao.pt>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/82j9xBf890UjLtJ_f/4cGrr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Jul 2012 13:08:44 +0800 Igor M Podlesny <for.poige+lsr@gmail.com>
wrote:

> On 9 July 2012 12:02, NeilBrown <neilb@suse.de> wrote:
> >
> > Hi Mr Stable,
> >
> >  please apply patch
> >
> > commit fab363b5ff502d1b39ddcfec04271f5858d9f26e
> > Author: Shaohua Li <shli@kernel.org>
> > Date:   Tue Jul 3 15:57:19 2012 +1000
> >
> >     raid5: delayed stripe fix
> >
> >
> > to 3.4.y and 3.2.y.
> >
> > It fixes a deadlock in RAID5 which can cause all IO to hang.
>=20
>    What about RAID6 as well?
>

Yes, RAID4, RAID5, and RAID6.

NeilBrown

--Sig_/82j9xBf890UjLtJ_f/4cGrr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/pp0znsnt1WYoG5AQKiRhAAvw3boO/iqdjyixW7RVn8rK5wNPrHlCEB
tuttzwHvjFfEOn9FlKFn2CJY3drpX1xvPFVJxsdD9BzCYLPHmz3ebRtDzmb8p1y8
WPaGAVIYlwEEVN2kUc/ACrxLyz1dXBn1JAjJKgjiWwvanvutbqqUQtlGBRWz9Zyw
y1y6w4rqdCeQpBg9ilscQNtQmzdw7dv3kxm6pXd0ffGzbKfcIYyAXxrF6aBfzEAC
Z9JrVzNVEfhwT+Vkrqeqk5y2dOWTGP2tWsetrc9+yVQfp8piries8pzYcPhtvvHj
0ywyMOJT0HjCPyE547XKCh3n6uxeriKGokZBwFZ7FP8/NaSkRt5VFsp+cc4bVSPz
z5whQETpggEGJa2sR3tkB8YuRIDwU1uNsvd9y8angucrCpSQ46R0FxQTSQFGZdGd
jVRjJk5pa0vrPkGvVIIsUI8VIFlzdKOk/YHxydlXPUmh/Nw6oh7AxaRwlYeAaFvi
4qgnfHy4QkWJ1uO1oSZthvKhU/Z1fMN2fEL2b+E3hfmEmeDXBnrkSKhO5KidgSWF
mXtHarcofJu7Icf+12mnsgu9s2nrfg+FemLHIyHCE9SHhUPKBGaK1BnTjadKRTeZ
5lll4rNwnQsXCLgqbQFlcw4EnA2oRvOrn4Vk7G4X/8S6QYgJVAvFoGMqoXIFafCv
RAEcom7l6WI=
=n2kj
-----END PGP SIGNATURE-----

--Sig_/82j9xBf890UjLtJ_f/4cGrr--
