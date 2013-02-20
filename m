From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance - new kernel results - 5x SSD RAID5
Date: Thu, 21 Feb 2013 04:10:15 +1100
Message-ID: <51250377.509@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51222A81.9080600@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/02/13 00:20, Stan Hoeppner wrote:
> On 2/17/2013 3:52 AM, Adam Goryachev wrote:
> 
>>    READ: io=4096MB, aggrb=2242MB/s, minb=2296MB/s, maxb=2296MB/s,
>> mint=1827msec, maxt=1827msec
> 
>>   WRITE: io=4096MB, aggrb=560660KB/s, minb=574116KB/s, maxb=574116KB/s,
>> mint=7481msec, maxt=7481msec
> 
> Our read throughput is almost exactly 4x the write throughput.  At the
> hardware level, single SSD write throughput should only be ~10% lower
> than read.  Sequential writes w/RAID5 should not cause RMW cycles so
> that is not in play in these tests.  So why are writes so much slower?
> Knowing these things, where should we start looking for our performance
> killing needle in this haystack?
> 
> We know that the md/RAID5 driver still uses a single write thread in
> kernel 3.2.35.  And given we're pushing over 500MB/s through md/RAID5 to
> SSD storage, it's possible that this thread is eating all of one CPU
> core with both IOs and parity calculations, limiting write throughput.
> So that's the first place to look.  For your 7 second test run of FIO,
> we could do some crude instrumenting.  Assuming you have top setup to
> show individual Cpus (if not hit '1' in interactive mode to get them,
> then exit), we can grab top output twice a seconds for 10 seconds, in
> another terminal window.  So we do something like the following, giving
> 3 seconds to switch windows and launch FIO.  (Or one could do it in  a
> single window, writing a script to pipe the output of each to a file)
> 
> ~$ top -b -n 20 -d 0.5 |grep Cpu
> 
> yields 28 lines of this for 2 cores, 56 lies for 4 cores.
> 
> Cpu0 : 1.2%us, 0.5%sy, 1.8%ni, 96.4%id, 0.1%wa, 0.0%hi, 0.0%si, 0.0%st
> Cpu1 : 1.1%us, 0.5%sy, 2.2%ni, 96.1%id, 0.1%wa, 0.0%hi, 0.0%si, 0.0%st
> Cpu0 : 1.9%us, 1.9%sy, 0.0%ni, 96.2%id, 0.0%wa, 0.0%hi, 0.0%si, 0.0%st
> Cpu1 : 0.0%us, 0.0%sy, 0.0%ni,100.0%id, 0.0%wa, 0.0%hi, 0.0%si, 0.0%st
> 
> This will give us a good idea of what the cores are doing during the FIO
> run, as well as interrupt distribution, which CPUs are handling the
> lower level IO threads, how long we're waiting on the SSDs, etc.  If any
> core is at 98%+ during the run then md thread starvation is the problem.

Didn't quite work, I had to run the top command like this:
top -n20 -d 0.5 | grep Cpu
Then press 1 after it started, it didn't save the state when running it
interactively and then exiting.
Output is as follows:
Cpu0  :  0.1%us,  2.3%sy,  0.0%ni, 94.3%id,  3.0%wa,  0.0%hi,  0.3%si,
0.0%st
Cpu1  :  0.1%us,  0.5%sy,  0.0%ni, 98.5%id,  0.9%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu2  :  0.1%us,  0.2%sy,  0.0%ni, 99.3%id,  0.4%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu3  :  0.0%us,  0.3%sy,  0.0%ni, 97.8%id,  1.9%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu4  :  0.1%us,  0.1%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu5  :  0.1%us,  0.3%sy,  0.0%ni, 98.0%id,  1.5%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu6  :  0.1%us,  0.1%sy,  0.0%ni, 97.4%id,  2.4%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu7  :  0.0%us,  0.1%sy,  0.0%ni, 99.6%id,  0.2%wa,  0.0%hi,  0.0%si,
0.0%st

Cpu0  :  0.0%us, 47.9%sy,  0.0%ni, 50.0%id,  0.0%wa,  0.0%hi,  2.1%si,
0.0%st
Cpu1  :  0.0%us,  2.0%sy,  0.0%ni, 98.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu2  :  2.0%us, 35.3%sy,  0.0%ni,  0.0%id, 62.7%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu3  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu4  :  0.0%us,  3.8%sy,  0.0%ni, 96.2%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu5  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu6  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st

