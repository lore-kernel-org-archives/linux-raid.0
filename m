From: David Brown <david@westcontrol.com>
Subject: Re: Special drives for Linux Raid?
Date: Mon, 07 Nov 2011 15:57:49 +0100
Message-ID: <j98s0f$a0f$1@dough.gmane.org>
References: <4EB7DD23.9090907@agenda.si> <4EB7E1F8.7060803@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EB7E1F8.7060803@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/11/2011 14:49, Miles Fidelman wrote:
> Danilo Godec wrote:
>> Some manufacturers make 'special' versions of drives for RAID (WD RE4,
>> Seagate SE, ...). Apparently the main difference is in error handling,
>> where normal 'desktop' drives try hard to recover an error (up to
>> several minutes) while RAID drives give up quickly (few seconds) so
>> that the RAID controller can take over.
>>
> not so much "special" as "different"
>
> the term to look for is "enterprise"
>
> you've identified the key distinction:
>
> - desktop drives assume that they have the only copy of your data, the
> on-board processor tries very hard to read and re-read until it returns
> your data ---- the result is that everything slows down
>
> - if you have a raid array, you want a failing disk to give up and
> return, very quickly, so that the data can be read from a different drive
>
> I learned this the hard way, when I had a server that just slowed way
> down to the point that it took 10 seconds or more to echo a keystroke.
> It took me a long time to figure out what was going on - and some rather
> painful false starts (trashed the o/s).
>
> One important thing I discovered: the md RAID driver does NOT consider a
> long time delay as a signal to fail a drive out of an array. It's a
> really good idea to run mdstat and keep an eye on your drives. If Raw
> Reed Error goes above 0, start paying attention.
>

As far as I know (and I hope I'll be corrected quickly if I'm wrong), 
when a drive fails to read from a sector, it will be considered a 
"failed" drive by the raid controller or software raid, and kicked out 
of the array.  The exception is the latest versions of md raid which 
support bad block lists.

If you are using a "raid" drive, which only re-tries for a couple of 
seconds, then a read failure will quickly return an error.  This limits 
the worst-case delay when reading from a failing drive.  But it also 
means that the drive won't try as hard as it can, and the drive will be 
kicked out of the array earlier.

With a "desktop" drive, worst case delays can be much longer, but you 
have a higher chance of getting your data off the disk.  That's always a 
good thing, even with raid.

If you use a hardware raid controller that requires "raid" drives, then 
long re-reads on a "desktop" drive will cause timeouts, and the drive 
will be kicked out of the array.


I don't believe it is very common to have long re-reads even with 
desktop drives - more commonly, the drive will either correct small 
errors quickly, or will have serious failures.  But obviously the 
situation does occur.

If you need to put limits on the worst-case read performance, then 
"raid" drives are the only way to go.  If not, then I would think 
"desktop" drives are a better choice in most cases.  Also note that 
since "desktop" drives are half the cost of "raid" drives, if you have 
the space in your system you can buy twice as many for the same price. 
That means better performance and/or better redundancy and/or more space 
and/or better value for money.


