From: David Brown <david.brown@hesbynett.no>
Subject: Re: Soft RAID and EFI systems
Date: Tue, 04 Feb 2014 09:57:04 +0100
Message-ID: <52F0AB60.8000800@hesbynett.no>
References: <CAC9WiBjSjBw8Y=cCd8bpwQhuy-1+swYVdHkBT7bynv6Hx8_6zA@mail.gmail.com> <70EFD3D5-F7AC-4359-8888-99EB6CCA9E4F@colorremedies.com> <52EEB9F2.2000607@gmail.com> <3D3B8F1A-F525-459D-95F2-9D7889C222CD@colorremedies.com> <52F0A58D.6000400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52F0A58D.6000400@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>, Chris Murphy <lists@colorremedies.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/02/14 09:32, Francis Moreau wrote:
> On 02/02/2014 11:30 PM, Chris Murphy wrote:
>> 
>> On Feb 2, 2014, at 2:34 PM, Francis Moreau <francis.moro@gmail.com>
>> wrote:
>>> 
>>> That's funny because one of the reasons I want to use UEFI
>>> firmware is to get rid of grub (I don't like it and the way it
>>> has become such a bloated beast): since /boot is vfat and has its
>>> own partition, I prefer use a much simpler bootloader such as
>>> gummyboot.
>> 
>> It might be possible to do what you want with mdadm metadata
>> version 1.0. Typically bootable raid1 is ext4 on md raid1 using
>> metadata format 1.0, and an internal bitmap. When the partitions
>> are not assembled, they each appear as separate ext4 partitions. If
>> FAT32 on md raid1 with metadata 1.0 still looks like FAT32 as a
>> separate partition, and the mdadm v1.0 metadata at the end of the
>> partition doesn't confuse the firmware, what should happen is any
>> ESP can boot the system. Once the kernel and initramfs are loaded,
>> mdadm will locate the mdadm metadata on each partition and assemble
>> them into a single md device, and fstab mounts the md device at
>> /boot. So prior to boot they are separate ESPs, and after boot it's
>> a single ESP (mirrored). But I haven't tested this arrangement with
>> ESPs and UEFI.
> 
> I'll test this configuration and see if it works soon.
> 
>> 
>> The easiest scenario I've found for resilient boot on EFI systems
>> is, well, not easy. First, I put shim and grub package files onto
>> each ESP along with the previously posted grub.cfg snippet. Those
>> grub.cfgs are one time, non-updatable files, that point to
>> /boot/grub2/grub.cfg (produced with grub2-mkconfig on Fedora) on
>> Btrfs raid1. That's about as reliable as it gets because the only
>> dependencies are grub (which understands Btrfs multiple devices)
>> and dracut baking the btrfs module into initramfs. It gets
>> essentially fool proof if btrfs is compiled into the kernel. Other
>> combinations are easier to break. I basically want ESPs that aren't
>> being modified if at all avoidable because FAT32 breaks easily if
>> anything is being written to it and there is a crash or power
>> failure.
>> 
> 
> I agree that FAT32 can break during power failure, that's the reason
> why I'm trying to make it mirrored. But I want to get rid of grub as
> much as possible so I would prefer to use the first solution.

Mirroring will not help FAT32 during power failure - you have a good
chance of getting two copies of the same error.  And if your power fail
hits during writes, you also have a good chance of the two disks having
/different/ errors and inconsistencies.  The problem lies in FAT32
having no log, and no barriers or ordering when it makes changes -
updates to the file data, the directory structure, and the FAT table can
happen in different orders, and a power failure can leave one part
updated and the other part with old data.  Raid cannot help with this
problem.

The most important way to protect your FAT32 system is simply to avoid
writing to it except when absolutely necessary.  If it is mounted
read-only, and only updated when changing grub or updating the kernel,
then just make sure you don't power-cycle your machine at that time.
The smaller the critical window, the smaller the chances of problems.

If you need to do updates more regularly, then your best bet is to have
independent FAT32 partitions on the two disks.  Make your updates on one
disk, and when it is finished copy the changes onto the other disk.
Then you always have a good copy - if you get a crash while the first
disk is being updated, then when you re-start the computer, use its boot
menu to choose booting from the second disk.

> 
>> 
>> 
>>>> For those distros doing Secure Boot, its complicated because
>>>> there is no such thing as grub-install. There's a one size fits
>>>> all signed grubx64.efi which typically searches for grub.cfg in
>>>> the same directory as the grubx64.efi file. That means your
>>>> grub.cfg isn't mirrored, and any time you do a kernel update
>>>> you have to manually update all the grub.cfgs on each ESP.
>>>> Messy. That's the way it is on Fedora right now and I just
>>>> filed some bugs on this.
>>> 
>>> Could you give me a pointer on the bug you filled out, I would
>>> be interested.
>> 
>> https://bugzilla.redhat.com/show_bug.cgi?id=1048999 
>> https://bugzilla.redhat.com/show_bug.cgi?id=1022316 
>> https://bugzilla.redhat.com/show_bug.cgi?id=1060576
> 
> Thanks.
> 
