From: CoolCold <coolthecold@gmail.com>
Subject: Re: Upgrading a software RAID
Date: Wed, 3 Jun 2009 01:13:01 +0400
Message-ID: <f19d625d0906021413m79a684b5v48f142296ddba6b8@mail.gmail.com>
References: <20090528141457.GA30322@cthulhu.home.robinhill.me.uk>
	 <4A21B0CF.6030104@usherbrooke.ca> <4A256E35.9050606@tmr.com>
	 <200906021232.50736.tfjellstrom@shaw.ca> <4A258440.5010001@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A258440.5010001@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: tfjellstrom@shaw.ca, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

debian's update-initramfs includes /etc/mdadm/mdadm.conf automatically
on image (re)build

On Tue, Jun 2, 2009 at 11:57 PM, Bill Davidsen <davidsen@tmr.com> wrote=
:
> Thomas Fjellstrom wrote:
>>
>> On Tue June 2 2009, Bill Davidsen wrote:
>>
>>>
>>> Maxime Boissonneault wrote:
>>>
>>>>>>>
>>>>>>> The initrd is the ramdisk which the kernel boots to first, cont=
aining
>>>>>>> the various modules and utility programs (like mdadm) needed to
>>>>>>> access
>>>>>>> the main root filesytem. =A0A quick search suggests that you ne=
ed to
>>>>>>> run
>>>>>>> 'update-initramfs -u' on Ubuntu. =A0You'll need to boot off the=
 CD and
>>>>>>> chroot onto the new array first though - something like:
>>>>>>>
>>>>>>> =A0- Boot off CD
>>>>>>> =A0- Assemble the RAID arrays
>>>>>>> =A0- Create a mount point for the new array (mkdir /mnt/newroot=
)
>>>>>>> =A0- Mount the root filesystem (mount /dev/md1 /mnt/newroot)
>>>>>>> =A0- Mount the proc filesystem (mount -o bind /proc /mnt/newroo=
t/proc)
>>>>>>> =A0- Mount the sys filesystem (mount -o bind /sys /mnt/newroot/=
sys)
>>>>>>> =A0- Mount the dev filesystem (mount -o bind /dev /mnt/newroot/=
dev)
>>>>>>> =A0- Chroot to the new array (chroot /mnt/newroot /bin/bash)
>>>>>>> =A0- Mount the boot filesystem (mount /boot)
>>>>>>> =A0- Update the initramfs (update-initramfs -u)
>>>>>>> =A0- Unmount the boot filesystem (umount /boot)
>>>>>>> =A0- Exit the chroot (exit)
>>>>>>> =A0- Unmount the dev filesystem (umount /mnt/newroot/dev)
>>>>>>> =A0- Unmount the sys filesystem (umount /mnt/newroot/sys)
>>>>>>> =A0- Unmount the proc filesystem (umount /mnt/newroot/proc)
>>>>>>> =A0- Unmount the root filesystem (umount /mnt/newroot)
>>>>>>> =A0- Reboot
>>>>>>>
>>>>>>> That's just from memory though, so watch out for any warnings/e=
rrors.
>>>>>>> The other issue you _may_ have is the raid5 module missing from=
 the
>>>>>>> initrd - you'd best check that raid5 is listed in
>>>>>>> /etc/initramfs/modules.
>>>>>>>
>>>>>>
>>>>>> RAID5 should not be missing, my /home was a RAID5.
>>>>>>
>>>>>
>>>>> Yes, but /home is only mounted after it's accessed the root parti=
tion.
>>>>> It can then read any modules from the root partition, so the raid=
5
>>>>> module could still be missing from the initrd. =A0I suspect it'll=
 have
>>>>> included it though.
>>>>>
>>>>
>>>> I did as you suggested above. I still get the same error message.
>>>> I have looked and did not find /etc/initramfs/modules. Instead, I
>>>> found /etc/initramfs-tools/modules. In this file, there were a cou=
ple
>>>> of comment lines explaining how to enable modules.
>>>> No modules were included.
>>>> I uncommented the "raid1" and added "raid5" and ran the procedure =
again.
>>>>
>>>> Still getting the same problem.
>>>>
>>>> Since the problem seems to be the boot, I will try to do a fresh
>>>> install, then restore my backup while keeping the /boot from the f=
resh
>>>> install.
>>>>
>>>
>>> If this were Fedora I would be using mkinitrd to get the right modu=
les
>>> in the boot image, however Ubuntu requires another method, which I =
don't
>>> know well enough to describe. You are probably on the right tract
>>> though, getting the modules and mdadm.conf available at boot.
>>>
>>
>> I assume its more or less like debian, so you just add the modules t=
o
>> /etc/initramfs-tools/modules and run: update-initramfs -uk `uname -r=
`
>>
>> then the modules you added to the modules file will be added to the
>> initramfs file, and loaded into the kernel at that stage.
>>
>>
>>
>
> Is there some explicit action needed to get the mdadm.conf file added=
 to the
> image?
>
> --
> Bill Davidsen <davidsen@tmr.com>
> =A0Even purely technical things can appear to be magic, if the docume=
ntation
> is
> obscure enough. For example, PulseAudio is configured by dancing nake=
d
> around a
> fire at midnight, shaking a rattle with one hand and a LISP manual wi=
th the
> other, while reciting the GNU manifesto in hexadecimal. The documenta=
tion
> fails
> to note that you must circle the fire counter-clockwise in the southe=
rn
> hemisphere.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
