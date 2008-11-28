From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [mdadm git pull] support for detecting platform raid capabilities and some fixes
Date: Fri, 28 Nov 2008 10:24:24 -0700
Message-ID: <e9c3a7c20811280924je623664s5d3b2fe9e990c06e@mail.gmail.com>
References: <1227743100.31146.41.camel@dwillia2-linux.ch.intel.com>
	 <ac3eb2510811261613ja5bc80ag4fc011d76d95e961@mail.gmail.com>
	 <e9c3a7c20811261925r36a304a6taaca2b6a8a146799@mail.gmail.com>
	 <ac3eb2510811262224h65d5b774j502c8a635328fe7c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ac3eb2510811262224h65d5b774j502c8a635328fe7c@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Nov 26, 2008 at 11:24 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Thu, Nov 27, 2008 at 04:25, Dan Williams <dan.j.williams@intel.com> wrote:
>> On Wed, Nov 26, 2008 at 5:13 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
>>> On Thu, Nov 27, 2008 at 00:45, Dan Williams <dan.j.williams@intel.com> wrote:
>>>> This implementation crawls through sysfs to put this information
>>>> together, I believe it is crawling in a future proof fashion, but here
>>>> are my assumptions:
>>>> 1/ /sys/bus/pci/drivers/ahci/<x>/device will identify a pci ahci device
>>>
>>> Why "device"? You just check for the "device" attribute file of the PCI device?
>>>
>>
>> $ ls /sys/bus/pci/drivers/ahci/
>> 0000:00:1f.2/   module/ uevent
>> bind                    new_id  unbind
>>
>> I look for the 'device' file to disambiguate '0000:00:1f.2' from
>> 'module' or some other object that appears in the future.  The other
>> attributes are discarded because they are not directories.
>
> But only devices of the bus "pci" have this attribute. The code looks
> like it it should be able to handle some other buses to, at least the
> bus values is passed around, but the pci-device attribute "device" is
> hard coded. That's why I asked.
> It's fine if you want to do it that way. If you just look for a
> "struct device" of that <bus>, resolving "subsystem" and checking if
> the tail of the string matches "/<bus>" should be fine.

gah, I was confusing the 'device' I find here "/sys/block/sda/device"
with the pci device id.  Yes, checking on 'subsystem' seems to be
exactly what I want.

Thanks,
Dan
