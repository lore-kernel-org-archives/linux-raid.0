From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Considering a complete rework of RAID on my home compute server
Date: Thu, 6 Jan 2011 15:45:04 +0500
Message-ID: <20110106154504.133bd7d6@natsu>
References: <AANLkTinsQoPVaYVe4H9kMK7_-GFzHoKt_Zdf4nUKc+C2@mail.gmail.com>
	<87.68.02631.5E6052D4@cdptpa-omtalb.mail.rr.com>
	<20110106054754.44e7fe1a@natsu>
	<AANLkTikb=bNr3iDj36Bz3zRd9RhfSZLQ40d3AFy4Up7E@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//ICpnWGndYcbOYX4MgV4O6k"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikb=bNr3iDj36Bz3zRd9RhfSZLQ40d3AFy4Up7E@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_//ICpnWGndYcbOYX4MgV4O6k
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 6 Jan 2011 00:05:31 -0200
Roberto Spadim <roberto@spadim.com.br> wrote:

> could we implement a more flexible raid1? maybe with checksum?

> what's the `new` raid1 with checksum idea?

There is BTRFS RAID1 which already does checksum verification:
https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices

--=20
With respect,
Roman

--Sig_//ICpnWGndYcbOYX4MgV4O6k
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0lnTAACgkQTLKSvz+PZwgy7wCfQtKfpczOIBxuOuDfXF/hjvtG
CG4AnjKH2s2gF1rCNGp1To5zhttyry9m
=ku3Q
-----END PGP SIGNATURE-----

--Sig_//ICpnWGndYcbOYX4MgV4O6k--
