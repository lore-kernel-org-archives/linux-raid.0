From: David Brown <david.brown@hesbynett.no>
Subject: Re: Multiple SSDs - RAID-1, -10, or stacked? TRIM?
Date: Fri, 11 Oct 2013 10:30:34 +0200
Message-ID: <5257B72A.9040404@hesbynett.no>
References: <20131009123135.GT1779@bitfolk.com> <5256701C.3090807@hardwarefreak.com> <20131010203750.GV1779@bitfolk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131010203750.GV1779@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/10/13 22:37, Andy Smith wrote:
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
> routines that kicked in, but then I read the rest of the thread and
> I think maybe you were hinting at the single write thread issue you
> talk about more in:
> 
>     http://www.spinics.net/lists/raid/msg44211.html
> 
> Is that the case?
> 
>> To be clear, the need for careful directory/file layout to achieve
>> parallel throughput pertains only to the linear concatenation storage
>> architecture described above.  If one is using XFS atop a striped array
>> then throughput, either sequential or parallel, is -not- limited by
>> file/dir placement across the AGs, as all AGs are striped across the disks.
> 
> So, in summary do you recommend the stacked RAID-0 on top of RAID-1
> pairs instead of a RAID-10, where write performance may otherwise be
> bottlenecked by md's single write thread?

I'll try and save Stan the effort in replying to this.

No, he is /not/ recommending RAID-0 on top of RAID-1 pairs.  He is
recommending XFS on a linear stripe of RAID-1 pairs.  There is a /huge/
difference here - what is best depends on your workload, but for any
workload for which 8 SSD's are better than 8 HD's, the XFS solution will
almost certainly be better.

At the bottom layer, you have raid-1 pairs.  These are simple, reliable,
and fast (being simple, there is little extra overhead to limit IOPs).
You can consider advice in other threads about mixing different SSD
types.  And being plain raid-1, you have plenty of flexibility - you can
add extra drives, re-size, etc., at any time.  So far, so good.

On top of that, you have two main choices.

If you want a simple system, you can make a RAID-0 stripe.  Then you can
partition as you want, and use whatever filesystems you need.  RAID-0
gives you excellent large-file performance - reads and writes are
striped across all disks.  But this also means that large reads cause
extra latency for other accesses.  If you are aiming for maximum
throughput on large reads, that's fine - if you are aiming for minimum
latency on lots of parallel accesses, it's much worse.  This can be
mitigated somewhat by having large chunk sizes on the RAID-0 (I'm saying
this from theory, not from experience - so take advice from others too,
and try benchmarking if you can).

The second choice is to use a linear concatenation of the RAID-1 pairs.
 There is no striping - the parts are just attached logically after each
other.  For most file systems, this would not be efficient - the
filesystem would just use the first raid1 pair until it filled up, then
move to the next one, and so on.  But XFS is designed specifically for
such arrangements.  It splits the array into "allocation groups", which
are divided across the array.  Each directory on the disk is put into
one of the allocation groups.  This means that if you make four
directories, all accesses to one directory will go to one pair, while
all accesses to the other directories will go to other pairs.  If you
have a reasonable number of directories, and accesses are distributed
across these directories, then XFS on linear cat gives greater
parallelism and lower latencies than you can get in any other way.  A
disadvantage is that it only works with a single full XFS across the
whole array, though you can probably partition the raid1 pairs into a
small section (for /boot, emergency swap, /, or whatever you need) and a
main partition that is used for the XFS.  Another point with XFS is you
/really/ need an UPS, or you need to use barrier options that lower
performance (this applies to all filesystems, but I believe it is more
so with XFS).



> 
> Write ops are a fraction of the random reads and using RAID with a
> battery-backed write cache solved that problem, but it does need to
> scale linearly with whatever improvement we can get for the read
> ops, so I would think it will still be something worth thinking
> about, so thanks for pointing that out.
> 
> Thanks,
> Andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

