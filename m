From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: using update-initramfs: how to get new mdadm.conf into the
	/boot? Or is it XFS?
Date: Mon, 4 Feb 2008 21:08:31 +0000
Message-ID: <20080204210831.GA7162@cthulhu.home.robinhill.me.uk>
References: <47A77CC0.10807@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47A77CC0.10807@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Feb 04, 2008 at 02:59:44PM -0600, Moshe Yudkowsky wrote:

> I've managed to get myself into a little problem.
>
> Since power hits were taking out the /boot partition, I decided to split=
=20
> /boot out of root. Working from my emergency partition,  I copied all fil=
es=20
> from /root, re-partitioned what had been /root into room for /boot and=20
> /root, and then created the drives. This left me with /dev/md/boot,=20
> /dev/md/root, and /dev/md/base (everything else).
>
> I modified mdadm.conf on the emergency partition, used update-initramfs t=
o=20
> make certain that the new md drives would be recognized, and rebooted. Th=
is=20
> worked as expected.
>
> I then mounted all the entire new file system on a mount point, copied th=
e=20
> mdadm.conf to that point, did a chroot to that point, and did an=20
> update-initramfs so that the non-emergency partition would have the updat=
ed=20
> mdadm.conf. This worked -- but with complaints about missing the file=20
> /proc/modules (which is not present under chroot). If I use the -v option=
 I=20
> can see the raid456, raid1, etc. modules loading.
>
> I modified menu.lst to make certain that boot=3D/dev/md/boot, ran grub=20
> (thanks, Robin!) successfully.
>
> Problem: on reboot, the I get an error message:
>
> root (hd0,1)  (Moshe comment: as expected)
> Filesystem type is xfs, partition type 0xfd (Moshe comment: as expected)
> kernel /boot/vmliuz-etc.-amd64 root=3D/dev/md/boot ro
---------------^^^^^^

Are you sure that's right?  Looks like a typo to me.

Cheers,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHp37PShxCyD40xBIRAvRZAJ4jbfFXTb+44GTh+5VKtZqbZJYjygCfXx3K
cKVH5CdyDac3pBFw3sxL5jU=
=E9Ih
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
