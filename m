From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance - new kernel results - 5x SSD RAID5
Date: Thu, 21 Feb 2013 00:04:21 -0600
Message-ID: <5125B8E5.5000502@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com> <51250377.509@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51250377.509@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/20/2013 11:10 AM, Adam Goryachev wrote:
> On 19/02/13 00:20, Stan Hoeppner wrote:
>> On 2/17/2013 3:52 AM, Adam Goryachev wrote:
>>
>>>    READ: io=4096MB, aggrb=2242MB/s, minb=2296MB/s, maxb=2296MB/s,
>>> mint=1827msec, maxt=1827msec
>>
>>>   WRITE: io=4096MB, aggrb=560660KB/s, minb=574116KB/s, maxb=574116KB/s,
>>> mint=7481msec, maxt=7481msec
>>
>> Our read throughput is almost exactly 4x the write throughput.  At the
>> hardware level, single SSD write throughput should only be ~10% lower
>> than read.  Sequential writes w/RAID5 should not cause RMW cycles so
>> that is not in play in these tests.  So why are writes so much slower?
>> Knowing these things, where should we start looking for our performance
>> killing needle in this haystack?
>>
>> We know that the md/RAID5 driver still uses a single write thread in
>> kernel 3.2.35.  And given we're pushing over 500MB/s through md/RAID5 to
>> SSD storage, it's possible that this thread is eating all of one CPU
>> core with both IOs and parity calculations, limiting write throughput.
>> So that's the first place to look.  For your 7 second test run of FIO,
>> we could do some crude instrumenting.  Assuming you have top setup to
>> show individual Cpus (if not hit '1' in interactive mode to get them,
>> then exit), we can grab top output twice a seconds for 10 seconds, in
>> another terminal window.  So we do something like the following, giving
>> 3 seconds to switch windows and launch FIO.  (Or one could do it in  a
>> single window, writing a script to pipe the output of each to a file)
>>
>> ~$ top -b -n 20 -d 0.5 |grep Cpu
>>
>> yields 28 lines of this for 2 cores, 56 lies for 4 cores.
>>
>> Cpu0 : 1.2%us, 0.5%sy, 1.8%ni, 96.4%id, 0.1%wa, 0.0%hi, 0.0%si, 0.0%st
>> Cpu1 : 1.1%us, 0.5%sy, 2.2%ni, 96.1%id, 0.1%wa, 0.0%hi, 0.0%si, 0.0%st
>> Cpu0 : 1.9%us, 1.9%sy, 0.0%ni, 96.2%id, 0.0%wa, 0.0%hi, 0.0%si, 0.0%st
>> Cpu1 : 0.0%us, 0.0%sy, 0.0%ni,100.0%id, 0.0%wa, 0.0%hi, 0.0%si, 0.0%st
>>
>> This will give us a good idea of what the cores are doing during the FIO
>> run, as well as interrupt distribution, which CPUs are handling the
>> lower level IO threads, how long we're waiting on the SSDs, etc.  If any
>> core is at 98%+ during the run then md thread starvation is the problem.
> 
> Didn't quite work, I had to run the top command like this:
> top -n20 -d 0.5 | grep Cpu
> Then press 1 after it started, it didn't save the state when running it
> interactively and then exiting.

Simply reading 'man top' tells you that hitting 'w' writes the change.
As you didn't have the per CPU top layout previously, I can only assume
you don't use top very often, if at all.  top is a fantastic diagnostic
tool when used properly.  Learn it, live it, love it. ;)

> Output is as follows:
...
> Cpu0  :  0.0%us, 47.9%sy,  0.0%ni, 50.0%id,  0.0%wa,  0.0%hi,  2.1%si,
> 0.0%st
> Cpu1  :  0.0%us,  2.0%sy,  0.0%ni, 98.0%id,  0.0%wa,  0.0%hi,  0.0%si,
> 0.0%st
> Cpu2  :  2.0%us, 35.3%sy,  0.0%ni,  0.0%id, 62.7%wa,  0.0%hi,  0.0%si,
> 0.0%st
> Cpu3  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
> 0.0%st
> Cpu4  :  0.0%us,  3.8%sy,  0.0%ni, 96.2%id,  0.0%wa,  0.0%hi,  0.0%si,
> 0.0%st
> Cpu5  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
> 0.0%st
> Cpu6  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
> 0.0%st
> Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,
> 0.0%st

With HT, this output for 8 "cpus" and line wrapping, it's hard to make
heads/tails.  I see in your header you use Thundebird 17 as I do.  Did
you notice my formatting of top output wasn't wrapped?  To fix the
wrapping, after you paste it into the compose windows, select it all,
then click Edit-->Rewrap.  And you get this:

Cpu0 : 1.1%us, 0.5%sy, 1.8%ni, 96.5%id, 0.1%wa, 0.0%hi, 0.0%si, 0.0%st
Cpu1 : 1.1%us, 0.5%sy, 2.2%ni, 96.1%id, 0.1%wa, 0.0%hi, 0.0%si, 0.0%st

instead of this:

Cpu0  :  1.1%us,  0.5%sy,  1.8%ni, 96.5%id,  0.1%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu1  :  1.1%us,  0.5%sy,  2.2%ni, 96.1%id,  0.1%wa,  0.0%hi,  0.0%si,
0.0%st

