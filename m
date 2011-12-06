From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: fix: does not allow to use invalid chunk size
Date: Tue, 6 Dec 2011 11:56:13 +1100
Message-ID: <20111206115613.77736d93@notabene.brown>
References: <20111125121204.662.4111.stgit@linux.site>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/a6/1=gnqRT/LpUNdB0FlqGK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111125121204.662.4111.stgit@linux.site>
Sender: linux-raid-owner@vger.kernel.org
To: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

--Sig_/a6/1=gnqRT/LpUNdB0FlqGK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Nov 2011 13:12:04 +0100 Przemyslaw Czarnowski
<przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:

> Only least significant bit of chunk size provided by user has been used
> in test with OROM capabilities. This way user could pass value which is
> not a power of 2.
>=20
> Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@i=
ntel.com>
> ---
>  platform-intel.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>=20
> diff --git a/platform-intel.h b/platform-intel.h
> index 6c094d7..99450ba 100644
> --- a/platform-intel.h
> +++ b/platform-intel.h
> @@ -124,11 +124,13 @@ static inline int imsm_orom_has_raid5(const struct =
imsm_orom *orom)
>  static inline int imsm_orom_has_chunk(const struct imsm_orom *orom, int =
chunk)
>  {
>  	int fs =3D ffs(chunk);
> +	int orom_chunk_bit;
> =20
>  	if (!fs)
>  		return 0;
>  	fs--; /* bit num to bit index */
> -	return !!(orom->sss & (1 << (fs - 1)));
> +	orom_chunk_bit =3D (orom->sss & (1 << (fs - 1)));
> +	return orom_chunk_bit && 1 << orom_chunk_bit =3D=3D chunk;
>  }
> =20
> =20

applied, thanks.

However it feels a bit clumsy, though maybe that is just me.
I would use a separate explicit test for "is a power of 2".
ie.

  if (chunk & (chunk-1))
        return 0; /* not a power of 2 */
  fs =3D ffs(chunk);
  return !!(orom->sss & (1 << (fs-2)));

or something like that.

NeilBrown

--Sig_/a6/1=gnqRT/LpUNdB0FlqGK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt1oLTnsnt1WYoG5AQICmA/7Byquul/ccboa8gZQH8SFo+2sQua1wjam
jqjtuNg+gqpXCkeIR/D61PWE8U3BYN62Nw/mpVjkp88k1pQsjBWvd9DvRCj+mCj5
F/15SQZ0ivP5TbDBjIJdL2ooRWlux3/u3n2XEEWmvOyRqAQpgC3XVxnPiJNcU+ge
rgN9f18kX1qeFOr2AdmOyVzhN9ZvCgyO0qmJVzz2k+bez9iogD+GqXS6hke0z5LC
JvTzOzfSgrsMC9nmhF0XevbGrPBM8K8n5e8stFrqZncebt75SPrhDT09d1a/OX2n
VDAExLG/qbx64EWi0BlR0VehEqKYIZiG/z8PCfS9ydj1YqUqOPPF1b9OWPphGUMZ
3QOAH2Lyr6GGH0kraC8HUNCclkWGuDuFOPZprxzRMFpFet5iHjQLmed0SZFXpNlh
kXcz0WesLvX3jx8Jio2ZfGHLkHb5QIuOFoe41bCZJKL7ltZZGveBf4knxoB5n/HY
CN13LTtFew3cInKL0t5wLM/OcgoHhPVahGthHhFr46apvn2fxC0qrh+/pZRE0PLT
STBa2vBrB856uJYUWLG8cllLE5XSn/CRsBPBmfzoT9sSApEljE7IVwfeba94ww7i
1V111UhFLGuu4h19QDmZGxhO91NwVPRi1YwCyfSd+Q2MOr4uvp6Xci5F2hRoWNPE
3BZI2tQ6kWw=
=R7r7
-----END PGP SIGNATURE-----

--Sig_/a6/1=gnqRT/LpUNdB0FlqGK--
