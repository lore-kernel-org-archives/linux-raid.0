From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: major performance drop on raid5 due to context switches caused
 by small max_hw_sectors [partially resolved]
Date: Sun, 22 Apr 2007 10:48:11 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0704221047570.21579@p34.internal.lan>
References: <200704202306.14880.dap@mail.index.hu> <200704221338.45759.dap@mail.index.hu>
 <Pine.LNX.4.64.0704220742080.14170@p34.internal.lan> <200704221638.11837.dap@mail.index.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200704221638.11837.dap@mail.index.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Pallai Roland <dap@mail.index.hu>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Sun, 22 Apr 2007, Pallai Roland wrote:

>
> On Sunday 22 April 2007 13:42:43 Justin Piszcz wrote:
>> http://www.rhic.bnl.gov/hepix/talks/041019pm/schoen.pdf
>> Check page 13 of 20.
> Thanks, interesting presentation. I'm working in the same area now, big media
> files and many clients. I spent some days to build a low-cost, high
> performance server. With my experience, I think, some results of this
> presentation can't be applied to recent kernels.
>
> It's off-topic in this thread, sorry, but I like to swagger what can be done
> with Linux! :)
>
> ASUS P5B-E Plus, P4 641, 1024Mb RAM, 6 disks on 965P's south bridge, 1 disk on
> Jmicron (both driven by AHCI driver), 1 disk on Silicon Image 3132, 8 disks
> on HPT2320 (hpt's driver). 16x Seagate 500Gb 16Mb cache.
> kernel 2.6.20.3
> anticipatory scheduler
> chunk size 64Kb
> XFS file system
> file size is 400Mb, I read 200 of them in each test
>
> The yellow points are marking thrashing thresholds, I computed it based on
> process number and RAM size. It's not an exact threshold.
>
> - now see the attached picture :)
>
> Awesome performance, near disk-platter speed with big RA! It's even better
> with ~+15% if I use the -mm tree with the new adaptive readahead! Bigger
> files, bigger chunk also helps, but in my case, it's constant
> (unfortunately).
>
> The rule of readahead size is simple: the much is better, till no thrashing.
>
>
> --
> d
>
>

Have you also optimized your stripe cache for writes?
