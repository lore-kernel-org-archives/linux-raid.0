From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] fix: imsm: re-enable size expansion to the max value
Date: Thu, 20 Sep 2012 12:32:08 +1000
Message-ID: <20120920123208.2c8059aa@notabene.brown>
References: <20120914140408.18473.68610.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/m3D0WFtWdJHB0iQORvx=i76"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120914140408.18473.68610.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com, ed.ciechanowski@intel.com, Jacek.Danecki@intel.com
List-Id: linux-raid.ids

--Sig_/m3D0WFtWdJHB0iQORvx=i76
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 14 Sep 2012 16:04:08 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> Size expansion to the 'max' value has been broken since
> the following patch:
>=20
>     commit d04f65f48c93e7e57cc3c1d70dd07d094dece717
>     Change the values for "max size" from -1 to 1.
>=20
> This patch re-enables it.
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  super-intel.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index d11eabd..1d36613 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -9737,7 +9737,7 @@ enum imsm_reshape_type imsm_analyze_change(struct s=
upertype *st,
>  	 */
>  	current_size =3D info.custom_array_size / data_disks;
> =20
> -	if (geo->size > 0) {
> +	if ((geo->size > 0) && (geo->size !=3D MAX_SIZE)) {
>  		/* align component size
>  		 */
>  		geo->size =3D imsm_component_size_aligment_check(

Applied, thanks.

NeilBrown


--Sig_/m3D0WFtWdJHB0iQORvx=i76
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFqAKDnsnt1WYoG5AQLwrA//f4aNwrRKkpc3UJoRAM7zVYgdvqtNr/1q
KqTuQOsQmKBbT+v/CuRW1ntN69PAgXxZVAMH71oA1Lvs28DR98wn7yTYsJeoErBj
2+Xsc38w2RDRzFZ0kaYd/cQynUWa7mbGIH0lMDHR2klobFx0YxrDKfqJIyYlyuSL
bCPfaWtYfjrdNseeXwO7ddSQC2lcSLWFlJyOIqlx2tEzx5i9PHam5m7UV0cuS9sF
s9cmXYlbF9TIq1vgMvK3NLfwsLQLI2SiV6R/60uBpx/cpBkHOJ5nXSYV91yoPy7+
ysaOQdGE22WHOm/Bag4eheM5/Hsx8lQypUb0qlkTQad4l2GqNyVn23jhv1gWK7tB
c/Zndf8nBegxDpYGh+YtAmijtOrxSbu1cyA/eN4+1ah4hd+KEIEZOoW3sjCLeg27
oOCwQ7g8QiiK4fBCymKewx0ZSgASK64f4mO+oY5E1qFwb7UCe3W+7JIXw+WBmyRq
q3+hdrvHIdyi41vV+XJVhysGY7sIW8Gd8DdteOCA/s699sT8bCHARIn/bNl3fWOA
r2DcPB0VetNyXspSmfajEWVKdusUTEcz4V7ToAvNNxRmn5AClJLsiRExZqIFtY8h
t2lipfvq6lpaGb+A2/w/ABDu8+BCOkz6zZusbegcUMiPVMYkTLDeJGRrJ7m2SWRX
mn72wMDlhMk=
=qG8m
-----END PGP SIGNATURE-----

--Sig_/m3D0WFtWdJHB0iQORvx=i76--
