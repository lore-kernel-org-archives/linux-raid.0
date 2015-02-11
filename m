From: NeilBrown <neilb@suse.de>
Subject: Re: dead RAID6 array on CentOS6.6 / kernel 3.19
Date: Wed, 11 Feb 2015 15:26:05 +1100
Message-ID: <20150211152605.0c1bf94e@notabene.brown>
References: <54DAB614.70302@athompso.net>
	<54DAC0E2.2070303@turmel.org>
	<54DAC42F.3090600@athompso.net>
	<54DAC7A4.40407@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/20UwX4mICsjg4VoEuOJtJvq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54DAC7A4.40407@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: athompso@athompso.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/20UwX4mICsjg4VoEuOJtJvq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Feb 2015 22:08:20 -0500 Phil Turmel <philip@turmel.org> wrote:

> Hi Adam,
>=20
> { Dropped members-only lists from CC }
>=20
> On 02/10/2015 09:53 PM, Adam Thompson wrote:
>=20
> >> [root@muug ~]# mdadm --verbose --misc --run --readonly /dev/md127
> >> mdadm: /dev/md127 does not appear to be active.

Supporting this sort of usage seemed like a good idea long long ago, but=20
it doesn't turn out to be really useful, so I haven't maintained it at all.

> >=20
> >=20
> > Also, kernel 3.19, which I mentioned we're running, pretty much *is* my
> > definition of an up-to-date kernel... how much newer do you want me to
> > try, and where would you recommend I find such a thing in a bootable im=
age?
>=20
> You're right, 3.19 should be fine.  I'm stumped.  Looks like a bug.
> Adding Neil ....

I think it is an mdadm bug.  I don't see a mention of mdadm version number
(but I didn't look very hard).
If you are using 3.3, update to at least 3.3.1

(just
  cd /tmp
  git clone git://neil.brown.name/mdadm
  cd mdadm
  make
  ./mdadm --assemble --force /dev/md127 .....
)

NeilBrown

--Sig_/20UwX4mICsjg4VoEuOJtJvq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVNrZ3Tnsnt1WYoG5AQJ6HRAApMsrsOc3iFccz9Y7qBiuRcVFOnrvs3JO
V8s771x91B64jtDlnzqjurcfVWEFFIwsaTjhcOy02NLt7EJY30dhvl6kVFw/IzMH
k6iTPmFPEQmZoIZ6dz5bdOUZuzJBfrwzvI/668nWP2RAsq3yXzg10u/XQsCufIQR
+fib8DGE5umVvLC7RvxaWjQd6YZ+a8MErPWvDfyKqcjAQYQmCCx1UtUGfpOFX9TT
d3sTWmZNZ4l14Eth0A/RMDe/CY8/je+kJ5JkYQ/ZCUSVCyZeN9JeHx0Q/sgoPsrR
bIcESxgOxdL7dhmvePpXV4O38V6PHV5XuRsnC9buRrApWvgNDtClBqFRK7/5PPd1
DH7iscvvmOYRQmmKxsPz7b+eUFonu01brKK1EJiCnxCWJRV3kUvNTsMdTzsOdGgP
+1dOJ3hdm3qBNXLKeF4Xpr4Vk4FySdNGqs1AjLTFTEQaNuklcS+ZIU/OKUDm86XQ
Als/xQHyPxCp000ZM067K01p+gtnWXwAHxgU+itrsdaQgzTo9KiGeW6ZjFstlm/D
Sr/72VrYw+yrfm0yIZFzV9hHWS3eMiURfy3/qFMSIyZR2ePbsfBQ50lQIfspA/k5
9l8efiY2/XFwBTRB4bp9wnBqFVWyCNYsCu3XFnX3zZGBKgI4BsCKaEBjIxzEMG2B
63iVBIPyuTc=
=LbFz
-----END PGP SIGNATURE-----

--Sig_/20UwX4mICsjg4VoEuOJtJvq--
