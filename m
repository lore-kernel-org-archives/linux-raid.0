From: Roman Mamedov <rm@romanrm.net>
Subject: Re: RAID5/6 slow due to a member device -- how to diagnose?
Date: Thu, 3 Mar 2016 20:00:16 +0500
Message-ID: <20160303200016.2d3da705@natsu>
References: <20160303193026.7d08e64b@natsu>
	<4472129.pebMKxQj7W@matkor-toshiba>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/QUcndE.ggxBoCgKe==BHx0c"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4472129.pebMKxQj7W@matkor-toshiba>
Sender: linux-raid-owner@vger.kernel.org
To: Mateusz Korniak <mateusz-lists@ant.gliwice.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/QUcndE.ggxBoCgKe==BHx0c
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 03 Mar 2016 15:35:21 +0100
Mateusz Korniak <mateusz-lists@ant.gliwice.pl> wrote:

> On Thursday 03 March 2016 19:30:26 Roman Mamedov wrote:
> > But is that broken down somewhere to show which particular block device=
 is
> > being the most 'waited for'?
>=20
> iostat  ?
>=20
> r_await w_await  svctm  %util  columns?

Cheers -- never knew there was this 'extended' output mode in iostat.
Indeed it pinpoints the culprit nicely.

Device: [...]    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %u=
til
sde1    [...] 53748.00   969.01     1.95   17.46   68.00   17.00   4.09  45=
.40
sdf1    [...] 49410.75  1176.97    32.09  393.95  106.00  397.42  11.90 100=
.00
sdg1    [...] 50230.00   995.17     7.12   66.81   88.00   66.60   6.08  61=
.40
sdh1    [...] 53110.00   970.89     2.46   22.21   46.40   21.64   4.64  50=
.80

--=20
With respect,
Roman

--Sig_/QUcndE.ggxBoCgKe==BHx0c
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlbYUYMACgkQTLKSvz+PZwhxfwCfSqYZMTxVcfmSWp0Ya3uiPnkd
s0EAoIYbYYpfLroDwJF8kgsuhmcEDn46
=gzuX
-----END PGP SIGNATURE-----

--Sig_/QUcndE.ggxBoCgKe==BHx0c--
