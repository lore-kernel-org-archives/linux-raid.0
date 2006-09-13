From: Tejun Heo <htejun@gmail.com>
Subject: Re: libata hotplug and md raid?
Date: Wed, 13 Sep 2006 20:06:41 +0900
Message-ID: <4507E641.7090508@gmail.com>
References: <c384c5ea0609130311t4005e5aam153251fc6bbbdfb8@mail.gmail.com> <4507E2A9.7070306@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4507E2A9.7070306@emc.com>
Sender: linux-ide-owner@vger.kernel.org
To: Ric Wheeler <ric@emc.com>
Cc: Leon Woestenberg <leon.woestenberg@gmail.com>, linux-raid@vger.kernel.org, Greg KH <gregkh@suse.de>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

Ric Wheeler wrote:
> (Adding Tejun & Greg KH to this thread)
Adding linux-ide to this thread.
> 
> Leon Woestenberg wrote:
[--snip--]
>> In short, I use ext3 over /dev/md0 over 4 SATA drives /dev/sd[a-d]
>> each driven by libata ahci. I unplug then replug the drive that is
>> rebuilding in RAID-5.
>>
>> When I unplug a drive, /dev/sda is removed, hotplug seems to work to
>> the point where proc/mdstat shows the drive failed, but not removed.

Yeap, that sounds about right.

>> Every other notion of the drive (in kernel and udev /dev namespace)
>> seems to be gone after unplugging. I cannot manually removed the drive
>> using mdadm, because it tells me the drive does not exist.

I see.  That's a problem.  Can you use /dev/.static/dev/sda instead?  If 
you can't find those static nodes, just create one w/ 'mknod 
my-static-sda b 8 0' and use it.

>> Replugging the drive brings it back as /dev/sde, md0 will not pick it up.

No, it won't.

> I have a similar setup, AHCI + 4 drives but using a RAID-1 group.  The 
> thing that you are looking for is "persistent device naming" and should 
> work properly if you can tweak udev/hotplug correctly.
> 
> I have verified that a drive pull/drive reinsert on a mainline kernel 
> with a SLES10 base does provide this (first insertion gives me sdb, pull 
> followed by reinsert still is sdb), but have not tested interaction with 
> RAID since I am focused on the bad block handling at the moment.  I will 
> add this to my list ;-)
> 
>>
>> The expected behaviour (from me) is that the drive re-appears as 
>> /dev/sda.

Apart from persistent naming Ric mentioned above, the reason why you 
don't get sda back is md is holding the internal device.  It's removed 
from all visible name spaces but md still holds a reference, so the 
device cannot be destroyed.  So, when a new device comes along, sda is 
occupied by the dead device, and the new one gets the next available 
slot, which happens to be sde in your case.

>> What is the intended behaviour of md in this case?
>>
>> Should some user-space application fail-remove a drive as a pre-action
>> of the unplug event from udev, or should md fully remove the drive
>> within kernel space??

I'm curious too.  Would it be better for md to listen to hotplug events 
and auto-remove dead devices or is it something which belongs to userland?

Thanks.

-- 
tejun
