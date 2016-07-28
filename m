From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID5 Performance
Date: Thu, 28 Jul 2016 23:50:06 +1000
Message-ID: <6a7aac82-9f82-3037-28ed-4e4ecea5cd6a@websitemanagers.com.au>
References: <7b7d730f-2951-ba5f-7f6b-33624b59a02d@websitemanagers.com.au>
 <22424.50313.900162.715200@tree.ty.sabi.co.uk>
 <CAFx4rwSRYDACX631eLpX7Jr9jB2u4jbC7dr-0rdi9U1nV9og3Q@mail.gmail.com>
 <22425.63565.439521.592849@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22425.63565.439521.592849@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 28/07/2016 22:19, Peter Grandi wrote:
> [ ... ]
>
>>> A very brave configuration, a shining example of the
>>> "syntactic" mindset, according to which any arbitrary
>>> combination of legitimate features must be fine :-).
>> While you may say that this configuration is very "brave", it
>> is actually quite common for VDI "appliance" deployments. [
>> ... ]
> There are a lot of very "brave" sysadms out there, and often I
> have to clean up after them :-).
>
> But then I am one of those boring people who think that =ABVDI
> "appliance" deployments=BB are usually a phenomenally bad idea, as
> it requires a storage layer that has to cover all possible IO
> workloads optimally, as indeed in:
Could I ask what you would "clean up" in the above system? What layers=20
would you remove/simplify?
At it's simplest, this system should be able to export a block of disk=20
space which the remote machine can present as a block device to the VM=20
(using Xen). Keep in mind there are actually multiple of these remote=20
machines. The method I've chosen is re-written here:
8 x 480GB Intel SSD (mix of 520 and 530 models)
Linux MD RAID5
LVM2
DRBD (takes an LV from each san and joins it together)
iSCSI (exports the block device to the 10Gbps network)
iSCSI (imported to the remove machine 2 x 1Gbps network)
multipathd (join the two iSCSI connections together)
Xen

Also, the two san machines have a second 10Gbps connection directly=20
between them.

Originally I had DRBD below LVM, but the folks at linbit switched those=
=20
two around to improve DRBD performance (multiple smaller DRBD devices i=
s=20
better than one large, this might have changed since that happened=20
around 3 years ago).
>    > [ ... ] The expectation, in terms of performance for VDI is
>    > quite high.  vmWare like to say you can get away with 8-12
>    > IOPS per virtual. Most people think you only get good
>    > performance with 100 IOPS per virtual. [ ... ]
>
> Those 100 random IOPS per VM are a bit "random", but roughly
> translate to one "disk arm" per VM, which is not necessarily
> enough: http://www.sabi.co.uk/blog/15-one.html#150305
>
> [ ... ]
>
>>> The queue sizes and waiting time on the second server are
>>> very low (on a somewhat similar system using 4TB disks I see
>>> waiting times in the 1-5 seconds range, not milliseconds).
>> The expectation, in terms of performance for VDI is quite high.
>> [ ... ]
> Sure, but the point here as to the speed issue is not that the
> SSDs are overwhelmed with IO, as the traffic on them is low and
> has relatively low latency, it is that very few IOPS are getting
> retired.
>
Previously when I was doing lots of tests on the system, I found I coul=
d=20
get great IO using larger block sizes, up to 2.5GB/s read and 1.5GB/s w=
rite.
Eventually, I found that using more real-world sized blocks, eg, 1k to=20
4k, I got abysmal transfer rates.

