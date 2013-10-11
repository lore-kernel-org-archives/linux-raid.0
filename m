From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Multiple SSDs - RAID-1, -10, or stacked? TRIM?
Date: Fri, 11 Oct 2013 04:37:45 -0500
Message-ID: <5257C6E9.4090508@hardwarefreak.com>
References: <20131009123135.GT1779@bitfolk.com> <5256701C.3090807@hardwarefreak.com> <20131010203750.GV1779@bitfolk.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131010203750.GV1779@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/10/2013 3:37 PM, Andy Smith wrote:
> Hi Stan,
> 
> (Thanks everyone else who's responded so far, too -- I'm paying
> attention with interest)
> 
> On Thu, Oct 10, 2013 at 04:15:08AM -0500, Stan Hoeppner wrote:
>> On 10/9/2013 7:31 AM, Andy Smith wrote:
>>> Are there any gotchas to be aware of? I haven't much experience with
>>> SSDs.
>>
>> Yes, there is one major gotcha WRT md/RAID and SSDs, which to this point
>> nobody has mentioned in this thread, possibly because it pertains to
>> writes, not reads.  Note my question posed to you up above.  Since I've
>> answered this question in detail at least a dozen times on this mailing
>> list, I'll simply refer you to one of my recent archived posts for the
>> details:
>>
>> http://permalink.gmane.org/gmane.linux.raid/43984
> 
> When I first read that link I thought perhaps you were referring to
> write performance dropping off a cliff due to SSD garbage caching
> routines that kicked in, 

I referenced that thread because it covers two possible causes of
bottlenecking of SSD performance, both with and without md/RAID.

> but then I read the rest of the thread and
> I think maybe you were hinting at the single write thread issue you
> talk about more in:
> 
>     http://www.spinics.net/lists/raid/msg44211.html
> 
> Is that the case?

Yes, but I wasn't hinting.  This is precisely why Shaohua Li has been
working on a set of patches to make md's write path threaded,
eliminating the single core bottleneck.  Once they're complete and in
distro kernels one should no longer need to create layered RAID levels
for max SSD throughput.

>> To be clear, the need for careful directory/file layout to achieve
>> parallel throughput pertains only to the linear concatenation storage
>> architecture described above.  If one is using XFS atop a striped array
>> then throughput, either sequential or parallel, is -not- limited by
>> file/dir placement across the AGs, as all AGs are striped across the disks.
> 
> So, in summary do you recommend the stacked RAID-0 on top of RAID-1

No.  Striping across SSDs increases write amplification on all the
drives and will wear the flash cells out more quickly than if not
striping.  I'd guess most people don't consider this when creating a
striped array of SSDs.  Then again, most people think EXT -is- the Linux
filesystem, and that the world is flat...

> pairs instead of a RAID-10, where write performance may otherwise be
> bottlenecked by md's single write thread?

Something to keep in mind when discussing the single thread write
bottleneck is that we're talking about maximizing the investment in SSD
throughput with "all" multi-core CPUs, mostly the lower clocked models.
 It's a relative discussion, not absolute.

If you dig around the archives you'll find a thread in which I helped
Adam Goryachev tune his md/RAID5 of 5x480GB Intel consumer SSDs, LSI
9211-8i, to achieve read/write of 2.5GB/s and 1.6 GB/s respectively.
That's 1.6GB/s with a single md write thread.  I don't recall which
LGA1155 CPU he was using.  IIRC it was 2.9-3.6GHz.

With a CPU with fast single core performance, multi-channel DRAM, and no
bottlenecks in the IO path (PCIe/system chipset connection), one
core/one write thread may be more than sufficient for most md/RAID
levels and workloads.

> Write ops are a fraction of the random reads and using RAID with a
> battery-backed write cache solved that problem, but it does need to
> scale linearly with whatever improvement we can get for the read
> ops, so I would think it will still be something worth thinking
> about, so thanks for pointing that out.

What is the target of the random read/write IOPS?  A single large file,
multiple small files, or a mix of the two?  Before I can give you any
real advice I need to know what the workload is actually doing.  Without
knowing the workload everything is guesswork.

In fact I should have asked this up front.  The workload drives
everything.  Always has, always will.

-- 
Stan

