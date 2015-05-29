From: NeilBrown <neilb@suse.de>
Subject: Re: raid5 reshape is stuck
Date: Fri, 29 May 2015 21:19:47 +1000
Message-ID: <20150529211947.3271b204@notabene.brown>
References: <1612858661.15347659.1431671671467.JavaMail.zimbra@redhat.com>
	<427651758.4121803.1432637303447.JavaMail.zimbra@redhat.com>
	<20150527100253.221ab553@notabene.brown>
	<20150527111004.5f136f23@notabene.brown>
	<2129908770.5092770.1432726084717.JavaMail.zimbra@redhat.com>
	<20150527213449.6e017deb@notabene.brown>
	<476656362.5105083.1432728264276.JavaMail.zimbra@redhat.com>
	<20150528085958.0f95e323@notabene.brown>
	<45685228.5717919.1432794771906.JavaMail.zimbra@redhat.com>
	<20150528164923.2cd4af02@notabene.brown>
	<556849E2.7030405@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/=l/YjBj7aZr7ca=otOxsQIq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <556849E2.7030405@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: XiaoNi <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/=l/YjBj7aZr7ca=otOxsQIq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 29 May 2015 19:13:38 +0800 XiaoNi <xni@redhat.com> wrote:


> And it's really the problem about selinux. The patch works after the=20
> command "setenforce 0". It need the patch you gave.  Is it right
> to setenforce 0 every time? I'll read the doc about selinux.

I know nothing about selinux, and don't really want to.
Presumably selinux needs to be told that mdadm, when run from systemd, can
access all block devices.
If there is something I can add to the system unit file to make this happen
I am happy to, but I would need someone to tell me what.

Glad you are making progress and learning a lot!!

NeilBrown

--Sig_/=l/YjBj7aZr7ca=otOxsQIq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWhLUznsnt1WYoG5AQIJMA//Tf0glaVUphJXhlvBDp5zAthkMtaax6pq
87V4mY4hGfFNLP939kqiD1LuIyVXcbKN2nakucMTtwlFxpmF3RLhcNj6lnC4pVMI
iA2AdCiWZoF+seOU4hT4d+CctoEop0GXym2Iyv1zohRXNSCQQjUFvVjIS71kqbSX
FLmdLmI4/KZP6j9L1f0eQBP1/yKZTMvZWZs9p9TwLgSiwh76VrqaMdm6CEDBnT6C
DmI7ARYBqR+XI0S+gH7fT7yUUN/NqoL770TYNOUyAan81FrHkYBmYPkACZ+hDSOR
gnb58VZ+HQqO2Qv7WPnqPDsm6blf3hmmBezEO2xwOye/VXcxFuKr34CB9tVE8K1t
hdLvcSsg45u1hh/q290U5SGz3lxDo8ncfMHP3coqZsuRHWYHEHZ2b84SWWewgtT7
aDFA9BMuMBVxaXn4gtIEYVs7Cq9PSAvx1/jiFMaD9Okv4JIyYKgowk+VekctPlH7
gfxsroDlq272GVaStkYzyumPF1sa9b5reu+LuhFZkS0BephFHd0zJQAEBzEQIVKY
/3aFCdUsnmGPEIj/ixRGI6F/FtuJJVaLz5my/i3ByRDkgbfBGJM5i4t27h9pYSKZ
47X8o9tJ0KpAXykvyaKG3A1XzFMkkKDwNnMv9f9FxLQ/fgTfQ31GHDH7b1E5M9LW
gAOOScWaULE=
=sB6i
-----END PGP SIGNATURE-----

--Sig_/=l/YjBj7aZr7ca=otOxsQIq--
