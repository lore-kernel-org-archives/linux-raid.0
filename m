From: David Brown <david.brown@hesbynett.no>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Tue, 22 May 2012 09:29:47 +0200
Message-ID: <4FBB406B.7040904@hesbynett.no>
References: <4FAAE8F1.8000600@pocock.com.au> <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com> <4FABC7C6.4030107@turmel.org> <4FAC2FF2.5060305@hardwarefreak.com> <4FAC40BC.1060300@hesbynett.no> <CABYL=ToORULrdhBVQk0K8zQqFYkOomY-wgG7PpnJnzP9u7iBnA@mail.gmail.com> <4FACBB68.2080304@hesbynett.no> <4FACCAC8.4020206@pocock.com.au> <4FAD9283.7020809@hardwarefreak.com> <CAGqmV7oJg8vwKPJEYJhPANzaN-xxVW6Lw2gLTEKmMfG=pqCHuA@mail.gmail.com> <4FBA8EA9.40203@hardwarefreak.com> <20120522093404.3ffaae42@notabene.brown> <4FBB33D6.4010101@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FBB33D6.4010101@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: NeilBrown <neilb@suse.de>, CoolCold <coolthecold@gmail.com>, Daniel Pocock <daniel@pocock.com.au>, Roberto Spadim <roberto@spadim.com.br>, Phil Turmel <philip@turmel.org>, Marcus Sorensen <shadowsor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/05/2012 08:36, Stan Hoeppner wrote:
> On 5/21/2012 6:34 PM, NeilBrown wrote:
>> On Mon, 21 May 2012 13:51:21 -0500 Stan Hoeppner<stan@hardwarefreak.com>
>> wrote:
>>
>>> On 5/21/2012 10:20 AM, CoolCold wrote:
>>>> On Sat, May 12, 2012 at 2:28 AM, Stan Hoeppner<stan@hardwarefreak.com>  wrote:
>>>>> On 5/11/2012 3:16 AM, Daniel Pocock wrote:
>>>>>
>>>> [snip]
>>>>> That's the one scenario where I abhor using md raid, as I mentioned.  At
>>>>> least, a boot raid 1 pair.  Using layered md raid 1 + 0, or 1 + linear
>>>>> is a great solution for many workloads.  Ask me why I say raid 1 + 0
>>>>> instead of raid 10.
>>>> So, I'm asking - why?
>>>
>>> Neil pointed out quite some time ago that the md RAID 1/5/6/10 code runs
>>> as a single kernel thread.  Thus when running heavy IO workloads across
>>> many rust disks or a few SSDs, the md thread becomes CPU bound, as it
>>> can only execute on a single core, just as with any other single thread.
>>
>> This is not the complete truth.
>
> Yes, I should have stipulated only writes are limited to a single thread.
>
>> For RAID1 and RAID10, successful IO requests do not involved the kernel
>> thread, so the fact that there is only one should be irrelevant.
>> Failed requests are retried using the thread and it is also involved it
>> resync/recovery so those processes may be limited by the single thread.
>>
>> RAID5/6 does not use the thread for read requests on a non-degraded array.
>> However all write requests go through the single thread so there could be
>> issues there.
>
> Thanks for clarifying this.  In your previous response to this issue
> (quoted and linked below) you included RAID 1/10 with RAID 5/6 WRT
> writes going through a single thread.
>
>> Have you  actually measured md/raid10 being slower than raid0 over raid1?
>
> I personally have not, as I don't have access to the storage hardware
> necessary to sink a sufficiently large write stream to peak a core with
> the md thread.
>
>> I have a vague memory from when this came up before that there was some extra
>> issue that I was missing, but I cannot recall it just now....
>
> We're recalling the same thread, which was many months ago.  Here's your
> post:  http://marc.info/?l=linux-raid&m=132616899005148&w=2
>
> And here's the relevant section upon which I was basing my recent
> statements:
>
> "I think you must be misremembering.  Neither RAID0 or Linear have any
> threads involved.  They just redirect the request to the appropriate
> devices.  Multiple threads can submit multiple requests down through
> RAID0 and Linear concurrently.
>
> RAID1, RAID10, and RAID5/6 are different.  For reads they normally are
> have no contention with other requests, but for writes things do get
> single-threaded at some point."
>

I would think that even if writes to raid1 and raid10 do go through a 
single thread, it is unlikely to be a bottleneck - after all, it will 
mostly just pass the write on to the block layer for the 2 (or more) disks.

As for how much single-threading limits raid5/6 writes, it comes down to 
a balance between memory bandwidth and processor speed.  I would imagine 
that for calculating the simple XOR for raid5, the limit is how fast the 
data can get on and off the chip, rather than how fast a single thread 
can chew through it.  If that's the case, then having two threads doing 
the same thing on different blocks will not run any faster.  If you have 
more than one chip, however, you might have more memory bandwidth - and 
raid6 calculations as well as degraded array access involve more 
processing, and will then be cpu limited.

And if the single thread has to block (such as while waiting for reads 
during a partial stripe update on raid5 or raid6), then it could quickly 
become a bottleneck.

But in general, it's important to do some real-world testing to 
establish whether or not there really is a bottleneck here.  It is 
counter-productive for Stan (or anyone else) to advise against raid10 or 
raid5/6 because of a single-thread bottleneck if it doesn't actually 
slow things down in practice.  On the other hand, if it /is/ a hinder to 
scaling, then it is important for Neil and other experts to think about 
how to change the architecture of md raid to scale better.  And 
somewhere in between there can be guidelines to help users - something 
like "for an average server, single-threading will saturate raid5 
performance at 8 disks, raid6 performance at 6 disks, and raid10 at 10 
disks, beyond which you should use raid0 or linear striping over two or 
more arrays".

Of course, to do such testing, someone would need a big machine with 
lots of disks, which is not otherwise in use!

mvh.,

David
