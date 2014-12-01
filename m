From: NeilBrown <neilb@suse.de>
Subject: Re: LVM RAID1 syncing component
Date: Tue, 2 Dec 2014 08:41:11 +1100
Message-ID: <20141202084111.6514ec79@notabene.brown>
References: <alpine.DEB.2.02.1411242255300.12886@jlaw-desktop.mno.stratus.com>
	<20141127074158.2a3472f3@notabene.brown>
	<20141201161947.1d503df9@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/v9G5vgYU4j7SeziBE=TOTXA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141201161947.1d503df9@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/v9G5vgYU4j7SeziBE=TOTXA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 1 Dec 2014 16:19:47 -0500 Joe Lawrence <joe.lawrence@stratus.com>
wrote:

> On Thu, 27 Nov 2014 07:41:58 +1100
> NeilBrown <neilb@suse.de> wrote:
>=20
> > On Mon, 24 Nov 2014 23:07:32 -0500 Joe Lawrence <joe.lawrence@stratus.c=
om>
> > wrote:
> >=20
> > > Does anyone know how its possible to determine which side of an LVM R=
AID 1=20
> > > is the stale partner during RAID resync?
> > >=20
> > > In ordinary MD RAID, I believe you can check=20
> > > /sys/block/md0/md/dev-XXX/state,
> >=20
> > Why do you believe that?
> >=20
> > During a resync (after an unclean shutdown) the devices are indistingui=
shable.
> > RAID1 reads all drives and if there is a difference it chooses one data=
 block
> > to write to the others - always the one with the lowest index number.
> >=20
> > So with md or LVM it is the same: first "first" is "copied" to the "sec=
ond".
>=20
> Hi Neil,
>=20
> Here's a quick example of my thought-process, where md2 is an in-sync
> RAID1 of sdq2 and sdr2 with an internal write bitmap:
>=20
> % mdadm --fail /dev/md3 /dev/sdr2
> % mdadm --remove /dev/md3 /dev/sdr2

You are referring to what I would call "recovery", not "resync"
(which is why I put "(after an unclean shutdown)" in my answer to make it
clear what circumstances I was talking about).

resync: fixing things after an unclean shutdown
recovery: restoring data after a device has been removed an another
          (or possibly the same) added.

I think

  dmsetup info=20

should provide the info you want.
One of the fields is a sequence of letters 'D', 'a', 'A'.

		 * Status characters:
		 *  'D' =3D Dead/Failed device
		 *  'a' =3D Alive but not in-sync
		 *  'A' =3D Alive and in-sync

Does that provide the information you wanted?

NeilBrown

--Sig_/v9G5vgYU4j7SeziBE=TOTXA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVHzgdznsnt1WYoG5AQLhOg/+OEUg2YU7sVUasgYBsmOCdk3Js0tm/jJD
p9hG1Nxdrhn08HnpLdNiy+uTgiLJUtNPk0SQV07MBxi2LvGviabtuLCsN7uSrcbp
RU/ZAoEltr2mqsUKGGS1c8a19bFZCc/kA6dVdEZgtcJUtJUKB8eAp4TeBqq64gyZ
WEG4DD85/1vd4mc0j2mW4na1HcVS7U7SF+qbmIKohzGitoBxJb9bhi4BzbY1/VG9
xQ/M0fOYlKGPuVDL84m1FlEqD0fAgOuRYeYPjF5HA0yTiEIPfIt0aOTRjx8CxLPs
MO1fTCImV3r5wASsB/Bv00qch6bxbpeel9JhHkim+uvxriUDP7gE6WZtTGf4fWDq
G4QbXuKuK8gMqQHVsyQCSIsBLdjfdxX4DiNxAYOPjdb5136PPLvfoOeDJDxQYuLH
ro7u+d8c22LnIG7/VadjAJbQdXGKyfAnhm2WCwIcfmWZ9O4h6YXI4m/yq7pRpQSY
RIELUIBG8wNwetU72UijwM/dCwCEgzYQxo8BsghcCzXQUSUYVV1OSLKrBxOBSy46
Pbfzw/ZiVt1L4v0Fv2XWPzjm2pTZTFIrt+yfLS6g/3QhGbuwHupHtlvSkrPKB51I
8hOm74MaYlFtDYKtH4xvr7PUcnhC1BsKnMBYEa2ElulUI3pk+RG3o4Fvted6wSeB
kRCCKPbbQ7M=
=GfMt
-----END PGP SIGNATURE-----

--Sig_/v9G5vgYU4j7SeziBE=TOTXA--
