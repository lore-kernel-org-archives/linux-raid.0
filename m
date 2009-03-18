From: david.geib@huskymail.uconn.edu
Subject: Re: Why do I need 4 disks for a raid6?
Date: Wed, 18 Mar 2009 14:12:44 -0400 (EDT)
Message-ID: <63799.69.177.110.128.1237399964.squirrel@huskymailweb.uconn.edu>
References: <87ljr4hsk9.fsf@frosties.localdomain>
    <62620.69.0.24.162.1237347686.squirrel@huskymailweb.uconn.edu>
    <87vdq7w46n.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87vdq7w46n.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> If this is the only case where it would be useful, wouldn't it be better
>> to add an option to mdadm --grow specifying a new raid level, if
>> different? That way you could take your /dev/md9 raid1 and do:
>>
>> mdadm --add /dev/md9 /dev/sdc1
>> mdadm --grow -n 3 /dev/md9 --level=5
>>
>> or
>>
>> mdadm --add /dev/md9 /dev/sdc1 /dev/sdd1
>> mdadm --grow -n 4 /dev/md9 --level=6
>>
>> or convert a raid5 to raid6 in like fashion, for that matter.

> That would do 2 things in one, convert the raid level and grow the
> stripes.
>
> On the other hand, if 3 disk raid6 where allowed, then this could be
> broken down into 2 simple operations for the userspace: 1) change raid
> level without restriping, 2) restripe, which we already know how to
> do.
>
> To me it just seems easier to teach the kernel to online reload a raid
> device with a different raid mode without any changes, covering
> conversion of 1<->4, 1<->5 and 1<->6 in both directions, than to
> combine the 2 steps.
>
> That would only leave conversion from 4/5 <-> 6 as complicated case.

That's really what I'm getting at. In the 4/5 <-> 6 case the level
conversion would require a reshape and either changing the number of
devices or shrinking the array. This implies the need for the userspace to
convey to the kernel both the level conversion and the new number of
devices at the same time. Once that is possible, why not use it for 1 <->
6 and all the others too?

> And hey, maybe I am crazy and do want a 3 disk raid6 next to my 2 disk
> raid5, my 1 disk raid10, my 1 disk raid1 and my 1 disk raid0. :)
> The limitation in the kernel just seems arbitrary, that is unless one
> of the raid algorithms would break down with just 3 disks.

I don't disagree that if a three disk raid6 is possible in theory then it
might as well be supported. I'm merely suggesting that there ought to be a
better way to do level conversion than creating a new array on top of the
old one.

