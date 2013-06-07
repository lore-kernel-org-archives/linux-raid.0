From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Is this expected RAID10 performance?
Date: Fri, 7 Jun 2013 16:52:36 +0600
Message-ID: <20130607165236.60ac7451@natsu>
References: <CAO9HMNH4eFyshhhohw0wQ13j98BTRELTiWF9uDLp3vmFsOEfwQ@mail.gmail.com>
	<CAAMCDefb7TFXDOD7=aK-FjHVCQXMdiQKdz=CFJT4+q9rKR3KGA@mail.gmail.com>
	<CAGqvA+svdBvWTbwnzQjoHWQz6n0iEaAZzmu-EqKqdPx-AK0Zkg@mail.gmail.com>
	<CAO9HMNE3F-ZN0fQmHW7yz2JLRFaUqSYSaVpZe3KaXuaLMojV8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.vZGfafQKGVbcIamge/=QM="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAO9HMNE3F-ZN0fQmHW7yz2JLRFaUqSYSaVpZe3KaXuaLMojV8w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Bergman <sbergman27@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/.vZGfafQKGVbcIamge/=QM=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 7 Jun 2013 05:44:00 -0500
Steve Bergman <sbergman27@gmail.com> wrote:

> Thanks for the helpful posts. After posting, I decided to study up a
> bit on what SATA 3Gb/s actually means. It turns out that the 3Gbit/s
> bandwidth is aggregate per controller.

This is just plain wrong. I wonder where do you find b/s like this (maybe
post the actual link with such misinformation so we could try getting it
corrected or removing it if it's some wiki?). Unless your controller is bui=
lt
to use an onboard PMP (port multiplier), there is no such thing as 3 Gbit/s=
ec
controller-wide limitation. But of course it's still limited by whatever bus
it sits on, if it's a narrow PCI-E 1x, that might well come into play.

--=20
With respect,
Roman

--Sig_/.vZGfafQKGVbcIamge/=QM=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlGxu3UACgkQTLKSvz+PZwhZAACgjvjaE83rKXiX7je/qLshTQEU
kiQAn203Ctt+qM3/UCna/87pwTdtnwMs
=3wuS
-----END PGP SIGNATURE-----

--Sig_/.vZGfafQKGVbcIamge/=QM=--
