From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Tue, 14 Apr 2020 15:20:08 +0100
Message-ID: <5E95C698.1030307@youngman.org.uk>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/04/20 14:02, Stefanie Leisestreichler wrote:
> Hi List.
> I want to set up a new server. Data should be redundant that is why I
> want to use RAID level 1 using 2 HDs, each having 1TB. Like suggested in
> the wiki, I want to have the RAID running on a partition which has
> TOTAL_SIZE - 100M allocated for smoother replacement of an array-disk in
> case of failure.
> 
> The firmware is UEFI, Partitioning will be made using GPT/gdisk.
> 
> Boot manager should be GRUB (not legacy).

Why? Why not EFI? That can boot linux just as easily as it can boot grub.
> 
> To be safe on system updates I want to use LVM snapshots. I like to make
> a LVM-based snapshot when the system comes up, do the system updates,
> perform the test and dicide either to go with the updates made or revert
> to the original state.
> 
That's a good idea. Have you already got the 1TB disks, and how much
"growth room" does 1TB provide? Make sure you get drives that are
SCT/ERC-capable, and I'd certainly look at going larger. The more spare
space you have, the more snapshots you can keep, maybe keeping a backup
once a fortnight going back back back (or even daily :-)

> I have read that - when using UEFI - the EFI-System-Partition (ESP) has
> to reside in a own native partition, not in a RAID nor LVM block device.
> 
EFI is the replacement for BIOS - in other words it's encoded in the
motherboard ROM and knows nothing about linux and linux-type file
systems. The only reason it knows about VFAT is that the EFI spec
demands it.

> Also I read a recommendation to put SWAP in a seperate native partition
> and raid it in case you want to avoid a software crash when 1 disk fails.

That's true, but is it worth it? RAM is cheap, max out your motherboard,
and try and avoid falling into swap at all. I have one swap partition
per disk, but simply set them up as equal priority so the kernel does
its own raid-0 stripe across them. Yes a disk failure would kill any
apps swapped on to that disk, but my system rarely swaps...
> 
> I wonder, how I should build up this construct. I thought I could build
> one partition with TOTAL_SIZE - 100M, Type FD00, on each device, take
> these two (sda1 + sdb1) and build a RAID 1 array named md0. Next make
> md0 the physical volume of my LVM (pvcreate /dev/md0) and after that add
> a volume group in which I put my logical volumes:
> - swap - type EF00
> - /boot - with filesystem fat32 for uefi
> - /home - ext4
> - /tmp - ext4
> - / - ext4
> - /var/lib/mysql - ext4 with special mount options
> - /var/lib/vmimages - ext4 with special mount options
> 
> Is this doable or is it not working since UEFI will not find my
> bootimage, because in this config it is sitting not in an own native
> partition?

/boot needs to be outside your linux setup, and I'd put swap outside
lvm/raid too
> 
> If it is not doable, do you see any suitable setup to archive my goals?
> I do not want to use btrfs.
> 
okay. sda1 is vfat for EFI and is your /boot. configure sdb the same,
and you'll need to manually copy across every time you update (or make
it a v0.9/v1.0 raid array and only change it from inside linux - tricky)

sda2 - swap. I'd make its size equal to ram - and as I said, same on sdb
configured in linux as equal priority to give me a raid-0.

sda3 / sdb3 - the remaining space, less your 100M, raided together. You
then sit lvm on top in which you put your remaining volumes, /, /home,
/var/lib/mysql and /var/lib/images.

Again, personally, I'd make /tmp a tmpfs rather than a partition of its
own, the spec says that the system should *expect* /tmp to disappear at
any time and especially on reboot... while tmpfs defaults to half ram,
you can specify what size you want, and it'll make use of your swap space.

> Thanks,
> Steffi
> 
Cheers,
Wol
