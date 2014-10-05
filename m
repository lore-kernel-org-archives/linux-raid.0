From: Phil Turmel <philip@turmel.org>
Subject: Re: UEFI and mdadm questions.
Date: Sun, 05 Oct 2014 14:18:46 -0400
Message-ID: <54318B86.7060506@turmel.org>
References: <BLU436-SMTP10330CBEBC0CA1E27853BE498B80@phx.gbl> <E82F134B-634B-46B9-A835-846CA89728FB@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E82F134B-634B-46B9-A835-846CA89728FB@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/03/2014 01:04 AM, Chris Murphy wrote:
> 
> On Oct 1, 2014, at 12:33 PM, "Wilson, Jonathan"
> <piercing_male@hotmail.com> wrote:
> 
>> From what I can tell with UEFI I need to set up a UEFI partition
>> with a FAT format.
> 
> It's a particular kind of FAT, that's defined as EFI FAT, the idea
> being that if the originating FAT ever changes, EFI FAT won't.
> 
>> 
>> On my current BIOS system I have a Biosboot 1M, /boot Raid1 200M
>> and / Raid 1 40G.
>> 
>> Obviously Grub installs to the mbr, and then installs a bit into 
>> Biosboot which can read raids, hence it can read and boot from
>> /boot.
> 
> BIOSboot applies to GPT disks on BIOS computers, not MBR. On MBR
> disks, the GRUB stage1 code jumps to stage2 code in the MBR gap which
> is the region between the MBR and the first partition's starting
> LBA.
> 
>> 
>> Further, from what I can tell, into the UEFI partition can go
>> either a kernel & initramfs with UEFI support, or a "loader" that
>> then loads the kernel.
> 
> No. An OSLoader is required, it's an EFI application. Its job is to
> load a kernel and initramfs. The kernel and initramfs could be on the
> ESP (EFI System partition) but this is fraught with limitations. The
> expectation is that the kernel and initramfs are on some other
> partition of the same disk. Of course if you're using GRUB it doesn't
> care and will find a kernel/initramfs off another disk also, or even
> off md raid.

An option to consider is to compile a kernel using the EFI stub option,
a pre-set command line, and an embedded initramfs.  Then the kernel can
boot directly from the EFI FAT partition with *no bootloader*.  The
embedded initramfs can support any raid/lvm/partitioning scheme
what-so-ever.

http://kroah.com/log/blog/2013/09/02/booting-a-self-signed-linux-kernel/

The cryptography is optional if you just want to boot really fast.

If your BIOS can be configured to try multiple boot images, it should be
possible to have true raid fallback without using motherboard or
hardware raid.  (Set up md raid1 with metadata v1.0 of multiple copies
of the EFI FAT partition.)  I've been meaning to try this....

Phil
