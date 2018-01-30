From: David Brown <david.brown@hesbynett.no>
Subject: Re: Implementing Global Parity Codes
Date: Tue, 30 Jan 2018 12:47:30 +0100
Message-ID: <5d74077e-8100-2d12-1a93-5121acfbd24c@hesbynett.no>
References: <CACm9mdUJLczo8zSB5UfU9Fd_6VK3+sGCYJYdaEaX0qW1cMLtYA@mail.gmail.com>
 <5A6C3A43.6030701@youngman.org.uk>
 <CACm9mdWs0d+Fo32AQ3prMuJhfsmECK2jBw-0O7D-KR=LNWtyvw@mail.gmail.com>
 <5A6C972C.8070401@youngman.org.uk>
 <bcd4cf40-dba6-1c52-ab8a-6884290215fa@hesbynett.no>
 <5A6F5D9B.5060201@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A6F5D9B.5060201@youngman.org.uk>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 29/01/2018 18:44, Wols Lists wrote:
> On 29/01/18 10:22, David Brown wrote:
>>> I've updated a page on the wiki, because it's come up in other
>>> discussions as well, but it seems to me if you need extra parity, you
>>> really ought to be going for raid-60. Take a look ...
>>>
>>> https://raid.wiki.kernel.org/index.php/What_is_RAID_and_why_should_you_want_it%3F#Which_raid_is_for_me.3F
>>>
>>>
>>> and if anyone else wants to comment, too? ...
>>>
>>
>> Here are a few random comments:
>>
>> Raid-10-far2 can be /faster/ than Raid0 on the same number of HDs, for
>> read-only performance.  This is because the data for both stripes will
>> be read from the first half of the disks - the outside half.  On many
>> disks this gives higher read speeds, since the same angular rotation
>> speed has higher linear velocity at the disk heads.  It also gives
>> shorter seek times as the head does not have to move as far in or out to
>> cover the whole range.  For SSDs, the layout for Raid-10 makes almost no
>> difference (but it is still faster than plain Raid-1 for streamed reads).
> 
> Except that most drives don't do that nowadays, they do "constant linear
> velocity" so the drive speeds up or slows down depending on where the
> heads are, I believe.

Perhaps - I haven't tried to keep up with the specs of all drives, and 
it is surprisingly hard to get a good answer from a quick google. 
However, I would be surprised if CLV were the norm for hard disks. 
Certainly it was not the case before (though it was used for CD-ROMS and 
other optical media).  The inner tracks of a hard disk are perhaps half 
the circumference of the outer tracks - to keep constant linear 
velocity, you need twice the rotational speed on the inside compared to 
the outside.  That is a massive difference, taking several seconds 
(perhaps 10 seconds) to bring to a stable speed.

I suspect you are mixing up velocity and density here.  Earlier hard 
drives had constant angular density - the same number of sectors per 
track throughout the disk.  Modern drives have constant linear density - 
so you get more sectors on an outer track than an inner track.

>>
>> For two drives, Raid-10 is a fine choice on read-heavy or streaming
>> applications.
> 
> Which is just raid-1, no?

No.  The "raid-10 near" is pretty much identical to raid-1, but the 
"far" and "offset" raid-10 layouts are different:

<https://en.wikipedia.org/wiki/Non-standard_RAID_levels#LINUX-MD-RAID-10>

Near layout minimises the head movement on writes.  Far layout maximises 
streaming read performance, but has more latency during writes due to 
larger head movements.  Offset layout gives raid0 read performance for 
small and mid-size reads, with only slightly more latency in writes.

>>
>> I think you could emphasise that there is little point in having Raid-5
>> plus a spare - Raid-6 is better in every way.
> 
> Agreed. I don't agree raid-6 is better in *every* way - it wastes space
> - but yes once you have enough drives you should go raid-6 :-)

Raid-6 is better than raid-5 plus a spare - it uses exactly the same 
number of disks, and does not waste anything while providing a huge 
improvement in redundancy and therefore data safety.

Okay, it is not better in /every/ way.  It takes a bit of computing 
power, though that is rarely relevant as cpus have got more threads that 
are mostly idle.  And it gives a bit more write amplification than 
raid-5.  But if you think "my raid-5 array is so important that I want a 
hot spare to make rebuilds happen as soon as possible", then you 
/definitely/ want raid-6 instead.

>>
>> You should make a clearer distinction that by "Raid-6+0" you mean a
>> Raid-0 stripe of Raid-6 sets, rather than a Raid-6 set of Raid-0 stripes.
>>
> Done.
> 
>> There are also many, many other ways to organise multi-layer raids.
>> Striping at the high level (like Raid-6+0) makes sense only if you have
>> massive streaming operations for single files, and massive bandwidth -
>> it is poorer for operations involving a large number of parallel
>> accesses.  A common arrangement for big arrays is a linear concatenation
>> of Raid-1 pairs (or Raid-5 or Raid-6 sets) - combined with an
>> appropriate file system (XFS comes out well here) you get massive
>> scalability and very high parallel access speeds.
>>
>> Other things to consider on big arrays are redundancy of controllers, or
>> even servers (for SAN arrays).  Consider the pros and cons of spreading
>> your redundancy across blocks.  For example, if your server has two
>> controllers then you might want your low-level block to be Raid-1 pairs
>> with one disk on each controller.  That could give you a better spread
>> of bandwidths and give you resistance to a broken controller.
>>
>> You could also talk about asymmetric raid setups, such as having a
>> write-only redundant copy on a second server over a network, or as a
>> cheap hard disk copy of your fast SSDs.
> 
> Snag is, I don't manage large arrays - it's a lot to think about. I
> might add that later.

Fair enough.  You can't cover /everything/ on a wiki page - then it is a 
full time job and a book, not a wiki page!  I am just giving suggestions 
and ideas.

>>
>> And you could also discuss strategies for disk replacement - after
>> failures, or for growing the array.
>>
>> It is also worth emphasising that RAID is /not/ a backup solution - that
>> cannot be said often enough!
>>
>> Discuss failure recovery - how to find and remove bad disks, how to deal
>> with recovering disks from a different machine after the first one has
>> died, etc.  Emphasise the importance of labelling disks in your machines
>> and being sure you pull the right disk!
>>
> I think that's covered elsewhere :-)

Maybe you could add a few links?  There is no need to repeat information.

mvh.,

David


> 
> Cheers,
> Wol
> 
