From: Phil Turmel <philip@turmel.org>
Subject: Re: Wrong device name after hot-swap
Date: Fri, 22 Jan 2016 17:27:00 -0500
Message-ID: <56A2ACB4.6060808@turmel.org>
References: <n7u8gr$1bv$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <n7u8gr$1bv$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Paul van der Vlis <paul@vandervlis.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/22/2016 04:55 PM, Paul van der Vlis wrote:
> Hello,
> 
> I want to put bigger disks into my server. What I want to do is replace
> the first disk, rebuild the raid, replace the second disk, rebuild the
> raid. The machine has two disks, sda and sdb.
> 
> But, when I replace a disk, it gets a new device name. E.g. /dev/sdb
> becomes /dev/sdc. After a reboot it's good again, but I prefer not to
> reboot this machine!
> 
> Is there a way to get the correct device name?

No.  Device names are assigned in the order they are encountered after
boot, and that order is not guaranteed by the kernel.  You should never
depend on those names.

When a device name is fully disconnected, modern kernels will recycle
the name at the next opportunity.  You must be using a hotplug-enabled
driver.  For most motherboards, turning on "AHCI" mode in the BIOS on
those sata ports is all you need.

> When not:
> Is it maybe an idea too add the wrong device name to the md-device?
> mdadm /dev/md0 -a /dev/sdc1
> Then replace /dev/sda what becomes /dev/sdd:
> mdadm /dev/md0 -a /dev/sdd1
> Then restore grub on both disks (with "--recheck" ??)
> But what will happen after a reboot later? Will the md-device be
> restored with the old names?

MD stores signatures in the devices it uses that identify them for later
assembly.  It does not depend on the device name, though it is recorded
in the superblock as a "last connected as" kind of indicator.

In general, you should not rely on device names in your system
configuration.  UUIDs and filesystem labels were implemented
specifically to avoid this problem.

Phil
