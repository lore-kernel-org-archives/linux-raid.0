From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Linux RAID metadata format docs?
Date: Mon, 17 Nov 2003 16:55:40 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16312.25308.143873.280291@notabene.cse.unsw.edu.au>
References: <20031114185013.GA11930@gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jeff Garzik on Friday November 14
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday November 14, jgarzik@pobox.com wrote:
> Do any docs exist, that describe the on-disk md format?

Not to my knowledge, beyond source code.

> 
> I'm talking with a vendor that would like to support booting off of 
> "Linux RAID" (as they call it), from their card's BIOS, which implies
> the vendor would need to add support for the md format to their BIOS.

I don't see that knowledge of the RAID format is needed by the bios.

It might be needed by the boot sector, and certainly by the next stage
(whether that be the kernel itself, or grub or whatever).

Based on my limited understanding, the bios should only need:
  1/ to be able to try subsequent drives if the first fails,
  2/ be able to tell the boot sector which drive was used
  3/ to allow the boot sector to indicate failure
 and maybe
  4/ be able to have a dynamically determined boot order
   (so that when one drive fails, it gets put to the bottom of the 
    list).

Clearly 1,2,3 don't need the bios to know anything about RAID layout.  4
could use raid layout information, and an easy interface for the
kernel to tell it when things have changed would be a lot easier and
more general.

I think the simplest approach would be:

 Bios attempts each potential boot device in some order, loading the
 boot sector and telling the boot sector that the device is "0x80".
 If the boot sector fails (e.g. bad code, such as all zeros), it tries
 the next.

 The boot sector tries to load a kernel or second-stage off "0x80" as
 normal.   The kernel or second-stage understands raid and makes sure
 the correct root is assembled.

 Some daemon monitors drives that fail, and attempts to over-write
 sector 0 of any such drive that is a boot-candidate.

This wouldn't quite do the right thing if:
  The "first" drive goes off line for some reason.
  A new kernel/second-stage is installed on remaining drive(s).
  machine is rebooted and "first" drive comes back online during the
  boot.

The "first" drive will look OK, but will not have a current kernel on
it.

Does any of this make sense?

Were you thinking of some RAID level other than RAID1?

NeilBrown