Cpu0  :  0.0%us, 37.3%sy,  0.0%ni, 62.7%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu1  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu2  :  0.0%us, 13.7%sy,  0.0%ni, 52.9%id, 33.3%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu3  :  2.0%us, 12.0%sy,  0.0%ni, 46.0%id, 40.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu4  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu5  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu6  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st

Cpu0  :  0.0%us, 26.0%sy,  0.0%ni, 44.0%id, 26.0%wa,  0.0%hi,  4.0%si,
0.0%st
Cpu1  :  0.0%us,  7.7%sy,  0.0%ni, 82.7%id,  9.6%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu3  :  0.0%us,  4.0%sy,  0.0%ni, 86.0%id, 10.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu4  :  1.9%us,  1.9%sy,  0.0%ni, 96.2%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu5  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu6  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu7  :  0.0%us,  3.9%sy,  0.0%ni, 13.7%id, 82.4%wa,  0.0%hi,  0.0%si,
0.0%st

Cpu0  :  0.0%us, 10.2%sy,  0.0%ni, 51.0%id, 38.8%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu1  :  0.0%us,  2.0%sy,  0.0%ni, 86.0%id, 12.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu3  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu4  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu5  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu6  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu7  :  0.0%us,  0.7%sy,  0.0%ni, 66.2%id, 33.1%wa,  0.0%hi,  0.0%si,
0.0%st

Cpu0  :  0.0%us, 15.7%sy,  0.0%ni, 39.2%id, 41.2%wa,  0.0%hi,  3.9%si,
0.0%st
Cpu1  :  0.0%us,  4.0%sy,  0.0%ni, 82.0%id, 14.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu3  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu4  :  1.9%us,  1.9%sy,  0.0%ni, 96.2%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu5  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu6  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu7  :  0.0%us,  0.7%sy,  0.0%ni, 66.7%id, 32.7%wa,  0.0%hi,  0.0%si,
0.0%st

Cpu0  :  0.0%us, 12.2%sy,  0.0%ni, 55.1%id, 32.7%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu1  :  0.0%us,  6.0%sy,  0.0%ni, 56.0%id, 38.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu2  :  0.0%us,  1.9%sy,  0.0%ni, 98.1%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu3  :  0.0%us,  1.9%sy,  0.0%ni, 98.1%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu4  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu5  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu6  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu7  :  0.0%us,  0.7%sy,  0.0%ni, 66.2%id, 33.1%wa,  0.0%hi,  0.0%si,
0.0%st

Cpu0  :  0.0%us, 12.5%sy,  0.0%ni, 41.7%id, 45.8%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu1  :  0.0%us,  6.2%sy,  0.0%ni, 89.6%id,  4.2%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu2  :  0.0%us,  0.0%sy,  0.0%ni, 62.0%id, 38.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu3  :  0.0%us,  2.0%sy,  0.0%ni, 78.4%id, 19.6%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu4  :  0.0%us,  3.8%sy,  0.0%ni, 96.2%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu5  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu6  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu7  :  0.0%us,  1.9%sy,  0.0%ni, 57.7%id, 40.4%wa,  0.0%hi,  0.0%si,
0.0%st

Cpu0  :  0.0%us, 13.7%sy,  0.0%ni, 33.3%id, 51.0%wa,  0.0%hi,  2.0%si,
0.0%st
Cpu1  :  0.0%us,  7.8%sy,  0.0%ni, 80.4%id, 11.8%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu3  :  0.0%us,  0.0%sy,  0.0%ni, 66.7%id, 33.3%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu4  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu5  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu6  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st

Cpu0  :  0.0%us, 10.4%sy,  0.0%ni, 25.0%id, 62.5%wa,  0.0%hi,  2.1%si,
0.0%st
Cpu1  :  0.0%us,  8.0%sy,  0.0%ni, 88.0%id,  4.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu3  :  0.0%us,  0.7%sy,  0.0%ni, 66.7%id, 32.7%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu4  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu5  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu6  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st

Cpu0  :  0.0%us,  6.5%sy,  0.0%ni, 21.7%id, 71.7%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu1  :  0.0%us,  7.8%sy,  0.0%ni, 88.2%id,  3.9%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu3  :  0.0%us,  0.0%sy,  0.0%ni, 66.7%id, 33.3%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu4  :  1.9%us,  1.9%sy,  0.0%ni, 96.2%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu5  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu6  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st

