From: David Greaves <david@dgreaves.com>
Subject: Re: Questions about software RAID
Date: Tue, 19 Apr 2005 09:08:40 +0100
Message-ID: <4264BC88.4050209@dgreaves.com>
References: <1113853825.1483.34.camel@debian> <426414A5.3020706@dgreaves.com> <1113865936.1483.73.camel@debian> <20050419071514.GB29247@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050419071514.GB29247@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra wrote:

> many people find it easier to understand if raid partitions are set to
> 0XFD. kernel autodetection is broken and should not be relied upon.

Could you clarify what is broken?
I understood that it was simplistic (ie if you have a raid0 built over a 
raid5
or something exotic then it may have problems) but essentially worked.
Could it be :
* broken for complex raid on raid
* broken for root devices
* fine for 'simple', non-root devices

>
>
>>> >4) I guess the partitions itself doesn't have to be formated as the
>>> >filesystem is on the RAID-level. Is that correct?
>>> compulsory!
>>
>>
>> I meant, the /dev/mdX has to be formatted, not the individual
>> partitions. Still right?
>
> compulsory! if you do anything on the individual components you'll 
> damage data.
>
>>> >5) Removing a disk requires that I do a "mdadm -r" on all the 
>>> partitions
>>> >that is involved in a RAID array. I attempt to by a hot-swap capable
>>> >controler, so what happens if I just pull out the disk without this
>>> >manual removal command?
>>> as far as md is concerned the disk disappeared.
>>> I _think_ this is just like mdadm -r.
>>
> i think it will be marked faulty, not removed.

yep - you're right, I remember now.
You have to mdadm -r remove it and re-add it once you restore the disk.

>
>> So I could actually just pull out the disk, insert a new one and do a
>> "mdadm -a /dev/mdX /dev/sdY"?
>> The RAID system won't detect the newly inserted disk itself?
>
> no, think of it as flexibility. if you want you can build something
> using the "hotplug" subsystem.

or:
no, it would be mighty strange if the raid subsystem just grabbed every
new disk it saw...
Think of what would happen when I insert my camera's compact flash card
and it suddenly gets used as a hot spare <grin>



I'll leave Luca's last word - although it's also worth re-reading Peter's
first words!!

David

> one last word:
> never trust howtos (they should be called howidid), they have the
> tendency to apply to the author configuration, not yours.
> general documentation is far more accurate.

