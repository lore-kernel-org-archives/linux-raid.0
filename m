From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/1] mdmon: Add missing option documentation to --help
 output
Date: Fri, 26 Apr 2013 08:45:45 +1000
Message-ID: <20130426084545.280298a6@notabene.brown>
References: <1366903476-30039-1-git-send-email-Jes.Sorensen@redhat.com>
	<1366903476-30039-2-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/K8n5/fXcbUhZ.Z3f.nzkrAA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1366903476-30039-2-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/K8n5/fXcbUhZ.Z3f.nzkrAA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Apr 2013 17:24:36 +0200 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Document that -a is equivalent to --all, as well as --foreground / -F
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  mdmon.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/mdmon.c b/mdmon.c
> index fd136e5..23cd7e2 100644
> --- a/mdmon.c
> +++ b/mdmon.c
> @@ -271,7 +271,8 @@ void usage(void)
>  "\n"
>  "Options are:\n"
>  "  --help        -h   : This message\n"
> -"  --all              : All devices\n"
> +"  --all         -a   : All devices\n"
> +"  --foreground  -F   : Run in foreground (do not fork)\n"
>  "  --takeover    -t   : Takeover container\n"
>  );
>  	exit(2);

Applied.  Thanks!

NeilBrown

--Sig_/K8n5/fXcbUhZ.Z3f.nzkrAA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXmyGTnsnt1WYoG5AQLfJBAApSzBHbs2WTL2jk/3+EdUSm/Uc4QPJDV/
ZNqNKk3tA41sSsd2nZTMimvJ2wHufhuKvPbnNGhFUn/G9PO0PfXFhftYJwikG66L
no64aRMhYrHEACZ+OscLjNTqQa6ONBOh940kxNb/vPrYJZ0LHxd8JdPyoRAYOoTC
1qVEBzrJtLfhLkaPzPNE9eCZ+cs05nute6P+rHQwkke3dgF0tkbztyIbx8RsTWeV
csp99DHoriAXC/uT/2oodqjIjQKwy/34BwxBipdzUYnGDcahRJZALNb7vwZJz7kv
PoyBYYDtOyDwFv7zZyiJSO712BT9BnF3IdCCBVC5qafIUR59YYMojvQjhpPY4bFZ
Hxn1hWs+HKu0CL97lBuKHnwstCzmGHQm7NFn7QA3htousS67btMgAIDratbFpmf4
8QpNSdDK7djdqFcRJRYlIcTmF9h8SJxE6/q2/8s6Pp5bPbiWaR4/HBnT8BzPLOnD
2Kmi+lrgybAOO5YweCusG3131Ut35VfJalHCE+lXrD8ITZy2jHSYEl6US2wPtD7a
STy3nmZqskhdFEL1RdeUdklyHlLq85271xkirjADkqRIESk/LeoYsDY+JLuRM7JU
QBeUo7yOBMgqwfdHmglYkfDTt/8i5NokkJDMQGCXaZPGRMlgOQZFJITqbGAaFnVx
cy/rzSuLDtQ=
=6K31
-----END PGP SIGNATURE-----

--Sig_/K8n5/fXcbUhZ.Z3f.nzkrAA--
