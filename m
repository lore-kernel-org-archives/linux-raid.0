From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Raid 6--best practices
Date: Fri, 20 Jan 2012 14:33:06 +0600
Message-ID: <20120120143306.22e1ebf4@natsu>
References: <4F173D3D.6070902@npr.org>
	<CF17461882827E43AD7DF6E471FFA903834EFD7853@EXCHANGE.ads.npr.org>
	<CF17461882827E43AD7DF6E471FFA903834EFD7858@EXCHANGE.ads.npr.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/I3F1YrR0l3vAl6dG3G9tNW+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CF17461882827E43AD7DF6E471FFA903834EFD7858@EXCHANGE.ads.npr.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shain Miley <SMiley@npr.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/I3F1YrR0l3vAl6dG3G9tNW+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Jan 2012 21:54:40 -0500
Shain Miley <SMiley@npr.org> wrote:

> b)    Would you recommend using any specific Linux distro over any other?=
 =20
> Right now I am trying to decide between Debian and Ubuntu....

In my experience Ubuntu doesn't really care about packages outside of a nar=
row
set of "desktop" or "regular user" ones, and therefore is not a good choice=
 for
a such use. E.g. they have been shipping an ancient version of mdadm (2.6.x)
long after it was no longer sane to even try using it. :)

You can compare=20
http://packages.debian.org/search?keywords=3Dmdadm
with
http://packages.ubuntu.com/search?keywords=3Dmdadm&searchon=3Dnames&suite=
=3Dall&section=3Dall
and notice that Debian generally has a newer mdadm.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/I3F1YrR0l3vAl6dG3G9tNW+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8ZJsIACgkQTLKSvz+PZwgfOQCeJh61UMZEonAFG71aj+NVk2TC
X5oAn0lzIP7cvB0g3UY970mAxfTVmGow
=WiiU
-----END PGP SIGNATURE-----

--Sig_/I3F1YrR0l3vAl6dG3G9tNW+--
