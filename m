From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Tue, 28 Jan 2014 18:56:32 -0600
Message-ID: <52E851C0.50202@hardwarefreak.com>
References: <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com> <20140122174854.GF26014@merlins.org> <52E0807D.2030608@hardwarefreak.com> <20140123091319.GB2306@merlins.org> <52E10A07.3070302@hardwarefreak.com> <20140123210155.GJ10046@merlins.org> <52E1F685.3050300@hardwarefreak.com> <20140125083630.GA7555@merlins.org> <52E76054.5090900@hardwarefreak.com> <20140128165020.GL14998@merlins.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140128165020.GL14998@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/28/2014 10:50 AM, Marc MERLIN wrote:
> On Tue, Jan 28, 2014 at 01:46:28AM -0600, Stan Hoeppner wrote:
>>> Today, I don't use PMPs anymore, except for some enclosures where it's easy
>>> to just have one cable and where what you describe would need 5 sata cables
>>> to the enclosure, would it not?
>>
>> No.  For external JBOD storage you go with an SAS expander unit instead
>> of a PMP.  You have a single SFF 8088 cable to the host which carries 4
>> SAS/SATA channels, up to 2.4 GB/s with 6G interfaces.
>  
> Yeah, I know about those, but I have 5 drives in my enclosures, so that's
> one short :)

I think you misunderstood.  I was referring to a JBOD chassis with SAS
expander, up to 32 drives, typically 12-24 drives with two host or two
daisy chain ports.  Maybe an example would help here.

http://www.newegg.com/Product/Product.aspx?Item=N82E16816133047

Obviously this is in a difference cost category, and not typical for
consumer use.  Smaller units are available for less $$ but you pay more
per drive, as the expander board is the majority of the cost.  Steel and
plastic are cheap, as are PSUs.

>>> I generally agree. Here I was using it to transfer data off some drives, but
>>> indeed I wouldn't use this for a main array.
>>
>> Your original posts left me with the impression that you were using this
>> as a production array.  Apologies for not digesting those correctly.
>  
> I likely wasn't clear, sorry about that.
> 
>> You don't get extra performance.  You expose the performance you already
>> have.  Serial submission typically doesn't reach peak throughput.  Both
>> the resync operation and dd copy are serial submitters.  You usually
>> must submit asynchronously or in parallel to reach maximum throughput.
>> Being limited by a PMP it may not matter.  But with your direct
>> connected drives of your production array you should see a substantial
>> increase in throughput with parallel submission.
> 
> I agree, it should be faster. 
>  
>>>> [global]
>>>> directory=/some/directory
>>>> zero_buffers
>>>> numjobs=4
>>>> group_reporting
>>>> blocksize=1024k
>>>> ioengine=libaio
>>>> iodepth=16
>>>> direct=1
>>>> size=1g
>>>>
>>>> [read]
>>>> rw=read
>>>> stonewall
>>>>
>>>> [write]
>>>> rw=write
>>>> stonewall
>>>
>>> Yeah, I have fio, didn't seem needed here, but I'll it a shot when I get a
>>> chance.
>>
>> With your setup and its apparent hardware limitations, parallel
>> submission may not reveal any more performance.  On the vast majority of
>> systems it does.
> 
> fio said:
> Run status group 0 (all jobs):
>    READ: io=4096.0MB, aggrb=77695KB/s, minb=77695KB/s, maxb=77695KB/s, mint=53984msec, maxt=53984msec
> 
> Run status group 1 (all jobs):
>   WRITE: io=4096.0MB, aggrb=77006KB/s, minb=77006KB/s, maxb=77006KB/s, mint=54467msec, maxt=54467msec

Something is definitely not right if parallel FIO submission is ~25%
lower than single submission dd.  But you were running your dd tests
through buffer cache IIRC.  This FIO test uses O_DIRECT.  So it's not
apples to apples.  When testing IO throughput one should also bypass
buffer cache.

>>> Of course, I'm not getting that speed, but again, I'll look into it.
>>
>> Yeah, something's definitely up with that.  All drives are 3G sync, so
>> you 'should' have 300 MB/s data rate through the PMP.
> 
> Right.
>  
>>> Thanks for your suggestions for tweaks.
>>
>> No problem Marc.  Have you noticed the right hand side of my email
>> address? :)  I'm kinda like a dog with a bone when it comes to hardware
>> issues.  Apologies if I've been a bit too tenacious with this.
> 
> I had not :) I usually try to optimize stuff as much as possible when it's
> worth it or when I really care and have time. I agree this one is puzzling
> me a bit and even if it's fast enough for my current needs and the time I
> have right now, I'll try and move it to another system to see. I'm pretty
> sure that one system has a weird bottleneck.

Yeah, something definitely not right.  Your RAID throughput is less than
a single 7.2K SATA drive.  It's probably just something funky with that
JBOD chassis.

-- 
Stan



