From: ross@lug.udel.edu (Ross Vandegrift)
Subject: Re: your mail
Date: Wed, 11 Jan 2006 12:44:33 -0500
Message-ID: <20060111174433.GA9970@lug.udel.edu>
References: <20060111144943.93BAA396A20@mxo3.broadbandsupport.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060111144943.93BAA396A20@mxo3.broadbandsupport.net>
Sender: linux-raid-owner@vger.kernel.org
To: bhess@patmedia.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 11, 2006 at 09:47:03AM -0500, bhess@patmedia.net wrote:
> Has anyone put an effort into building a raid 1 based on USB connected
> drives under Redhat 3/4 not as the root/boot
> drive.

No, I haven't actually tried this, but I do know that it'll work
without any problem.

The main issue that you'll confront - USB devices do not have fixed
device numbers.  They can change every time they are plugged/unplugged.
As a result, you may not be able to depend on your disks to always be
(for example) /dev/sde and /dev/sdf.

There's a user-space daemon called hotplug that manages this stuff.
It load appropriate drivers for the devices it sees plugged into the
USB bus.  I don't know enough about to tell you specifically how it
will handle your setup.

My initial suggestion:
	1) Start with no driver plugged
	2) cat /proc/partitions > ~/nousb
	3) Plug one drive in
	4) cat /proc/partitions > ~/oneusb
	5) Plug second drive in
	6) cat /proc/parititons > ~/twousb
	7) diff -u ~/nousb ~/oneusb
	8) diff -u ~/oneusb ~/twousb

This should give you a good idea of how the kernel treats the
situation from the device perspective.

As far as the RAID part - that's easy.  Once you know what the block
devices look like, make your RAID.  I promise the md driver will work.
I've run md across all sorts of weird device setups and so long as
it's a working block device, md is happy!

Finally, if you use mdadm's --uuid option to assemble your array after
creating it, it should just find the USB disks, regardless of where
they came up.  That way, you only need to worry about what device node
they are using when you first create the array.

Good luck! 


-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
