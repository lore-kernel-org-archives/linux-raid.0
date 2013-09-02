From: NeilBrown <neilb@suse.de>
Subject: Re: question about mdmon --takeover
Date: Mon, 2 Sep 2013 12:04:03 +1000
Message-ID: <20130902120403.374b0895@notabene.brown>
References: <CAC9WiBgFPSeKGBYxYCkw8DHk4dS6=aBhCeiMGgkj2eNgtY0asw@mail.gmail.com>
	<20130805165908.2d1e291b@notabene.brown>
	<CAC9WiBhab-Acx+U0NWAxki+M9sXccdEPBj=LyLPYQv3XQ_Nnxg@mail.gmail.com>
	<CAC9WiBgunq0nHC2s1sOk=2zdTwDCJZN_5VOUgqA27r1s+0PNKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+42qWwFTaI9k+kmJ_qQRkHD"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBgunq0nHC2s1sOk=2zdTwDCJZN_5VOUgqA27r1s+0PNKQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/+42qWwFTaI9k+kmJ_qQRkHD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 31 Aug 2013 22:21:36 +0200 Francis Moreau <francis.moro@gmail.com>
wrote:

> Hello Martin,
>=20
> I'm adding you in the discussion because you might have an idea on
> what's going on with my array which is using DDF metadata.

Hi Francis,
 I think this problem will be fixed by Martin's latest patch set.
The root cause seems to be that safe_mode_delay isn't being set properly
which is the same root cause as the other problem you had.

NeilBrown

--Sig_/+42qWwFTaI9k+kmJ_qQRkHD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUiPyEznsnt1WYoG5AQIuvA//XENem6S0jzO1OLIq0SkpRBIc+l4U9RCo
AUmxofgCSp9KnQEysbb2JVtqBBrYQsOqC1D41JKaR7Crdh0RGMVTlos2v25+QwP1
jd3iS81wOYKiheyYDuad/GfERTE1Q3UTcJAGTP3GD5gQ1MOtDgBPd88c13dy8cuI
L4GUeWPfLUF+saHrqmXhUytfh5SWok7LX76vysf5w/JWyklvvPOOlsJxjKgnuJ+z
ZMWk/JoJIUPmXfSSTiy1OHRkKVLJhO1upWIji6DQwuKoozHHufuvHpjJVtu1SfPx
aO8VC6HQjYCQ0armFJU99UIGIj/VF5Nrdez8VeLSbuEBq1HQhDSO6eaWs8VwU/ub
IBAqiFC0Tx4g93rhvBTt+AxQwlwk3IJ5E/HZ+Ed/QmXfK0qxvAsr8kEuLpt9eofn
FxgUTuO5BpniOHJ3yzt8CGIY/nG4cZ9tX0c7FgezMhtK0eq/FQNgYsWZvl9J/L9m
YWQIRyc4cGPajCYN2e7r0mYomTJkrF3jNP0stjgHBRuqo601KGZuNlefJynzOR/9
gJN2WqKnAklf7y3hW/RRKNVJgegw22CXgyCUQGI6+vGe761q0S4PswkTW8U3YcPa
KtZj4HaPgA0vq8Li3KpdzX0ftXpB2MFBxiuykb9aJWkInfP7SaRT1dH21KuIul1V
6IVrHklExRw=
=tobg
-----END PGP SIGNATURE-----

--Sig_/+42qWwFTaI9k+kmJ_qQRkHD--
