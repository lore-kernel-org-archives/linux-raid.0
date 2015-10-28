From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Replacing a RAID1 drive that has not failed.
Date: Wed, 28 Oct 2015 10:28:17 +0500
Message-ID: <20151028102817.4ec30b5c@natsu>
References: <n0mbam$gmk$1@ger.gmane.org>
	<n0o9n3$gmk$2@ger.gmane.org>
	<562FED15.5040804@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lo7w5hcx1MRwb9A/8Pvv978"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <562FED15.5040804@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Doug Herr <gmane@wombatz.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/lo7w5hcx1MRwb9A/8Pvv978
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Oct 2015 21:31:01 +0000
Wols Lists <antlists@youngman.org.uk> wrote:

> On 27/10/15 16:45, Doug Herr wrote:
> >  1. Partition new drive (plugged in via external SATA dock)
> > #fdisk /dev/sdc
> > (make it an exact match of sda/sdb unless it turns out to be smaller,
> >  in which case I can shrink /boot to make room.)
>=20
> man gdisk.
>=20
> Look at the "u" option in the "expert" menu - it'll probably save you
> some work :-)

Unfamiliar with 'gdisk', but when I need the exact same set of partitions on
another drive, I use sfdisk:

# sfdisk -d /dev/sda > sda.sf
# sfdisk /dev/sdb < sda.sf

You could even do it in one step:

# sfdisk -d /dev/sda | sfdisk /dev/sdb

--=20
With respect,
Roman

--Sig_/lo7w5hcx1MRwb9A/8Pvv978
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlYwXPEACgkQTLKSvz+PZwhVPACdEDfe4HWnN013AZfcZR72jlak
vOEAnRPOZDoI+19VimNB9UzgKE5xszA6
=uXLz
-----END PGP SIGNATURE-----

--Sig_/lo7w5hcx1MRwb9A/8Pvv978--
