From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] DDF: brief_examine_subarrays_ddf: print array name
Date: Thu, 12 Sep 2013 15:47:43 +1000
Message-ID: <20130912154743.1e6f0bf9@notabene.brown>
References: <1378502781-849-1-git-send-email-mwilck@arcor.de>
	<20130909111546.2e9551b1@notabene.brown>
	<522E13EF.3080001@arcor.de>
	<20130910100151.31048cad@notabene.brown>
	<5230C98B.7030902@arcor.de>
	<5230CAAE.1020804@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qZ7js_06EQq_omSAa1M0+ba"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5230CAAE.1020804@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/qZ7js_06EQq_omSAa1M0+ba
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Sep 2013 21:55:26 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> On 09/11/2013 09:50 PM, Martin Wilck wrote:
>=20
> > That means that libstorage's way of parsing mdadm -Es output must be
> > changed, but that should be possible. Sending new patches.
>=20
> Forgot to mention: It seems that IMSM BIOS forces users to set an array
> name. LSI BIOS does not, the name is optional there. It is possible to
> have several subarrays, each without name.
>=20
>

Yes.  Names are optional.  Each array needs a UUID though.

If no name is found in the metadata or in mdadm.conf you end up with "md127"
or similar I think.

NeilBrown


--Sig_/qZ7js_06EQq_omSAa1M0+ba
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUjFVfznsnt1WYoG5AQIdBQ/+JfMszAC2r5afXBlZeG8rmDP207fTlPD2
jabJNrO1k4xUg7whelt+a5mrxpiy+nOGJPMxLab8h+bjrsO2bAF+mZ3UZWPvvsM7
n9zFPjmGX4RWBhrAImzxs0BFU+An82sfhXC/N+X0zK/L5dEuxSIQ/cXdRs7+I5Bo
z9maCHdPFhNFE2Te4D09GEFyxyimS6sQud/EUXEc3q60h7UNeezg96tkuLuoVujx
rLxYyrj1tU+FsELeq+uR/+lhz7juxARFk9bnP39rSZYGR7fAn0FG79m+j/nd0Nmt
UZWAup28oOMHM4nS3SF1w+oMdmb00Aa2UeBK/4uvI+yVl+kXt4PgMuqNlsNsOILB
8acOz/Vkmq+V3fuUGQ6jA6sZ9g9I2KZvRH0nVBD1/s471ngAANm+/cnUXavhAGjY
q9hQrMfT7Z58b9v0SNWYhVAi2lXv1ifEV8hZlypZE0PdmatNahLGZv/tfGHSJccA
oc4VrL6HVdXTIo3uhWO7ixPa3u2wZFcgZCjF1d/qAjN+eHQ+CjF0yzUNEvcKkhzH
061l06jnWZydR2tqWvKL/pxYwH6TBod0O2XTdWeEiPruNBBs2DPA1IMkosCh+6y5
5R6H6KRpsv++EIv6zMLeDdVrOIp/uzksw0Uo61KEVdvUhMgf7/RjzsY7QDCQ7d2V
fAa/bNFC1UM=
=Ctx4
-----END PGP SIGNATURE-----

--Sig_/qZ7js_06EQq_omSAa1M0+ba--
