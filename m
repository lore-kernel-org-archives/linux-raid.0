From: Roman Mamedov <rm@romanrm.net>
Subject: Re: [PATCH 0/1] RFC: Unreliable discard performance can cripple
 RAID1
Date: Wed, 24 Jun 2015 10:00:14 +0500
Message-ID: <20150624100014.7d1e9842@natsu>
References: <1435105573-1373-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/MNOfM9r9sOJlfmv0Wo.VGce"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1435105573-1373-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/MNOfM9r9sOJlfmv0Wo.VGce
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Jun 2015 20:26:12 -0400
Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Neil,
>=20
> I have been hitting issues with discard being ridiculously slow on
> arrays with certain typs of SSDs that seem to serialize discard
> processing.
>=20
> This is particularly bad as I have seen systems where the IMSM BIOS
> defaults to 4KB chunk size, combined with these badly performing
> drives, it could bump the mkfs on an array from seconds to over 40
> minutes. Most users will stick to the defaults and then hit the
> problem during install without understanding why it goes wrong :(
>=20
> The problem is that there is no way to benchmark our way to this or
> somehow test if a drive performs discard at reasonable speed. I
> suggest we take an approach similar to that of RAID456 and default to
> disabling discard, except for the case where the user knows the drives
> are safe.
>=20
> Thoughts?

It's very unfortunate if you would cripple all the good SSD models because =
of
a few bad ones. No one will remember to explicitly put the override to enab=
le
TRIM, or perhaps even know that it gets disabled in md in the first place. =
The
only thing they will later notice is lowered performance and lifespan of th=
eir
SSDs.

Also most importantly, shouldn't this be handled in the lower level (indivi=
dual
block devices), and not in md? There's already a mechanism to blacklist TRIM
on some specific SSD models (see libata-core), maybe there should be a way =
to
disable it by default. Or if those SSDs you mentioned really make it unusab=
le,
maybe they should be just blacklisted as well.

--=20
With respect,
Roman

--Sig_/MNOfM9r9sOJlfmv0Wo.VGce
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlWKOV8ACgkQTLKSvz+PZwgaQgCfWFF5phKex19KdrRyLLb2jH2q
4S0An0gvpwPAJPwbdBn82fmTkDoazpei
=G1tA
-----END PGP SIGNATURE-----

--Sig_/MNOfM9r9sOJlfmv0Wo.VGce--
