From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] FIX: mdmon doesn't start
Date: Mon, 7 Nov 2011 11:46:16 +1100
Message-ID: <20111107114616.580d7b0f@notabene.brown>
References: <20111103165532.8864.80753.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Uw64r0aEA1qGkLfkUj3KEn7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111103165532.8864.80753.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

--Sig_/Uw64r0aEA1qGkLfkUj3KEn7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 03 Nov 2011 17:55:33 +0100 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> When array is not clean dismounted directory /dev/.mdadm is not cleaned u=
p.
> On array re-assembly read pid is not valid and it is not possible
> to connect to monitor. This causes mdmon to exit and array remains
> not monitored.
> Problem is introduced by fix:
>    mdmon(): Error out if failing to connect to victim monitor
>    819c158866f466075a1c719f0dc496deb2fb3814
>=20
> This is critical for container reshape when mdmon is should finish reshap=
e.
> when reshape is not finished, array is reshaped again by mdadm.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  mdmon.c |   15 ++++++++++-----
>  1 files changed, 10 insertions(+), 5 deletions(-)
>=20
> diff --git a/mdmon.c b/mdmon.c
> index bdcda0e..5ac7cd6 100644
> --- a/mdmon.c
> +++ b/mdmon.c
> @@ -458,11 +458,16 @@ static int mdmon(char *devname, int devnum, int mus=
t_fork, int takeover)
> =20
>  	victim =3D mdmon_pid(container->devnum);
>  	if (victim >=3D 0) {
> -		victim_sock =3D connect_monitor(container->devname);
> -		if (victim_sock < 0) {
> -			fprintf(stderr, "mdmon: %s unable to connect monitor\n",
> -				container->devname);
> -			exit(3);
> +		/* It is possible that mdmon that wrote pid file was killed.
> +		 * check if read pid is valid/mdmon is running
> +		 */
> +		if (mdmon_running(victim)) {
> +			victim_sock =3D connect_monitor(container->devname);
> +			if (victim_sock < 0) {
> +				fprintf(stderr, "mdmon: %s unable to connect "
> +					"monitor\n", container->devname);
> +				exit(3);
> +			}
>  		}
>  	}
> =20

Thanks for the patch.
I decided to revert the patch that originally caused the problem instead - =
it
really isn't needed.
I then added a patch to make sure we never use victim_sock when it is -1.
The places were we might have used it we not dangerous at all, but it is
cleaner to check.

Thanks,
NeilBrown

--Sig_/Uw64r0aEA1qGkLfkUj3KEn7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrcqWDnsnt1WYoG5AQL9fxAAoIkWYZbxFQ2V2Y7enF0h+EPuy2XrDixG
5DFnUEqoqFNkpzl6rky2eWsm4sf8E1XWYL53FFAXMPxPMBAvJ/i2i2eF8SVAxnUd
OfDa3z4USZAidSjoFkZ0KB1noSl8kJo7JHuZeQupQ29iVj7HD047pVg8k7/Ht2kY
HzlU8jjcwdsw0pyjnHpZ/kHApE3ZEQPV9XyE2xsAHhfOnXY3sC+e+GwOAW1SZvTU
ouyXBYW4REbtLdz4WnFK07YT8DoQ2FELxxmDipHXG0kLMn0XpgcyQ1XT4pid3o/E
OOs7ii0e0VMZKZajig+Dq22TE/hrTlC9tRWJB4j1KM4XmYK8K65sgMfK4wxLC0lJ
KOzABLAWeOwuaA17CidoKZa7g/FdfMctmynuIqIk6RdUzvd5XNPobPqjwomuETbI
uZQ1oM3D2lxMcOlPzttU1568No9bXWF+zMy1ok8bFx2dm0a9LgksDWShddwnc+Ep
da8qKxY8t5lwhCjTA/VeHtr9krvAsEx/PrrRHNe1Dm5Ik+ct4w8YJraBz7dce44e
BTkpjQLrhEOk4oobilXM6pE2txpkmGAY6KozIrV3Ayb5g/98RKmVo7NdN0GlwSoF
h/bYB2Gk7dVOfH2dN4YSR0sH98MyIopncczgsl54H7LeEuN88uqJ4ihB61G6ThQr
WKQaIDrfua0=
=CsKB
-----END PGP SIGNATURE-----

--Sig_/Uw64r0aEA1qGkLfkUj3KEn7--
