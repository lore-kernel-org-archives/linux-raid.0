From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, system
 unresponsive
Date: Fri, 29 Apr 2011 02:11:18 +0600
Message-ID: <20110429021118.0f247326@natsu>
References: <4DA773EB.5030005@turmel.org>
	<327628.84887.qm@web65101.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ySTMAom.7xIPIOb.rPcvVWa"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <327628.84887.qm@web65101.mail.ac2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Flower <gavinflower@yahoo.com>
Cc: Phil Turmel <philip@turmel.org>, Mathias =?UTF-8?B?QnVyw6lu?= <mathias.buren@gmail.com>, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ySTMAom.7xIPIOb.rPcvVWa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 28 Apr 2011 13:03:39 -0700 (PDT)
Gavin Flower <gavinflower@yahoo.com> wrote:

> A couple of days ago, my friend Mario brought over his oscilloscope and a
> volt meter.  The 5 volt rail was showing about 4.7 volts, typically it
> should be 5.2 - 5.4 (from memory of what he said), and the voltage looked
> shaky on the oscilloscope.  The old power supply rated at 400 Watts. =20

4.7V is fine, those voltages have a tolerance of +/-10%. And if you have a
deviation there, it is actually better for it to be to the lower side, than
equivalent to the higher. Reason: no heat increase.

--=20
With respect,
Roman

--Sig_/ySTMAom.7xIPIOb.rPcvVWa
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk25yeYACgkQTLKSvz+PZwhRawCglOU05ihi4rS6H7tbiZ0knh5U
NPoAn36+EJxkaluNHDW8SrF6GkaXMaaA
=oHKY
-----END PGP SIGNATURE-----

--Sig_/ySTMAom.7xIPIOb.rPcvVWa--
