From: Adam Thompson <athompso@athompso.net>
Subject: Re: [RndTbl] Big-endian RAID5 recovery problem
Date: Fri, 05 May 2017 14:22:44 -0500
Message-ID: <0fed0cadfe6c29f8fef4c9a341766bdd@athompso.net>
References: <5c6e6e5d93d4056839e4f370e00a8e08@mail.athompso.net>
 <20170502135934.59548e17@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170502135934.59548e17@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Continuation of Round Table discussion <roundtable@muug.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2017-05-02 03:59, Roman Mamedov wrote:
> On Mon, 01 May 2017 16:39:07 -0500
> Adam Thompson <athompso@athompso.net> wrote:
> 
>> I can't find any modern big-endian Linux systems... looks like all the
>> ARM distros run in little-endian mode.
> 
> Here are QEMU images for debian-mips (should be big-endian, as opposed 
> to
> debian-mipsel): https://people.debian.org/~aurel32/qemu/mips/
> 
> Of course it will run purely in software, but most likely more than 
> fast enough
> to copy away the data.
> 
> Not entirely sure that particular emulated MIPS system support more 
> than 4
> drives), but it appears that a starting point could be (man 
> qemu-system):
> 
>            Instead of -hda, -hdb, -hdc, -hdd, you can use:
> 
>                    qemu-system-i386 -drive file=file,index=0,media=disk
>                    qemu-system-i386 -drive file=file,index=1,media=disk
>                    qemu-system-i386 -drive file=file,index=2,media=disk
>                    qemu-system-i386 -drive file=file,index=3,media=disk
> 
> with indexes 0..5, as you need the boot disk, all 4 drives, and one 
> more as
> the backup destination.
> 
> May or may not be the best way, but IMO beats trying to hex-edit the
> superblock right away.


So I now have:
  4 x old IDE hard drives,
  plugged into 4 x USB3-to-IDE adapters,
  plugged into a 4x USB3 PCIe 1x adapter card,
  plugged into an Ubuntu desktop i5 system @ 3.3GHz,
  passed through into QEMU as virtual SCSI devices,
  connected to a virtual AMD am53c974 SCSI adapter,
  connected to a virtual Malta-series MIPS64 series,
  emulated by QEMU.

Yikes!

The good news is that as soon as the Debian kernel booted, it 
auto-detected the RAID arrays and started re-silvering them.

The bad news is: 1) that I thought I had attached the devices in 
read-only mode (oops); and 2) it's re-syncing the MD array at 
~5000Kb/sec.

I'll leave it to sync over the weekend (praying for no power outages), 
but I sure hope I can upgrade the metadata block instead of doing this 
all through a QEMU (non-accelerated) VM!

Thanks for the suggestions so far,
-Adam
