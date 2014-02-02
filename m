From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: Soft RAID and EFI systems
Date: Sun, 02 Feb 2014 22:34:42 +0100
Message-ID: <52EEB9F2.2000607@gmail.com>
References: <CAC9WiBjSjBw8Y=cCd8bpwQhuy-1+swYVdHkBT7bynv6Hx8_6zA@mail.gmail.com> <70EFD3D5-F7AC-4359-8888-99EB6CCA9E4F@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70EFD3D5-F7AC-4359-8888-99EB6CCA9E4F@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Chris,

First of all, thanks for your answer :)

On 02/02/2014 09:39 PM, Chris Murphy wrote:
> 
> On Jan 31, 2014, at 10:02 AM, Francis Moreau <francis.moro@gmail.com> wrote:
> 
>> Hello,
>>
>> On EFI systems I'd like to RAID mirror /boot partition.
> 
> Yes this is non-obvious with existing tools I think. With BIOS it's as simple as grub-install /dev/sdX for each member device in the md raid1 array, and then grub-mkconfig -o /boot/grub/grub.cfg which creates a single (mirrored) copy of the grub.cfg.
> 
> For UEFI, we need:
> 1.  ESP created per member device
> 2.  grubx64.efi on each ESP. Grub-install depends on the ESP being mounted in order to install to it, unlike MBR gap or BIOS Boot installs. So you have to manually umount/mount each ESP to do a grub-install; or copy one grubx64.efi to each ESP.
> 3. grub.cfg at /boot/grub just like on BIOS.
>

That's funny because one of the reasons I want to use UEFI firmware is
to get rid of grub (I don't like it and the way it has become such a
bloated beast): since /boot is vfat and has its own partition, I prefer
use a much simpler bootloader such as gummyboot.

> For those distros doing Secure Boot, its complicated because there is no such thing as grub-install. There's a one size fits all signed grubx64.efi which typically searches for grub.cfg in the same directory as the grubx64.efi file. That means your grub.cfg isn't mirrored, and any time you do a kernel update you have to manually update all the grub.cfgs on each ESP. Messy. That's the way it is on Fedora right now and I just filed some bugs on this.

Could you give me a pointer on the bug you filled out, I would be
interested.

> 
> Anyway, another way to do this is a simpler grub.cfg on each ESP that's never updated again, that forwards to the /boot/grub/grub.cfg which is updated with kernel updates. That simple grub.cfg is described as:
> 
> # forward to real config
> 	  search --no-floppy --fs-uuid --set=root --hint-bios=hd$d,gpt2 --hint-efi=hd$d,gpt2 --hint-baremetal=ahci$d,gpt2  d7bc9d0e-7706-44f9-b1a7-ff24b7c360a7
> 	  configfile /boot/grub2/grub.cfg
> 
> # $d is the number for each md member disk, so that the hint is only looking for the fs-uuid on the local disk first. But I think even a single such grub.cfg that's not customized per disk will work, but it does need to be copied to each ESP.
> 

Interesting, I didn't know such trick was possible.

> 
>> For Fake RAID, I'm not sure but I would say that the bios is able to
>> read the RAID metadata as well.
> 
> I'm not sure if the fake raid is going to present a single ESP to the firmware or not? If the EFI System partitions are raided via fake raid, then you have only one grubx64.efi and one grub.cfg so there should be no problem? I haven't test it.

I haven't and can't because of lack of HW, at least for now. But I would
think there's no problem on such systems. That would give a first reason
to use them.

> 
>>
>> For (md) Soft RAID, I don't know. I would say that the bios is
>> unlikely to understand the md metadata stored in the /boot partition
>> so it won't work.
> 
> The UEFI firmware has no way of directly reading /boot aside from the md metadata, which is that it's likely ext4 which the firmware won't understand. UEFI firmware is looking for an OS loader on the EFI System Partition (ESP) and that OS Loader will be grub, which will understand both md raid1 metadata and ext4.
> 

Actually, IIRC, one metadata format (0.9 perhaps) is stored at the end
of the partition which would allow the UEFI firmware to access the /boot
partition transparently, no ?

Thanks !
