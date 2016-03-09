From: Roman Mamedov <rm@romanrm.net>
Subject: Re: When do you replace old hard drives in a raid6?
Date: Wed, 9 Mar 2016 11:59:05 +0500
Message-ID: <20160309115905.5ff2e9dd@natsu>
References: <56DB465E.9010703@gmail.com>
	<56DCCB55.1060906@turmel.org>
	<56DCD0E9.8040506@gmail.com>
	<56DD0F12.2060104@turmel.org>
	<56DF6A39.4020904@gmail.com>
	<alpine.DEB.2.02.1603090733030.31096@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/_0WYSf2SJxXDLCw4Uy0O.g2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1603090733030.31096@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/_0WYSf2SJxXDLCw4Uy0O.g2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 9 Mar 2016 07:43:16 +0100 (CET)
Mikael Abrahamsson <swmike@swm.pp.se> wrote:

> I had very high failure rates of the early 2TB WD Greens, but I still hav=
e=20
> some WD20EARS and WD20EADS that are alive after 58k hours.

In my experience a major cause for the WD failures is that they develop rust
on the PCB contacts which connect to the drive insides, see e.g.:
http://ods.com.ua/win/rus/other/hdd/2/wd_cont2.jpg
http://www.chipmaker.ru/uploads/monthly_12_2013/post/image/post-7336-020632=
100%201388236036.jpg
and: https://www.youtube.com/watch?v=3DtDTt_yjYYQ8

If such WD drive has just developed several unreadable sectors, this often =
can
be solved by checking and cleaning those contacts, then overwriting the who=
le
drive with zeroes (or well, with whatever you want, the point is to rewrite
all the "badly written" areas), then it will likely work fine for years aft=
er
that.

> One of the slightly lower power on time ones has a scary load cycle count=
=20
> though:
>=20
> Device Model:     WDC WD20EARS-00S8B1
>    9 Power_On_Hours          0x0032   033   033   000    Old_age   Always=
       -       49255
> 193 Load_Cycle_Count        0x0032   001   001   000    Old_age   Always =
      -       1317839

This can be disabled:
http://www.storagereview.com/how_to_stop_excessive_load_cycles_on_the_weste=
rn_digital_2tb_caviar_green_wd20ears_with_wdidle3
http://idle3-tools.sourceforge.net/

--=20
With respect,
Roman

--Sig_/_0WYSf2SJxXDLCw4Uy0O.g2
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlbfybwACgkQTLKSvz+PZwhdOgCglEpBVPAUb/fGHRGbctC24Pcb
5jAAoJZaaEbrnP0ml9KeGiRnJnClFqyb
=AI03
-----END PGP SIGNATURE-----

--Sig_/_0WYSf2SJxXDLCw4Uy0O.g2--
