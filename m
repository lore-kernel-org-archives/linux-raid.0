From: dean gaudet <dean@arctic.org>
Subject: Re: RAID5 array showing as degraded after motherboard replacement
Date: Sun, 5 Nov 2006 13:02:23 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0611051247550.13706@twinlark.arctic.org>
References: <ef2613f30611050858m562386a0m7966667f803f35fc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ef2613f30611050858m562386a0m7966667f803f35fc@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: James Lee <james.lee@cantab.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 5 Nov 2006, James Lee wrote:

> Hi there,
> 
> I'm running a 5-drive software RAID5 array across two controllers.
> The motherboard in that PC recently died - I sent the board back for
> RMA.  When I refitted the motherboard, connected up all the drives,
> and booted up I found that the array was being reported as degraded
> (though all the data on it is intact).  I have 4 drives on the on
> board controller and 1 drive on an XFX Revo 64 SATA controller card.
> The drive which is being reported as not being in the array is the one
> connected to the XFX controller.
> 
> The OS can see that drive fine, and "mdadm --examine" on that drive
> shows that it is part of the array and that there are 5 active devices
> in the array.  Doing "mdadm --examine" on one of the other four drives
> shows that the array has 4 active drives and one failed.  "mdadm
> --detail" for the array also shows 4 active and one failed.

that means the array was assembled without the 5th disk and is currently 
degraded.


> Now I haven't lost any data here and I know I can just force a resync
> of the array which is fine.  However I'm concerned about how this has
> happened.  One worry is that the XFX SATA controller is doing
> something funny to the drive.  I've noticed that it's BIOS has
> defaulted to RAID0 mode (even though there's only one drive on it) - I
> can't see how this would cause any particular problems here though.  I
> guess it's possible that some data on the drive got corrupted when the
> motherboard failed...

no it's more likely the devices were renamed or the 5th device didn't come 
up before the array was assembled.

it's possible that a different bios setting lead to the device using a 
different driver than is in your initrd... but i'm just guessing.

> Any ideas what could cause mdadm to report as I've described above
> (I've attached the output of these three commands)?  I'm running
> Ubuntu Edgy, which is a 2.17.x kernel, and mdadm 2.4.1.  In case it's
> relevant here, I created the array using EVMS...

i've never created an array with evms... but my guess is that it may have 
used "mapped" device names instead of the normal device names.  take a 
look at /proc/mdstat and see what devices are in the array and use those 
as a template to find the name of the missing device.  below i'll use 
/dev/sde1 as the example missing device and /dev/md0 as the example array.

first thing i'd try is something like this:

	mdadm /dev/md0 -a /dev/sde1

which hotadds the device into the array... which will start a resync.

when the resync is done (cat /proc/mdstat) do this.

	mdadm -Gb internal /dev/md0

which will add write-intent bitmaps to your device... which will avoid 
another long wait for a resync after the next reboot if the fix below 
doesn't help.

then do this:

	dpkg-reconfigure linux-image-`uname -r`

which will rebuild the initrd for your kernel ... and if it was a driver 
change this should include the new driver into the initrd.

then reboot and see if it comes up fine.  if it doesn't, you can repeat 
the "-a /dev/sde1" command above... the resync will be quick this time due 
to the bitmap... and we'll have to investigate further.

-dean
