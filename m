From: Martin T <m4rtntns@gmail.com>
Subject: Re: Linux software-RAID and bootloader
Date: Sat, 8 Mar 2014 04:13:02 +0000
Message-ID: <CAJx5YvF7t=suX8jzQso4cjPPqFgCgBDXiop9i47F+C2A2KtR=g@mail.gmail.com>
References: <CAJx5YvGGM7yziWQEefs=_Wte4jy13w1x1oG6MuUOggSgTfodMQ@mail.gmail.com>
	<67153819-285E-430A-A745-A96D6ECDA4DB@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <67153819-285E-430A-A745-A96D6ECDA4DB@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, pg@lxra2.for.sabi.co.uk
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Chris, Peter,

thank you for this information! So in a nutshell, it's important to
make sure that partitioning tool leaves enough space between the start
of the block device and the first partition so that both Linux MD RAID
and bootloader can both write their data to this area?
In addition, it's a best practice to mirror MBR/GPT using
sfdisk/sgdisk(or dd) to each block device in RAID array and then
install GRUB to each block device separately?


regards,
Martin

On Fri, Mar 7, 2014 at 7:45 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Mar 6, 2014, at 8:13 PM, Martin T <m4rtntns@gmail.com> wrote:
>
>> Hi,
>>
>> how is it ensured that superblock(for example version 1.2) can be
>> created at 4KiB from the beginning of the drive? I mean isn't there a
>> hazard that this area on the disk is already occupied for example by
>> the bootloader stage 1.5?
>
> The offset is 4KB from the block device. So if the chosen block device is the drive, e.g. /dev/sda, then the superblock will start at LBA 8. If it's /dev/sda1 then typically it would be LBA 2056 since most partition tools these days start the first partition at 2048.
>
>> In addition, if software-RAID is created using partitions for example
>> like this: mdadm --create --verbose --level=1 --metadata=1.2
>> --chunk=64 --raid-devices=2 /dev/md0 /dev/sdb1 /dev/sdc1
>
> In that case it's almost certainly at LBA 2056, whereas the MBR gap ranges from LBA 1 to 2047, and only a small part of which (less than 50K) will be the GRUB core.img (essentially it's a mandatory stage 1.5).
>
>
>> ..then how should one ensure that for example MBR/GPT is mirrored or
>> bootloader data is mirrored which both are located out of partition
>> boundaries?
>
> The MBR/GPT and bootloader are not mirrored. grub-install can detect if /boot is on md raid, and will install an appropriate core.img on each disk's MBR gap or BIOS Boot partition.
>
> Right now this doesn't happen on UEFI because grub-install only installs core.img (as grubx64.efi) onto /boot/efi which can only be one EFI System partition. It's not a good UX. The way it ought to work in my opinion, is to never have persistently mounted ESPs. The grub-install should determine member drives of /boot, and then mount their ESP's and install an appropriate grubx64.efi (core.img) to each; as well as a very basic grub.cfg that merely points GRUB to the real grub.cfg on /boot/grub - which since it's mirrored or raid5/6, only one copy must be maintained by the kernel upgrade utility.
>
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
