From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Booting from a raid1 device ?
Date: Thu, 30 Oct 2003 17:26:31 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FA11F97.4020800@tls.msk.ru>
References: <E5DA6395B8F9614EB7A784D628184B200E33E8@hdsmsx402.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E5DA6395B8F9614EB7A784D628184B200E33E8@hdsmsx402.hd.intel.com>
To: "Cress, Andrew R" <andrew.r.cress@intel.com>
Cc: donj@asaca.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Cress, Andrew R wrote:
> Michael,
> 
> If you only have an MBR on the first disk, and it fails, your system
> will not boot, since BIOS won't be able to read an MBR from the
> redundant disk (the only working one).  You may be thinking of a use
> case in which the first disk has a corrupted partition, but its MBR is
> intact.

Corrupted boot partition - yes.  If it contains corrupted MBR, it
will not boot either, because BIOS will not try 2nd disk anyway
(if 1st disk "half-works").  None of current bootloaders support
"fallback" (or redundrand) boot (e.g. try first disk, if read
fails or bad checksum, try another disk etc).  That to say: with
half-working disk, nothing will work.  Note that it is the loader
itself plus the kernel image that (and MBR) that should have
failed - if all this (pretty small) stuff is ok (but there's
a bad block or many bad blocks but elsewhere on the disk), system
will boot just fine.

> You have to also have a working MBR on the redundant disk as well, or
> you'll never get to the loader if the first disk really fails.  Usually
> it is the loader's responsibility to set up (or at least verify) the
> MBR.  

Well.. not really.  Sure, working MBR should be on all disks involved.
But it is necessary to set it up only once on every disk, and forgot
about it.  "Standard" MBR that comes with MS-DOS, or any other similar
MBR code will work, and there's no reason to touch it during the whole
lifetime of the disk.

That's exactly what I said in my previous email: set up standard MBR on
each disk once, and install lilo/grup/whatever on the raid partition,
so that kernel raid code will replicate every e.g. lilo update to all
disks.

The only possible problem with that is - disks with different geometry
and/or partition placement (e.g. raid1 made from /dev/hda1 and /dev/hdb2
- 1st partition on first disk and *second* partition on second, so that
sector addresses of loader data will be different on the two).  For this
case, some support from the bootloader IS needed, but it's rather bizzare
case.

/mjt

