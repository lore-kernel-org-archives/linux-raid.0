From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Booting from a raid1 device ?
Date: Thu, 30 Oct 2003 03:54:48 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FA06158.9040007@tls.msk.ru>
References: <E5DA6395B8F9614EB7A784D628184B200E33DE@hdsmsx402.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E5DA6395B8F9614EB7A784D628184B200E33DE@hdsmsx402.hd.intel.com>
To: "Cress, Andrew R" <andrew.r.cress@intel.com>
Cc: donj@asaca.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Cress, Andrew R wrote:
> Don,
> 
> Yes, it certainly can be done.  I do it all the time.
> 
> It's not hard with lilo, but grub doesn't support raid/md boot devices
> yet.  This means that the grub boot record doesn't automatically get
> written to the second disk.  In short, choose lilo for root mirroring if
> possible.

Ugh-blah.  Excuse me folks, but.. maybe someone will be able to
answer this one:

  why the hell a boot loader should "mirror" anything to the second disk? :)

That is.  Place standard MBR into the boot sector.  An MBR that will boot
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

