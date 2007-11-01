From: Doug Ledford <dledford@redhat.com>
Subject: Re: switching root fs '/' to boot from RAID1 with grub
Date: Thu, 01 Nov 2007 14:30:58 -0400
Message-ID: <1193941858.10336.659.camel@firewall.xsintricity.com>
References: <20071030210721.386ca2fa@absurd>
	 <1193781699.10336.585.camel@firewall.xsintricity.com>
	 <472A0D7A.4040807@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AuhkxjJ6yh98RvlDu6sX"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <472A0D7A.4040807@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-AuhkxjJ6yh98RvlDu6sX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-11-01 at 10:31 -0700, H. Peter Anvin wrote:
> Doug Ledford wrote:
> >=20
> > device /dev/sda (hd0)
> > root (hd0,0)
> > install --stage2=3D/boot/grub/stage2 /boot/grub/stage1 (hd0) /boot/grub=
/e2fs_stage1_5 p /boot/grub/stage2 /boot/grub/menu.lst
> > device /dev/hdc (hd0)
> > root (hd0,0)
> > install --stage2=3D/boot/grub/stage2 /boot/grub/stage1 (hd0) /boot/grub=
/e2fs_stage1_5 p /boot/grub/stage2 /boot/grub/menu.lst
> >=20
> > That will install grub on the master boot record of hdc and sda, and in
> > both cases grub will look to whatever drive it is running on for the
> > files to boot instead of going to a specific drive.
> >=20
>=20
> No, it won't... it'll look for the first drive in the system (BIOS drive=20
> 80h).

Yes, and except for some fantastic BIOS I've never heard of, the drive
that the BIOS reads the boot sector from is always the 0x80 drive.  This
is either because the drive truly is the first drive, or because the
BIOS is remapping a later drive to 0x80 for boot purposes.  In either
case, what I said is still true: the boot sector will look to read the
data files from the drive the boot sector itself was read from.

>   This means that if the BIOS can see the bad drive, but it doesn't=20
> work, you're still screwed.

Correct, and that's what you want.  The alternative is that if the BIOS
can see the first disk but it's broken and can't be used, and if you
have the boot sector on the second disk set to read from BIOS disk 0x81
because you ASSuMEd the first disk would be broken but still present in
the BIOS tables, then your machine won't boot unless that first dead but
preset disk is present.  If you remove the disk entirely, thereby
bumping disk 0x81 to 0x80, then you are screwed.  If you have any drive
failure that prevents the first disk from being recognized (blown fuse,
blown electronics, etc), you are screwed until you get a new disk to
replace it.

Follow these simple rules when setting up boot sectors and you'll be OK:

1)  If you are using RAID1, then a boot sector should *never* try and
read data from anything other than the disk the boot sector is on.  To
do otherwise defeats the whole purpose of RAID1 which is that you only
need 1 disk to survive in order for the array to survive.
2)  If the BIOS runs any given MBR in the RAID array, then that MBR will
be on the disk the BIOS has mapped to 0x80.
3)  While there are failure scenarios that would leave a disk unusable
but still visible to the OS, there are no magic BIOS switches to fake a
totally dead device.  So, since you can remove a defunct but present
disk in order to allow disk B to become disk A, but you can't magic a
new disk A out of thin air should it fail to the point of not being
recognized, set all your raid boot sectors to think they are the first
disk in the system and you will always be able to start your machine.

So, what I said is true, the MBR will search on the disk it is being run
from for the files it needs: 0x80.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-AuhkxjJ6yh98RvlDu6sX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHKhtiTzP9PM7pjw8RAvvbAJ0cicR8X3U7kJJpXbkxhwUi1DP76gCeN0EP
hDsbcT/MbsBh7+qaddCXgFc=
=mTfC
-----END PGP SIGNATURE-----

--=-AuhkxjJ6yh98RvlDu6sX--

