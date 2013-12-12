From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH mdadm 1/1] Clarify scope of Rebuild events in mdadm
 manpage
Date: Thu, 12 Dec 2013 13:26:53 +1100
Message-ID: <20131212132653.28f56053@notabene.brown>
References: <1386747955-7238-1-git-send-email-jan.ceuleers@computer.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZOgUekAdd+qkIS4MDN9sZE8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1386747955-7238-1-git-send-email-jan.ceuleers@computer.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Ceuleers <jan.ceuleers@computer.org>
Cc: Mark Knecht <markkecht@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ZOgUekAdd+qkIS4MDN9sZE8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Dec 2013 08:45:55 +0100 Jan Ceuleers <jan.ceuleers@computer.org>
wrote:

> To date, the manpage did not make it clear under which circumstances
> Rebuild events are generated, leading to a question on the mailing
> list as to whether it is normal for these events to be generated
> while checking an array.
> So clarify that all operations that act on the entire array are in
> scope. The list is given as "e.g.", because it might grow in the
> future as other full-array operations are added.
>=20
> Reported-by: Mark Knecht <markknecht@gmail.com>
> Signed-off-by: Jan Ceuleers <jan.ceuleers@computer.org>
> ---
>  mdadm.8.in |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/mdadm.8.in b/mdadm.8.in
> index edbedc4..ced1b50 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -2363,7 +2363,8 @@ hot-spare and resync operations which are monitored.
> =20
>  .TP
>  .B RebuildStarted
> -An md array started reconstruction. (syslog priority: Warning)
> +An md array started reconstruction (e.g. recovery, resync, reshape,
> +check, repair). (syslog priority: Warning)
> =20
>  .TP
>  .BI Rebuild NN

Applied, thanks.

NeilBrown

--Sig_/ZOgUekAdd+qkIS4MDN9sZE8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUqke8znsnt1WYoG5AQIfcQ//cpOiIawUEKXMAbwK431c5VbU4Qz4HCIL
sqDtYsG9bo+8baCxMt8hh3Z7zsJ19n0uJnhRQqaKouPWAHOp45oNieDTO8FWfTLe
PqhdMWzDI6LHh9YZjf9fgoYfPkbk521ztJcXnITvLnF6aGxbWRwHDyEPC+hqGsX3
vaxCCQ2D3Wfodvt/3q9OaiI/MMWpnlaFI6Pp3XtEBjAfOcHZxxv9VwWa/lRHu+5M
NdvA8cnhFTa1mn4gsO4ie4gMT0q+0A5DcctoHnIzTJ8SRBqiNfQ7ysaSxAr/dxn3
sZwCqSm6WRYXXw9b8SKckPxc1VgQEwefeKeLeXQFXZ22uYwgWYU4P+gL23KunjFq
eDi80kcKC0IsJJkPoHaHn86In8JPZkaSffK5xyWmuu2q7U7LMKYfdFVWlQ5ePXS/
Erg0hJrAqaUNTy+dWBdXajwhovTvyA7FhHZLdtWAnscO1ZWc6MKFF9z6WUagRP7w
8Q5gYjsPNEm3KBFbD0ifCTtNyYQwhRtGurWRv5TZT0ykrnMAZRTDl9Cwvg4ZZ/Tm
Coy3XQsmcLhsydtd6jJZtOmXuZIre77rf+QGtXS9uZFyog8goJkSRWe/dC928gSH
ko15dooD8l+JZOKFs0GlKIkAvz9tbUWjTUekXfJx8bcami2AL++esN2PwmylkciG
LdKdbV7njvY=
=M5th
-----END PGP SIGNATURE-----

--Sig_/ZOgUekAdd+qkIS4MDN9sZE8--
