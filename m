From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/3] md/bitmap: Delete an unnecessary check before the
 function call "kfree"
Date: Tue, 3 Feb 2015 06:46:03 +1100
Message-ID: <20150203064603.1ae5cfec@notabene.brown>
References: <5307CAA2.8060406@users.sourceforge.net>
	<alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
	<530A086E.8010901@users.sourceforge.net>
	<alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	<530A72AA.3000601@users.sourceforge.net>
	<alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	<530B5FB6.6010207@users.sourceforge.net>
	<alpine.DEB.2.10.1402241710370.2074@hadrien>
	<530C5E18.1020800@users.sourceforge.net>
	<alpine.DEB.2.10.1402251014170.2080@hadrien>
	<530CD2C4.4050903@users.sourceforge.net>
	<alpine.DEB.2.10.1402251840450.7035@hadrien>
	<530CF8FF.8080600@users.sourceforge.net>
	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	<530DD06F.4090703@users.sourceforge.net>
	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<54CF93BB.40206@users.sourceforge.net>
	<54CF95CA.90102@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/6/ZrM9HD6FUceyxl9CY/AX8"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54CF95CA.90102@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

--Sig_/6/ZrM9HD6FUceyxl9CY/AX8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 02 Feb 2015 16:20:42 +0100 SF Markus Elfring
<elfring@users.sourceforge.net> wrote:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 2 Feb 2015 15:10:57 +0100
>=20
> The kfree() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
>=20
> * This issue was detected by using the Coccinelle software.
>=20
> * Let us also move an assignment for the variable "pages" to the place
>   directly before it is really needed for a loop.
>=20
> * Let us also move another kfree() call into a block which should belong
>   to a previous check for the variable "bp".
>=20
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/md/bitmap.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index da3604e..47d72df 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -1586,15 +1586,15 @@ static void bitmap_free(struct bitmap *bitmap)
>  	bitmap_file_unmap(&bitmap->storage);
> =20
>  	bp =3D bitmap->counts.bp;
> -	pages =3D bitmap->counts.pages;
> =20
>  	/* free all allocated memory */
> -
> -	if (bp) /* deallocate the page memory */
> +	if (bp) { /* deallocate the page memory */
> +		pages =3D bitmap->counts.pages;
>  		for (k =3D 0; k < pages; k++)
> -			if (bp[k].map && !bp[k].hijacked)
> +			if (!bp[k].hijacked)
>  				kfree(bp[k].map);
> -	kfree(bp);
> +		kfree(bp);
> +	}
>  	kfree(bitmap);
>  }
> =20

Hi,
 I'm somewhat amused that you removed a test for one kfree, but imposed a
 test on another.  I realised the second test was already there, but why not
 just:

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index da3604e73e8a..ad13b2e1bf1f 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1592,7 +1592,7 @@ static void bitmap_free(struct bitmap *bitmap)
=20
 	if (bp) /* deallocate the page memory */
 		for (k =3D 0; k < pages; k++)
-			if (bp[k].map && !bp[k].hijacked)
+			if (!bp[k].hijacked)
 				kfree(bp[k].map);
 	kfree(bp);
 	kfree(bitmap);


It makes the intention of the patch much clearer.

I'd probably prefer to leave the code as it is.  I don't think either patch
is really an improvement in readability, and readability trumps performance
in places like this.

Thanks,
NeilBrown

--Sig_/6/ZrM9HD6FUceyxl9CY/AX8
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVM/T/Dnsnt1WYoG5AQKbig//c528vXYW1/Z2m/oKP+mQAiwysNiS/qqp
FpTQSFnOCAER/rWef8Y+VTl02E7Q7GhYWNLsraftD8RETSqD8YZ8u2IeGCaoAfIi
AfgL4xjHBg+JB1hN3rLSLLtPPSpGUF2Oev5bHUf/ztNplNpwnTs1Gj+cgTJyKgee
7HNxha+71ll+S+9i1qH0/A/pAFkrzaTp6uN+JNtxMHMOUTE1XEt0WB4pozpb+K9h
cDtV7aj+URYSDjmoQrv2CdiCEC2EdTJnbbp8ifqTPflYFYFO5xNH0NqJE388Me68
txBmjmSDATSaRNcyk9OAB7pdTzQvaypsxRs+I6wNJtLzMY01brtSkiyiCUKUn3Qi
SaNmg/BXNno9/Bvrzsvw7qq0p7YkTgb8WfG0jxv0hGO58urfru9wAKKwFJbNcurA
Rog31I5cfmeyLglUdxRIBVnllCOPSyHZjge5+otpDsT6+V0UsEZU/kpppjxbNkoP
75UJxou1jI9g5TyFCEZFPmC11JI/uyJHhILu+03UYFat9nkkkqYMHnN6Nu6TnP7i
3nOPELxi/BQxxL6oiV0aLHvejA266mqYug/N/omB6smHcCq86QyG0blszsrqihda
byCZ0QwEGNiFp9Zkd3s0v8PFEGFbN+8/JlmQhTIv+HXsTvkiAlzEGJCctpLVDxp/
Nga6KDYr3dE=
=g19a
-----END PGP SIGNATURE-----

--Sig_/6/ZrM9HD6FUceyxl9CY/AX8--
