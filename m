From: David Brown <david.brown@hesbynett.no>
Subject: Re: raid5 to utilize upto 8 cores
Date: Sat, 18 Aug 2012 10:59:05 +0200
Message-ID: <502F5959.3000507@hesbynett.no>
References: <CAEyJA_sSzmgcK6miWfxC4jgvbH7WJ_hgZhnmFABaK9r7X=SLDQ@mail.gmail.com> <502C8C18.5070501@hardwarefreak.com> <502CA6CE.1080105@hesbynett.no> <502DEFAB.3060206@hardwarefreak.com> <502DF2E8.4030207@hesbynett.no> <502E2253.9020409@hardwarefreak.com> <502E2F65.7040501@hesbynett.no> <502F204D.5020506@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <502F204D.5020506@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: vincent Ferrer <vincentchicago1@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/08/12 06:55, Stan Hoeppner wrote:
> On 8/17/2012 6:47 AM, David Brown wrote:
>> On 17/08/2012 12:52, Stan Hoeppner wrote:
>
>> It sounds like I /have/ misunderstood things - at least regarding the
>> inode64 allocator (which will surely be the best choice for a large
>> array).  I had though that while directories "/a/" and "/b/" get
>> different allocation groups, directories "/a/1/" and "/a/2/" would go in
>> the same AG as "/a/".  What you are saying is that this is not correct -
>> each of these four directories would go in a separate AG.  File "/a/1/x"
>> would go in the same AG as "/a/1/", of course.  Assuming this is the
>> case, XFS over linear concat sounds more appealing for a much wider set
>> of applications than I had previously thought.
>
> I may bear some blame for this.  Long ago I thought the inode64
> allocator worked as you describe.  I may have spread that
> misinformation.  If so, my apologies to all.
>
> Indeed the inode64 allocator creates new directories evenly across all
> AGs in a round robin fashion.

Thanks for clearing this up.  I understand much better now why you are 
such a fan of XFS over concat - spreading all directories around like 
this will give better performance for a much wider set of workloads.

> Thus it will work better with most
> workloads on storage with some level of concatenation than with straight
> striped RAID on rust.  This is due to excessive seeks across all the
> AGs, which line up from outer to inner tracks when striping.  With SSD
> seek starvation is irrelevant, so concat and striping are pretty much equal.
>
>>> The only real benefit of striped RAID over concat, for the majority of
>>> workloads, is $/GB.
>
> To be more clear, I was obviously referring to striped parity RAID here,
> not RAID10, which has the same cost as concat+mirror.
>

