From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Failed during rebuild (raid5)
Date: Fri, 3 May 2013 22:32:57 +0600
Message-ID: <20130503223257.3ec8025c@natsu>
References: <51839E4F.7050102@midgaard.us>
	<5183A1C7.5000905@mpstor.com>
	<20130503124023.GB27548@cthulhu.home.robinhill.me.uk>
	<20867.49429.400548.184315@quad.stoffel.home>
	<5183CF09.1080605@turmel.org>
	<20867.58492.72376.428170@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ckGl2Ycqzkq+Tfy/wddRQjm"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20867.58492.72376.428170@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Phil Turmel <philip@turmel.org>, Robin Hill <robin@robinhill.me.uk>, Andreas Boman <aboman@midgaard.us>, linux-raid@vger.kernel.org, Benjamin ESTRABAUD <be@mpstor.com>
List-Id: linux-raid.ids

--Sig_/ckGl2Ycqzkq+Tfy/wddRQjm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 3 May 2013 12:23:24 -0400
"John Stoffel" <john@stoffel.org> wrote:

> Sure, but I'm saying that MD should push the policy to default to
> doing this.  You can turn if off if you like and if you know enough. =20

I wouldn't want mdadm suddenly change its behavior on my systems to activate
some automated waste of resources, and leave me scrambling how to disable
this, with the point of this whole change being to pander to stupid and gre=
edy
people (because using RAID5 and not RAID6 with a set-up of six 4 TB drives
is nothing but utter stupidity and greed). Let them lose their arrays once =
or
twice, and learn.

--=20
With respect,
Roman

--Sig_/ckGl2Ycqzkq+Tfy/wddRQjm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlGD5rkACgkQTLKSvz+PZwjxiQCeNdCE9/A4rPgQUvRJKF/evNvt
LwMAmwXCQygvZgd6mkHUowYhkDRHMKbe
=KwPn
-----END PGP SIGNATURE-----

--Sig_/ckGl2Ycqzkq+Tfy/wddRQjm--
