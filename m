From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: southbridge/sata controller performance?
Date: Sun, 4 Jan 2009 04:55:18 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901040451520.18797@p34.internal.lan>
References: <20090103193429.GA17462@sewage.raw-sewage.fake> <495FC67A.2030201@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <495FC67A.2030201@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: Matt Garman <matthew.garman@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 3 Jan 2009, Roger Heflin wrote:

> Matt Garman wrote:
>> When using Linux software RAID, I was thinking that, from a
>> performance perspective, the southbridge/SATA controller is probably
>> one of the most important components (assuming a reasonable CPU).
>> Is this a correct generalization?
>> 
>> If it is, has anyone done a study or benchmarked SATA controller
>> performance?  Particularly with consumer-grade hardware?
>> 
>> I haven't been able to find much info about this on the web; the
>> Tech Report seems to consistently benchmark SATA performance:
>>
>>     AMD SB600: http://techreport.com/articles.x/13832/5
>>     AMD SB700: http://techreport.com/articles.x/14261/10
>>     AMD SB750: http://techreport.com/articles.x/13628/9
>>     Intel ICH10: http://techreport.com/articles.x/15653/9
>>     nVidia GeForce 8300: http://techreport.com/articles.x/14993/9
>
> In general those benchmarks are mostly useless for Raid.
>
> The biggest different for RAID is what happens when multiple channels are 
> used.   On full speed streaming read/write almost every (even the worst PCI 
> controllers on a PCI bus) sata controller is close to equal when you only 
> have one drive, once you use 2 drives or more things change.   If the given 
> controller setup can actually run several drives at close to full single 
> drive speed performance will be good, if it cannot things are going to get 
> much slower.
>
> One test I do is a single dd from one disk and watch the io speed, and then I 
> add dd's and watch what happens.   I have 4 identical disks, 2 are on a ICH7, 
> 2 are on a pci bus based MB controller, any single of these disks will do 
> about 75MB/second no matter were it is, using 2 on the ich7 gets about 
> 140-150MB/second, using the 2 on the pci bus based MB controller gets 
> 98MB/second.   If all of the controllers techreports tested were equal on 
> this test, then it might be worth it to look at the benchmarks techreport is 
> using, but the simple dd benchmark is likely more important, and I am pretty 
> sure that someone could use a controller (on a bandwidth limited bus) that 
> would do good on the above techreport benchmark, but fail horribly when 
> several disks with a high io speed were being used and work badly for raid.
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

This has been discussed before, on the southbridge it is usually good/you 
will get the maximum bandwidth for each of the 6 sata ports.  After that, 
you need to use PCI-e lanes from the northbridge.  Using PCI-e x1 slots 
that come off the southbridge can degrade performance of the 6 SATA ports 
or the speed coming off the drives connected to the x1 slots will be slow.

What are you trying to accomplish?

As Roger pointed out, doing a dd is a good way to test, from each disk, 
simultaneously, on an old Intel P965 board I was able to achieve 
1.0-1.1Gbyte/sec doing that with 12 Velociraptors and 1.0Gbyte/sec reads 
on the XFS filesystem when dd (reading) large data on the volume.  Approx 
500-600MiB/s from the southbridge, the other 400MiB/s from the 
northbridge.

Justin.
