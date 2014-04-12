From: bobzer <bobzer@gmail.com>
Subject: Re: Some info given by 'mdadm --detail --export' are not convenient
 to use
Date: Sat, 12 Apr 2014 12:34:18 -0400
Message-ID: <CADzS=aoGiQMG5MRL9Z3+tBsaGGEKEuxX+eq8q190aZJrHw79kQ@mail.gmail.com>
References: <5347CB9D.5090702@gmail.com> <20140412094330.12fbf1a7@notabene.brown>
 <5348F7CC.40400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5348F7CC.40400@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi
If i can give my thoughts
I like the idea of having a MD device list
But I also think the francis's idea is good and for the spare you
could enumerate with letter ?

we could get :

MD_DEVICES=4
MD_DEVICE_LIST=loop0p1 loop1p1 loop2p1 loop3p1
MD_DEVICE_DEV_1=/dev/loop0p1
MD_DEVICE_ROLE_1=0
MD_DEVICE_DEV_2=/dev/loop1p1
MD_DEVICE_ROLE_2=1
MD_DEVICE_DEV_3=/dev/loop2p1
MD_DEVICE_ROLE_3=2
MD_DEVICE_DEV_A=/dev/loop3p1
MD_DEVICE_ROLE_A=spare

like that it's really easy to parse what ever you need :-)

or maybe just continue normal increment since we have the role...

On Sat, Apr 12, 2014 at 4:22 AM, Francis Moreau <francis.moro@gmail.com> wrote:
> On 04/12/2014 01:43 AM, NeilBrown wrote:
>> On Fri, 11 Apr 2014 13:01:49 +0200 Francis Moreau <francis.moro@gmail.com>
>> wrote:
>>
>>> Hello,
>>>
>>> I'm writing a tool that relies udev lib in order to manage block
>>> devices connected to my computer.
>>>
>>> One thing that I need is to retrieve disks contained by a RAID array.
>>>
>>> The current usefull information exported by udev are, for example:
>>>
>>> MD_DEVICES=3
>>> MD_DEVICE_loop0p1_DEV=/dev/loop0p1
>>> MD_DEVICE_loop0p1_ROLE=0
>>> MD_DEVICE_loop1p1_DEV=/dev/loop1p1
>>> MD_DEVICE_loop1p1_ROLE=1
>>> MD_DEVICE_loop2p1_DEV=/dev/loop2p1
>>> MD_DEVICE_loop2p1_ROLE=2
>>>
>>> but this is not really easy to exploit since I need to know the disk
>>> names in order to poke the devices used by the array :-/
>>>
>>> why not simply using ?
>>>
>>> MD_DEVICE_DEV_1=/dev/loop0p1
>>> MD_DEVICE_ROLE_1=0
>>>
>>
>> What number would I use for spare devices?
>> Certainly something like this could be done, but it wasn't.
>>
>> Maybe what you are really asking is:
>>
>> "Could we please have another record which lists all the devices, e.g.
>>   MD_DEVICE_LIST=loop0p1 loop1p1 loop2p1
>> ??"
>>
>
> Yes please, that's what I was asking for: there's currently no easy way
> to retrieve the list of disks that is part of an array. Currently we have:
>
> MD_DEVICE_loop0p1_DEV=/dev/loop0p1
>
> The name of the property involves the value of the property.
>
>> Obviously you can extract that from the output above, but it might be easier
>> to have it explicitly.
>
> Yes I can but it's not very convenient.
>
>>
>> Would that meet your need, or have I misunderstood you completely?
>>
>
> Yes, it would.
>
> Thanks.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
