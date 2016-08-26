From: Chris Murphy <lists@colorremedies.com>
Subject: Re: bootsect replicated in p1, RAID enclosure suggestions?
Date: Thu, 25 Aug 2016 22:25:35 -0600
Message-ID: <CAJCQCtQLLJEoovBtks0ft9XArHwwZTMqBGobW5WavsQydbqSBQ@mail.gmail.com>
References: <20160823050947.GL32250@subspacefield.org> <CAJCQCtSY=D-ASQ22km8GJjfju4jUgJSOBTAH5+XveCZq1BvT7w@mail.gmail.com>
 <20160825062501.GN32250@subspacefield.org> <CAJCQCtSWOwf6pHD2O7CtaNwF4BDbHO+hh7XrXpcaRsqPkvmFrQ@mail.gmail.com>
 <20160826025012.GO32250@subspacefield.org> <CAJCQCtRwF1XCNQRxibFGZ0SVQ8=RKo1birv5ZWZBvZGpuu0ndQ@mail.gmail.com>
 <20160826035850.GQ32250@subspacefield.org> <20160826040619.GR32250@subspacefield.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160826040619.GR32250@subspacefield.org>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Aug 25, 2016 at 10:06 PM,
<travis+ml-linux-raid@subspacefield.org> wrote:
> On Thu, Aug 25, 2016 at 08:58:50PM -0700, travis@subspacefield.org wrote:
>> Yeah, *when I created this disk layout* I might have created a GPT in
>> partition 1.
>>
>> That was probably a year or more ago.
>>
>> That has nothing to do with this crash, which is perhaps the fourth of
>> its kind.
>>
>> I haven't touched the box in weeks before this happened, when I was
>> away on vacation.  Although, it could have lurked for some time,
>> and only been uncovered by a crash or kpanic.
>
> I certainly have not repartitioned the disks multiple times.  There's
> no need for that.  It leads to these sort of problems.
>
> The kernel does panic from time to time.
>
> To repeat, this box was *completely unattended* for several weeks
> before the crash.  No administration at all.  I simply rsync'd things
> off it as necessary.  As a non-root user.
>
> I am curious about the fact that /dev/sdd1 and /dev/sde1 were listed
> together in this lvm cache, and those are the two disks that normally
> get blasted every 6 months or so.  That's an odd coincidence, and my
> best lead yet.

Well that file does seem stale, because those partitions aren't
actually part of LVM. They're members of an mdadm array. I don't know
where LVM comes into this because we don't have the complete layout.



-- 
Chris Murphy
