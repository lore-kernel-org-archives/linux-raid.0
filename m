From: Nix <nix@esperi.org.uk>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Mon, 20 Apr 2020 12:05:32 +0100
Message-ID: <87eesito1v.fsf@esperi.org.uk>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
        <5E95C698.1030307@youngman.org.uk>
        <13a3bc12-67f7-46d5-7e6a-c6880ace4b1c@peter-speer.de>
        <5E95F461.50209@youngman.org.uk> <87lfmtemqf.fsf@esperi.org.uk>
        <f3139daa-37d5-a965-d204-0ef5d9fe4f3f@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f3139daa-37d5-a965-d204-0ef5d9fe4f3f@peter-speer.de> (Stefanie
        Leisestreichler's message of "Mon, 20 Apr 2020 11:45:44 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20 Apr 2020, Stefanie Leisestreichler said:

> On 18.04.20 01:06, Nix wrote:
>> Boot000B* Current kernel	HD(1,GPT,b6697409-a6ec-470d-994c-0d4828d08861,0x800,0x200000)/File(\efi\nix\current.efi)
>> Boot000E* Current kernel (secondary disk)	HD(1,GPT,9f5912c7-46e7-45bf-a49d-969250f0a388,0x800,0x200000)/File(\efi\nix\current.efi)
>> Boot0011* Current kernel (tertiary disk)	HD(1,GPT,8a5cf352-2e92-43ac-bb23-b0d9f27109e9,0x800,0x200000)/File(\efi\nix\current.efi)
>> Boot0012* Current kernel (quaternary disk)	HD(1,GPT,83ec2441-79e9-4f3c-86ec-378545f776c6,0x800,0x200000)/File(\efi\nix\current.efi)
[...]
>
> Is there any reason why one could not have another entry for each disk (8 entries in this example in total instead of the 4 being
> listed) like:
>
> Boot000B* Current kernel HD(1,GPT,b6697409-a6ec-470d-994c-0d4828d08861,0x800,0x200000)/File(\efi\nix\old.efi)
>
> and so on to support booting the old kernel in case something went wrong?

None! I have one entry each for old/stable kernel on the current disk,
but it just gets quite verbose and repetitive with six disks, and the
two (other disks, old kernels) serve different purposes: I'm going to
want to boot off another disk if the kernel works but something went
wrong with the disk, and I'm going to want to boot an old kernel if the
kernel has gone wrong, in which case probably the disk is fine and I can
just boot off the current disk. If I find when booting a new kernel that
it breaks the disk and I have to boot an old kernel off another disk,
I'll just use the EFI shell to do it. :)

-- 
NULL && (void)
