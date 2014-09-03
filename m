From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/1] Grow: Report when grow needs metadata update
Date: Wed, 3 Sep 2014 13:28:10 +1000
Message-ID: <20140903132810.4e593b3c@notabene.brown>
References: <20140824130939.461501b4@notabene.brown>
	<1409345232-24837-1-git-send-email-andy@strugglers.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/dR7wtQG.bk+46Lf2u+KV0Xw"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1409345232-24837-1-git-send-email-andy@strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@strugglers.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/dR7wtQG.bk+46Lf2u+KV0Xw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 29 Aug 2014 20:47:12 +0000 Andy Smith <andy@strugglers.net> wrote:

> Report when the array's metadata needs updating instead of just
> reporting the generic "kernel too old" message.
>=20
> Signed-off-by: Andy Smith <andy@strugglers.net>
> ---
>  Grow.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index a9c8589..76bb35a 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -2255,7 +2255,9 @@ static int set_new_data_offset(struct mdinfo *sra, =
struct supertype *st,
>  		if (info2.space_before =3D=3D 0 &&
>  		    info2.space_after =3D=3D 0) {
>  			/* Metadata doesn't support data_offset changes */
> -			return 1;
> +			pr_err("%s: Metadata version doesn't support"
> +			       " data_offset changes\n", devname);
> +			goto release;
>  		}
>  		if (before > info2.space_before)
>  			before =3D info2.space_before;

Applied, thanks.

NeilBrown

--Sig_/dR7wtQG.bk+46Lf2u+KV0Xw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVAaKyjnsnt1WYoG5AQJSzw/+KXpGF3OXLcczSbERh6+NQ1rjNNS4X2BU
tyNyE/Mt6iR6awmNkAjUirfV9/iLGIrjNtKkveH/TXnllpxfMULLn4ivqrdqa/91
+umNsaLyIY3URTofwjhzX6sQTXzkAAXIoovLxumj0UwjbjkKh++DUAHZu5yZQ5oh
u1RrXAWjDZUGRNnbownF+qE8LR7hQGEDFQgpk/uVgl8CPpyKAH7aK+DTzq9w9ULT
v2uBJ0qbI9BdFB2KjgTTUP5Dkub/nChZMDoAfRIrWuL7gMMj7qClT0PxYg32qWjC
apUNc46nOrD6L6/au4/lPpdzYuNIMLpTokLteF9qAEXrU3tWMxDu/9XIt52D+ewF
VMvY6mhV8WX7MHZreAABDnNiJqVkTbtoPDh88vHvjt826qjcI8JPBAZbR1zgEWQS
U/F94vS8WDbuV87yzVUq/xDsEeTm6VZLPZmvpTNHDYbkDNJW7FlUDDzufvokyTV1
h3m0GMf360epQvfRMCY+6h+MZPksRD+0IBMK/o5HfgksL2AGf4UWoZfMZ0RtnOhG
3GdMdIa34obYshbvJ74Pe1iyPXMP2mh8Hp4Wm6pvPeQMLYZrm8ckCrntVetXQm38
JVwbK2Jm5tnQPk4cm0ykx+le5jj99GGKqgAxCPLftfS9wjcYGMEzzGDfJJwgixv+
E+7TAHYW/LU=
=4WuQ
-----END PGP SIGNATURE-----

--Sig_/dR7wtQG.bk+46Lf2u+KV0Xw--
