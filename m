From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Converting system to raid
Date: Sun, 12 Apr 2009 12:11:07 +0100
Message-ID: <20090412111107.GA19413@cthulhu.home.robinhill.me.uk>
References: <49DF0D06.8030705@musmo.com> <20090410195303.GB21242@cthulhu.home.robinhill.me.uk> <00cc01c9ba1d$3aefecf0$0a00a8c0@vorg> <20090410205942.GC21242@cthulhu.home.robinhill.me.uk> <00f301c9ba23$032025f0$0a00a8c0@vorg> <20090410215129.GD21242@cthulhu.home.robinhill.me.uk> <019701c9ba66$aeed5630$0a00a8c0@vorg> <f19d625d0904110729y30e8bc80m41fcd8f2c3298d49@mail.gmail.com> <007001c9bad6$2525c610$0a00a8c0@vorg> <001201c9bb09$3161e9d0$0a00a8c0@vorg>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <001201c9bb09$3161e9d0$0a00a8c0@vorg>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat Apr 11, 2009 at 05:53:04PM -0700, Timothy D. Lenz wrote:

> I used a grml x86-64 boot cd and it seemed to create hda as sdc. I
> mounted sdc1 and md0 to /mnt and used:
>=20
> rsync -cavHh --progress --delete /mnt/sdc1 /mnt/md0
>=20
Yes, GRML uses the newer libata drivers for both PATA and SATA, so both
will appear as sd? devices.

> After rebooting back to hda1 I changed fstab to put root on /dev/md0
> and changed menu.lst on /mnt/md0. Rebooted and moved the ide to the
> bottom of the boot list in cmos so the 2 sata drives are listed first.
> It seems to have booted to md0 ok. Now I need to confirm everything is
> set correct.
>=20
That's good :)

> Before when at the grub boot menu when booting with the ide moved
> below the sata drives, droping to command line for grub showed that
> the ide drive only moved down 1, not 2. It seemed to have:
>   hd0 =3D sda
>   hd1 =3D hda
>   hd2 =3D sdb
>=20
> Now with the array booted, going to the grub command line and using
> auto complete for "root (hd0," it seems to be using the device map at
> this point which is no longer correct:
> (hd0) /dev/hda
> (hd1) /dev/sda
> (hd2) /dev/sdb
>=20
> Note that in the other system, because linux was installed with only
> the ide and 1 sata drive, it doesn't even list the other two in it's
> device map. So what is the best/safest way to update/correct this to
> what ever it should be?
>
Just delete/rename the old device map file (/boot/grub/device.map) and
run grub again - it'll rescan the devices and create a new map file.

> Moving swap:
> I have used "sudo mkswap /dev/md1" so if I read info correct, I should
> be able to just change fstab:
>   /dev/md1       none            swap    sw              0       0
>=20
> and reboot to start using md1 array for swap?
>
Yup, swap's very simple to change.

> menu.lst updates:
> The guides all call for assorted changes to menu.lst Some of the
> guides call for adding the line savedefault to kernel entries but the
> people in #grub said not to do that with a raid system as it would
> corrupt the array and I thought I saw something about that reading
> about grub but can't find it.
>=20
No, best not doing that - it just makes grub always default to the last
chosen option, rather than always using the same default.

> Some guides call for adding "fallback 1" after "default 0". And all
> call for adding duplicating the first kernel entry but changing root
> to (1,0) for the second entry. But some have said it's not needed.
> Sorry of some of these questions have been answered before, but I want
> to make sure everything is updated/corrected as needed before moving
> on to the other stuff I need to do. Don't want to get nearly done and
> have a nasty suprise down the road or the next time I build/install a
> new kernel because something was missed.
>=20
Neither of these options are likely to make much difference.  Fallback
just means it will boot the second entry if the first can't be found -
it's more likely that the first will fail to boot, in which case you're
no better off.  As for adding a duplicate entry with a changed root
device - this is unlikely to help at all.  In order for GRUB to boot
that far, it has to have read the stage1 bootloader from the MBR of the
first disk and the stage 1.5, stage 2 and menu files from /boot on the
first disk.  The chances of it managing all of that but then being
unable to read the kernel from the first disk are pretty slim.

I'd just leave it as is - if the first disk fails altogether then it
should boot straight from the second disk, and for other failures you
can just edit the boot commands in grub manually to fix/work around
whatever the issue is.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAknhzEgACgkQShxCyD40xBL/bQCfdAsVzBWGjESuHhXeGd+K/S3l
DCoAn0NF0aA+ihBGi6MCmbAx4g3iRZSP
=uNzq
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