> There was more, very similar figures... apart from the second sample
> above, there was never a single Cpu with close to 0% Idle, and I'm
> assuming the %CPU in wa state is basically "idle" waiting for the disk
> or something else to happen rather than the CPU actually being busy...

We're looking for a pegged CPU, not idle ones.  Most will be idle, or
should be idle, as this is a block IO server.  And yes, %wa means the
CPU is waiting on an IO device.  With 5 very fast SSDs in RAID5, we
shouldn't be seeing much %wa.  And during a sustained streaming write, I
would expect to see one CPU core pegged at 99% for the duration of the
FIO run, or close to it.  This will be the one running the mdraid5 write
thread.  If we see something other than this, such as heavy %wa, that
may mean there's something wrong elsewhere in the system, either
kernel/parm, or hardware.

>> (If you have hyperthreading enabled, reboot and disable it.  It normally
>> decreases thread performance due to scheduling and context switching
>> overhead, among other things.  Not to mention it makes determining
>> actual CPU load more difficult.  In this exercise you'll needlessly have
>> twice as many lines of output to comb through.)
> 
> I'll have to go in after hours to do that. Hopefully over the weekend
> (BIOS setting and no remote KVM)... Can re-supply the results after that
> if you think it will make a difference.

FYI for future Linux server deployments, it's very rare that a server
workload will run better with HT enabled.  In fact they most often
perform quite a bit worse with HT enabled.  The ones that may perform
better are those such as IMAP servers with hundreds or thousands of user
processes, most sitting idle, or blocking on IO.  For a block IO server
with very few active processes, and processes that need all possible CPU
bandwidth for short intervals (mdraid5 write thread), HT reduces CPU
bandwidth due to switching between two hardware threads on one core.

Note that Intel abandoned HT with the 'core' series of CPUs, and
reintroduced it with the Nehalem series.  AMD has never implemented HT
(SMT) it its CPUs.  And if you recall Opterons beat the stuffing out of
Xeons for many, many years.

>> Again, these numbers assume the low write performance is due to thread
>> starvation.
> 
> I don't think it is from my measurements...

It may not be but it's too early to tell.  After we have some readable
output we'll be able to discern more.  It may simply be that you're
re-writing the same small 15GB section of the SSDs, causing massive
garbage collection, which in turn causes serious IO delays.  This is one
of the big downsides to using SSDs as SAN storage and carving it up into
small chunks.  The more you write large amounts to small sections, the
more GC kicks in to do wear leveling.  With rust you can overwrite the
same section of a platter all day long and the performance doesn't change.

>> The downside for both:  Neither of these configurations can be expanded
>> with a reshape and thus drives cannot be added.  That can be achieved by
>> using a linear layer atop these RAID0 devices, and adding new md devices
>> to the linear array later.  With this you don't get automatic even
>> distribution of IO for the linear array, but only for the constituent
>> striped arrays.  This isn't a bad tradeoff when IO flow analysis and
>> architectural planning are performed before a system is deployed.
> 
> I'll disable the hyperthreading, and re-test afterwards, but I'm not
> sure that will produce much of a result. 

Whatever the resulting data, it should help point us to the cause of the
write performance problem, whether it's CPU starvation of the md write
thread, or something else such as high IO latency due to something like
I described above, or something else entirely, maybe the FIO testing
itself.  We know from other peoples' published results that these Intel
520s SSDs are capable of seq write performance of 500MB/s with a queue
depth greater than 2.  You're achieving full read bandwidth, but only
1/3rd the write bandwidth.  Work with me and we'll get it figured out.

> Let me know if you think I
> should run any other tests to track it down...

Can't think of any at this point.  Any further testing will depend on
the results of good top output from the next FIO run.  Were you able to
get all the SSD partitions starting at a sector evenly divisible by 512
bytes yet?  That may be of more benefit than any other change.  Other
than testing on something larger than a 15GB LV.

> One thing I can see is a large number of interrupts and context switches
> which looks like it happened at the same time as a backup run. Perhaps I
> am getting too many interrrupts on the network cards or the SATA controller?

If cpu0 isn't peaked your interrupt load isn't too high.  Regardless,
installing irqbalance is a good idea for a multicore iSCSI server with 2
quad port NICs and a high IOPS SAS controller with SSDs attached.  This
system is the poster boy for irqbalance.  As the name implies, the
irqbalance daemon spreads the interrupt load across many cores.  Intel
systems by default route all interrupts to core0.  The 0.56 version in
Squeeze I believe does static IRQ routing, each device's (HBA)
interrupts are routed to a specific core based on discovery.  So, say,
LSI routes to core1, NIC1 to core2, NIC2 to core 3.  So you won't get an
even spread, but at least core0 is no longer handling the entire
interrupt load.  Wheezy ships with 1.0.3 which does dynamic routing, so
on heavily loaded systems (this one is actually not) the spread is much
more even.

WRT context switches, you'll notice this drop substantially after
disabling HT.  And if you think this value is high, compare it to one of
the Terminal Services Xen boxen.  Busy hypervisors and terminal servers
generate the most CS/s of any platform, by far, and you've got both on a
single box.

-- 
Stan

