From: Maxime Boissonneault <maxime.boissonneault@usherbrooke.ca>
Subject: Re: Upgrading a software RAID
Date: Sat, 30 May 2009 18:52:20 -0400
Message-ID: <4A21B8A4.1010304@usherbrooke.ca>
References: <20090528141457.GA30322@cthulhu.home.robinhill.me.uk> <4A1EA095.9090406@usherbrooke.ca> <20090528150849.GB30322@cthulhu.home.robinhill.me.uk> <4A2176E8.9090701@usherbrooke.ca> <20090530190348.GB23606@cthulhu.home.robinhill.me.uk> <4A2190F8.3030204@usherbrooke.ca> <20090530201519.GD23606@cthulhu.home.robinhill.me.uk> <4A21B0CF.6030104@usherbrooke.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A21B0CF.6030104@usherbrooke.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Maxime Boissonneault a =E9crit :
>
>>>> The initrd is the ramdisk which the kernel boots to first, contain=
ing
>>>> the various modules and utility programs (like mdadm) needed to ac=
cess
>>>> the main root filesytem.  A quick search suggests that you need to=
 run
>>>> 'update-initramfs -u' on Ubuntu.  You'll need to boot off the CD a=
nd
>>>> chroot onto the new array first though - something like:
>>>>
>>>>  - Boot off CD
>>>>  - Assemble the RAID arrays
>>>>  - Create a mount point for the new array (mkdir /mnt/newroot)
>>>>  - Mount the root filesystem (mount /dev/md1 /mnt/newroot)
>>>>  - Mount the proc filesystem (mount -o bind /proc /mnt/newroot/pro=
c)
>>>>  - Mount the sys filesystem (mount -o bind /sys /mnt/newroot/sys)
>>>>  - Mount the dev filesystem (mount -o bind /dev /mnt/newroot/dev)
>>>>  - Chroot to the new array (chroot /mnt/newroot /bin/bash)
>>>>  - Mount the boot filesystem (mount /boot)
>>>>  - Update the initramfs (update-initramfs -u)
>>>>  - Unmount the boot filesystem (umount /boot)
>>>>  - Exit the chroot (exit)
>>>>  - Unmount the dev filesystem (umount /mnt/newroot/dev)
>>>>  - Unmount the sys filesystem (umount /mnt/newroot/sys)
>>>>  - Unmount the proc filesystem (umount /mnt/newroot/proc)
>>>>  - Unmount the root filesystem (umount /mnt/newroot)
>>>>  - Reboot
>>>>
>>>> That's just from memory though, so watch out for any warnings/erro=
rs.
>>>> The other issue you _may_ have is the raid5 module missing from th=
e
>>>> initrd - you'd best check that raid5 is listed in
>>>> /etc/initramfs/modules.
>>>>      =20
>>> RAID5 should not be missing, my /home was a RAID5.
>>>    =20
>> Yes, but /home is only mounted after it's accessed the root partitio=
n.
>> It can then read any modules from the root partition, so the raid5
>> module could still be missing from the initrd.  I suspect it'll have
>> included it though.
>>
>>  =20
> I did as you suggested above. I still get the same error message.
> I have looked and did not find /etc/initramfs/modules. Instead, I=20
> found /etc/initramfs-tools/modules. In this file, there were a couple=
=20
> of comment lines explaining how to enable modules.
> No modules were included.
> I uncommented the "raid1" and added "raid5" and ran the procedure aga=
in.
>
> Still getting the same problem.
>
> Since the problem seems to be the boot, I will try to do a fresh=20
> install, then restore my backup while keeping the /boot from the fres=
h=20
> install.
>
> Thanks,
>
> Maxime
>
Ok, I just did that, and I get the same problem. However, now, if I=20
press ctrl+alt+del while the system is trying to load, it tells me that=
=20
process rc5 and rc6 have been killed, and it bring me up to the login=20
screen of ubuntu.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
