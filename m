From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Status of discard support in MD RAID
Date: Fri, 12 Sep 2014 15:39:15 +0600
Message-ID: <20140912153915.473bc562@natsu>
References: <1ED0286A-56DA-491D-853A-1C1045449201@redhat.com>
	<26CB8B36-9CD9-4EE0-BFF2-4B183DBDD033@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/DCGgG2pbpjAA59d27Djl=+C"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <26CB8B36-9CD9-4EE0-BFF2-4B183DBDD033@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Brassow Jonathan <jbrassow@redhat.com>, "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

--Sig_/DCGgG2pbpjAA59d27Djl=+C
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Sep 2014 18:46:04 -0600
Chris Murphy <lists@colorremedies.com> wrote:

> If it doesn't, a check check > md/sync_action will report mismatches in
> md/mismatch_cnt; and a repair will probably corrupt the volume.

At least with RAID1/10, why would it?

> and you can't do repair type scrubs.

If the FS issues TRIM on a certain region, by definition it no longer cares
about what's stored there (as it's is no longer in use by the FS). So even =
if
a repair ends up coping some data from one SSD to another, in effect changi=
ng
the contents of that region, this should not affect anything whatsoever from
the FS standpoint.

Technically perhaps that still counts as a "corruption", but not of anything
in the filesystem metadata or user data, just of unused regions. So not as
scary as it first sounds.

The only case where you'd run into problems with this, is if some apps expe=
ct
to read back zeroes on TRIM'ed regions, e.g. Qemu in the "detect-zeroes=3Du=
nmap"
mode. But using that would be dangerous even on a single SSD with
non-deterministic TRIM, so mdraid changes nothing here.

--=20
With respect,
Roman

--Sig_/DCGgG2pbpjAA59d27Djl=+C
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlQSv0MACgkQTLKSvz+PZwgOXACgmBurWx4a/0SzqR418how5xMw
D/EAn01TV6UfpoL+CXB9z2E7Kauv1xxF
=fkDG
-----END PGP SIGNATURE-----

--Sig_/DCGgG2pbpjAA59d27Djl=+C--
