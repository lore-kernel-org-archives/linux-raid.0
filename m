From: Doug Ledford <dledford@redhat.com>
Subject: Re: switching root fs '/' to boot from RAID1 with grub
Date: Tue, 30 Oct 2007 18:01:39 -0400
Message-ID: <1193781699.10336.585.camel@firewall.xsintricity.com>
References: <20071030210721.386ca2fa@absurd>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iBI+Oi7PwW3Q/4jtZ0mY"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071030210721.386ca2fa@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-iBI+Oi7PwW3Q/4jtZ0mY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-30 at 21:07 +0100, Janek Kozicki wrote:
> Hello,
>=20
> I have and olde HDD and two new HDDs:
>=20
> - hda1 - my current root filesystem '/'
> - sda1 - part of raid1 /dev/md0 [U_U]
> - hdc1 - part of raid1 /dev/md0 [U_U]
>=20
> I want all hda1, sda1, hdc1 to be a raid1. I remounted hda1 readonly=20
> then I did 'dd if=3D/dev/hda1 of=3D/dev/md0'. I carefully checked that
> the partition sizes match exactly. So now md0 contains the same thing
> as hda1.=20
>=20
> But hda1 is still outside of the array. I want to add it to the array.
> But before I do this I think that I should boot from /dev/md0 ?
> Otherwise I might hose this system. I tried `grub-install /dev/sda1`
> (assuming that grub would see no problem with reading raid1
> partition, and boot from it, until mdadm detects an array). I tried
> `grub-install /dev/sda` as well as on /dev/hdc and /dev/hdc1.
> I turned off 'active' flag for partition hda1 and turned it on for hdc1
> and sda1. But still grub is booting from hda1.

Well, without going into a lot of detail, you would have to boot
from /dev/hda1 and specify a root=3D/dev/md0 option to the kernel to
actually boot to the new / filesystem before grub-install will do what
you are expecting.  The fact that hda1 is mounted as / and that hda1
contains /boot with all your kernels and initrd images means that when
you run grub-install it looks up the current location of the /boot
files, sees they are on /dev/hda1, and regardless of where you put the
boot sector (sda1, hdc1), those sectors point to the files grub found
in /boot which are on hda1.

> I did all this with version 1.1

Which won't work, and you'll see that as soon as you have md0 mounted
as / and try to run grub-install again.

> mdadm --create --verbose /dev/md0 --chunk=3D64 --level=3Draid1 \
>       --metadata=3D1.1  --bitmap=3Dinternal --raid-devices=3D3 /dev/sda1 =
\
>       missing /dev/hdc1
>=20
> I'm NOT using LVM here.
>=20
> Can someone tell me how should I switch grub to boot from /dev/md0 ?
>=20
> After the boot I will add hda1 to the array, and all three partitions
> should become a raid1.

Grub doesn't work with version 1.1 superblocks at the moment.  It could
be made to work quick and dirty in a short period of time, making it
work properly would take longer.

So, here's what I would do in your case.  Scrap the current /dev/md0
setup.  Make a new /dev/md0 using a version 1.0 superblock with all the
other options the same as before.  BTW, your partition sizes don't need
to match exactly.  If the new device is larger than your /dev/hda1, then
no big deal, just do the dd like you did before and when you are done
you can resize the fs to fit the device.  If the new device is slightly
smaller than /dev/hda1, then just run resizefs to shrink your /dev/hda1
to the same size as the fs on the /dev/md0 *before* you do the dd from
hda1 to md0.  Once you have the data copied to /dev/md0, you'll need to
reboot the system and this time specify /dev/md0 as your root device
(you may need to remake your initrd before you reboot, I don't know if
your initrd starts /dev/md0, but it needs to).  Once you are running
with md0 as your root partition, you need to run grub to install the
boot sectors on the md0 devices.  You can't use grub-install though, it
gets it wrong.  Run the grub command, then enter these commands:

device /dev/sda (hd0)
root (hd0,0)
install --stage2=3D/boot/grub/stage2 /boot/grub/stage1 (hd0) /boot/grub/e2f=
s_stage1_5 p /boot/grub/stage2 /boot/grub/menu.lst
device /dev/hdc (hd0)
root (hd0,0)
install --stage2=3D/boot/grub/stage2 /boot/grub/stage1 (hd0) /boot/grub/e2f=
s_stage1_5 p /boot/grub/stage2 /boot/grub/menu.lst

That will install grub on the master boot record of hdc and sda, and in
both cases grub will look to whatever drive it is running on for the
files to boot instead of going to a specific drive.

Next you need to modify the /etc/grub.conf and change all the root=3D
lines to be root=3D/dev/md0, and you need to modify /etc/fstab the same
way.  Then you probably need to remake all the initrd images so that
they contain the update.

Once you've done that, shut the system down, remove /dev/hda from the
machine entirely, move /dev/hdc to /dev/hda, then reboot.  The system
should boot up to your raid array just fine.  If it doesn't work, you
can always put your old hda back in and boot up from it.  If it does
work, shut the machine down one more time, put the old hda in as hdc,
boot back up (which should boot from hda to the md0 root, it should not
touch hdc), add hdc to the raid array, let it resync, and then the final
step is to run the grub install on hdc to make it match the other two
disks.  After that, you have a fully functional and booting raid1 array.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-iBI+Oi7PwW3Q/4jtZ0mY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJ6nDTzP9PM7pjw8RAjtYAJ4+dIC51neqzwYlzuSQ9bTpX8m76QCfWT5z
nPMC9izDwx2omepUBEiCbYA=
=5zVU
-----END PGP SIGNATURE-----

--=-iBI+Oi7PwW3Q/4jtZ0mY--

