From: NeilBrown <neilb@suse.de>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Mon, 26 Sep 2011 08:18:53 +1000
Message-ID: <20110926081853.2819622b@notabene.brown>
References: <4E7EDE58.3000804@yazzy.org>
	<20110926074002.6399de56@notabene.brown>
	<4E7FA3E8.5010603@yazzy.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ij.dpnpon67OB1kJE.6KsRL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7FA3E8.5010603@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: lists@yazzy.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ij.dpnpon67OB1kJE.6KsRL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 25 Sep 2011 23:58:00 +0200 "Marcin M. Jessa" <lists@yazzy.org> wrot=
e:

> On 9/25/11 11:40 PM, NeilBrown wrote:
>=20
> [...]
>=20
> > You wouldn't expect an LV to contain a partition table.  You would expe=
ct it
> > to contain a filesystem.
>=20
> Yes, there is still data available on the LVs.
> I actually managed to grab some files from one of the LVs using=20
> foremost. But foremost is limited and creates it's own directory=20
> hierarchy with file names being changed.
>=20
> > What does
> >     fsck -f -n /dev/fridge/storage
> >
> > show??
>=20
> # fsck -f -n /dev/fridge/storage
> fsck from util-linux 2.19.1
> e2fsck 1.42-WIP (02-Jul-2011)
> fsck.ext2: Superblock invalid, trying backup blocks...
> fsck.ext2: Bad magic number in super-block while trying to open=20
> /dev/mapper/fridge-storage
>=20
> The superblock could not be read or does not describe a correct ext2
> filesystem.  If the device is valid and it really contains an ext2
> filesystem (and not swap or ufs or something else), then the superblock
> is corrupt, and you might try running e2fsck with an alternate superblock:
>      e2fsck -b 8193 <device>
>=20
>=20

Do you remember what filesystem you had on 'storage'?  Was it ext3 or ext4 =
or
xfs or something else?

NeilBrown

--Sig_/ij.dpnpon67OB1kJE.6KsRL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOf6jNG5fc6gV+Wb0RAr3UAKCXmBL54suqR1NeSczJLFJIDaU7IACfYeH0
215WHs5BgW6CIMvJq10SqAU=
=Qgwt
-----END PGP SIGNATURE-----

--Sig_/ij.dpnpon67OB1kJE.6KsRL--
