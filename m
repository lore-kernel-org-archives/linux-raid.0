From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Nested RAID and booting
Date: Wed, 8 Jun 2011 13:27:18 +0600
Message-ID: <20110608132718.7f88bac9@natsu>
References: <D1.7A.00666.3AE0FED4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+3o2l8xcyhnKuX8fcpfBYx1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D1.7A.00666.3AE0FED4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/+3o2l8xcyhnKuX8fcpfBYx1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 8 Jun 2011 00:54:44 -0500
"Leslie Rhorer" <lrhorer@satx.rr.com> wrote:

> Will simply putting them in the mdadm.conf file prior to the RAID6 array =
do
> the trick?

Seems to work just fine for me.

Well, I also have the member array explicitly listed in a DEVICE clause,
together with physical drives. So I am not really sure if the default
"DEVICE partitions" would also include MD devices.

So in my mdadm.conf I have, roughly:=20

  DEVICE /dev/disk/by-id/ata-WDC_WD20EADS-*-part*
  DEVICE /dev/disk/by-id/ata-WDC_WD15EADS-*-part*
  DEVICE /dev/disk/by-id/ata-Hitachi_HDS*-part*
  DEVICE /dev/md1
  ARRAY /dev/md1 UUID=3D...................................
  ARRAY /dev/md0 UUID=3D...................................

...where md1 is a member of md0.

--=20
With respect,
Roman

--Sig_/+3o2l8xcyhnKuX8fcpfBYx1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3vJFYACgkQTLKSvz+PZwhcBwCfWTjHs17ISjYIvhMcrReUL7Zd
h+sAn2XlEG+EHdbCybfl09wtd2juTuxK
=j/4D
-----END PGP SIGNATURE-----

--Sig_/+3o2l8xcyhnKuX8fcpfBYx1--
