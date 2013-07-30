From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/4] Basic hotspare handling for RAID10
Date: Tue, 30 Jul 2013 11:22:46 +1000
Message-ID: <20130730112246.59aa9eca@notabene.brown>
References: <1374778753-6252-1-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.RfOGNqsdLPgDtwbZ.7HgpJ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374778753-6252-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/.RfOGNqsdLPgDtwbZ.7HgpJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Jul 2013 20:59:09 +0200 mwilck@arcor.de wrote:

> This patch set contains a minor bug fix and code to make --fail/--add
> work with DDF/RAID10.
>=20
> Martin Wilck (4):
>   DDF: find_vdcr: fix minor bug in debug message
>   DDF: ddf_activate_spare: Add RAID10 code
>   DDF: ddf_activate_spare: only activate good drives
>   DDF: ddf_activate_spare: fix metadata update for SVDs
>=20
>  super-ddf.c |  107 ++++++++++++++++++++++++++++++++++++++++++++++++++++-=
------
>  1 files changed, 95 insertions(+), 12 deletions(-)

All applied - thanks.

NeilBrown

--Sig_/.RfOGNqsdLPgDtwbZ.7HgpJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUfcVZjnsnt1WYoG5AQKgohAAlmum/9/NPjUEA44fXOCgJoN2H8oih+Qm
NE391I3ViIARJqke3jczQoIPLtQ8tBh7irtI4igkQDK8/18Rl6lsKFBWQ5YFB/vq
mRV5cWvnp3O/U8hNlWHlks2HAUXhO86cqpVj/uUlzmxzRtohxUiCize30aGJh3qE
9zDRS7TXJBdb9ZML19Bte03z2noeaZF0VL6EyjWpaFI2h5SdXp+LDlpwtt7zPZEX
Qjbw8Z3ilff2OOQDjgZl2K0S0RZFV9T+/XEQLKznZ0NnaY1Tj94k51vAcKxxawAl
f0NI89ieAOf+CDOJFWH8tYNybqiXJHaaAskX7ymOFNIGdg+txhY29jKtkXZyr/aj
xtypeBgBnH4yB3pV1Mt4ssJa8LbEXMhNJUs4dRQumS1XZdp9FHyDRWLQTJatoWiC
l/eXXj4Gm56DkH/UfFLu+jtvN6IfwvHjbFLWySrR4Jt97BDwj7BVZR4OCZdcBh7W
nWkY3WDjEDpqgFDauVFpWHXeyMeH//rwfwHaSR8FuuE+DKimO8IiO7o/9PRkxpZB
ESPc0qSoLRM5V8aSq90YS9PrC2eWsFWTbUE5teFv1QJGIpNZXfW1bKSti0BnD4JU
66RVtqF5SoKgmalVkudwW8EuSs3hJpPNo+cP4q7CqeEYA/X6vP9eyhJ5CWWs3poh
BdqNW+XkGIc=
=cz6L
-----END PGP SIGNATURE-----

--Sig_/.RfOGNqsdLPgDtwbZ.7HgpJ--
