From: David Brown <david.brown@hesbynett.no>
Subject: Re: possibly silly question (raid failover)
Date: Tue, 01 Nov 2011 23:00:01 +0100
Message-ID: <j8pq51$jol$1@dough.gmane.org>
References: <4EAF3F78.5060900@meetinghouse.net> <j8odkj$46h$1@dough.gmane.org> <4EAFEE95.6070608@meetinghouse.net> <4EAFF636.6060904@anonymous.org.uk> <j8p0g3$9r4$1@dough.gmane.org> <4EB052E6.4050400@meetinghouse.net> <20111101212023.GA20565@cthulhu.home.robinhill.me.uk> <4EB06561.8090706@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EB06561.8090706@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/11/11 22:32, Miles Fidelman wrote:
> Robin Hill wrote:
>> On Tue Nov 01, 2011 at 04:13:26 -0400, Miles Fidelman wrote:
>>
>>> David Brown wrote:
>>>> No, md RAID10 does /not/ offer more redundancy than RAID1. You are
>>>> right that md RAID10 offers more than RAID1 (or traditional RAID0 over
>>>> RAID1 sets) - but it is a convenience and performance benefit, not a
>>>> redundancy benefit. In particular, it lets you build RAID10 from any
>>>> number of disks, not just two. And it lets you stripe over all disks,
>>>> improving performance for some loads (though not /all/ loads - if you
>>>> have lots of concurrent small reads, you may be faster using plain
>>>> RAID1).
>>> wasn't suggesting that it does - just that it does things differently
>>> than normal raid 1+0 - for example, by doing mirroring and striping as a
>>> unitary operation, it works across odd number of drives - it also (I
>>> think) allows for more than 2 copies of a block (not completely clear
>>> how many copies of a block would be made if you specified a 16 drive
>>> array) - sort of what I'm wondering here
>>>
>> By default it'll make 2 copies, regardless how many devices are in the
>> array. You can specify how many copies you want though, so -n3 will give
>> you a near configuration with 3 copies, -n4 for four copies, etc.
>>
>>
> cool, so with 16 drives, and say -n6 or -n8, and a far configuration -
> that gives a pretty good level of resistance to multi-disk failures, as
> well as an entire node failure (taking out 4 drives)

You are aware, of course, that if you take your 16 drives and use "-n8", 
you will get a total disk space equivalent to two drives.  It would be 
very resistant to drive failures, but /very/ poor space efficiency.  It 
would also be very fast for reads, but very slow for writes (as 
everything must be written 8 times).

It's your choice - md is very flexible.  But I think an eight-way mirror 
would be considered somewhat unusual.

>
> which then leaves the question of whether the md driver, itself, can be
> failed over from one node to another
>
> Thanks!
>
> Miles
>

