From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: ATARAID userspace configuration tool
Date: Wed, 11 Feb 2004 09:41:41 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16425.24101.755694.738298@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.40.0402101405190.25784-100000@jehova.dsm.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Thomas Horsten on Tuesday February 10
To: Thomas Horsten <thomas@horsten.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday February 10, thomas@horsten.com wrote:
> Hi,
> 
> I'm writing a userspace utility to detect/configure Medley (and later
> other) ataraid devices in 2.6.
...
> 
> On top of this it would be useful to make the underlying devices
> inaccessible after the mapped device is created (to prevent people from
> doing things like fdisk /dev/hda, when what they really wanted was
> something like fdisk /dev/ataraid/disc).

The best way to avoid this sort of problem is to change "fdisk" (and
mkfs and fsck and ...) to (optionally) open the device with O_EXCL.

In 2.6, a device that is "claimed" by a kernel subsystem - ie is
mounted, or is part of an MD or DM array, or has a partition which is
claimed in one of these ways, cannot be opened O_EXCL.

So these tools that operate on block devices and expect exclusive
access should ask for it.
They probably should have a way to not use O_EXCL if the admin
promises they know what they are doing, as fsck does need to run on a
mounted partition some times, and fdisk can reasonably be used on
devices with mounted partitions.  But the default should be O_EXCL.

NeilBrown

> 
> Detecting the partition table in userspace would fix this, but it's not
> planned before 2.7 and I don't think it is safe to leave the false
> partitions exposed.
> 
> - Some RAID types will need (I think) to use the MD framework as well as
> DM (e.g. RAID0+1), so the device the users would be the md device which
> would be composed of two dm devices. Is there a way to hide the underlying
> dm devices from the user so he they only see the ones they should use (or
> prevent these from being used directly some other way)?
> 
> // Thomas
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
