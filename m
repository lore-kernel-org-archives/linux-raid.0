From: David Brown <david@westcontrol.com>
Subject: Re: possibly silly question (raid failover)
Date: Tue, 01 Nov 2011 15:36:34 +0100
Message-ID: <j8p0g3$9r4$1@dough.gmane.org>
References: <4EAF3F78.5060900@meetinghouse.net> <j8odkj$46h$1@dough.gmane.org> <4EAFEE95.6070608@meetinghouse.net> <4EAFF636.6060904@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EAFF636.6060904@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/11/2011 14:37, John Robinson wrote:
> On 01/11/2011 13:05, Miles Fidelman wrote:
>> David Brown wrote:
>>>
>>> One thing to watch out for when making high-availability systems and
>>> using RAID1 (or RAID10), is that RAID1 only tolerates a single failure
>>> in the worst case. If you have built your disk image spread across
>>> different machines with two-copy RAID1, and a server goes down, then
>>> the rest then becomes vulnerable to a single disk failure (or a single
>>> unrecoverable read error).
>>>
>>> It's a different matter if you are building a 4-way mirror from the
>>> four servers, of course.
>>>
>>
>> Just a nit here: I'm looking at "md RAID10" which behaves quite
>> differently that conventional RAID10. Rather than striping and raiding
>> as separate operations, it does both as a unitary operation -
>> essentially spreading n copies of each block across m disks. Rather
>> clever that way.
>>
>> Hence my thought about a 16-disk md RAID10 array - which offers lots of
>> redundancy.

No, md RAID10 does /not/ offer more redundancy than RAID1.  You are 
right that md RAID10 offers more than RAID1 (or traditional RAID0 over 
RAID1 sets) - but it is a convenience and performance benefit, not a 
redundancy benefit.  In particular, it lets you build RAID10 from any 
number of disks, not just two.  And it lets you stripe over all disks, 
improving performance for some loads (though not /all/ loads - if you 
have lots of concurrent small reads, you may be faster using plain RAID1).

To get higher redundancy with RAID10 or RAID1, you need to use more 
"ways" in the mirror.  For example, creating RAID10 with "--layout n3" 
will give you three copies of all data, rather than just two, and 
therefore better redundancy - at the cost of disk space.  When you write 
"RAID10", the assumption is you mean a normal two-way mirror unless you 
specifically say otherwise, and such a mirror has only a worst-case 
redundancy of 1 disk.  A second failure will kill the array if it 
happens to hit the second copy of the data.

>
> I'm pretty sure that a normal (near) md RAID10 on 16 disks will use the
> first two drives you specify as mirrors, and the next two, and so on, so
> when you specify the drive order when building the array you'd need to
> make sure all the mirrors are on another machine.
>

Correct.  If you have a multiple of 4 disks, a "normal" near two-way 
RAID10 is almost indistinguishable from a standard two-way RAID1.

> Cheers,
>
> John.
>

