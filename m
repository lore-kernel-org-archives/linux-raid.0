From: "John P. Looney" <valen@tuatha.org>
Subject: Re: Problems with RAID1 on cobalt raq3
Date: Mon, 19 Aug 2002 09:38:34 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020819083834.GM26818@jinny.ie>
References: <200208172056.g7HKuHm05754@raq.iceblink.org> <1029625780.14769.134.camel@atherton>
Reply-To: valen@tuatha.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1029625780.14769.134.camel@atherton>
To: Duncan Laurie <duncan@sunbalt.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 Duncan, thanks for responding! I was on the cobalt-developers list, but
they don't seem that interested in such problems.

 First off set_boot_dev was used to set the boot device to hda2 (I tryed
hda1, and as you pointed out, you can't move the root device easily to
hda2 later).

 I had originally planned that hda1 was /boot and hda2 was / - in the end,
to get *anything* booting, I'd to copy the /boot files into a /boot
directory on the / filesystem, and write off hda1 as a waste of disk
space.

On Sat, Aug 17, 2002 at 04:09:40PM -0700, Duncan Laurie mentioned:
> 1/ where did hdg come from?  Is there a 3rd party IDE controller
> in the PCI slot?  (some RaQ3s had only 1 IDE connector populated..)
> If it is, then you might run into problems because most likely the
> ROM kernel does not have a driver for it.

 It's a third-party ATA-66 disk controller. I wanted some sort of
reliability in the box, and as you said, this raq3 has only a single IDE
channel.

> 2/ the ext3 filesystem might also be confusing the ROM kernel.
> If you want to try one that will recognize it look here:
> ftp://ftp-eng.cobalt.com/pub/users/duncan/kernel/rom/2.9.37-ext3.rom

 Oh, thanks...I was using 2.3.40, and it seemed to boot the kernel off
ext3 fine (perhaps treating it as ext2).

> This will also give you better control over the boot process,
> adding a "set_lparams" function to the boot menu that specifies
> the parameters specific to the ROM kernel.  ("set_params' will
> pass parameters to the kernel that is loaded from disk)  This
> will let you set a different root device to grab a kernel from.

 Woo-hoo. Exactly what I wanted. I think.

 So, do I do 

     set_boot_dev hda1                      (/boot)
     set_params "root=/dev/md0 ro"         

 And that should do what I've been trying to do ? Or do I have to change
the paramters to the ROM kernel also ?

> It also has some more built-in PCI IDE drivers, so it might
> help with problem #1. (if it is a problem...)

 Well, it's not a problem just yet - though it certainly would be if hda
failed, and the next time, it had to boot from hdg. 

John

