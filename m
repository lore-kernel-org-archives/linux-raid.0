From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Recovering RAID Volumes from 6 Disks
Date: Wed, 20 Jul 2016 20:07:26 +0500
Message-ID: <20160720200726.2e399266@natsu>
References: <CADsVfeyiiAgxeeATrX9UqmWb+Hr3MCf2_eMPjL8hbD7Gpj5Ksg@mail.gmail.com>
	<578E8616.4000908@youngman.org.uk>
	<CADsVfeyz=KiAqSBe11jjBT-yOWpZp_eyP_BctkjvWC5UPNLXuQ@mail.gmail.com>
	<578F8B2D.5070003@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/SbbFsmeCz6W.D5oKgyzrV7m"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <578F8B2D.5070003@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Amit Biswas <abiswas@nyu.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/SbbFsmeCz6W.D5oKgyzrV7m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Jul 2016 15:31:09 +0100
Wols Lists <antlists@youngman.org.uk> wrote:

> backing up and replacing the barracudas=20

Yeah especially the sdb and sdf ones, which are failing HARD right now.

  5 Reallocated_Sector_Ct   0x0033   095   095   036    Pre-fail Always    =
  -       7808
197 Current_Pending_Sector  0x0012   080   080   000    Old_age Always     =
  -       3359
198 Offline_Uncorrectable   0x0010   080   080   000    Old_age Offline    =
  -       3359

  5 Reallocated_Sector_Ct   0x0033   072   051   036    Pre-fail Always    =
  -       37616
187 Reported_Uncorrect      0x0032   001   001   000    Old_age Always     =
  -       587
197 Current_Pending_Sector  0x0012   001   001   000    Old_age Always     =
  -       33664
198 Offline_Uncorrectable   0x0010   001   001   000    Old_age Offline    =
  -       33664

--=20
With respect,
Roman

--Sig_/SbbFsmeCz6W.D5oKgyzrV7m
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlePk7EACgkQTLKSvz+PZwj5jwCfQsAkL8vwrhTbLiMMr12bezKb
l60AoJKAyCzq/v+7+Jm6+xMsW2KUu8pj
=kMlU
-----END PGP SIGNATURE-----

--Sig_/SbbFsmeCz6W.D5oKgyzrV7m--
