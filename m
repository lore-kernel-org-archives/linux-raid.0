From: David Greaves <david@dgreaves.com>
Subject: Re:
Date: Thu, 12 Jan 2006 11:16:36 +0000
Message-ID: <43C63A94.2020702@dgreaves.com>
References: <20060111144943.93BAA396A20@mxo3.broadbandsupport.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060111144943.93BAA396A20@mxo3.broadbandsupport.net>
Sender: linux-raid-owner@vger.kernel.org
To: bhess@patmedia.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

bhess@patmedia.net wrote:

><snip - a lot!!>
>  
>
can I summarise (!) as:
I want to create a non-system data-storage raid array (ie can be
initialised well after boot)
I want to use a mix of SCSI, sata + USB devices
Will this work if the USB devices change their 'order'

Short answer: yes, with the right kernel/mdadm versions

Longer:

I use debian so don't know what version of the kernel you use? also mdadm?
You need to look at UUIDs
Use the --assemble, --uid and --scan options *after* you know usb
devices are online (and make sure they're listed in the conf (or use
--config=partitions)). It's safe, mdadm won't assemble an array that's
not complete.

Maybe you'd like to script a test for the usb devices and only attempt
an assemble when all devices are available.

AFAIK there are no issues with the hardware/bus type. A block device is
a block device is a block device is a.... :)

Now, advice...

ok, first off: a 14 device raid1 is 14 times more likely to lose *all*
your data than a single device. I have a scsi device running in one of
my machines since 1995. I am about to RMA a 1yr old maxtor sata drive
(I've RMA'd about 30% of my consumer grade ides/sata drives over the
last few years - ie failed *in* warranty). You appear to be jumping into
consumer grade (usb) devices and it may bite you!

Why not just have a lot of individual filesystems and manage the data by
hand?

Also, if you go the one-device way, why not consider lvm2 instead?
The reason is that it seems *very* likely that you'll be looking to swap
devices in and maybe out (when smart tells you a drive is about to fail)
of this ad-hoc storage.
LVM allows you to see each device as a large number of 'chunks'. You
then gather all those chunks from many devices into a 'pool'. You can
then allocate chunks from the pool to create virtual devices and then
make filesystems on them.

This is good because you can then add another device to the 'pool' and
use those chunks to either:
* swap out a failing (SMART) drive if you're lucky
* grow the virtual drive
* take 'snapshots' (OK you don't need this but it's cool!)

finally, watch the filesystem - eg xfs is excellent for big files but
can't shrink

HTH

David

-- 

