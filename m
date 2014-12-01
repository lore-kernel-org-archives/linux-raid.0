From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Grow: Fix wrong 'goto' in set_new_data_offset
Date: Tue, 2 Dec 2014 09:52:49 +1100
Message-ID: <20141202095249.1840e731@notabene.brown>
References: <20141127113524.8874.37994.stgit@gklab-154-222.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/2lz0+rbANVLdb+ZpPBpL_MA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141127113524.8874.37994.stgit@gklab-154-222.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

--Sig_/2lz0+rbANVLdb+ZpPBpL_MA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Nov 2014 12:35:24 +0100 Pawel Baldysiak
<pawel.baldysiak@intel.com> wrote:

> Commit a821c95f114724b38df1ea99b2858178e0ed28ce
> besides introducing additional message, also changed
> direct return to "goto" instruction.
> 'goto release' will cause routine to return with '-1',
> when previously '1' was returned.
> Described behaviour breaks e.g. IMSM reshape process.
> This patch fixes this issue by changing 'goto' to proper one -
> the one that returns '1'.
>=20
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  Grow.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index a0f7526..6ff225a 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -2257,7 +2257,7 @@ static int set_new_data_offset(struct mdinfo *sra, =
struct supertype *st,
>  			/* Metadata doesn't support data_offset changes */
>  			pr_err("%s: Metadata version doesn't support"
>  			       " data_offset changes\n", devname);
> -			goto release;
> +			goto fallback;
>  		}
>  		if (before > info2.space_before)
>  			before =3D info2.space_before;

Applied, thanks.

NeilBrown

--Sig_/2lz0+rbANVLdb+ZpPBpL_MA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVHzxQjnsnt1WYoG5AQIllQ//czHJFFZCmdKPalKfiqP66XUr8cDcotb7
dryc0s0bcXEnXV58K9cRRtzxicAFWn0aqn6jqFS6ppNeg+WhO9pmYp5ZtAD7MVFG
drUmuRvAsvQbHt/uvDiZpeAD4jIwGMpL3+/ikmz1nzJMQgvHwe2XLAq5MWmLbYnS
efuQSh1HaNCvF5S1i/By50vA+wav+Wusp7YigPgeZw6JyU02Q/Iz8kGmSAcPU++2
rVo5BCT7drtfjJKljMYaQHnHCKQR3qIwnV/bmgfQE8SbMa4BTw/t8WdiZo/Q/zpo
1C5KN2FPKNpABVgZGqKpqOOVHXnlsaIt7f+640uB3t/VFrNVa5JvULsA+b+QXA6V
FV2kcSyFR0cSwDeB+p1yjh8QRkYKC0QWOQCpAet9IB4nmmhoQe1hrsXR4uIUlonW
fUnvhXqca3iSm0q/24ZRXrZC+dFf+ujNjVnDbAaU0uIHAs2YO54DTLRDWGeKmMD5
U+oC9nvCHsyQ5L9T45I+O74ZnMh9cGZM/cbMghFnqsx9/HIZfCnnrH6XaHIP8Ntm
F/L7Tu54t7HHrSmKRFfxM5Z8iyBkL4hxDtjM09q+AxEtkOA+m9UuJKFSZrPLve5m
M074ER+INo0tXjcAMu8eCMiuwmaxb3lEPZRt0ZOmNAjuLqcqdlgeTSBikpv8j4P7
e1WAt+R735o=
=7ZxH
-----END PGP SIGNATURE-----

--Sig_/2lz0+rbANVLdb+ZpPBpL_MA--
