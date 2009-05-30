From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Upgrading a software RAID
Date: Sat, 30 May 2009 21:15:19 +0100
Message-ID: <20090530201519.GD23606@cthulhu.home.robinhill.me.uk>
References: <20090528141457.GA30322@cthulhu.home.robinhill.me.uk> <4A1EA095.9090406@usherbrooke.ca> <20090528150849.GB30322@cthulhu.home.robinhill.me.uk> <4A2176E8.9090701@usherbrooke.ca> <20090530190348.GB23606@cthulhu.home.robinhill.me.uk> <4A2190F8.3030204@usherbrooke.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sXc4Kmr5FA7axrvy"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A2190F8.3030204@usherbrooke.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--sXc4Kmr5FA7axrvy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat May 30, 2009 at 04:03:04PM -0400, Maxime Boissonneault wrote:

>
> Robin Hill a =E9crit :
>> On Sat May 30, 2009 at 02:11:52PM -0400, Maxime Boissonneault wrote:
>>
>>> Now, GRUB loads (it was on /dev/md0 which is a RAID1 composed of sd*1),=
=20
>>> and it tries to load Ubuntu, but it just won't load.
>>>    =20
>> How far does it get with booting?  It should boot the kernel but fail to
>> find the root filesystem (if it's an initrd problem anyway).
>>  =20
> It says :
> Loading, please wait...
> Check root =3D bootarg cat /proc/cmdline or missing modules, devices : ca=
t=20
> /proc/modules ls /dev
> ALERT! /dev/md1 does not exist. Dropping to a shell!
> BusyBox v1.1.3 (Debian 1:1.1.3-5ubuntu12) Built-in shell (ash)
> Enter 'help' for a list of built-in commands.
>
> (initramfs)
>
Okay, that's what I'd expect.

>>> You said that I would have to edit initrd... what is that and what do I=
=20
>>> have to change in it ?
>>>    =20
>> The initrd is the ramdisk which the kernel boots to first, containing
>> the various modules and utility programs (like mdadm) needed to access
>> the main root filesytem.  A quick search suggests that you need to run
>> 'update-initramfs -u' on Ubuntu.  You'll need to boot off the CD and
>> chroot onto the new array first though - something like:
>>
>>  - Boot off CD
>>  - Assemble the RAID arrays
>>  - Create a mount point for the new array (mkdir /mnt/newroot)
>>  - Mount the root filesystem (mount /dev/md1 /mnt/newroot)
>>  - Mount the proc filesystem (mount -o bind /proc /mnt/newroot/proc)
>>  - Mount the sys filesystem (mount -o bind /sys /mnt/newroot/sys)
>>  - Mount the dev filesystem (mount -o bind /dev /mnt/newroot/dev)
>>  - Chroot to the new array (chroot /mnt/newroot /bin/bash)
>>  - Mount the boot filesystem (mount /boot)
>>  - Update the initramfs (update-initramfs -u)
>>  - Unmount the boot filesystem (umount /boot)
>>  - Exit the chroot (exit)
>>  - Unmount the dev filesystem (umount /mnt/newroot/dev)
>>  - Unmount the sys filesystem (umount /mnt/newroot/sys)
>>  - Unmount the proc filesystem (umount /mnt/newroot/proc)
>>  - Unmount the root filesystem (umount /mnt/newroot)
>>  - Reboot
>>
>> That's just from memory though, so watch out for any warnings/errors.
>> The other issue you _may_ have is the raid5 module missing from the
>> initrd - you'd best check that raid5 is listed in
>> /etc/initramfs/modules.
>
> RAID5 should not be missing, my /home was a RAID5.
Yes, but /home is only mounted after it's accessed the root partition.
It can then read any modules from the root partition, so the raid5
module could still be missing from the initrd.  I suspect it'll have
included it though.

> The alternate CD explicitly allows me to mount with a drive (say
> /dev/md1). Could I just do this and update-initramfs -u, then reboot?
You should be able to, yes.  Worth a try anyway - it's certainly the
easiest option.

> Why would I have to mount all of these filesystems ? The only thing I car=
ed=20
> about before was /boot -> /dev/md0, / -> /dev/md1 and /home -> /dev/md2.
>
All these filesystems are standard, so will be taken care of
automatically under normal conditions.  When you're doing a chroot,
you'll need to take care of them manually though (otherwise most
commands will fail to run under the chroot).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--sXc4Kmr5FA7axrvy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkohk7YACgkQShxCyD40xBK5oQCgjz6oKPYFknP+v36hxblSBLCm
tp4An1b7IWgEFCcOA8V5+N13Fh5JIemS
=Bg33
-----END PGP SIGNATURE-----

--sXc4Kmr5FA7axrvy--
