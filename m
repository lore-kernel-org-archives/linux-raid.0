From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: southbridge/sata controller performance?
Date: Sat, 03 Jan 2009 14:11:38 -0600
Message-ID: <495FC67A.2030201@gmail.com>
References: <20090103193429.GA17462@sewage.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090103193429.GA17462@sewage.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matt Garman wrote:
> When using Linux software RAID, I was thinking that, from a
> performance perspective, the southbridge/SATA controller is probably
> one of the most important components (assuming a reasonable CPU).
> Is this a correct generalization?
> 
> If it is, has anyone done a study or benchmarked SATA controller
> performance?  Particularly with consumer-grade hardware?
> 
> I haven't been able to find much info about this on the web; the
> Tech Report seems to consistently benchmark SATA performance:
> 
>     AMD SB600: http://techreport.com/articles.x/13832/5
>     AMD SB700: http://techreport.com/articles.x/14261/10
>     AMD SB750: http://techreport.com/articles.x/13628/9
>     Intel ICH10: http://techreport.com/articles.x/15653/9
>     nVidia GeForce 8300: http://techreport.com/articles.x/14993/9

In general those benchmarks are mostly useless for Raid.

The biggest different for RAID is what happens when multiple channels 
are used.   On full speed streaming read/write almost every (even the 
worst PCI controllers on a PCI bus) sata controller is close to equal 
when you only have one drive, once you use 2 drives or more things 
change.   If the given controller setup can actually run several 
drives at close to full single drive speed performance will be good, 
if it cannot things are going to get much slower.

One test I do is a single dd from one disk and watch the io speed, and 
then I add dd's and watch what happens.   I have 4 identical disks, 2 
are on a ICH7, 2 are on a pci bus based MB controller, any single of 
these disks will do about 75MB/second no matter were it is, using 2 on 
the ich7 gets about 140-150MB/second, using the 2 on the pci bus based 
MB controller gets 98MB/second.   If all of the controllers 
techreports tested were equal on this test, then it might be worth it 
to look at the benchmarks techreport is using, but the simple dd 
benchmark is likely more important, and I am pretty sure that someone 
could use a controller (on a bandwidth limited bus) that would do good 
on the above techreport benchmark, but fail horribly when several 
disks with a high io speed were being used and work badly for raid.



