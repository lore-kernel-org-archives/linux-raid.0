From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [mdadm git pull] support for detecting platform raid capabilities and some fixes
Date: Wed, 26 Nov 2008 20:25:56 -0700
Message-ID: <e9c3a7c20811261925r36a304a6taaca2b6a8a146799@mail.gmail.com>
References: <1227743100.31146.41.camel@dwillia2-linux.ch.intel.com>
	 <ac3eb2510811261613ja5bc80ag4fc011d76d95e961@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ac3eb2510811261613ja5bc80ag4fc011d76d95e961@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Nov 26, 2008 at 5:13 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Thu, Nov 27, 2008 at 00:45, Dan Williams <dan.j.williams@intel.com> wrote:
>> This implementation crawls through sysfs to put this information
>> together, I believe it is crawling in a future proof fashion, but here
>> are my assumptions:
>> 1/ /sys/bus/pci/drivers/ahci/<x>/device will identify a pci ahci device
>
> Why "device"? You just check for the "device" attribute file of the PCI device?
>

$ ls /sys/bus/pci/drivers/ahci/
0000:00:1f.2/	module/	uevent
bind			new_id	unbind

I look for the 'device' file to disambiguate '0000:00:1f.2' from
'module' or some other object that appears in the future.  The other
attributes are discarded because they are not directories.

>> 1/ An attempt to cover the delay between mdadm creating an array and the
>> friendly-named device node showing up in /dev/md/ by calling 'udevadm
>> settle' before starting starting Incremental assembly.  This
>> specifically fixes scripts that do:
>> mdadm -A /dev/md/<container>
>> mdadm -I /dev/md/<container>
>> There is a good chance there is a better place to put this call, but
>> putting it in create_mddev didn't work, and moving it up in main()
>> resulted in a hang.  I didn't want to hold up the other patches for this
>> debug.
>
> If mdadm calls "udevadm settle", we can not call mdadm (which we do
> already) from udev rules because it will just deadlock.
>
> We need to make "udevadm settle" smarter and not to wait for its own
> event, or make it wait for something specific and not just "all"
> events, or find a different way for mdadm to sync with udev.
>

It just sounds like we need to be careful that the path that udev
triggers when it calls mdadm does not result in another call to
"udevadm settle" which should be ok because udev should never be
creating md devices, right?

Thanks,
Dan
