From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Soft RAID and EFI systems
Date: Sun, 2 Feb 2014 15:30:55 -0700
Message-ID: <3D3B8F1A-F525-459D-95F2-9D7889C222CD@colorremedies.com>
References: <CAC9WiBjSjBw8Y=cCd8bpwQhuy-1+swYVdHkBT7bynv6Hx8_6zA@mail.gmail.com> <70EFD3D5-F7AC-4359-8888-99EB6CCA9E4F@colorremedies.com> <52EEB9F2.2000607@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52EEB9F2.2000607@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Feb 2, 2014, at 2:34 PM, Francis Moreau <francis.moro@gmail.com> wrote:
> 
> That's funny because one of the reasons I want to use UEFI firmware is
> to get rid of grub (I don't like it and the way it has become such a
> bloated beast): since /boot is vfat and has its own partition, I prefer
> use a much simpler bootloader such as gummyboot.

It might be possible to do what you want with mdadm metadata version 1.0. Typically bootable raid1 is ext4 on md raid1 using metadata format 1.0, and an internal bitmap. When the partitions are not assembled, they each appear as separate ext4 partitions. If FAT32 on md raid1 with metadata 1.0 still looks like FAT32 as a separate partition, and the mdadm v1.0 metadata at the end of the partition doesn't confuse the firmware, what should happen is any ESP can boot the system. Once the kernel and initramfs are loaded, mdadm will locate the mdadm metadata on each partition and assemble them into a single md device, and fstab mounts the md device at /boot. So prior to boot they are separate ESPs, and after boot it's a single ESP (mirrored). But I haven't tested this arrangement with ESPs and UE
 FI.

The easiest scenario I've found for resilient boot on EFI systems is, well, not easy. First, I put shim and grub package files onto each ESP along with the previously posted grub.cfg snippet. Those grub.cfgs are one time, non-updatable files, that point to /boot/grub2/grub.cfg (produced with grub2-mkconfig on Fedora) on Btrfs raid1. That's about as reliable as it gets because the only dependencies are grub (which understands Btrfs multiple devices) and dracut baking the btrfs module into initramfs. It gets essentially fool proof if btrfs is compiled into the kernel. Other combinations are easier to break. I basically want ESPs that aren't being modified if at all avoidable because FAT32 breaks easily if anything is being written to it and there is a crash or power failure.



>> For those distros doing Secure Boot, its complicated because there is no such thing as grub-install. There's a one size fits all signed grubx64.efi which typically searches for grub.cfg in the same directory as the grubx64.efi file. That means your grub.cfg isn't mirrored, and any time you do a kernel update you have to manually update all the grub.cfgs on each ESP. Messy. That's the way it is on Fedora right now and I just filed some bugs on this.
> 
> Could you give me a pointer on the bug you filled out, I would be
> interested.

https://bugzilla.redhat.com/show_bug.cgi?id=1048999
https://bugzilla.redhat.com/show_bug.cgi?id=1022316
https://bugzilla.redhat.com/show_bug.cgi?id=1060576



Chris Murphy

