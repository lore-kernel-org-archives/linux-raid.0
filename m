From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Monitor.c (trivial) Remove bedside manner in email
 text.
Date: Wed, 3 Sep 2014 13:32:43 +1000
Message-ID: <20140903133243.535f0534@notabene.brown>
References: <1409686068-9888-1-git-send-email-kauffman@cs.uchicago.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/mxzca7+4S58OCrmT+/hgu5_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1409686068-9888-1-git-send-email-kauffman@cs.uchicago.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Kauffman <kauffman@cs.uchicago.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/mxzca7+4S58OCrmT+/hgu5_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue,  2 Sep 2014 14:27:48 -0500 Phil Kauffman <kauffman@cs.uchicago.edu>
wrote:

> The words removed are superfluous and add no value to the message.
> In addition, they imply that the message is from a person,
> which is obviously not the case.
> ---
>  Monitor.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/Monitor.c b/Monitor.c
> index 5cb24fa..74a88e1 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -402,14 +402,12 @@ static void alert(char *event, char *dev, char *dis=
c, struct alert_info *info)
>  			if (disc && disc[0] =3D=3D ' ')
>  				fprintf(mp, "Extra information:%s.\n\n", disc);
> =20
> -			fprintf(mp, "Faithfully yours, etc.\n");
> -
>  			mdstat =3D fopen("/proc/mdstat", "r");
>  			if (mdstat) {
>  				char buf[8192];
>  				int n;
>  				fprintf(mp,
> -					"\nP.S. The /proc/mdstat file"
> +					"\nThe /proc/mdstat file"
>  					" currently contains the following:\n\n");
>  				while ( (n=3Dfread(buf, 1, sizeof(buf), mdstat)) > 0)
>  					n=3Dfwrite(buf, 1, n, mp);

"superfluous" - probably.
"no value" - I did receive a comment from someone saying that the "Faithful=
ly
your" line gave them a chuckle when they needed it.

Did/do the words you would like removed actually cause a problem?
I'm inclined to not apply the patch but if you have a case which is stronger
than the one you have made so far, I will certainly listen to it.

Thanks,
NeilBrown

--Sig_/mxzca7+4S58OCrmT+/hgu5_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVAaL2znsnt1WYoG5AQLGoBAAm+MlrEhGc4wo7P9oIbskDK7JfNZ4EcOW
6MYw4xIPxEHe0SGWsIbwUGq2Kiu+746JC0UEjHW85IYC//AD9auSsKda3ijxlByX
pRX9x0WN9rQm0WNOSYocJlZpPnbF0lM5lAq4IT5KKfRhyfDXSZJ2V46bXLDagsLo
kYRJGAlajIg8gRY5xWuN/VlhE9orzW+MuH8dGrsT3xofm570ZziN4+L91XaonmnQ
LEDDGEl+h1QjzrCeN92Rp3qQX6oegtZnaVJmfKr0SPFCLmx3QLDPoEEyLzpIeRdU
0eInciGmowhFwUGHXapLcnnX3zG0QMiMxNMDzRDTMV8YZXb+R/7o8X8KXFKu6I1V
l0ftK2PzI/KmdvFhgV4qQBH4jYjFZzYOyfbGc/m4kMoGob+d56WNVyEPhatk5+VU
sjoTDGKwshL3BqPywNpNPnw/wymKIqVh6RMIN90TOBMpADXrhdLB/T7HTeMRZDCW
vhcFPGGUEai0rc9YFQp7fK3fHLDGFocgLSb5yXpNx6Pfb9aOqAWK4qNP/UXQmmwj
PbgJFEgxFnndQjzAy+ZtdTBEIwX/KPE+AjKdLPzSJ3JrgmgWRE18YNXGRTYiaC/6
BIFWndQL+wGYUlPJ1cIdFO/qC5P33pnWJ1zzrEE93065wctq+SEeFxdvlKtYxkMc
saazOysJJ7Y=
=avkV
-----END PGP SIGNATURE-----

--Sig_/mxzca7+4S58OCrmT+/hgu5_--
