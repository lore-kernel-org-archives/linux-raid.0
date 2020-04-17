From: Nix <nix@esperi.org.uk>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Sat, 18 Apr 2020 00:06:16 +0100
Message-ID: <87lfmtemqf.fsf@esperi.org.uk>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
        <5E95C698.1030307@youngman.org.uk>
        <13a3bc12-67f7-46d5-7e6a-c6880ace4b1c@peter-speer.de>
        <5E95F461.50209@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5E95F461.50209@youngman.org.uk> (Wols Lists's message of "Tue,
        14 Apr 2020 18:35:29 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14 Apr 2020, Wols Lists said:

> On 14/04/20 16:12, Stefanie Leisestreichler wrote:
>> 
>> On 14.04.20 16:20, Wols Lists wrote:
>>> okay. sda1 is vfat for EFI and is your /boot. configure sdb the same,
>>> and you'll need to manually copy across every time you update (or make
>>> it a v0.9/v1.0 raid array and only change it from inside linux - tricky)
>
>> If I would like to stay with my intial thought and use GRUB, does this
>> mean, I have to have one native partition for the UEFI System Partition
>> formated with vfat on each disk? If this works and I will create an raid
>> array (mdadm --create ... level=1 /dev/sda1 /dev/sda2) from these 2
>> partitions, will I still have the need to cross copy after a kernel
>> update or not?
>> 
> Everything else is mirrored - you should mirror your boot setup ... you
> don't want disk 0 to die, and although (almost) everything is there on
> disk 1 you can't boot the system because grub/efi/whatever isn't there...

Yep.

> The crucial question is whether your updates to your efi partition
> happen under the control of linux, or under the control of efi. If they
> happen at the linux level, then they will happen to both disks together.
> If they happen at the efi level, then they will only happen to disk 0,
> and you will need to re-sync the mirror.

Rather than trying to make some sort of clever mirroring setup work with
the ESP, I just made one partition per disk, added all of them to the
efibootmgr:

Boot000B* Current kernel	HD(1,GPT,b6697409-a6ec-470d-994c-0d4828d08861,0x800,0x200000)/File(\efi\nix\current.efi)
Boot000E* Current kernel (secondary disk)	HD(1,GPT,9f5912c7-46e7-45bf-a49d-969250f0a388,0x800,0x200000)/File(\efi\nix\current.efi)
Boot0011* Current kernel (tertiary disk)	HD(1,GPT,8a5cf352-2e92-43ac-bb23-b0d9f27109e9,0x800,0x200000)/File(\efi\nix\current.efi)
Boot0012* Current kernel (quaternary disk)	HD(1,GPT,83ec2441-79e9-4f3c-86ec-378545f776c6,0x800,0x200000)/File(\efi\nix\current.efi)

... and used simple rsync at kernel install time to keep them in sync
(the variables in here are specific to my autobuilder, but the general
idea should be clear enough):

    # For EFI, we install the kernel by hand.  /boot may be a mountpoint,
    # kept unmounted in normal operation.
    mountpoint -q /boot && mount /boot
    KERNELVER="$(file $BUILDMAKEPATH/.o/arch/x86/boot/bzImage | sed 's,^.*version \([0-9\.]*\).*$,\1,g')"
    install -o root -g root $BUILDMAKEPATH/.o/System.map /boot/System.map-$KERNELVER
    install -o root -g root $BUILDMAKEPATH/.o/arch/x86/boot/bzImage /boot/efi/nix/vmlinux-$KERNELVER.efi
    [[ -f /boot/efi/nix/current.efi ]] && mv /boot/efi/nix/current.efi /boot/efi/nix/old.efi
    install -o root -g root $BUILDMAKEPATH/.o/arch/x86/boot/bzImage /boot/efi/nix/current.efi
    for backup in 1 2 3; do
        test -d /boot/backups/$backup || continue
        mount /boot/backups/$backup
        rsync -rtq --modify-window=2 --one-file-system /boot/ /boot/backups/$backup
        umount /boot/backups/$backup
    done
    mountpoint -q /boot && umount /boot

The firmware should automatically handle booting the first kernel that's
on a disk that works. (I use CONFIG_EFI_STUB, so the kernel is itself
bootable directly by the firmware and I can avoid all that boot manager
rubbish and just let the firmware be my boot manager. I have 4 entries
each in the boot manager menu for the current kernel, the previous one I
installed, and a manually-copied 'stable kernel' that I update whenever
I think a kernel was working well enough to do so.)

>>> sda2 - swap. I'd make its size equal to ram - and as I said, same on sdb
>>> configured in linux as equal priority to give me a raid-0.
>
>> Thanks for this tip, I would prefer swap and application safety which
>> comes with raid1 in this case. Later I will try to optimize swappiness.
>> 
> I prefer swap to be at least twice ram. A lot of people think I'm daft
> for that, but it always used to be the rule things were better that way.
> It's been pointed out to me that this can be used as a denial of service
> (a fork bomb, for example, will crucify your system until the OOM killer
> takes it out, which will take a LOOONNG time with gigs of VM). Horses
> for courses.

Frankly... I would make this stuff a lot simpler and just not make a
swap partition at all. Instead, make a swapfile: RAID will just happen
for you automatically, you can expand the thing (or shrink it!) with
ease while the system is up, and it's exactly as fast as swap
partitions: swapfiles have been as fast as raw partitions since the
Linux 2.0 days.

>> What Partition Type do I have to use for /dev/sd[a|b]3? Will it be LVM
>> or RAID?
>> 
> I'd just use type linux ...

Literally nothing cares :) it's for documentation, mostly, to make sure
that e.g. Windows won't randomly smash a Linux partition. So whatever
feels right to you. The only type that really matters is the GUID of the
EFI system partition, and fdisk gets that right these days so you don't
have to care.

 -- N., set up a system without RAID recently and felt so... dirty (it
    has one NVMe device and nothing else). So everything important is
    NFS-mounted from a RAID array, natch. With 10GbE the NFS mounts are
    actually faster than the NVMe device until the server's huge write
    cache fills and it has to actually write it to the array :) but how
    often do you write a hundred gig to a disk at once, anyway?
