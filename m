From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Uneven wear on raid1 devices
Date: Mon, 25 Jan 2016 10:40:27 +0500
Message-ID: <20160125104027.597041a3@natsu>
References: <56A5B29E.3020708@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ln3feRn4nrVNXv2n3DRRejb"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56A5B29E.3020708@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <adam@websitemanagers.com.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/ln3feRn4nrVNXv2n3DRRejb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Jan 2016 16:29:02 +1100
Adam Goryachev <adam@websitemanagers.com.au> wrote:

>    9 Power_On_Hours          -O--CK   098   098   000    -    6435

>    9 Power_On_Hours          -O--CK   095   095   000    -    23178

2nd drive has almost 4x as much power-on time than the first one. My guess
would be that it accumulated all that write usage back before you put it in=
to
this RAID1.

If you want to ensure the RAID1 usage is even, record the SMART data you ha=
ve
now, and compare to the readings you will have a month later.

--=20
With respect,
Roman

--Sig_/ln3feRn4nrVNXv2n3DRRejb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlaltUsACgkQTLKSvz+PZwimnACcDDgpAbonMg4DMAFNaoG+5scx
ik0An1CssDYBeRUcwXxRTZsWe2rqmS3C
=topI
-----END PGP SIGNATURE-----

--Sig_/ln3feRn4nrVNXv2n3DRRejb--
