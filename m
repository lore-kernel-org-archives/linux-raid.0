From: NeilBrown <neilb@suse.de>
Subject: Re: Badblocks and degraded array.
Date: Thu, 26 Mar 2015 10:50:35 +1100
Message-ID: <20150326105035.5051a60d@notabene.brown>
References: <20150325231400.GA9242@animx.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/e4YHnCeFh8BD/xn7duwkM4o"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150325231400.GA9242@animx.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/e4YHnCeFh8BD/xn7duwkM4o
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Mar 2015 19:14:00 -0400 Wakko Warner <wakko@animx.eu.org> wrote:

> Firstly, I'm not in need of assistance, just looking for information.
>=20
> I had a system with 4x 500gb disks in raid 5.  One drive (slot 2) was
> kicked.  I removed and reseated the drive (which is OK).  During rebuild,=
 it
> hit a bad block on another drive (slot 1) which it kicked.  Is it possible
> that if there's no redundancy to not kick a drive if it has a bad block?

Only if you have bad-block-logs enabled.  This is a relatively new feature.

>=20
> In the end, my solution was to create a dm target using linear and zero as
> needed (zero where the bad block was) then a snapshot target ontop of that
> since there was no possibility to write to that section that was a zero
> target.  I had LVM on top of the raid and my /usr was the one in the bad
> block.  Fortunately, no files were in that bad block.  I dumped the usr
> volume elsewhere, removed all the mappings (md, dm, and lvm), assembled t=
he
> array again and dumped the volume back which corrected the bad sector.  A=
ll
> this was done using another installation.
>=20
> This system will be retired anyway so the data isn't really useful.  But
> having the experience is.
>=20
> On a side note, it seems that everytime I encounter a bad sector on a dri=
ve,
> it's always 8 sectors.  Does anyone know if hard drives have been 4k
> sectored longer than AF drives?  This disk is 512 physical according to
> fdisk.  I've even noticed this on IDE drives.
>=20
Linux tends to do IO in multiples of 4k so it is unlikely to report a small=
er
block.  That may or may not be relevant for your particular experiences.

NeilBrown


--Sig_/e4YHnCeFh8BD/xn7duwkM4o
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVRNJyznsnt1WYoG5AQJNig/9ETQ1Mm8wJeGlQDLb1rYXBgB2tWABFW+T
FcnPHGWqnuWi6AOUfxWcSk4F0F8mZWobRiXlJhSeDb7SechqM4CVtSHHZeRXeZqu
GUqMgPSUO3ecBd6hjl289+23CxAl7ZCmvk4oWBCj/fGMgEGDI5aYqGmf7H3rt9dJ
iGSC2nNuRCdZmtVkLi6koaYfwFMZhKtKgUZKVx2234MDNvCPgxGtWc5dpWp5aflL
2S1tVEY9yxbpbB6VxqU9/HgcHnalD2SIu2XeNZZtFTU85Wxn8ziFMDOjNqViMpjY
z0taIZzTsSn7dOt1WmzhF0w9g4hi5mPA2ccXAE1Oib6BFEeyCB5yXJShyO4LhPqa
Z6Qs3LT6is26x0yyS4J3Vs53mfvQk2eAZRSr5uW4IhSk+0l0YolMZlFHV7nEDaVy
IT2UlyNKDr5dt7yS5dZFe3KbilNK/SESWjSkLvxsFudja3/6BuhJjLpG6nYM3+aB
CBgHD0JK7gzFgpEF3s3GNWmeb3H0fIm8vwGgvkCYeQN+VtFKQhZY9ZhCTV/BS0C1
GlPfu3Wi0bPRLpiQ3Pe2JJ4IcdlPiPeYvufEPGz+HFiyDUhjjcAB2QybvD3MabGZ
V8HRbbwRO7BY/dUhpj5LRF426oC3jNcKRgNZrVXpDG6wyv9majlbE1T/rcW848Zh
ctQyzaCNfLs=
=d6CE
-----END PGP SIGNATURE-----

--Sig_/e4YHnCeFh8BD/xn7duwkM4o--
