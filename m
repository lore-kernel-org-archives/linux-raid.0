From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: Booting from a raid1 device ?
Date: Thu, 30 Oct 2003 09:11:33 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E5DA6395B8F9614EB7A784D628184B200E33E8@hdsmsx402.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: donj@asaca.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael,

If you only have an MBR on the first disk, and it fails, your system
will not boot, since BIOS won't be able to read an MBR from the
redundant disk (the only working one).  You may be thinking of a use
case in which the first disk has a corrupted partition, but its MBR is
intact.

You have to also have a working MBR on the redundant disk as well, or
you'll never get to the loader if the first disk really fails.  Usually
it is the loader's responsibility to set up (or at least verify) the
MBR.  

Andy

-----Original Message-----
From: Michael Tokarev [mailto:mjt@tls.msk.ru] 
Sent: Wednesday, October 29, 2003 7:55 PM
To: Cress, Andrew R
Cc: donj@asaca.com; linux-raid@vger.kernel.org
Subject: Re: Booting from a raid1 device ?


Cress, Andrew R wrote:
> Don,
> 
> Yes, it certainly can be done.  I do it all the time.
> 
> It's not hard with lilo, but grub doesn't support raid/md boot devices
> yet.  This means that the grub boot record doesn't automatically get
> written to the second disk.  In short, choose lilo for root mirroring
if
> possible.

Ugh-blah.  Excuse me folks, but.. maybe someone will be able to
answer this one:

  why the hell a boot loader should "mirror" anything to the second
disk? :)

That is.  Place standard MBR into the boot sector.  An MBR that will
boot
from active partition.  Be it e.g. /dev/hda and /dev/hdb.  Create raid1
device from /dev/hda1 and /dev/hdb1.  Mark both partitions as active.
And install whatever boot loader you want into /dev/md1 - it will be
mirrored automatically to /dev/hda1 and /dev/hdb1 (and to whatever else
disks you'll use).

Should your first disk fail, the system will either not boot because
of bios limitations, or bios may "remap" /dev/hdb into /dev/hda (to
be 0x80), and in this case boot procedure will work.

Well, ok, a boot loader should be able to determine real offsets from
the start of the disk, not from the start of raid device.  I don't
know whenever grub can do that - lilo apparently does, as all our
systems are set up exactly this way...

/mjt

