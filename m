From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: ATARAID userspace configuration tool
Date: Tue, 10 Feb 2004 12:38:00 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <402916F8.8050008@pobox.com>
References: <Pine.LNX.4.40.0402101405190.25784-100000@jehova.dsm.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.40.0402101405190.25784-100000@jehova.dsm.dk>
To: Thomas Horsten <thomas@horsten.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thomas Horsten wrote:
> - Is there a "recommended" way to enumerate all block devices (not
> partitions) from userside? Since this is ATA RAID, I could of course just
> read the ideX majors from /proc/devices and try all the minors, but I
> would prefer to get a list of all detected block devices in a portable
> way.

sysfs, definitely.


> - After I have used the DM (and possible MD for some RAID types) to map
> the ataraid devices, is there a way to remove the partitions from the
> underlying disks from the kernel? This was my main reason for wanting to
> do kernel-level autodetection of these arrays, so I could prevent add_disk
> from being called and analysing the partition table (on these BIOS RAIDs,
> in striped mode the first disk contains the partition table for the entire
> array in sector 0, and if the user (or a script) tries to mount the
> partitions (or even read the extended partition table) it may try to read
> after the end of the disk and will in any case use wrong sector numbers -
> leading to possible disk corruption.

You have control of what happens to the devices.  If you don't want them 
probed for partitions, they won't be..


> On top of this it would be useful to make the underlying devices
> inaccessible after the mapped device is created (to prevent people from
> doing things like fdisk /dev/hda, when what they really wanted was
> something like fdisk /dev/ataraid/disc).

This would be something to talk with the md maintainer about, I think. 
I'm not sure we want to do this, since the user may have a valid reason 
to access the underlying disk.

	Jeff
