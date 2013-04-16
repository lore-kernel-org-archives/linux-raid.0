From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Use RAID-6!
Date: Wed, 17 Apr 2013 02:19:15 +0600
Message-ID: <20130417021915.35da6406@natsu>
References: <15345091.8.1366130671716.JavaMail.root@zimbra>
	<516DABF2.5050409@tigertech.com>
	<516DAF21.5040409@aei.mpg.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/iYjRNK1f.dPJ4vITx+.63df"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516DAF21.5040409@aei.mpg.de>
Sender: linux-raid-owner@vger.kernel.org
To: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Cc: Robert L Mathews <lists@tigertech.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/iYjRNK1f.dPJ4vITx+.63df
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 16 Apr 2013 22:05:53 +0200
Carsten Aulbert <Carsten.Aulbert@aei.mpg.de> wrote:

> The problem I find with RAID1 is that it won't protect you against
> silent corruptions (same as RAID5). What do you do if you do a through
> check and both drives claim a data block is valid and intact, but data
> differs? Do you trust disk1 or disk2?
>=20
> In that respect I think RAID1 is a step into the wrong direction :(

Then use btrfs RAID1 where every data and metadata block is checksummed and=
 in
case some array member returns blocks with invalid checksums, this is healed
from others which still have the correct ones.

(Although currently btrfs "RAID1" stores data on *two disks*, no matter how
many you have in the array; so it's a bit unconventional).

--=20
With respect,
Roman

--Sig_/iYjRNK1f.dPJ4vITx+.63df
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFtskMACgkQTLKSvz+PZwhsmACfT6USwe3ZweYLjNHx1+j8gj68
YKoAnjBOM58XGsT3ZaUXyHxY7975ZqFe
=hpT/
-----END PGP SIGNATURE-----

--Sig_/iYjRNK1f.dPJ4vITx+.63df--
