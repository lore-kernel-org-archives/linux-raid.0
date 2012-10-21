From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/3] Align FAILED to test name to be parsable
Date: Mon, 22 Oct 2012 09:08:55 +1100
Message-ID: <20121022090855.1bb52c91@notabene.brown>
References: <1350749002-5445-1-git-send-email-g.esp@free.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/eHV1uASDKWcT+WJL0C_0B1D"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1350749002-5445-1-git-send-email-g.esp@free.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Gilles Espinasse <g.esp@free.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/eHV1uASDKWcT+WJL0C_0B1D
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 20 Oct 2012 18:03:22 +0200 Gilles Espinasse <g.esp@free.fr> wrote:

> Signed-off-by: Gilles Espinasse <g.esp@free.fr>
>=20
> So 'grep FAILED log' is now meaningfull.
> Let both stdout and sderr be displayed after a failed test
> ---
>  test |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/test b/test
> index 9340afe..2bb482c 100755
> --- a/test
> +++ b/test
> @@ -222,12 +222,13 @@ do_test() {
>      # source script in a subshell, so it has access to our
>      # namespace, but cannot change it.
>      echo -ne "$_script... "
> -    if ( set -ex ; . $_script )  2> $targetdir/log
> +    if ( set -ex ; . $_script ) &> $targetdir/log
>      then
>        echo "succeeded"
>        _fail=3D0
>      else
> -      echo "FAILED - see $targetdir/log for details"
> +      echo "FAILED"
> +      cat $targetdir/log
>        _fail=3D1
>      fi
>      if [ "$savelogs" =3D=3D "1" ]; then

Hi,
 the patch makes some sense, but it doesn't seem to match the description,
 though maybe I'm just being dense.

 How does the patch "Align FAILED to test name" ?

Thanks,
NeilBrown

--Sig_/eHV1uASDKWcT+WJL0C_0B1D
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUIRydznsnt1WYoG5AQKbkg//bNhHmeNUSYvT60e3rb/RVLwGAd245pop
/rHeXjeRgClxAff4Eit+RwQ7vP+FcgOkdFhw0mFH32LdSal0IcoDCJT5cHFpRVzc
x4cd0YJyp5Nj17gGhmpx6gjsphErAeJBFaM4nyhyLcqslKg45FVmG/Y9BK1IbBD8
xoeXR+FqrOwUUyYVZN1bzmNVURY+GbnjNBLKY1UNztHEKU8go7pbyhHOF+hIspFQ
waDCEynVx3PJc9l+Pr3FPFrTz12BaOo/GbksGrEio7S8WhPbKpNIEaHe8YPrSpLU
7bY+7knmUqZxjAEfI5J4bmv/WNRP+uDEWgj2iWiP6xcl4i56MAABUu8R4TAPI4zp
nN3VxjReAZS/g84ga8oiOUifjwDodh2YhDooagGhq4uz4X9i5QSwPiC2p8dAm6de
UAMpz2gjT5x0dU0MDVOxqU+TtvbHNh8epuXHJPiCS/5XfiVS0JZBBfpfBiJAdFsm
Or93zBkWQlUR9ZEcfmGFQXIxRvO0FxijpSixS95PmASzFYHRkg2T6OBRuj0mUl0U
Ci3sX8PWnkMw5s2bapvthuh+J1hkr8MYCPUGcPvIYQrZxdZeacbyeCCsoVGFdz0T
PyfSduvrQLIieSlco/JpLBN6qbZiGSihg+bFX8rXVoE2eTWrpTJcqHN16RbH4etn
ojdyu7xyWkk=
=V8FR
-----END PGP SIGNATURE-----

--Sig_/eHV1uASDKWcT+WJL0C_0B1D--
