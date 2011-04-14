From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, system
 unresponsive
Date: Thu, 14 Apr 2011 10:08:23 +0600
Message-ID: <20110414100823.5529feac@natsu>
References: <BANLkTinc-+cb-ZLJBr7m4283xf_MjZ2VmQ@mail.gmail.com>
	<541553.42147.qm@web65113.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SMb7Rs82iz_2Pe+Ep1tjeuu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <541553.42147.qm@web65113.mail.ac2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Flower <gavinflower@yahoo.com>
Cc: Mathias =?UTF-8?B?QnVyw6lu?= <mathias.buren@gmail.com>, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/SMb7Rs82iz_2Pe+Ep1tjeuu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 13 Apr 2011 17:15:42 -0700 (PDT)
Gavin Flower <gavinflower@yahoo.com> wrote:

> Note that smart reports no bad blocks.

It reports 24 bad blocks:

183 Runtime_Bad_Block       0x0032   076   076   000    Old_age   Always
-       24

Try running a long SMART self test on the drive (smartctl -t long /dev/sdX).

Also for a bit of common sense - why not just try the disk on another PC. I=
f it
produces clicking sounds and "frozen" errors when running "badblocks" even
there, then what else do you expect it to do, jump out of the PC and say "i=
'm
broken please replace me"? :)

--=20
With respect,
Roman

--Sig_/SMb7Rs82iz_2Pe+Ep1tjeuu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2mczcACgkQTLKSvz+PZwiRAwCfeFV5DGpSNG8VQLvoG0H1LYE4
CSEAoIPwCoS2bELQ5wF6s9PADrQZiTAG
=4hOH
-----END PGP SIGNATURE-----

--Sig_/SMb7Rs82iz_2Pe+Ep1tjeuu--
