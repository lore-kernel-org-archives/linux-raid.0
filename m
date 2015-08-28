From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: How best to re-sync raid1 array? zero superblock on removed disk
 and let it rebuild?
Date: Fri, 28 Aug 2015 10:52:50 +0100
Message-ID: <20150828095250.GA2602@cthulhu.home.robinhill.me.uk>
References: <55E02841.9050701@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55E02841.9050701@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Aug 28, 2015 at 04:22:09am -0500, David C. Rankin wrote:

> All,
>=20
>    I had a disc-controller failure on a server running several raid1
> arrays. The disks are fine, but I have had the root partition come up
> in degraded mode. What is the best way to tell mdraid to resync the
> disks? Here are the symptoms:
>=20
> # cat /proc/mdstat
> Personalities : [raid1]
> md1 : active raid1 sdb7[1]
>        52396032 blocks super 1.2 [2/1] [_U]
>=20
> md3 : active raid1 sdb6[1] sda6[0]
>        1047552 blocks super 1.2 [2/2] [UU]
>=20
> md2 : active raid1 sda8[0] sdb8[1]
>        922944192 blocks super 1.2 [2/2] [UU]
>        bitmap: 0/7 pages [0KB], 65536KB chunk
>=20
> md0 : active raid1 sda5[0] sdb5[1]
>        204608 blocks super 1.2 [2/2] [UU]
>=20
> unused devices: <none>
>=20
<- snip ->
> Reading, it looks like one approach is the boot the install media and
> then zero the superblock on /dev/sda7 and then reboot. Will that force
> a rebuild, or do I need to fail and remove the disk first? I was thinking:
>=20
> # mdadm --zero-superblock /dev/sda7
>=20
> should set it up for a rebuild without more. Is this a sane approach?
>=20
No need to over-complicate things. The only issue you have looks to be
that sda7 has not come up as part of md1, so just add it back in:
    mdadm /dev/md1 -a /dev/sda7

You probably want to check dmesg, etc. to see why it didn't get added in
at all in the first place (I'd have expected it to be at least in as a
spare).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlXgL3EACgkQShxCyD40xBLTOwCdFD5ohPmDn8f4jozagzgXT/F+
EjYAn1XmbnJZLPavF8Ig/IjDVWz/WltX
=lhvT
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
