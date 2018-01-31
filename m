From: David Brown <david.brown@hesbynett.no>
Subject: Re: [LSF/MM TOPIC] De-clustered RAID with MD
Date: Wed, 31 Jan 2018 09:03:29 +0100
Message-ID: <5A717851.2020909@hesbynett.no>
References: <mqdvafkhep0.fsf@linux-x5ow.site>        <5A6F4CA6.5060802@youngman.org.uk> <mqd607jn0pq.fsf@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <mqd607jn0pq.fsf@linux-x5ow.site>
Sender: linux-raid-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Wols Lists <antlists@youngman.org.uk>
Cc: lsf-pc@lists.linux-foundation.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On 30/01/18 10:40, Johannes Thumshirn wrote:
> Wols Lists <antlists@youngman.org.uk> writes:
> 
>> On 29/01/18 15:23, Johannes Thumshirn wrote:
>>> Hi linux-raid, lsf-pc
>>>
>>> (If you've received this mail multiple times, I'm sorry, I'm having
>>> trouble with the mail setup).
>>
>> My immediate reactions as a lay person (I edit the raid wiki) ...
>>>
>>> With the rise of bigger and bigger disks, array rebuilding times start
>>> skyrocketing.
>>
>> And? Yes, your data is at risk during a rebuild, but md-raid throttles
>> the i/o, so it doesn't hammer the system.
>>>
>>> In a paper form '92 Holland and Gibson [1] suggest a mapping algorithm
>>> similar to RAID5 but instead of utilizing all disks in an array for
>>> every I/O operation, but implement a per-I/O mapping function to only
>>> use a subset of the available disks.
>>>
>>> This has at least two advantages:
>>> 1) If one disk has to be replaced, it's not needed to read the data from
>>>    all disks to recover the one failed disk so non-affected disks can be
>>>    used for real user I/O and not just recovery and
>>
>> Again, that's throttling, so that's not a problem ...
> 
> And throttling in a production environment is not exactly
> desired. Imagine a 500 disk array (and yes this is something we've seen
> with MD) and you have to replace disks. While the array is rebuilt you
> have to throttle all I/O because with raid-{1,5,6,10} all data is
> striped across all disks.

You definitely don't want a stripe across 500 disks!  I'd be inclined to
have raid1 pairs as the basic block, or perhaps 6-8 drive raid6 if you
want higher space efficiency.  Then you build your full array on top of
that, along with a file system that can take advantage of the layout.
If you have an XFS over a linear concat of these sets, then you have a
system that can quickly server many parallel loads - but that could be
poor distribution if you are storing massive streaming data.  And
rebuilds only delay data from the one block that is involved in the rebuild.

(I have no experience with anything bigger than about 6 disks - this is
just theory on my part.)

> 
> With a parity declustered RAID (or DDP like Dell, NetApp or Huawei call
> it) you don't have to as the I/O is replicated in parity groups across a
> subset of disks. All I/O targeting disks which aren't needed to recover
> the data from the failed disks aren't affected by the throttling at all.
> 
>>> 2) an efficient mapping function can improve parallel I/O submission, as
>>>    two different I/Os are not necessarily going to the same disks in the
>>>    array. 
>>>
>>> For the mapping function used a hashing algorithm like Ceph's CRUSH [2]
>>> would be ideal, as it provides a pseudo random but deterministic mapping
>>> for the I/O onto the drives.
>>>
>>> This whole declustering of cause only makes sense for more than (at
>>> least) 4 drives but we do have customers with several orders of
>>> magnitude more drivers in an MD array.
>>
>> If you have four drives or more - especially if they are multi-terabyte
>> drives - you should NOT be using raid-5 ...
> 
> raid-6 won't help you much in above scenario.
> 

Raid-6 is still a great deal better than raid-5 :-)

And for your declustered raid or distributed parity, you can have two
parities rather than just one.


