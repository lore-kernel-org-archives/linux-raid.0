From: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Mon, 20 Apr 2020 11:45:44 +0200
Message-ID: <f3139daa-37d5-a965-d204-0ef5d9fe4f3f@peter-speer.de>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
 <5E95C698.1030307@youngman.org.uk>
 <13a3bc12-67f7-46d5-7e6a-c6880ace4b1c@peter-speer.de>
 <5E95F461.50209@youngman.org.uk> <87lfmtemqf.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87lfmtemqf.fsf@esperi.org.uk>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>, Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 18.04.20 01:06, Nix wrote:
> Rather than trying to make some sort of clever mirroring setup work with
> the ESP, I just made one partition per disk, added all of them to the
> efibootmgr:
> 
> Boot000B* Current kernel	HD(1,GPT,b6697409-a6ec-470d-994c-0d4828d08861,0x800,0x200000)/File(\efi\nix\current.efi)
> Boot000E* Current kernel (secondary disk)	HD(1,GPT,9f5912c7-46e7-45bf-a49d-969250f0a388,0x800,0x200000)/File(\efi\nix\current.efi)
> Boot0011* Current kernel (tertiary disk)	HD(1,GPT,8a5cf352-2e92-43ac-bb23-b0d9f27109e9,0x800,0x200000)/File(\efi\nix\current.efi)
> Boot0012* Current kernel (quaternary disk)	HD(1,GPT,83ec2441-79e9-4f3c-86ec-378545f776c6,0x800,0x200000)/File(\efi\nix\current.efi)
> 
> ... and used simple rsync at kernel install time to keep them in sync
> (the variables in here are specific to my autobuilder, but the general
> idea should be clear enough):
> 
>      # For EFI, we install the kernel by hand.  /boot may be a mountpoint,
>      # kept unmounted in normal operation.
>      mountpoint -q /boot && mount /boot
>      KERNELVER="$(file $BUILDMAKEPATH/.o/arch/x86/boot/bzImage | sed 's,^.*version \([0-9\.]*\).*$,\1,g')"
>      install -o root -g root $BUILDMAKEPATH/.o/System.map /boot/System.map-$KERNELVER
>      install -o root -g root $BUILDMAKEPATH/.o/arch/x86/boot/bzImage /boot/efi/nix/vmlinux-$KERNELVER.efi
>      [[ -f /boot/efi/nix/current.efi ]] && mv /boot/efi/nix/current.efi /boot/efi/nix/old.efi
>      install -o root -g root $BUILDMAKEPATH/.o/arch/x86/boot/bzImage /boot/efi/nix/current.efi
>      for backup in 1 2 3; do
>          test -d/boot/backups/$backup || continue
>          mount/boot/backups/$backup
>          rsync -rtq --modify-window=2 --one-file-system/boot/  /boot/backups/$backup
>          umount/boot/backups/$backup
>      done
>      mountpoint -q /boot && umount /boot

Is there any reason why one could not have another entry for each disk 
(8 entries in this example in total instead of the 4 being listed) like:

Boot000B* Current kernel 
HD(1,GPT,b6697409-a6ec-470d-994c-0d4828d08861,0x800,0x200000)/File(\efi\nix\old.efi)

and so on to support booting the old kernel in case something went wrong?
