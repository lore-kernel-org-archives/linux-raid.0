From: NeilBrown <neilb@suse.com>
Subject: Re: Big-endian RAID5 recovery problem
Date: Sat, 06 May 2017 15:57:17 +1000
Message-ID: <87fugio7cy.fsf@notabene.neil.brown.name>
References: <5c6e6e5d93d4056839e4f370e00a8e08@mail.athompso.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5c6e6e5d93d4056839e4f370e00a8e08@mail.athompso.net>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Thompson <athompso@athompso.net>, MUUG Roundtable <roundtable@muug.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, May 01 2017, Adam Thompson wrote:

> So I've got 4 IDE HDDs, each with 3 RAID partitions on them, that were=20
> part of a RAID array in a now-very-dead NAS.
>
> Of course, I need to get data off them that wasn't backed up anywhere=20
> else.
>
> I've got a 4-port USB3 PCIe card, and 4 IDE/SATA USB adapters, and all=20
> the hardware seems to work.  So far, so good.
>
> The problem is that the disks use the v0.90 metadata format, and they=20
> came from a big-endian system, not a little-endian system.  MD=20
> superblocks *since* v0.90 are endian-agnostic, but back in v0.90, the=20
> superblock was byte-order specific.
>
> mdadm(8) on an Intel processor refuses to acknowledge the existence of=20
> the superblock.  Testdisk detects it and correctly identifies it as a=20
> Big-endian v0.90 superblock.
>
> I'm reluctant to blindly do a forced --create on the four disks, because=
=20
> I'm not 100% certain of the RAID topology; there are at least two RAID=20
> devices, one of which was hidden from the user, so I have no a-priori=20
> knowledge of its RAID level or layout.
>
> The filesystems on the md(4) devices are, AFAIK, all XFS, and so should=20
> (hopefully) not have any endianness issues.
>
> I can't find any modern big-endian Linux systems... looks like all the=20
> ARM distros run in little-endian mode.
>
> Any suggestions on the best way to move forward?
>

Look for "--update=3Dbyteorder" in the mdadm man page.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkNZb0ACgkQOeye3VZi
gbnlfg/+Or1s1RPCH2LeH/3sGbXnZzgUNHg3Jyw+yFExFAgt0X2/xexfDfstuWCj
rWy8ZPGmH6rS4PntitviwsIiGPGbUBBEGjgAu9O4MR9ty8TrINzIj6lp9HywrPPY
4c3PclMpc1yf5S2fIKumabtfKG5X/91bYnhAZUhWWV1wKEVcUmnWrdPJ6npNoZXE
7Y5JUf6uyoVuRblJINfFoFj6bDoY6AJx0CjmygvqdzyokrjYcl2vh8yFCwhb6VFd
UNShpa+000kk51ZztrKOWe9EcuGpsrn52fXcBtzMqHu3/9Quj+YBfUzFE6bbee20
k88FxZw6ITPfiz4yL7EX127AGLepgfKaN6+07BURhdsO8qTEJSNujeUoxx3FpTjO
i5UxdPWv9DgMJyKr7ZUq+9N0avau9QBo4uvX5JI/hGgDFagnuskJQF72lUgstjkN
ZyZ8TiSxuE21RdhjP2NeloUDJmbQhcYFcSgiylKc1uSNVNSgK4U+ItizkcVpvkcj
CwneB+6I4yTUnqc2S1YBJlX+1EBc49f0Hqs3P+uxH9tUnHWxaOCDQnOaoi/tzFLS
8qqlkT/INRa+bkKGzmVhWlfSZy4Xym4latiLOhOx0FNmq+/mvJZebKzJ2qJ7Gp8i
4IAY2STriEYon4tnQePMSgsFIUQRgulIo0DKMczzr+Wo5QKUxsM=
=iuSu
-----END PGP SIGNATURE-----
--=-=-=--
