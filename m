From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: Woody, initrd, raid1, boot
Date: Mon, 17 Jun 2002 20:50:19 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020617185019.GB7974@unthought.net>
References: <20020617171511.B12084@itreff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020617171511.B12084@itreff.de>
To: Thomas -Balu- Walter <tw@itreff.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jun 17, 2002 at 05:15:11PM +0200, Thomas -Balu- Walter wrote:
> First two smaller questions/notes:
> The FAQ at http://www.tldp.org/FAQ/Linux-RAID-FAQ/index.html lists
> three mailinglist-archives, while only
> http://marc.theaimsgroup.com/?l=3Dlinux-raid&r=3D1&w=3D2 seems to hav=
e actual
> mails (I was kinda shocked that the last mails were coming from 2000 =
:)
>=20
> What are the actual raidtools? raidtools-20010914?

On debian woody here, I use 0.90.20010914-15

>=20
> Now to a something more complex problem (which I am going to despair =
on):
>=20
> I've read different HOWTOs, Hints, Tipps and tricks, but none helped.

I'm sorry to hear that  :)

>=20
> I am trying to set up a debian (woody) system running the
> debian-packaged 2.4.18-686-kernel that boots from "root=3D/dev/md1" (=
and
> uses the debian-initrd to load the md-modules)
>=20
> To do so, I've installed a minimal woody using a netinstall-CD and
> upgraded it to kernel-image-2.4.18-686 (including the initrd-changes =
to
> lilo). The system got installed on hda:
>=20
> Disk /dev/hda: 4865 cylinders, 255 heads, 63 sectors/track
> Units =3D cylinders of 8225280 bytes, blocks of 1024 bytes, counting =
from 0
>=20
>    Device Boot Start     End   #cyls   #blocks   Id  System
> /dev/hda1   *      0+      5       6-    48163+  83  Linux
> /dev/hda2          6      67      62    498015   82  Linux swap
> /dev/hda3         68     675     608   4883760   83  Linux
> /dev/hda4          0       -       0         0    0  Empty
>=20
> while /dev/hhda1 is mounted as /boot and /dev/hda3 is mounted as / an=
d
> /dev/hdc got exact the same partition table.=20
>=20
> I rebooted to get 2.4.18 up and running, then I've changed the
> /dev/hdc-partitions to be Raid-Autodetect and set up the following
> /etc/raidtab:
>=20
>         # /boot
>         raiddev /dev/md0
>                 raid-level      1
>                 nr-raid-disks   2
>                 nr-spare-disks  0
>                 chunk-size      4
>                 persistent-superblock   1
>                 device          /dev/hdc1
>                 raid-disk       0
>                 device          /dev/hda1
>                 failed-disk     1
>=20
>         # /
>         raiddev /dev/md1
>                 raid-level      1
>                 nr-raid-disks   2
>                 nr-spare-disks  0
>                 chunk-size      4
>                 persistent-superblock   1
>                 device          /dev/hdc3
>                 raid-disk       0
>                 device          /dev/hda3
>                 failed-disk     1

Good

>=20
> I've prepared the md-devices using mkraid and mke2fs, mounted them
>         /dev/md1 -> /mnt
>         /dev/md0 -> /mnt/boot

Good

>=20
> Next was to "cp -a" the installed system on the md-devices (all but
> /mnt, /proc and /lost+found) and change /mnt/etc/fstab to mount the
> md-devices instead of the original /dev/hda partitions.
>=20
> So far, everything is okay. Next I tried to reboot and at boot I told
> lilo to run "Linux root=3D/dev/md1", but I get
>=20
>         md: md driver 0.90.0 MAX_MD...
>         cramfs: wrong magic
>         EXT3-FS: unable to read superblock
>         EXT2-FS: unable to read superblock
>         Kernel panic: VFS: Unable to mount root fs on 09:01

Since it's cramfs that complains, I suppose it's your initrd that is
bad.

>=20
> Missing the raid-module, I've added "raid1" to /etc/mkinitrd/modules =
and
> created a new initrd:
>       # mkinitrd -o /boot/initrd-2.4.18-686-raid1 /lib/modules/2.4.18=
-686
>       # ln -sf /boot/initrd-2.4.18-686-raid1 /initrd.img
>       # lilo
>=20
> Now the raid1-module gets loaded right after the md-module, but I kee=
p
> getting the same error.
>=20
> I've also tried the way James Bromberger suggests in
> http://www.james.rcpt.to/programs/debian/raid1/ - especially using
> (manually entered by now though) the append parameters
> "md=3D0,/dev/hdc1,/dev/hda1", and "root=3D/dev/md0" (and
> "md=3D1,/dev/hdc3,/dev/hda3") and and and.
>=20
> Also tested was root=3D/dev/md1 in mkinitrd.conf.
>=20
> Another approach was adding the values to lilo.conf -=20
>         boot=3D/dev/md0
>         root=3D/dev/md1
> (which should not make a difference than adding it to the lilo-prompt=
?)
>=20
> One of my biggest problems is, that I don't know where the problem is
> located - is it lilo (which boots the kernel and initrd and should be
> fine?), initrd (missing a module?) or the root-filesystem on the
> md-devices, or even the md-devices themself (it should be possible to
> boot from a degraded device?)

It looks like you have an initrd problem.

>=20
> I am really clueless... :-/ any hints?

Compile the RAID-1 into the kernel, forget about using modules.  That i=
s
the simple solution that I use - I am no initrd expert, and I have no
intentions of becoming one  :)

--=20
=2E...............................................................
:   jakob@unthought.net   : And I see the elder races,         :
:.........................: putrid forms of man                :
:   Jakob =D8stergaard      : See him rise and claim the earth,  :
:        OZ9ABN           : his downfall is at hand.           :
:.........................:............{Konkhra}...............:
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