Cpu0  :  0.0%us, 14.0%sy,  0.0%ni, 34.0%id, 52.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu1  :  0.0%us,  9.8%sy,  0.0%ni, 80.4%id,  9.8%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu3  :  0.0%us,  1.3%sy,  0.0%ni, 65.8%id, 32.9%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu4  :  0.0%us,  2.0%sy,  0.0%ni, 98.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu5  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu6  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st

Cpu0  :  0.0%us, 12.5%sy,  0.0%ni, 29.2%id, 58.3%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu1  :  0.0%us,  6.0%sy,  0.0%ni, 86.0%id,  8.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu3  :  0.0%us,  0.7%sy,  0.0%ni, 66.2%id, 33.1%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu4  :  2.0%us,  0.0%sy,  0.0%ni, 98.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu5  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu6  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st

There was more, very similar figures... apart from the second sample
above, there was never a single Cpu with close to 0% Idle, and I'm
assuming the %CPU in wa state is basically "idle" waiting for the disk
or something else to happen rather than the CPU actually being busy...

> (If you have hyperthreading enabled, reboot and disable it.  It normally
> decreases thread performance due to scheduling and context switching
> overhead, among other things.  Not to mention it makes determining
> actual CPU load more difficult.  In this exercise you'll needlessly have
> twice as many lines of output to comb through.)

I'll have to go in after hours to do that. Hopefully over the weekend
(BIOS setting and no remote KVM)... Can re-supply the results after that
if you think it will make a difference.

> If md is peaking a single core, the next step is to optimize the single
> thread performance.  There's not much you can do here but to optimize
> the parity calculation rate and tweak buffering.  I'm no expert on this
> but others here are.  IIRC you can tweak md to use the floating point
> registers and SSEx/AVX instructions.  These FP execution units in the
> CPU run in parallel to the integer units, and are 128 vs 64 bits wide
> (256 for AVX).  So not only is the number crunching speed increased, but
> it's done in parallel to the other instructions.  This makes the integer
> units more available.  You should also increase your stripe_cache_size
> if you haven't already.  Such optimizations won't help much overall--
> we're talking 5-20% maybe-- because the bottleneck lay elsewhere in the
> code.  Which brings us to...
> 
> The only other way I know of to increase single thread RAID5 write
> performance substantially is to grab a very recent kernel and Shaohua
> Li's patch set developed specifically for the single write thread
> problem on RAID1/10/5/6.  His test numbers show improvements of 130-200%
> increasing with drive count, but not linearly.  It is described here:
> http://lwn.net/Articles/500200/
> 
> With current distro kernels and lots of SSDs, the only way to
> significantly improve this single thread write performance is to use
> nested md/RAID0 over smaller arrays to increase the thread count and
> bring more cores into play.  With this you get one write thread per
> constituent array.  Each thread receive one core of performance.  The
> stripe over them has no threads and can scale to any numbers of cores.
> 
> Assuming you are currently write thread bound at ~560-600MB/s, adding
> one more Intel SSD for 6 total gives us...
> 
> RAID0 over 3 RAID1, 3 threads-- should yield read speed between 1.5 and
> 3GB/s depending on load, and increase your write speed to 1.6GB/s, for
> the loss of 480G capacity.
> 
> RAID0 over 2 RAID5, 2 threads-- should yield between 2.2 and 2.6GB/s
> read speed, and increase your write speed to ~1.1GB/s, for no change in
> capacity.
> 
> Again, these numbers assume the low write performance is due to thread
> starvation.

I don't think it is from my measurements...

> The downside for both:  Neither of these configurations can be expanded
> with a reshape and thus drives cannot be added.  That can be achieved by
> using a linear layer atop these RAID0 devices, and adding new md devices
> to the linear array later.  With this you don't get automatic even
> distribution of IO for the linear array, but only for the constituent
> striped arrays.  This isn't a bad tradeoff when IO flow analysis and
> architectural planning are performed before a system is deployed.

I'll disable the hyperthreading, and re-test afterwards, but I'm not
sure that will produce much of a result. Let me know if you think I
should run any other tests to track it down...

One thing I can see is a large number of interrupts and context switches
which looks like it happened at the same time as a backup run. Perhaps I
am getting too many interrrupts on the network cards or the SATA controller?

Thanks,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
