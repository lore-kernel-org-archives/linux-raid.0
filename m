From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: [mdadm git pull] support for detecting platform raid capabilities and some fixes
Date: Thu, 27 Nov 2008 01:13:29 +0100
Message-ID: <ac3eb2510811261613ja5bc80ag4fc011d76d95e961@mail.gmail.com>
References: <1227743100.31146.41.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1227743100.31146.41.camel@dwillia2-linux.ch.intel.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Nov 27, 2008 at 00:45, Dan Williams <dan.j.williams@intel.com> wrote:
> This is hopefully the tail of the feature additions from me for
> mdadm-3.0-final.  It adds the capability for mdadm to detect platform
> raid capabilities, and honor them when creating new arrays.

> This implementation crawls through sysfs to put this information
> together, I believe it is crawling in a future proof fashion, but here
> are my assumptions:
> 1/ /sys/bus/pci/drivers/ahci/<x>/device will identify a pci ahci device

Why "device"? You just check for the "device" attribute file of the PCI device?

> 1/ An attempt to cover the delay between mdadm creating an array and the
> friendly-named device node showing up in /dev/md/ by calling 'udevadm
> settle' before starting starting Incremental assembly.  This
> specifically fixes scripts that do:
> mdadm -A /dev/md/<container>
> mdadm -I /dev/md/<container>
> There is a good chance there is a better place to put this call, but
> putting it in create_mddev didn't work, and moving it up in main()
> resulted in a hang.  I didn't want to hold up the other patches for this
> debug.

If mdadm calls "udevadm settle", we can not call mdadm (which we do
already) from udev rules because it will just deadlock.

We need to make "udevadm settle" smarter and not to wait for its own
event, or make it wait for something specific and not just "all"
events, or find a different way for mdadm to sync with udev.

Thanks,
Kay
