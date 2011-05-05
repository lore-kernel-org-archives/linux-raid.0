From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: mdadm raid1 read performance
Date: Thu, 5 May 2011 10:06:10 +0600
Message-ID: <20110505100610.66c93e08@natsu>
References: <BANLkTim8Ehn0fANtibg7X1cMVvOgt7CNMA@mail.gmail.com>
	<20110504105822.21e23bc3@notabene.brown>
	<BANLkTimzqu1C+_Z2t5m1bjduXFeRwbgssQ@mail.gmail.com>
	<4DC0F2B6.9050708@fnarfbargle.com>
	<BANLkTinbFZf=kV=3eUe2S6XNAOst_McX4w@mail.gmail.com>
	<BANLkTikQTKPuY+Mg8h9ZOkJPoEQ-jGTeLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5B9roHYFR3afGm34sicdbWU"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTikQTKPuY+Mg8h9ZOkJPoEQ-jGTeLg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Liam Kurmos <quantum.leaf@gmail.com>
Cc: Roberto Spadim <roberto@spadim.com.br>, Brad Campbell <lists2009@fnarfbargle.com>, Drew <drew.kay@gmail.com>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/5B9roHYFR3afGm34sicdbWU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 5 May 2011 00:08:59 +0100
Liam Kurmos <quantum.leaf@gmail.com> wrote:

> in my tests i read 1GB and throw away the data.
> dd if=3D/dev/md0 of=3D/dev/null bs=3D1M count=3D1000

If you have enough RAM for disk cache, on the second and further consecutive
invocations of this you will be reading mostly from the cache, giving you an
incorrect inflated result. So either don't forget to drop filesystem caches
between runs, or just test read performance with "hdparm -t /dev/mdX" inste=
ad.

--=20
With respect,
Roman

--Sig_/5B9roHYFR3afGm34sicdbWU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3CIjIACgkQTLKSvz+PZwhdUgCfYPCuxKoX3SLCNxXvmg89yKxQ
0DsAniCCV3nmOCH1PhDEgXBrdHbsy4MP
=ZLTn
-----END PGP SIGNATURE-----

--Sig_/5B9roHYFR3afGm34sicdbWU--
