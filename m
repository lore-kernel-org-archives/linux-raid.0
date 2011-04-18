From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: GPT on MD raid
Date: Mon, 18 Apr 2011 23:11:51 +0600
Message-ID: <20110418231151.5ff9de82@natsu>
References: <iohnsc$ggc$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/m83AdQpyKGxvJLd.SnKg7jm"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iohnsc$ggc$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeremy Sanders <jeremy@jeremysanders.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/m83AdQpyKGxvJLd.SnKg7jm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Apr 2011 17:11:56 +0100
Jeremy Sanders <jeremy@jeremysanders.net> wrote:

> Hi - I was thinking of using a GPT partition on top of a MD raid device. =
It=20
> occurs to me that because GPT also puts data at the end of the device, it=
=20
> might get confused if the raid device is resized by adding more drives, e=
tc.
>=20
> Has anyone tried this? Should it work? How should the GPT header get move=
d=20
> to the end of the raid device? Will parted fix it?
>=20
> Should I ditch this idea and delve into the complexities of LVM?

I'd suggest that you reconsider if you really need to partition a single
mdraid device, or maybe it would be better to create several mdraid devices
(on regular partitions) for different needs, possibly with differing shapes
and settings. E.g. over the same set of disks I use three RAIDs, two small
arrays for boot and root FS, and the rest for data.

--=20
With respect,
Roman

--Sig_/m83AdQpyKGxvJLd.SnKg7jm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2scNcACgkQTLKSvz+PZwiMmACeO8rGBF3F8WS1++8MCmm5cWLk
ORkAnjlAlUAjcAy39lNgPTlr/VltyTZx
=K11M
-----END PGP SIGNATURE-----

--Sig_/m83AdQpyKGxvJLd.SnKg7jm--
