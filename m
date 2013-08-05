From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] mdmon: let mdmon know the layout
Date: Mon, 5 Aug 2013 15:12:37 +1000
Message-ID: <20130805151237.72e8947d@notabene.brown>
References: <20130802081445.7222.5151.stgit@gklab-154-244.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/UvWk78uYPP1OFoMbNPxAqQM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130802081445.7222.5151.stgit@gklab-154-244.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

--Sig_/UvWk78uYPP1OFoMbNPxAqQM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 02 Aug 2013 10:14:45 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> The following commit:
>=20
> 	Fix is_resync_complete for RAID10
> 	commit 71d68ff62f945254240575cd836f5f2a09ced5d2
>=20
> requires that mdmon knows the layout.
> So make manage_new() read the layout form sysfs.
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  managemon.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/managemon.c b/managemon.c
> index 6cd93e5..7033c19 100644
> --- a/managemon.c
> +++ b/managemon.c
> @@ -650,8 +650,8 @@ static void manage_new(struct mdstat_ent *mdstat,
>  		return;
> =20
>  	mdi =3D sysfs_read(-1, mdstat->devnm,
> -			 GET_LEVEL|GET_CHUNK|GET_DISKS|GET_COMPONENT|
> -			 GET_DEGRADED|GET_SAFEMODE|
> +			 GET_LEVEL|GET_LAYOUT|GET_CHUNK|GET_DISKS|
> +			 GET_COMPONENT|GET_DEGRADED|GET_SAFEMODE|
>  			 GET_DEVS|GET_OFFSET|GET_SIZE|GET_STATE);
> =20
>  	if (!mdi)

Thanks.  I applied a very similar patch from Martin Wilck instead (his came
first:-)

Thanks,
NeilBrown

--Sig_/UvWk78uYPP1OFoMbNPxAqQM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUf80RTnsnt1WYoG5AQIZ9xAAmT6286qnyT+HXYpH4tabA5IZUwb72rob
UeGUyS/8rWS1xd/vyYIBhEHyjGnCFg8JGy27Jq4TULoDA5OIOu5FtdNHvdYShSWA
/03CHSNJ/kZEz01j7YoOV+EDcG99EwSCnt8P9lrviAeBpJP2+bJLd+QVPRdqdqNr
TQpdCmmQyRGzmsb9vCuVPci1Bo5+HNm9mfLrFb8FnaN7yrbQ9bkLlqiF9KTOSSy+
o33TtZlvUgJUHYGBr/ST9B/zdh+wUXIrF4rtWpoej/wuZBYoo1Ga0oDv/VoxX8jM
OrudDmNEXz3EqSb8HyMOWRq9dIXL7lIuIa0uMaH1/JrcmamDpt1MOb9UlnkjNkqX
lklnSBX9CuUbT1Y4nbN0RunuISc+zllRQ9uCaqdA7Zlw5QecFzHmAFOMunU/BpAf
l2v0HH/ObjZq/Ev3/UdqfO6W1TVpvBSeJXXm6Qrp7ei6KAYCUdz1yWRcLg3Zyixw
0Qfl7O91F7Vq6LIIoGemu7N8n+OfXI6xjfhX5NgRCFJwNZ5ChnxIjpljgu2tFJnq
cq9zm8gpOtMkM87U0fU+kV3UcEJ/8TeAkllWyuG+xG/7TMusZCmiRMSX37BCCiVv
eKcP7iw3w1Hsrv6HtUadG4xgnEVWL3n14QXmbBcmg4topjWSroKHnmxMdLdy2QiP
lNS+5CoykTI=
=VEy8
-----END PGP SIGNATURE-----

--Sig_/UvWk78uYPP1OFoMbNPxAqQM--
