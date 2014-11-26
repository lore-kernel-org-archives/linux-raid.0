From: NeilBrown <neilb@suse.de>
Subject: Re: LVM RAID1 syncing component
Date: Thu, 27 Nov 2014 07:41:58 +1100
Message-ID: <20141127074158.2a3472f3@notabene.brown>
References: <alpine.DEB.2.02.1411242255300.12886@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/sI0lDgNh1eLKpXh_IhUI.yt"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1411242255300.12886@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/sI0lDgNh1eLKpXh_IhUI.yt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Nov 2014 23:07:32 -0500 Joe Lawrence <joe.lawrence@stratus.com>
wrote:

> Does anyone know how its possible to determine which side of an LVM RAID =
1=20
> is the stale partner during RAID resync?
>=20
> In ordinary MD RAID, I believe you can check=20
> /sys/block/md0/md/dev-XXX/state,

Why do you believe that?

During a resync (after an unclean shutdown) the devices are indistinguishab=
le.
RAID1 reads all drives and if there is a difference it chooses one data blo=
ck
to write to the others - always the one with the lowest index number.

So with md or LVM it is the same: first "first" is "copied" to the "second".

NeilBrown


>                                  but LVM RAID seems to hide those files=20
> when leveraging the MD code.  I've looked though pvs/vgs/lvs manpages, bu=
t=20
> can't figure anything out there either.
>=20
> Thanks,
>=20
> -- Joe
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/sI0lDgNh1eLKpXh_IhUI.yt
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVHY7Fjnsnt1WYoG5AQKNig/8D/hT9nNQKobwgwrawVrABW+0OP0l8c6r
3kmgyP85QsvF9edDnD7HWk/NliggfNFbEp3SVhi8OtSmFtLwcv7BIXkGhFV+xj6I
aUWGpscML5sn1mkyCuAl9qHdCveM63M1DbKqkR9sTfaFuylpvINzU20yE+5ovGJs
xsrYH492PxZ0MwYYhSoC+De5xn8UxAjZqWSq0hLdA4A1Z4C6IFOyrud7LM4Ydvx6
1420pgaVC627LJNaBUqRCRypbuU7sH5yM9Mo1W/g1ukZD3pKuLnMXRJWpEWS9Ybx
Npt+M6J0MZ+MZktcfxJFzswW7fqhW9niNaboez1bqUczJDP5QJKC1ZoE39wng82D
kJTXvefAUdirBKCXKtH8fOFU492SHn5MxulVHTpSyC4lhJkcQgrOR0bA1XZH5zXN
wa7BP3oCRs3OLaKnEDuhFmGaVT5boJjt1JtPUcwLGv/ZBmNhNus+aMPIKFvkY5tV
oXHUBrsfrYGSx5lWUgKgCISYlqN27p7nhZ1vpMNfnA+xYnRnbpkpA5vXnUS2DTvh
D9Fmt8Otb4SzvNpKiqH84Ul4K1Wq9JwkPSSuKvZct8kPYgoRG46ggYtZX+GMNSZa
FKuduFNNIkt49LINtCek0stA4Og1FzSBl1CV9dI/jBAQFaqRyjCYeFbvUZ4aeHT6
BxCn3YEmr7Y=
=B1UA
-----END PGP SIGNATURE-----

--Sig_/sI0lDgNh1eLKpXh_IhUI.yt--
