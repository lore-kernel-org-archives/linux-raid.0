From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: monitor: do not finish migration if there are no
 failed disks
Date: Mon, 22 Apr 2013 16:21:55 +1000
Message-ID: <20130422162155.6a832c64@notabene.brown>
References: <20130418085136.8837.86343.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fDI_pOswmaQmM0Ewc7_ArMC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130418085136.8837.86343.stgit@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com, lukasz.dorau@intel.com
List-Id: linux-raid.ids

--Sig_/fDI_pOswmaQmM0Ewc7_ArMC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Apr 2013 10:51:37 +0200 Pawel Baldysiak
<pawel.baldysiak@intel.com> wrote:

> From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
>=20
> Transition from "degraded" to "recovery" made in OROM is slightly differe=
nt
> than the same transision in mdadm. Missing disk is not removed from list =
of
> raid devices, but just from map. Therefore mdadm should not end migration
> basing on existence of list of missing disks but should rely on count of
> failed disks.
>=20
> Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@i=
ntel.com>
> Tested-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  super-intel.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 24016b7..3f15b0f 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -6886,6 +6886,12 @@ static void handle_missing(struct intel_super *sup=
er, struct imsm_dev *dev)
>  	if (!super->missing)
>  		return;
> =20
> +	/* When orom adds replacement for missing disk it does
> +	 * not remove entry of missing disk, but just updates map with
> +	 * new added disk. So it is not enough just to test if there is
> +	 * any missing disk, we have to look if there are any failed disks
> +	 * in map to stop migration */
> +
>  	dprintf("imsm: mark missing\n");
>  	/* end process for initialization and rebuild only
>  	 */
> @@ -6896,7 +6902,8 @@ static void handle_missing(struct intel_super *supe=
r, struct imsm_dev *dev)
>  		failed =3D imsm_count_failed(super, dev, MAP_0);
>  		map_state =3D imsm_check_degraded(super, dev, failed, MAP_0);
> =20
> -		end_migration(dev, super, map_state);
> +		if (failed)
> +			end_migration(dev, super, map_state);
>  	}
>  	for (dl =3D super->missing; dl; dl =3D dl->next)
>  		mark_missing(dev, &dl->disk, dl->index);
>=20

applied, thanks.

NeilBrown

--Sig_/fDI_pOswmaQmM0Ewc7_ArMC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXTXAznsnt1WYoG5AQJOOA//TRLgQ++MU9vvZzheQ4EBdEn9z/O6i0tt
xHYNTDA7LoQo2u4XlEz++Q6w0mQsdpHFKqPTDwP21CckTX/djuhSGkMXv7GtyC4t
N/k6u9DpQs7z6e9aTGmQr3e/tkuMsyViaHNxpezN4nGb76yJJpdol5pShC/Xixf9
Ov62tHt2X8/QaOqdaReIjIzBRnpGzoGba2NAznMbeTO3+X3fsI/u+37z2cGu5o31
aWAmzBPpl+/x3GY60fK/djIAnDt53xaoEHo4d9plyJ5MVs1J0ci9LelfqsryYmsk
Ef1wKJnMwGbeGawh06KANPuzQVdqtA4dQVtUWjZeY/j2cOjvqkqQPt0g41fToezx
3pqj1gxfe7TQqsc3YKnxfoXqKmr7CFVPdGT82Pl2u7vAK4ZwYa9FuC7RulXxTr1J
tySj7VVKSHhnmGcWi2PK5nAtPCYHC2ghaIM8k+Y4SGZcrtFEq0hsrvM3cL1xVsro
KH+MKNqf9u5/vVUX75Y1GOqyJaB8QfF+1XNuz5Bm/Tv+i4JJumXjp1/JUFkCA1OC
8Xwf4nClLK50qv7OiQDSr0AxiVRHwIafIQjTXzNs7gvHU6CPUnfDmnOmnp5tHzGC
eE4PMdcPJ5c6cKIag4+TSLwGUBxcyOnw8O3rcJrMrcnAclyBPK7OBZ2m5l7zeSLS
933iVnOZS6o=
=PSwd
-----END PGP SIGNATURE-----

--Sig_/fDI_pOswmaQmM0Ewc7_ArMC--
