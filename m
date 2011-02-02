From: NeilBrown <neilb@suse.de>
Subject: Re: Software RAID and Fakeraid
Date: Wed, 2 Feb 2011 14:22:33 +1100
Message-ID: <20110202142233.79940092@notabene.brown>
References: <4CF81A16.2010606@cfl.rr.com>
	<20101203123615.6edce071@notabene.brown>
	<4CF860EB.7010005@cfl.rr.com>
	<20101209094354.4c6aaa93@notabene.brown>
	<4D01328D.9050503@cfl.rr.com>
	<4D46E6D7.2000205@cfl.rr.com>
	<20110131170349.GR343@caffeine.csclub.uwaterloo.ca>
	<4D470BCF.20508@cfl.rr.com>
	<20110131221252.GT343@caffeine.csclub.uwaterloo.ca>
	<4D47627A.1080509@cfl.rr.com>
	<20110201162642.GU343@caffeine.csclub.uwaterloo.ca>
	<4D48A069.8010202@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D48A069.8010202@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: The development of GNU GRUB <grub-devel@gnu.org>, Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, John Sheu <john.sheu@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 01 Feb 2011 19:08:09 -0500 Phillip Susi <psusi@cfl.rr.com> wrote:

> On 02/01/2011 11:26 AM, Lennart Sorensen wrote:
> > If the raid stores the raid info at the end, then the data starts at
> > sector 0.  So no space for a bootloader at all.
> 
> I know that is how it works with 0.9, but are you sure it is for 1.0? 
> If so, then for anything but raid-1 we will just have to try to install 
> only to the first device if it has an MBR.
> 
> > Certainly makes sense.  Now is 4K enough for a boot loader?  Not sure.
> 
> It is enough for the MBR.  The core image will need to go elsewhere, 
> hence the proposal to ask mdadm for a suitable location.
> 
> > I personally consider soft raid on raw devices so convluted that I
> > have never done it.  I would rather have something I know works with my
> > bootloader and other tools, than gain that extra 1MB (at most) that not
> > having partitions gives.  Also given many PCs won't boot from a drive
> > without a partition table, it isn't even an option then.
> 
> That is why I like the idea of 1.2 since you could still have a bootable 
> MBR when using the whole disk.  Though now that you mention it, I can't 
> think of a good reason to use the whole disk instead of a partition either.


It seems to me that a case analysis would be useful here.
Assuming that the area of interest is loading the grub core image when
/boot (or '/') is on an md device,

 0 If the md device is comprised entirely of partitions, then it is
   not involved in loading the core image at all
 
 otherwise:

 1 The md device could be addressable directly by the bios.  This applies
   to a RAID1 which starts at the start of the devices, or any RAID level
   which is explicitly understood by BIOS or an option ROM (such as Intel
   IMSM)

 2 The md device could leave the first block, and some other section of
   each device unused.  These can be used to store the boot block and
   the core image.
   This applies to 1.2 metadata stored on whole devices.  It could apply to
   1.0 (as the start address is configurable) but doesn't in practise.  The
   main reason to choose 1.0 is to have the array aligned with the start of
   the device.

 3 The md device does not permit booting.  This applies to 1.1 metadata
   and various other combinations other than those identified above.


There is a difficulty in case 2 as it is not clear who's responsibility it is
to write a partition table at the start of each device.
Presumably GRUB doesn't like to write partition tables unless one already
exists.
Currently mdadm doesn't write a partition table either.  Possibly it could,
but I would rather avoid that if possible.
Maybe once case 2 has been clearly identified, GRUB could consider that
sufficient permission to write a boot block and partition table even if no
partition table existed??

I imagine that the best way to distinguish between the cases would be to have
   mdadm --detail --export /dev/mdXXX

report something appropriate.  Maybe a setting for "MD_BOOTABLE"
e.g.

 MD_BOOTABLE=partitions    # case 0 - the array is comprised entirely of
                           # partitions
 MD_BOOTABLE=BIOS          # mdadm believes that the bios can an will read the
                           # the array directly - i.e. case 1
 MD_BOOTABLE=reserved      # Space at the start of each device is reserved
                           # for storing boot information.  In particular the
                           # first block (4K) is reserved plus some more.
 MD_BOOTABLE=no            # mdadm does not believe it is possible to boot
                           # from this array

In the 'reserved' case, mdadm would also report where the space is. e.g.

 MD_BOOT_SPACE="/dev/sda 8192 32768"

means that from byte offset 8192 there is 32768 bytes of available space.
I would need to make sure that mdadm kept that space available, so I would
need to know how much to reserve.  Maybe 32K.  Maybe 1M is safe?

However there is another complication.
I understand that the boot block sometimes lives at the start of the
partition instead of (or as well as) the start of the device.
I'm fairly syslinux does this - I don't know about GRUB.
So I really want to still report BIOS or 'reserved' or 'no' even when
partitions are in use.

So maybe I should scrap case 0 (MD_BOOTABLE=partitions), assume that the
boot-loader configurer can detect and understand partitions itself, and just
report the other 3 cases ignoring the details about partitions.

Would that be helpful?  Would it get used?  How could it be better?

Thanks,
NeilBrown

