From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Storage device enumeration script
Date: Fri, 27 May 2011 09:58:40 +0600
Message-ID: <20110527095840.427d90be@natsu>
References: <42.A9.00666.D9CEEDD4@cdptpa-omtalb.mail.rr.com>
	<4DDEED47.1040809@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bEreq8MRAGbCPtHpo+GiOOb"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDEED47.1040809@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@fnarfbargle.com>
Cc: lrhorer@satx.rr.com, 'Phil Turmel' <philip@turmel.org>, 'Mathias =?UTF-8?B?QnVyw6luJw==?= <mathias.buren@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/bEreq8MRAGbCPtHpo+GiOOb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 27 May 2011 08:16:07 +0800
Brad Campbell <brad@fnarfbargle.com> wrote:

> On 27/05/11 08:13, Leslie Rhorer wrote:
> >>
> > 	I can't speak to Ubuntu, but Debian evidently does not.  I don't
> > know what "pvs" is, but neither bash nor Python recognize it as a file
> > anywhere in the path.
> apt-get install lvm2.

Sure, but lsdrv shouldn't assume lvm2 is installed or require it to be
installed. Not everyone uses LVM, and simply installing it automatically ad=
ds
things to initramfs (PV/VG/LV detection?), which can slow down boot-up proc=
ess.

--=20
With respect,
Roman

--Sig_/bEreq8MRAGbCPtHpo+GiOOb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3fIXAACgkQTLKSvz+PZwi44ACffi2ciSy0oJNWlAhubjT7TyXg
JNQAn0g42yhVEut36SrFOcleZbY0qgS7
=TPpE
-----END PGP SIGNATURE-----

--Sig_/bEreq8MRAGbCPtHpo+GiOOb--
