From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: Soft RAID and EFI systems
Date: Fri, 07 Feb 2014 09:00:24 +0100
Message-ID: <52F49298.6030305@gmail.com>
References: <CAC9WiBjSjBw8Y=cCd8bpwQhuy-1+swYVdHkBT7bynv6Hx8_6zA@mail.gmail.com> <70EFD3D5-F7AC-4359-8888-99EB6CCA9E4F@colorremedies.com> <52EEB9F2.2000607@gmail.com> <3D3B8F1A-F525-459D-95F2-9D7889C222CD@colorremedies.com> <52F0A58D.6000400@gmail.com> <F1ACED9B-6316-4DF1-829E-E6FB6A2F0B8A@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F1ACED9B-6316-4DF1-829E-E6FB6A2F0B8A@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/04/2014 03:50 PM, Chris Murphy wrote:
> 
> On Feb 4, 2014, at 1:32 AM, Francis Moreau <francis.moro@gmail.com> wrote:
> 
>> On 02/02/2014 11:30 PM, Chris Murphy wrote:
>>>
>>> On Feb 2, 2014, at 2:34 PM, Francis Moreau <francis.moro@gmail.com> wrote:
>>>>
>>>> That's funny because one of the reasons I want to use UEFI firmware is
>>>> to get rid of grub (I don't like it and the way it has become such a
>>>> bloated beast): since /boot is vfat and has its own partition, I prefer
>>>> use a much simpler bootloader such as gummyboot.
>>>
>>> It might be possible to do what you want with mdadm metadata version 1.0. Typically bootable raid1 is ext4 on md raid1 using metadata format 1.0, and an internal bitmap. When the partitions are not assembled, they each appear as separate ext4 partitions. If FAT32 on md raid1 with metadata 1.0 still looks like FAT32 as a separate partition, and the mdadm v1.0 metadata at the end of the partition doesn't confuse the firmware, what should happen is any ESP can boot the system. Once the kernel and initramfs are loaded, mdadm will locate the mdadm metadata on each partition and assemble them into a single md device, and fstab mounts the md device at /boot. So prior to boot they are separate ESPs, and after boot it's a single ESP (mirrored). But I haven't tested this arrangement with ESPs an
 d UEFI.
>>
>> I'll test this configuration and see if it works soon.
>>
>>>
>>> The easiest scenario I've found for resilient boot on EFI systems is, well, not easy. First, I put shim and grub package files onto each ESP along with the previously posted grub.cfg snippet. Those grub.cfgs are one time, non-updatable files, that point to /boot/grub2/grub.cfg (produced with grub2-mkconfig on Fedora) on Btrfs raid1. That's about as reliable as it gets because the only dependencies are grub (which understands Btrfs multiple devices) and dracut baking the btrfs module into initramfs. It gets essentially fool proof if btrfs is compiled into the kernel. Other combinations are easier to break. I basically want ESPs that aren't being modified if at all avoidable because FAT32 breaks easily if anything is being written to it and there is a crash or power failure.
>>>
>>
>> I agree that FAT32 can break during power failure, that's the reason why
>> I'm trying to make it mirrored. But I want to get rid of grub as much as
>> possible so I would prefer to use the first solution.
> 
> Having gone down the grub2-efi road, I don't blame you at all. However, I really think to be useful gummiboot is going to need filesystem extensions. I'm biased, if it were one filesystem, I'd pick Btrfs because so much can be gained with less work, and then put /boot files there. But because ext4 would be a gateway to supporting pretty much everything else, that's also understandable.
> 

Hmm ESP must be vfat so you'll always get a (small) number of files
(bootloader configurations files) that can be rewritten and will live in
the ESP.

And some bootloaders, such as syslinux (probably gummiboot too), do not
(currently) have the ability to access files outside its own partition
so they need the kernel and initramfs files to be in the ESP.

> I think the ESP really ought to be predominately read only, and in terms of resilience we're better off updating each disk's ESP one at a time asynchronously, so that a crash or power fail hopefully only munges one device's ESP. If we get such an event with a raid1'd ESP all bets are off - if there's corruption it's likely on all ESPs (by design) and it's even possible they each have slightly different problems.
> 
> A compromise option for you is rEFInd, which like gummiboot is much much simpler than GRUB. But it does have filesystem extensions so you can put only rEFInd on each ESP. And then put boot files on something else like ext4, or even ext4 on md raid if you choose e.g. metadata 1.0.
> 

I didn't know rEFInd, thanks for pointing it out. It seems that it
currently supports ReiserFS and ext2 filesystems though.

> And yet still another option, maybe even simpler, is extlinux for EFI. This work is somewhat new, and I haven't tried it. I know that grub (Fedora), gummiboot and rEFInd are using EFISTUB as the actual bootloader. I suspect the same is the case for extlinux which would make things easier.
> 

There's also syslinux which can be used on UEFI systems. It supports a
reasonnable number of filesystems but comes with some limitations too:
https://wiki.archlinux.org/index.php/syslinux#Limitations_of_UEFI_Syslinux

Thanks.
