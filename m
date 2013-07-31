From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 00/10] Two bug fixes and a lot of debug code
Date: Wed, 31 Jul 2013 13:10:27 +1000
Message-ID: <20130731131027.73a0ec0f@notabene.brown>
References: <51F82D3B.6060104@arcor.de>
	<1375219114-5626-1-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/faj3OPUP+WOWj92gHQ/jK67"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1375219114-5626-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/faj3OPUP+WOWj92gHQ/jK67
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 30 Jul 2013 23:18:24 +0200 mwilck@arcor.de wrote:

> From: Martin Wilck <mwilck@arcor.de>
>=20
> This patch series fixes the "suspicious test failure" mentioned
> in an earlier posting to linux-raid, and another bug introduced
> by myself. Besides, it contains a lot of DEBUG code that was=20
> necessary to understand the "suspicious" problem.
>=20
> Verified that the 09 and 10 unit test series are not broken.
>=20
> Martin Wilck (10):
>   DDF: ddf_activate_spare: bugfix for 62ff3c40
>   DDF: log disk status changes more nicely
>   DDF: ddf_process_update: log offsets for conf changes
>   DDF: load_ddf_header: more error logging
>   DDF: ddf_set_disk: add some debug messages
>   monitor: read_and_act: log status when called
>   mdmon: wait_and_act: fix debug message for SIGUSR1
>   mdmon: manage_member: debug messages for array state
>   mdmon: manage_member: fix race condition during slow meta data writes
>   tests/10ddf-create-fail-rebuild: new unit test for DDF
>=20
>  managemon.c                     |   11 +++++-
>  monitor.c                       |   25 +++++++++++--
>  super-ddf.c                     |   75 +++++++++++++++++++++++++++++----=
-----
>  tests/10ddf-create-fail-rebuild |   77 +++++++++++++++++++++++++++++++++=
++++++
>  4 files changed, 166 insertions(+), 22 deletions(-)
>  create mode 100644 tests/10ddf-create-fail-rebuild

Thanks. All applied with one small change as already mentioned.

NeilBrown

--Sig_/faj3OPUP+WOWj92gHQ/jK67
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUfiAIznsnt1WYoG5AQIJjQ//b7FWdkMBVqZ6GdCDMI9z8iuFIxx5M4kb
iFq68UW9KzkZBTvSc1Pjaeuz8tKLv649wMavYcykO8uMI54/qdR6NEZ5w/GyxzLl
PvkvUdJag9XDNdsIlrXXtPl34sty4+NgOlY78nkovJPaeLZ53lYrLR1T8u7ZRjIA
hpLcdlmcehpBtF5z86JvdYLk4ZbBJ/mmruhenSaDGCV0fZ583f/EEy5coZjqoFa5
CmzMiaNv1FO7mz3GKalB81W6PK6MHeqR86jrN7qTFlEZjoke0htGGtMMn6h/oAdO
X/mxd+vaBDyzSh+P9IDE3PQIaIvPzvRI/IyRloW2B9y9pkOz3AYt+XX6k9bpjwcn
XMMtXjXvs8jVrVybW3XIGxbCnzdrrFnDeuwihXt/28e2l3ygjOMz4Dy7/nx3KPow
IoVRlBZDDTiQQlc6HPU/Fo56Nh2Fo4lI7WS6gza4zyYLYFCjsIytnWjg7si+Jk4x
eraHd9oDqMQ0fbK/RzsXAN4b89K2GIR/h0uJU9Dzo9S/ianEmuVlEN9Q3+utTbSq
6nOzixHV23HxamTPUTe3F/fAWm9p9irCT/xxUa/CQZ1lQH4DVr38ouJEYBwOrEdP
v9LRRNxNa5zs8BMbjBlxZTVFV1jF9M9rVuNZmjDwOSAr1WI9xWZM13O94Y+uM5Gu
J8APO3z/cho=
=sfEu
-----END PGP SIGNATURE-----

--Sig_/faj3OPUP+WOWj92gHQ/jK67--
