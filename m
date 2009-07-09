From: david@lang.hm
Subject: Re: partition detection problem on 2.6.29.1 and 2.6.30
Date: Wed, 8 Jul 2009 18:05:06 -0700 (PDT)
Message-ID: <alpine.DEB.1.10.0907081759550.9159@asgard>
References: <alpine.DEB.1.10.0907081424140.9159@asgard>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; FORMAT=flowed; CHARSET=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0907081424140.9159@asgard>
Content-ID: <alpine.DEB.1.10.0907081759552.9159@asgard>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I managed to track the problem down.

it turns out that at some point someone created a md array using the raw 
devices instead of the partitions. it looks like the kernel autodetection 
for raid kicked in prior to the partition detection and after it claimed 
the drives the partition detection was never given a chance to do so.

this is logical, but it makes the dmesg output that appears to be 
identifying the paritions _very_ misleading.

David Lang

On Wed, 8 Jul 2009, david@lang.hm wrote:

> Date: Wed, 8 Jul 2009 14:35:41 -0700 (PDT)
> From: david@lang.hm
> To: linux-kernel <linux-kernel@vger.kernel.org>
> Subject: partition detection problem on 2.6.29.1 and 2.6.30
> 
> I have a system that has a large number of drives in it (45), and it's had a 
> problem with banks of disks getting disconnected from it.
>
> however, when I started looking into it today (after another sysadmin worked 
> on it for a while), I found that the system is not able to access the 
> partitions on the drives.
>
> if I am reading dmesg correctly it is seeing the partitions during boot, and 
> if I do 'fdisk -l' it lists all the paritions correctly, but if I try to do a
>
> dd if=/dev/sdb1 of=/dev/null count=1
>
> I get the error "dd: opening `/dev/sdb1': No such device or address"
>
> #ls -l /dev/sdb1
> brw-rw---- 1 root disk 8, 17 Nov  7  2006 /dev/sdb1
>
> I removed udev and setup nodes manually to eliminate any possibility that it 
> was a problem there.
>
> the attachment partitions.missing.partitions is a cat of /proc/partitions
>
> sysfs shows all the drives but none of the partitions.
>
> if I run fdisk and do a write (which runs the ioctl to re-read the parition 
> table) the system detects the partition and is able to access it until the 
> next reboot.
>
> what is going on here?
>
> David Lang
