From: Joseph Glanville <joseph.glanville@orionvm.com.au>
Subject: Re: RAID performance - new kernel results - 5x SSD RAID5
Date: Thu, 21 Feb 2013 19:47:53 +1100
Message-ID: <CAOzFzEhepU8HtbEALZDWTFmBC0v-Mx1K7nmXquOWnLHQU6CHWQ@mail.gmail.com>
References: <51134E43.7090508@websitemanagers.com.au>
	<CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com>
	<51137FB8.6060003@websitemanagers.com.au>
	<CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com>
	<5113A2D6.20104@websitemanagers.com.au>
	<CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com>
	<51150475.2020803@websitemanagers.com.au>
	<5120A84E.4020702@websitemanagers.com.au>
	<51222A81.9080600@hardwarefreak.com>
	<51250377.509@websitemanagers.com.au>
	<5125B8E5.5000502@hardwarefreak.com>
	<5125C154.3090603@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5125C154.3090603@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: stan@hardwarefreak.com, Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21 February 2013 17:40, Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:
> On 21/02/13 17:04, Stan Hoeppner wrote:
>> Simply reading 'man top' tells you that hitting 'w' writes the change.
>> As you didn't have the per CPU top layout previously, I can only assume
>> you don't use top very often, if at all.  top is a fantastic diagnostic
>> tool when used properly.  Learn it, live it, love it. ;)
>
> haha, yes, I do use top a lot, but I guess I've never learned it very
> well. Everything I know about linux has been self-learned, and I guess
> until I have a problem, or a need, then I don't tend to learn about it.
> I've mostly worked for ISP's as linux sysadmin for the past 16 years or
> so....
>
>>> Output is as follows:
>> With HT, this output for 8 "cpus" and line wrapping, it's hard to make
>> heads/tails.  I see in your header you use Thundebird 17 as I do.  Did
>> you notice my formatting of top output wasn't wrapped?  To fix the
>> wrapping, after you paste it into the compose windows, select it all,
>> then click Edit-->Rewrap.  And you get this:
>
> Funny, I never thought to use that feature like that. For me, I only
> ever used it to help line wrap really long lines that were quoted from
> someone else email. Didn't know it could make my lines longer (without
> manually adjusting the global linewrap character count). Thanks for
> another useful tip :)
>
> I'll repost numbers after I disable HT, no point right now.
>
>> We're looking for a pegged CPU, not idle ones.  Most will be idle, or
>> should be idle, as this is a block IO server.  And yes, %wa means the
>> CPU is waiting on an IO device.  With 5 very fast SSDs in RAID5, we
>> shouldn't be seeing much %wa.  And during a sustained streaming write, I
>> would expect to see one CPU core pegged at 99% for the duration of the
>> FIO run, or close to it.  This will be the one running the mdraid5 write
>> thread.  If we see something other than this, such as heavy %wa, that
>> may mean there's something wrong elsewhere in the system, either
>> kernel/parm, or hardware.
>
> Yes, I'm quite sure that there was no CPU with close to 0% idle (or
> 100%sy) for the duration of the test. In any case, I'll re-run the test
> and advise in a few days.
>
>> FYI for future Linux server deployments, it's very rare that a server
>> workload will run better with HT enabled.  In fact they most often
>> perform quite a bit worse with HT enabled.  The ones that may perform
>> better are those such as IMAP servers with hundreds or thousands of user
>> processes, most sitting idle, or blocking on IO.  For a block IO server
>> with very few active processes, and processes that need all possible CPU
>> bandwidth for short intervals (mdraid5 write thread), HT reduces CPU
>> bandwidth due to switching between two hardware threads on one core.
>>
>> Note that Intel abandoned HT with the 'core' series of CPUs, and
>> reintroduced it with the Nehalem series.  AMD has never implemented HT
>> (SMT) it its CPUs.  And if you recall Opterons beat the stuffing out of
>> Xeons for many, many years.
>
> Yes, and I truly loved telling customers that AMD CPU's were both
> cheaper AND better performing. Those were amazing days for AMD. To be
> honest, I don't read enough about CPU's anymore, but my understanding is
> that AMD are a little behind on the performance curve, but not far
> enough that I wouldn't want to use them....
>
>>> I don't think it is from my measurements...
>>
>> It may not be but it's too early to tell.  After we have some readable
>> output we'll be able to discern more.  It may simply be that you're
>> re-writing the same small 15GB section of the SSDs, causing massive
>> garbage collection, which in turn causes serious IO delays.  This is one
>> of the big downsides to using SSDs as SAN storage and carving it up into
>> small chunks.  The more you write large amounts to small sections, the
>> more GC kicks in to do wear leveling.  With rust you can overwrite the
>> same section of a platter all day long and the performance doesn't change.
>
> True, I can allocate a larger LV for testing (I think I have around 500G
> free at the moment, just let me know what size I should allocate/etc...)
>
>> Whatever the resulting data, it should help point us to the cause of the
>> write performance problem, whether it's CPU starvation of the md write
>> thread, or something else such as high IO latency due to something like
>> I described above, or something else entirely, maybe the FIO testing
>> itself.  We know from other peoples' published results that these Intel
>> 520s SSDs are capable of seq write performance of 500MB/s with a queue
>> depth greater than 2.  You're achieving full read bandwidth, but only
>> 1/3rd the write bandwidth.  Work with me and we'll get it figured out.
>
> Sounds good, thanks.
>
>>> Let me know if you think I
>>> should run any other tests to track it down...
>>
>> Can't think of any at this point.  Any further testing will depend on
>> the results of good top output from the next FIO run.  Were you able to
>> get all the SSD partitions starting at a sector evenly divisible by 512
>> bytes yet?  That may be of more benefit than any other change.  Other
>> than testing on something larger than a 15GB LV.
>
> All drives now look like this (fdisk -ul)
> Disk /dev/sdb: 480 GB, 480101368320 bytes
> 255 heads, 63 sectors/track, 58369 cylinders, total 937697985 sectors
> Units = sectors of 1 * 512 = 512 bytes
>
> Device Boot Start End Blocks Id System
> /dev/sdb1 64 931770000 465893001 fd Lnx RAID auto
> Warning: Partition 1 does not end on cylinder boundary.
>
> I think (from the list) that this should now be correct...
>
>>> One thing I can see is a large number of interrupts and context switches
>>> which looks like it happened at the same time as a backup run. Perhaps I
>>> am getting too many interrrupts on the network cards or the SATA controller?
>>
>> If cpu0 isn't peaked your interrupt load isn't too high.  Regardless,
>> installing irqbalance is a good idea for a multicore iSCSI server with 2
>> quad port NICs and a high IOPS SAS controller with SSDs attached.  This
>> system is the poster boy for irqbalance.  As the name implies, the
>> irqbalance daemon spreads the interrupt load across many cores.  Intel
>> systems by default route all interrupts to core0.  The 0.56 version in
>> Squeeze I believe does static IRQ routing, each device's (HBA)
>> interrupts are routed to a specific core based on discovery.  So, say,
>> LSI routes to core1, NIC1 to core2, NIC2 to core 3.  So you won't get an
>> even spread, but at least core0 is no longer handling the entire
>> interrupt load.  Wheezy ships with 1.0.3 which does dynamic routing, so
>> on heavily loaded systems (this one is actually not) the spread is much
>> more even.
>
> OK, currently all IRQ's are on CPU0 (/proc/interrupts). I've installed
> irqbalance, and it has already started to spread interrupts across the
> CPU's. I am pretty sure I started doing some irq balancing a few months
> ago, but I was doing it manually, and set the onboard SATA to one CPU,
> each pair of ethernet ports to another, and everything else to the last.
> I tried to skip the HT CPU's. I think this is going to be a better
> solution, especially once I disable HT.
>
>> WRT context switches, you'll notice this drop substantially after
>> disabling HT.  And if you think this value is high, compare it to one of
>> the Terminal Services Xen boxen.  Busy hypervisors and terminal servers
>> generate the most CS/s of any platform, by far, and you've got both on a
>> single box.
>
> Speaking of which, I've found another few issues that are not related to
> the RAID write speed, but may be related to the end user experience.
>
> Tonight, I will increase each xen physical box from having 1 CPU pinned,
> to having 2 CPU's pinned.
>
> The Domain Controller/file server (windows 2000) is configured for 2
> vCPU, but is only using one since windows itself is not setup for
> multiple CPU's. I'll change the windows driver and in theory this should
> allow dual CPU support.
>
> Generally speaking, complaints have settled down, and I think most users
> are basically happy. I've still had a few users with "outlook crashing",
> and I've now seen that usually the PST file is corrupt. I'm hopeful that
> running the scanpst tool will fix the corruptions and stop the outlook
> crashes. In addition, I've found the user with the biggest complaints
> about performance has a 9GB pst file, so a little pruning will improve
> that I suspect.
>
> So, I think between the above couple of things, and all the other work
> already done, the customer is relatively comfortable (I won't say happy,
> but maybe if we can survive a few weeks without any disaster...).
> Personally, I'd like to improve the RAID performance, just because it
> should, but at least I can relax a little, and dedicate some time to
> other jobs, etc...
>
> So, summary:
> 1) Disable HT
> 2) Increase test LV to 100G
> 3) Re-run fio test
> 4) Re-collect CPU stats
>
> Sound good?
>
> Thanks,
> Adam
>
> --
> Adam Goryachev
> Website Managers
> www.websitemanagers.com.au
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Sorry to but in, but have you tried doing the tests beneath the DRBD layer?
DRBD is known for doing intersesting things to IOs and could be what
is now limiting performance.

I found when building fast SRP based SANs that using DRBD for
replication (even when not connected) dropped performance to less than
20% what the array is cappable of.
This may have changed since - I am talking a few years ago now when
DRBD was first merged into mainline.

It is safe to do reads on the raw md device as long as you don't have
fio configured to do writes you won't hurt anything.

Joseph.

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
