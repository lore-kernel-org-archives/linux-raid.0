From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: possibly silly question (raid failover)
Date: Tue, 01 Nov 2011 13:37:58 +0000
Message-ID: <4EAFF636.6060904@anonymous.org.uk>
References: <4EAF3F78.5060900@meetinghouse.net> <j8odkj$46h$1@dough.gmane.org> <4EAFEE95.6070608@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EAFEE95.6070608@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@meetinghouse.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/11/2011 13:05, Miles Fidelman wrote:
> David Brown wrote:
>>
>> One thing to watch out for when making high-availability systems and
>> using RAID1 (or RAID10), is that RAID1 only tolerates a single failure
>> in the worst case. If you have built your disk image spread across
>> different machines with two-copy RAID1, and a server goes down, then
>> the rest then becomes vulnerable to a single disk failure (or a single
>> unrecoverable read error).
>>
>> It's a different matter if you are building a 4-way mirror from the
>> four servers, of course.
>>
>
> Just a nit here: I'm looking at "md RAID10" which behaves quite
> differently that conventional RAID10. Rather than striping and raiding
> as separate operations, it does both as a unitary operation -
> essentially spreading n copies of each block across m disks. Rather
> clever that way.
>
> Hence my thought about a 16-disk md RAID10 array - which offers lots of
> redundancy.

I'm pretty sure that a normal (near) md RAID10 on 16 disks will use the 
first two drives you specify as mirrors, and the next two, and so on, so 
when you specify the drive order when building the array you'd need to 
make sure all the mirrors are on another machine.

Cheers,

John.

