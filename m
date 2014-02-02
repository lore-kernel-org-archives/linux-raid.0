From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Soft RAID and EFI systems
Date: Sun, 2 Feb 2014 13:39:36 -0700
Message-ID: <70EFD3D5-F7AC-4359-8888-99EB6CCA9E4F@colorremedies.com>
References: <CAC9WiBjSjBw8Y=cCd8bpwQhuy-1+swYVdHkBT7bynv6Hx8_6zA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBjSjBw8Y=cCd8bpwQhuy-1+swYVdHkBT7bynv6Hx8_6zA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 31, 2014, at 10:02 AM, Francis Moreau <francis.moro@gmail.com> wrote:

> Hello,
> 
> On EFI systems I'd like to RAID mirror /boot partition.

Yes this is non-obvious with existing tools I think. With BIOS it's as simple as grub-install /dev/sdX for each member device in the md raid1 array, and then grub-mkconfig -o /boot/grub/grub.cfg which creates a single (mirrored) copy of the grub.cfg.

For UEFI, we need:
1.  ESP created per member device
2.  grubx64.efi on each ESP. Grub-install depends on the ESP being mounted in order to install to it, unlike MBR gap or BIOS Boot installs. So you have to manually umount/mount each ESP to do a grub-install; or copy one grubx64.efi to each ESP.
3. grub.cfg at /boot/grub just like on BIOS.

For those distros doing Secure Boot, its complicated because there is no such thing as grub-install. There's a one size fits all signed grubx64.efi which typically searches for grub.cfg in the same directory as the grubx64.efi file. That means your grub.cfg isn't mirrored, and any time you do a kernel update you have to manually update all the grub.cfgs on each ESP. Messy. That's the way it is on Fedora right now and I just filed some bugs on this.

Anyway, another way to do this is a simpler grub.cfg on each ESP that's never updated again, that forwards to the /boot/grub/grub.cfg which is updated with kernel updates. That simple grub.cfg is described as:

# forward to real config
	  search --no-floppy --fs-uuid --set=root --hint-bios=hd$d,gpt2 --hint-efi=hd$d,gpt2 --hint-baremetal=ahci$d,gpt2  d7bc9d0e-7706-44f9-b1a7-ff24b7c360a7
	  configfile /boot/grub2/grub.cfg

# $d is the number for each md member disk, so that the hint is only looking for the fs-uuid on the local disk first. But I think even a single such grub.cfg that's not customized per disk will work, but it does need to be copied to each ESP.


> For Fake RAID, I'm not sure but I would say that the bios is able to
> read the RAID metadata as well.

I'm not sure if the fake raid is going to present a single ESP to the firmware or not? If the EFI System partitions are raided via fake raid, then you have only one grubx64.efi and one grub.cfg so there should be no problem? I haven't test it.

> 
> For (md) Soft RAID, I don't know. I would say that the bios is
> unlikely to understand the md metadata stored in the /boot partition
> so it won't work.

The UEFI firmware has no way of directly reading /boot aside from the md metadata, which is that it's likely ext4 which the firmware won't understand. UEFI firmware is looking for an OS loader on the EFI System Partition (ESP) and that OS Loader will be grub, which will understand both md raid1 metadata and ext4.

> Is that correct ?
> If so does that mean I can't mirror /boot partition on EFI systems ?

You can, it's just non-obvious (in my opinion) with the existing tools and installers.


> Maybe creating a RAID device using the whole disk (not the partition
> device) would work ?

No. The firmware absolutely is looking for an ESP. If you want this to be resilient across boots, then each disk needs an ESP.

And there's something I left out from above, which is that merely copying grubx64.efi might not be enough because of the all the NVRAM business. Ideally the NVRAM contains an entry pointing to each disk's ESP so that if one isn't available it falls back to another. The other way to do this on the ESP is with //EFI/BOOT/BOOTX64.efi which is simply a renamed grubx64.efi (on non-Secure Boot systems) that the firmware will load if there isn't an NVRAM entry.

On Fedora, they are using several EFI applications that also enable fallback booting absent NVRAM entries. So as long as those files are on all ESPs, we don't strictly need NVRAM entries for each ESP. We just get some extra clutter and a slight delay at boot.

Anyway, yes it's actually complicated for the mortal user, compared to BIOS booting degraded raid1, it's not you.



Chris Murphy