From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC/PATCH 0/6] DDF: safe big-endian types
Date: Tue, 23 Jul 2013 14:06:58 +1000
Message-ID: <20130723140658.20eb391b@notabene.brown>
References: <1374427704-7903-1-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Vxzgc5Llvvb2qaCDneODKz6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374427704-7903-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Vxzgc5Llvvb2qaCDneODKz6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 21 Jul 2013 19:28:18 +0200 mwilck@arcor.de wrote:

> Hi Neil, hello list,
>=20
> please review this patch series. I made so many endianness bugs
> while working on DDF during the last months that I thought this
> might be helpful - it will cause bugs to be caught by the
> compiler which may otherwise turn up as hard-to-find runtime errors.

I like this a lot - thanks!

>=20
> Note that the code  *does not* compile after each patch, only=20
> after the last one. I broke it down to make it more readable.
>=20
> Patch 0005 and 0006 are separate because they are actual minor bugs
> in the code that the endianness patch set helped me find.

I really prefer the compile to never break.  Thanks for highlighting those
two fixes more me, but I've taken the liberty of just merging them back to
where they are needed.

I applied these and all the other patches you sent and pushed it all out.

Thanks a lot!

NeilBrown


>=20
> I verified that the DDF unit tests aren't broken by this patch set.
>=20
> Martin
>=20
> Martin Wilck (6):
>   DDF: add endian-safe typedefs
>   DDF: convert big endian to be32 type
>   DDF: convert big-endian __u64 to be64 type
>   DDF: convert big-endian __u16 to be16 type
>   DDF: add_other_bvd: fix endianness bug
>   DDF: ddf_set_disk: fix minor endianness bug
>=20
>  super-ddf.c |  851 ++++++++++++++++++++++++++++++++---------------------=
------
>  1 files changed, 462 insertions(+), 389 deletions(-)


--Sig_/Vxzgc5Llvvb2qaCDneODKz6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUe4BYjnsnt1WYoG5AQLyxA//XmGJc/s45qQTNG21Z27LXM/Dr5SIwDuT
N/TRd+g7nxkJjr9Bveknkv93GBD6LhsGXMGM11tRzi9ShVBd9BIdMND+oMvPXssO
88txmHsah4AhqqkgJ9jEjiqtVwz8XUW+PXTrlaoyuxKX+7X9hZL0con3Q+dQNarC
xD8rX8wSq9x0HyngYQN9Ej8rJ2egLudId/ZjOiOTrGZVGNCWq8eb7seDR5fncoZT
DRh3Pj+jO869PBOCM2lLYeOWHAidfymsLXqPHEVL2PUlwTHHLIwcmHcEt9sH9ez/
nsInUes/nPSiOtQ6QgaR3CQ49cLt6qLi7GIeFbefbss4vO7NBGD+EYccV4z8Y5iy
JHa1Z2CtB138i8fFye7cE6jutFuTjkMFs8twyAxymDLYqRy+12rr7O8zFnggitxF
romsw1+DzYwS6ciN6yhWlY5h2e5W4eA90mIPeI12ZTRXuDP4U2LPBM+Fiq9MX7zZ
3plu4B9vFz2YVqHm3d0CjszFa43tgiBkpBZd5VT9z4HztJvQwIFQlY5FUTZUk+73
swt5kQ1nWZ3CAXHtEiHZJSsdUAVmN6znhblvbx7Cm/H8fMawBiRZAh4lXnZBetrV
yodz4Ik6tvdndlAkhyV4QY7X5sngp935+QOqFfcJoVGz+RX8xj0dHRF1pAdZqmbY
zi4LgSasDlg=
=Jc0g
-----END PGP SIGNATURE-----

--Sig_/Vxzgc5Llvvb2qaCDneODKz6--
