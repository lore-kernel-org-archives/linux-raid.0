From: Alex Lilley <alex@redwax.co.uk>
Subject: Re: status of raid 4/5 disk reduce
Date: Wed, 10 Dec 2008 12:14:36 +0000
Message-ID: <493FB2AC.7000902@redwax.co.uk>
References: <493D8A95.2020700@mikebrancato.com> <493EDF02.5090500@redwax.co.uk>	 <A20315AE59B5C34585629E258D76A97C02F476F7@34093-C3-EVS3.exchange.rackspace.com>	 <20081209215149.GA21523@cthulhu.home.robinhill.me.uk> <7d86ddb90812091515m1e0ee2f9w95a86ca2b56a98fe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7d86ddb90812091515m1e0ee2f9w95a86ca2b56a98fe@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There is the very obvious use to reduce the number of drives but
ultimately have a larger array if the drives are all larger. And there
should be no issue with file system/lvm resizing as these can generally
grow on-line anyway.

I appreciate that shrinking the size of the array and doing so onto less
disks is both an unlikely requirement and fraught with danger.   Growing
the size of the array but to less disks is very useful indeed, which is
what I was getting at.

Regards

Alex

Ryan Wagoner wrote:
>> Things like RAID1 -> RAID5 and RAID5 -> RAID6 reshaping seem to be more
>> in demand than shrinking as well.
>>     
>
> RAID 1 to RAID 5 can already be done with mdadm. The RAID 5 shrink
> could be useful in some situations. The risk of user error causing
> file system data loss is no worse than resizing an LVM volume without
> shrinking the file system first.
>
> Ryan
>
> On Tue, Dec 9, 2008 at 4:51 PM, Robin Hill <robin@robinhill.me.uk> wrote:
>   
>> On Tue Dec 09, 2008 at 03:33:17PM -0600, David Lethe wrote:
>>
>>     
>>>> -----Original Message-----
>>>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>>>> owner@vger.kernel.org] On Behalf Of Alex Lilley
>>>> Sent: Tuesday, December 09, 2008 3:12 PM
>>>> To: Michael Brancato
>>>> Cc: linux-raid@vger.kernel.org
>>>> Subject: Re: status of raid 4/5 disk reduce
>>>>
>>>> Hi Michael
>>>>
>>>> I posed this a few weeks back but haven't seen any activity on it yet
>>>> or
>>>> any suggestion as to when this might be possible.
>>>>
>>>> For reference, my thread started here:
>>>> http://marc.info/?l=linux-raid&m=122753511309332&w=2
>>>>
>>>> Cross fingers for this because I think it is a real killer feature.
>>>>
>>>> Regards
>>>>
>>>> Alex
>>>>
>>>> Michael Brancato wrote:
>>>>         
>>>>> I'm curious as to the status of the ability to reduce the number of
>>>>> disks in a RAID 4/5 array.  I would like the ability to reshape a 4
>>>>> disk raid4/5 to a 3 disk raid4/5 for flexibility.
>>>>>
>>>>> here is what I want to do....
>>>>> $ sudo mdadm /dev/md0 --fail /dev/disk4 --remove /dev/disk4
>>>>> mdadm: set /dev/disk4 faulty in /dev/md0
>>>>> mdadm: hot removed /dev/disk4
>>>>> $ sudo mdadm --grow /dev/md0 -n3
>>>>> mdadm: /dev/md0: Cannot reduce number of data disks (yet).
>>>>>
>>>>> I know this capability is missing in the md driver.  What is needed to
>>>>> make it work and is anyone currently working on it?
>>>>>
>>>>> Regards,
>>>>>
>>>>>           
>>> This is a lot to ask for in terms of development, and creates extreme
>>> risk of data loss.
>>> First, you degrade /dev/md0, so any bad blocks or drive failures will
>>> cause catastrophic
>>> data loss, unless /dev/disk4 is used for mirroring in the interim.
>>>
>>> Secondly, by removing that disk (for sake of argument, say each disk is
>>> 1TB. You go from 3TB usable data
>>> to 2TB.  Most likely, you need to resize the file system in place so it
>>> fits into 2TB.  You're probably booted
>>> onto md0 also, which makes it difficult.  Resizing a hot filesystem
>>> without scratch space??  If your file system
>>> can't be dynamically reduced, then no point worrying about md raid.
>>>
>>> I don't see it happening .. ever.  Even if somebody wrote the logic, I
>>> can't imagine the code being tested enough
>>> to be safe for live data.
>>>
>>>       
>> I'd agree that, as described here, it's not too likely.
>>
>> However, if you start with the requirement that the capacity of the
>> final array is the same or larger than the capacity of the current array
>> (e.g. replace the drives, one at a time, with larger drives first) so
>> that no filesystem resizing is required, you should be able to do the
>> reshape without having to go degraded at all.  I'm not sure this process
>> would be fundamentally more complex (or more risky) than the current
>> growing process.
>>
>> Having said that, I'm not aware of any current work going on on this.
>> Things like RAID1 -> RAID5 and RAID5 -> RAID6 reshaping seem to be more
>> in demand than shrinking as well.
>>
>> Cheers,
>>    Robin
>> --
>>     ___
>>    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
>>   / / )      | Little Jim says ....                            |
>>  // !!       |      "He fallen in de water !!"                 |
>>
>>     
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

