From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: standard performance (write speed 20Mb/s)
Date: Wed, 27 Jul 2011 11:46:47 +0600
Message-ID: <20110727114647.5a80b3d0@natsu>
References: <201107162140.58883.raid1@fuckaround.org>
	<4E226464.2030200@hardwarefreak.com>
	<ac6850f9420970de26472b6a9dcc2a82.squirrel@fuckaround.org>
	<4E22D167.2010905@anonymous.org.uk>
	<CAEUYfyMEj31Gfy9KeT4sHWyUXcB-+9ehoZoXvHSXq6yztCzVXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GsSkgNm=PFdaiJ9pHR5TfT1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEUYfyMEj31Gfy9KeT4sHWyUXcB-+9ehoZoXvHSXq6yztCzVXg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Matthews <simon.d.matthews@gmail.com>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Pol Hallen <raid1@fuckaround.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/GsSkgNm=PFdaiJ9pHR5TfT1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 26 Jul 2011 22:42:14 -0700
Simon Matthews <simon.d.matthews@gmail.com> wrote:

> On Sun, Jul 17, 2011 at 5:11 AM, John Robinson
> <john.robinson@anonymous.org.uk> wrote:
>=20
> > Pretty poor. CentOS 5, Intel ICH10, md RAID 6 over 5 7200rpm 1TB drives,
> > then LVM, then ext3:
> > # dd if=3D/dev/zero of=3Dtest bs=3D4096 count=3D262144
> > 262144+0 records in
> > 262144+0 records out
> > 1073741824 bytes (1.1 GB) copied, 2.5253 seconds, 425 MB/s
>=20
> What hard drive offers a sustained data rate of 425 MB/s or even half tha=
t?

"md RAID 6 over 5 7200rpm 1TB drives" does? :) At least half that - easily.

But still, the result posted is very much inflated, they forgot the "conv=
=3Dfdatasync" option, so mostly benchmarking the FS cache in RAM.

--=20
With respect,
Roman

--Sig_/GsSkgNm=PFdaiJ9pHR5TfT1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4vpkgACgkQTLKSvz+PZwi1FQCeN9AS+7PL9avyzamNUr/thBbR
zAoAnA7wpoVdpSjYKsMF+5Q/P08vkf3X
=bLWL
-----END PGP SIGNATURE-----

--Sig_/GsSkgNm=PFdaiJ9pHR5TfT1--
