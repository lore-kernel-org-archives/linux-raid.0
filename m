From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: [mdadm git pull] support for detecting platform raid capabilities and some fixes
Date: Thu, 27 Nov 2008 07:24:12 +0100
Message-ID: <ac3eb2510811262224h65d5b774j502c8a635328fe7c@mail.gmail.com>
References: <1227743100.31146.41.camel@dwillia2-linux.ch.intel.com>
	 <ac3eb2510811261613ja5bc80ag4fc011d76d95e961@mail.gmail.com>
	 <e9c3a7c20811261925r36a304a6taaca2b6a8a146799@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20811261925r36a304a6taaca2b6a8a146799@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Nov 27, 2008 at 04:25, Dan Williams <dan.j.williams@intel.com> wrote:
> On Wed, Nov 26, 2008 at 5:13 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> On Thu, Nov 27, 2008 at 00:45, Dan Williams <dan.j.williams@intel.com> wrote:
>>> This implementation crawls through sysfs to put this information
>>> together, I believe it is crawling in a future proof fashion, but here
>>> are my assumptions:
>>> 1/ /sys/bus/pci/drivers/ahci/<x>/device will identify a pci ahci device
>>
>> Why "device"? You just check for the "device" attribute file of the PCI device?
>>
>
> $ ls /sys/bus/pci/drivers/ahci/
> 0000:00:1f.2/   module/ uevent
> bind                    new_id  unbind
>
> I look for the 'device' file to disambiguate '0000:00:1f.2' from
> 'module' or some other object that appears in the future.  The other
> attributes are discarded because they are not directories.

But only devices of the bus "pci" have this attribute. The code looks
like it it should be able to handle some other buses to, at least the
bus values is passed around, but the pci-device attribute "device" is
hard coded. That's why I asked.
It's fine if you want to do it that way. If you just look for a
"struct device" of that <bus>, resolving "subsystem" and checking if
the tail of the string matches "/<bus>" should be fine.

>>> 1/ An attempt to cover the delay between mdadm creating an array and the
>>> friendly-named device node showing up in /dev/md/ by calling 'udevadm
>>> settle' before starting starting Incremental assembly.  This
>>> specifically fixes scripts that do:
>>> mdadm -A /dev/md/<container>
>>> mdadm -I /dev/md/<container>
>>> There is a good chance there is a better place to put this call, but
>>> putting it in create_mddev didn't work, and moving it up in main()
>>> resulted in a hang.  I didn't want to hold up the other patches for this
>>> debug.
>>
>> If mdadm calls "udevadm settle", we can not call mdadm (which we do
>> already) from udev rules because it will just deadlock.
>>
>> We need to make "udevadm settle" smarter and not to wait for its own
>> event, or make it wait for something specific and not just "all"
>> events, or find a different way for mdadm to sync with udev.
>>
>
> It just sounds like we need to be careful that the path that udev
> triggers when it calls mdadm does not result in another call to
> "udevadm settle" which should be ok because udev should never be
> creating md devices, right?

Udev calls mdadm also for the md devices, but with different options I
guess. In the future, udev will also create the device nodes instead
of mdadm.
This needs to be handled very careful, because _any_ call to udevadm
from mdadm will deadlock if called from udev. Something we need to
make sure, it can't happen, on udev's or mdadm's side.

Thanks,
Kay
