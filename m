From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Upgrading a software RAID
Date: Tue, 02 Jun 2009 14:23:49 -0400
Message-ID: <4A256E35.9050606@tmr.com>
References: <20090528141457.GA30322@cthulhu.home.robinhill.me.uk> <4A1EA095.9090406@usherbrooke.ca> <20090528150849.GB30322@cthulhu.home.robinhill.me.uk> <4A2176E8.9090701@usherbrooke.ca> <20090530190348.GB23606@cthulhu.home.robinhill.me.uk> <4A2190F8.3030204@usherbrooke.ca> <20090530201519.GD23606@cthulhu.home.robinhill.me.uk> <4A21B0CF.6030104@usherbrooke.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A21B0CF.6030104@usherbrooke.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Maxime Boissonneault <maxime.boissonneault@usherbrooke.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Maxime Boissonneault wrote:
>
>>>> The initrd is the ramdisk which the kernel boots to first, containing
>>>> the various modules and utility programs (like mdadm) needed to access
>>>> the main root filesytem.  A quick search suggests that you need to run
>>>> 'update-initramfs -u' on Ubuntu.  You'll need to boot off the CD and
>>>> chroot onto the new array first though - something like:
>>>>
>>>>  - Boot off CD
>>>>  - Assemble the RAID arrays
>>>>  - Create a mount point for the new array (mkdir /mnt/newroot)
>>>>  - Mount the root filesystem (mount /dev/md1 /mnt/newroot)
>>>>  - Mount the proc filesystem (mount -o bind /proc /mnt/newroot/proc)
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
>>>> That's just from memory though, so watch out for any warnings/errors.
>>>> The other issue you _may_ have is the raid5 module missing from the
>>>> initrd - you'd best check that raid5 is listed in
>>>> /etc/initramfs/modules.
>>>>       
>>> RAID5 should not be missing, my /home was a RAID5.
>>>     
>> Yes, but /home is only mounted after it's accessed the root partition.
>> It can then read any modules from the root partition, so the raid5
>> module could still be missing from the initrd.  I suspect it'll have
>> included it though.
>>
>>   
> I did as you suggested above. I still get the same error message.
> I have looked and did not find /etc/initramfs/modules. Instead, I 
> found /etc/initramfs-tools/modules. In this file, there were a couple 
> of comment lines explaining how to enable modules.
> No modules were included.
> I uncommented the "raid1" and added "raid5" and ran the procedure again.
>
> Still getting the same problem.
>
> Since the problem seems to be the boot, I will try to do a fresh 
> install, then restore my backup while keeping the /boot from the fresh 
> install.

If this were Fedora I would be using mkinitrd to get the right modules 
in the boot image, however Ubuntu requires another method, which I don't 
know well enough to describe. You are probably on the right tract 
though, getting the modules and mdadm.conf available at boot.

-- 
Bill Davidsen <davidsen@tmr.com>
  Even technical things can appear to be magic, if the documentation is
obscure enough. For example, PulseAudio is configured by dancing naked around
a fire at midnight, shaking a rattle with one hand and a LISP manual with the
other, while reciting the GNU manifesto in hexadecimal.

