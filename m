From: Maxime Boissonneault <maxime.boissonneault@usherbrooke.ca>
Subject: Re: Upgrading a software RAID
Date: Sat, 30 May 2009 16:03:04 -0400
Message-ID: <4A2190F8.3030204@usherbrooke.ca>
References: <20090528141457.GA30322@cthulhu.home.robinhill.me.uk> <4A1EA095.9090406@usherbrooke.ca> <20090528150849.GB30322@cthulhu.home.robinhill.me.uk> <4A2176E8.9090701@usherbrooke.ca> <20090530190348.GB23606@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090530190348.GB23606@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Robin Hill a =E9crit :
> On Sat May 30, 2009 at 02:11:52PM -0400, Maxime Boissonneault wrote:
>
>  =20
>> Ok. This is the configuration I had :
>> /dev/md1 was a RAID0 composed of /dev/sda2, /dev/sdb2 and /dev/sdc2
>>
>> I did this :
>> mdadm --stop /dev/md1
>> mdadm --zero-superblock /dev/sda2
>> mdadm --zero-superblock /dev/sdb2
>> mdadm --zero-superblock /dev/sdc2
>>
>> and then this :
>> mdadm --create --verbose /dev/md1 --level=3D5 --raid-devices=3D3 /de=
v/sda2=20
>> /dev/sdb2 /dev/sdc2
>>
>> I used the rescue mode from an alternate CD (hardy 8.04.2) to format=
=20
>> /dev/md1 as ext3. Then, I restored the backup and updated the=20
>> /etc/mdadm/mdadm.conf file with the output of mdadm --detail --scan.
>>
>> Now, GRUB loads (it was on /dev/md0 which is a RAID1 composed of sd*=
1), and=20
>> it tries to load Ubuntu, but it just won't load.
>>
>>    =20
> How far does it get with booting?  It should boot the kernel but fail=
 to
> find the root filesystem (if it's an initrd problem anyway).
>
>  =20
It says :
Loading, please wait...
Check root =3D bootarg cat /proc/cmdline or missing modules, devices : =
cat=20
/proc/modules ls /dev
ALERT! /dev/md1 does not exist. Dropping to a shell!
BusyBox v1.1.3 (Debian 1:1.1.3-5ubuntu12) Built-in shell (ash)
Enter 'help' for a list of built-in commands.

(initramfs)

>> You said that I would have to edit initrd... what is that and what d=
o I=20
>> have to change in it ?
>>
>>    =20
> The initrd is the ramdisk which the kernel boots to first, containing
> the various modules and utility programs (like mdadm) needed to acces=
s
> the main root filesytem.  A quick search suggests that you need to ru=
n
> 'update-initramfs -u' on Ubuntu.  You'll need to boot off the CD and
> chroot onto the new array first though - something like:
>
>  - Boot off CD
>  - Assemble the RAID arrays
>  - Create a mount point for the new array (mkdir /mnt/newroot)
>  - Mount the root filesystem (mount /dev/md1 /mnt/newroot)
>  - Mount the proc filesystem (mount -o bind /proc /mnt/newroot/proc)
>  - Mount the sys filesystem (mount -o bind /sys /mnt/newroot/sys)
>  - Mount the dev filesystem (mount -o bind /dev /mnt/newroot/dev)
>  - Chroot to the new array (chroot /mnt/newroot /bin/bash)
>  - Mount the boot filesystem (mount /boot)
>  - Update the initramfs (update-initramfs -u)
>  - Unmount the boot filesystem (umount /boot)
>  - Exit the chroot (exit)
>  - Unmount the dev filesystem (umount /mnt/newroot/dev)
>  - Unmount the sys filesystem (umount /mnt/newroot/sys)
>  - Unmount the proc filesystem (umount /mnt/newroot/proc)
>  - Unmount the root filesystem (umount /mnt/newroot)
>  - Reboot
>
> That's just from memory though, so watch out for any warnings/errors.
> The other issue you _may_ have is the raid5 module missing from the
> initrd - you'd best check that raid5 is listed in
> /etc/initramfs/modules.
>
> HTH,
>     Robin
>  =20

RAID5 should not be missing, my /home was a RAID5. The alternate CD=20
explicitely allows me to mount with a drive (say /dev/md1). Could I jus=
t=20
do this and update-initramfs -u, then reboot ?
Why would I have to mount all of these filesystems ? The only thing I=20
cared about before was /boot -> /dev/md0, / -> /dev/md1 and /home ->=20
/dev/md2.

Thanks

Maxime

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