>>> Thus the most likely issue here is the 'fsync' problem: for
>>> "consumerish" SSDs barrier-writes are synchronous, because
>>> they don't have a battery/capacitor-backed cache, and rather
>>> slow for small writes, because of the large size of erase
>>> blocks, which can be mitigated with higher over-provisioning.
>> On many consumer SSDs, barrier writes are only barriers, and
>> are not syncs at all. You are guaranteed serialization but not
>> actual storage.
> Probably in this case that is irrelevant, because the numbers
> coming out from both the OP's experience and the tests in the
> links I mentioned show that small sync writes seem synchronous
> indeed for the 520/530, resulting in small write rates of around
> 1-5 MB/s, which matches the reported stats.
>
>> Then again, in a server setup, especially with redundant power
>> supplies, power loss to the SSDs is rare. You are more
>> protecting against system hangs and other inter-connectivity
>> issues.
> That is also likely irrelevant here. The firmware in the flash
> SSD does not know about the system setup, and the DRBD is
> probably configured to request synchronous writes on the
> secondary with protocol "C".
Yep, using protocol C at the moment.
> BTW I don't know whether the process(es) writing to the DRBD
> primary also request synchronous writes, but that's hopefully the
> case too, if the VD layer has been configured properly.
>
>> The real system solution is to have some quantity of non
>> volatile DRAM that you can stage writes (either a PCI-e card
>> like a FlashTec or one or more nvDIMMs).
> If this were the case then the VD layer and the DRBD layer could
> be told not to use sync writes, but the numbers reported seem to
> indicate that sync writes are happening.
>
>> This is how the "major vendors" deal with sync writes.
> At the system level, but at the device level the "major vendors"
> put a large capacitor in "enterprise" SSDs for two reasons, one
> of them to allow the persistence of the RAM write buffer, to
> minimize write amplification and erase latency (the other is not
> relevant here).
>
> [ ... ]
>
>>> * Small writes are a very challenging workload for flash SSDs
>>>    without battery/capacitor-backed caches.
>> Even with battery backup, small writes create garbage
>> collection, so while batteries may give you some short term
>> bursts,
> That problem is mitigated with bigger overprovisioning in
> "enterprise" class flash SSDs. It can also be done in those of
> the "consumerish" class by partitioning them appropriately, or
> with 'hdparm -N'; but that does not seem to be the case here,
> becase the reported stats show a small number of IOPS with lowish
> queues sizes and not that huge latencies.
Can you advise what numbers I should look for, or worry about, which=20
would indicate that the problem is (or isn't) a erase cycle delay probl=
em?
>> longer term, you still have to do the writes.
> Unfortunately flash SSDs don't merely have to "do the writes",
> as things are quite different: as I mentioned above the issue is
> the large erase blocks (and the several milliseconds it takes to
> erase one).
>
> In the absence of power backing for the write cache, every sync
> write, for example a 4KiB one, is (usually) stored immediately to
> a flash chip, which means (usually) a lot of write amplification
> because of RMW on the 8MiB (or larger) erase block plus the large
> latency (often near 10 milliseconds) of the erase operation
> before erase block programming.
>
> That largely explains why in the tests I have mentioned small
> sync write IOPS for many "consumerish" flash SSDs top at around
> 100, instead of the usual > 10,000 for small non-sync writes.
>
> Some flash SSDs use an additional SLC buffer with smaller erase
> blocks and lower latency to reduce the problem with flushing sync
> writes directly to MLC etc, and that may explain why the 520s are
> better than the 530s (if the 520s have an SLC buffer, but IIRC
> intel started using an SLC buffer with the 540 series).
I can see the 545s series performs similar (or better, can't tell yet)=20
than the 520 series, but certainly it is better than the 530.
>
> Flash SSDs have only been popular for around 5 years, so it is
> understandable that some important aspects of their performance
> envelope (like what may happen on sync writes) is not well known
> yet.
>
Thank you, I appreciate all the responses.

So far, I've decided to make the following two changes:
1) Replace all 16 existing SSD's with the 1000GB 545s model, this will=20
double the capacity, and remove any of the 530 model drives. My concern=
=20
was (and is) that making actual use of this double capacity with the=20
same performance per drive will in effect halve the performance. I will=
=20
be able to leave 40G per drive un-partitioned, or partitioned and left=20
blank whichever is better.... Not sure if 40G per drive is enough to=20
help with the write/erase problem, but I guess it should be better than=
=20
nothing.
I think this change will produce a 40% improvement (potentially, given=20
the 520 drives are at 40% while the 530 is at 100%)

2) Upgrade to Linux kernel 4.6 from debian backports.
I think this change will give approx 30% improvement, because it will=20
reduce reads by 4 for each write, but a read is quicker than a write, s=
o=20
I'm hoping for 30% overall. It sounds like the performance should be=20
somewhere between current and RAID10.

With the above two improvements, I'm hoping it will be enough to solve=20
the problem.

At this stage, if it is not enough to solve the problem, my fall-back=20
option is to convert to RAID10 but it's something I'd prefer to avoid=20
based on cost, storage capacity, and the fact it is difficult to expand=
=20
the existing system past 8 drives (hence capacity)...

I'm not convinced that changing chunk size will offer any benefit=20
(positive or negative), so will likely leave that as it is (64k chunk s=
ize).

Regards,
Adam
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
