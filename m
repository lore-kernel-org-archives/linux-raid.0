From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Backup raid, power down questions.
Date: Tue, 19 May 2015 17:46:06 +0500
Message-ID: <20150519174606.4f7e8e75@natsu>
References: <BLU437-SMTP474BC966B5944E3445207D98C30@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/iy0/s2XPq4nyNQgj8twKr.V"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU437-SMTP474BC966B5944E3445207D98C30@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: "Wilson, Jonathan" <piercing_male@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/iy0/s2XPq4nyNQgj8twKr.V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 May 2015 13:36:43 +0100
"Wilson, Jonathan" <piercing_male@hotmail.com> wrote:

> I am looking to create a second raid6 set which will only be used to do
> periodical backups of the main raid6, probably using rsync. (all drives
> will be tler'able WD reds)

> Obviously when the system boots all the raids will start up

With both RAIDs in the same case, sharing a PSU, connected to the same
system? I'd say forget about it, that's a terrible way to have a "backup",
too many things that can go wrong affecting both RAIDs at once. Starting wi=
th
a power supply failing and frying all the drives, and ending with an
unauthorized access via some root exploit, with the intruder deleting all d=
ata
or dd'ing zeroes to all drives.

Throw together a separate inexpensive computer and back up to that. Can even
power off it entirely when not in use and power-on either by Wake On Lan or=
 by
schedule (most x86 BIOSes have a feature to power-on the machine daily at a
specified time).

--=20
With respect,
Roman

--Sig_/iy0/s2XPq4nyNQgj8twKr.V
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlVbMI4ACgkQTLKSvz+PZwgUbACcD6whS0E/7nSBNA/UAmIV1bqm
6WEAoJNahFxY6gBqHwqhr8xxrrbQ1HFv
=xkUq
-----END PGP SIGNATURE-----

--Sig_/iy0/s2XPq4nyNQgj8twKr.V--
