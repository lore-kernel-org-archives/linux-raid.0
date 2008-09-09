From: AndrewL733 <AndrewL733@aol.com>
Subject: Re: Observation about RAID 0 performance in 2.6.25 kernel
Date: Mon, 08 Sep 2008 21:04:07 -0400
Message-ID: <48C5CB87.7060900@aol.com>
References: <48C52206.9060101@aol.com> <a43edf1b0809080741j72c850f8n6508870ccec01ee7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a43edf1b0809080741j72c850f8n6508870ccec01ee7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Billy Crook <billycrook@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Billy Crook wrote:
> I would suspect the default IO scheduler changed between those two
> kernels.  On both systems,
> [bcrook@bcrook ~]$ cat /sys/block/sda/queue/scheduler
> noop anticipatory deadline [cfq]
>
> I bet you'll get closer matching results it you echo the name of the
> .20 default scheduler to /sys/block/sda/queue/scheduler on .25
> Though, it might be worth contrasting the performance of all options
> on the .25 system.
>
> You probably already know this but the io scheduler determines in what
> order the heads move to get at what parts of the disk in what order.
> It can greatly impact performance, so choosing the right scheduler,
> and tuning it, can potentially help a lot.
>   
Nice try, but no, both systems are running the deadline scheduler. CFQ?  
I believe that means "poor performance for all". CFQ is fair, in that it 
treats every request equally badly!

In all seriousness, CFQ is not for this kind of storage server.

Andrew
> On Mon, Sep 8, 2008 at 08:00, AndrewL733 <AndrewL733@aol.com> wrote:
>   
>> I'm wondering if anybody has observed something similar to what I am seeing.
>> For the past year, my production storage systems have primarily been using
>> the 2.6.20.15 kernel (that's what we settled on a while back, and generally
>> I have been happy with it).
>>
>> About 3 months ago, I began experimenting with the 2.6.25 kernel, because I
>> wanted to use some kernel-specific features that were only introduced in
>> 2.6.23, 2.6.24 and 2.6.25.
>>
>> My production systems typically consist of servers with two 3ware 9650
>> 12-port RAID cards and 24 SATA drives, 12 drives on each card. For maximum
>> performance, we stripe together the two 12-drive "hardware RAIDS" using
>> Linux software RAID-0. My other hardware includes a very recent motherboard
>> based on the Intel 5400 chipset, with 4 Gen-2 x8 PCI-e slots and the 5482
>> Intel 3.2 Ghz Quad Core CPU with 4 GBs of RAM. In other words, it's very
>> capable hardware.
>>
>> When comparing the 2.6.20.15 kernel with the 2.6.25 kernel, I have noticed
>> that:
>>
>> For the underlying 3ware devices, all benchmarks -- dd, bonnie++, and my own
>> "torture test" that measures performance doing many random reads
>> simultaneously -- show that 2.6.25 kernel is about 10 percent faster than
>> the 2.6.20.15 kernel for both reading and writing.
>>
>> However, when I stripe together those two 3ware devices with Linux software
>> RAID 0, with the 2.6.25 kernel I get about a 20 percent BOOST in
>>  performance for WRITING compared to the 2.6.20.15 kernel, but I get about
>> an 8 percent DROP in READING performance with the 2.6.25 kernel.
>>
>> My tests have been conducted using the in-kernel 3ware drivers, as well as
>> compiling 3ware's latest drivers for each kernel (so, in the latter case, I
>> have the same 3ware firmware and driver for either kernel). The results are
>> very similar either way.
>>
>> Does anybody have any insights into what might be going on here? Does Linux
>> software RAID need to be configured differently in 2.6.25 to NOT lose READ
>> performance? Is there something that most be done to vm tuning with 2.6.25?
>> Is there a known issue with 2.6.25 that perhaps has been resolved with
>> 2.6.26?
>>
>> Regards,
>> Andrew
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>     

