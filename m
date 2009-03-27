From: Andre Noll <maan@systemlinux.org>
Subject: Re: [md PATCH 4/6] md/raid5: change reshape-progress measurement to cope with reshaping backwards.
Date: Fri, 27 Mar 2009 17:19:36 +0100
Message-ID: <20090327161936.GQ17185@skl-net.de>
References: <20090324084629.15383.10271.stgit@notabene.brown> <20090324085332.15383.94300.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oiTwr10F0DlNHtiD"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090324085332.15383.94300.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--oiTwr10F0DlNHtiD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19:53, NeilBrown wrote:
> -			if (logical_sector >=3D conf->expand_progress) {
> +			if (mddev->delta_disks < 0
> +			    ? logical_sector < conf->reshape_progress
> +			    : logical_sector >=3D conf->reshape_progress) {
>  				disks =3D conf->previous_raid_disks;
>  				previous =3D 1;
>  			} else {
> -				if (logical_sector >=3D conf->expand_lo) {
> +				if (mddev->delta_disks < 0
> +				    ? logical_sector < conf->reshape_safe
> +				    : logical_sector >=3D conf->reshape_safe) {
>  					spin_unlock_irq(&conf->device_lock);
>  					schedule();
>  					goto retry;

Is it only me who finds such code hard to comprehend?  Given that
the patch adds checks of the form

	(delta < 0 && s < r) || (delta >=3D 0 && s >=3D r)

at several locations, it might make sense to introduce a marco or an
inline function for this check.

> +	/* reshape_progress is the leading edge of a 'reshape'
> +	 * It has value MaxSector when no expand is happening

s/expand/reshape

Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--oiTwr10F0DlNHtiD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJzPyYWto1QDEAkw8RAkg4AJ9lKMhnOejOxjRYk4R3daeMp5MIIQCfU/Xa
ZzhHddVzG7IdU8GUivjruF0=
=NCyb
-----END PGP SIGNATURE-----

--oiTwr10F0DlNHtiD--
