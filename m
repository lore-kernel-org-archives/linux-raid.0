From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Western Digital Green 3TB SATA3 experiences
Date: Wed, 20 Mar 2013 15:29:39 +0600
Message-ID: <20130320152939.480374e9@natsu>
References: <1363766982.51496ec6ea41f@mail.inbox.lv>
	<20130320144805.15140c70@natsu>
	<1363771292.51497f9ca4fb5@mail.inbox.lv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/06IJ.V6wX4fDa.y2ih+bTBx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1363771292.51497f9ca4fb5@mail.inbox.lv>
Sender: linux-raid-owner@vger.kernel.org
To: Andris Berzins <pkix@inbox.lv>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/06IJ.V6wX4fDa.y2ih+bTBx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Mar 2013 11:21:32 +0200
"Andris Berzins" <pkix@inbox.lv> wrote:

> >> Is this because of WD "green" series?
> >=20
> > No.
>=20
> "Green" series are special because they spin down after 7 seconds and the=
y do not
> return in timely manner when read error occurs.

They do not spin down after 7 seconds, they unload their heads. In any case
this behavior is not expected to ever cause Current_Pending_Sectors rising
(which are plain and simple unreadable sectors no matter how hard you try or
how long you wait).

You can disable the 7-second unload time behavior by using either "hdparm -=
J"
or using "idle3-tools" http://idle3-tools.sourceforge.net/ (also available =
in
Debian). I would indeed recommend doing that to reduce wear and tear on the
head mechanism from constant loads/unloads; but I somewhat doubt this will
make a difference in relation to your issue.

--=20
With respect,
Roman

--Sig_/06IJ.V6wX4fDa.y2ih+bTBx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFJgYMACgkQTLKSvz+PZwhkSACggmosaHtjy0FFcUJXTtZGaMNr
+HYAoI2CKUSXgYBiNGau271OBkuV8P8Q
=BeF0
-----END PGP SIGNATURE-----

--Sig_/06IJ.V6wX4fDa.y2ih+bTBx--
