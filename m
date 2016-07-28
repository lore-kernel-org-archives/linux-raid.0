From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: RAID5 Performance
Date: Thu, 28 Jul 2016 13:19:25 +0100
Message-ID: <22425.63565.439521.592849@tree.ty.sabi.co.uk>
References: <7b7d730f-2951-ba5f-7f6b-33624b59a02d@websitemanagers.com.au>
	<22424.50313.900162.715200@tree.ty.sabi.co.uk>
	<CAFx4rwSRYDACX631eLpX7Jr9jB2u4jbC7dr-0rdi9U1nV9og3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFx4rwSRYDACX631eLpX7Jr9jB2u4jbC7dr-0rdi9U1nV9og3Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

>> A very brave configuration, a shining example of the
>> "syntactic" mindset, according to which any arbitrary
>> combination of legitimate features must be fine :-).

> While you may say that this configuration is very "brave", it
> is actually quite common for VDI "appliance" deployments. [
> ... ]

There are a lot of very "brave" sysadms out there, and often I
have to clean up after them :-).

But then I am one of those boring people who think that =ABVDI
"appliance" deployments=BB are usually a phenomenally bad idea, as
it requires a storage layer that has to cover all possible IO
workloads optimally, as indeed in:

  > [ ... ] The expectation, in terms of performance for VDI is
  > quite high.  vmWare like to say you can get away with 8-12
  > IOPS per virtual. Most people think you only get good
  > performance with 100 IOPS per virtual. [ ... ]

Those 100 random IOPS per VM are a bit "random", but roughly
translate to one "disk arm" per VM, which is not necessarily
enough: http://www.sabi.co.uk/blog/15-one.html#150305

[ ... ]

>> The queue sizes and waiting time on the second server are
>> very low (on a somewhat similar system using 4TB disks I see
>> waiting times in the 1-5 seconds range, not milliseconds).

> The expectation, in terms of performance for VDI is quite high.
> [ ... ]

Sure, but the point here as to the speed issue is not that the
SSDs are overwhelmed with IO, as the traffic on them is low and
has relatively low latency, it is that very few IOPS are getting
retired.

>> Thus the most likely issue here is the 'fsync' problem: for
>> "consumerish" SSDs barrier-writes are synchronous, because
>> they don't have a battery/capacitor-backed cache, and rather
>> slow for small writes, because of the large size of erase
>> blocks, which can be mitigated with higher over-provisioning.

> On many consumer SSDs, barrier writes are only barriers, and
> are not syncs at all. You are guaranteed serialization but not
> actual storage.

Probably in this case that is irrelevant, because the numbers
coming out from both the OP's experience and the tests in the
links I mentioned show that small sync writes seem synchronous
indeed for the 520/530, resulting in small write rates of around
1-5 MB/s, which matches the reported stats.

> Then again, in a server setup, especially with redundant power
> supplies, power loss to the SSDs is rare. You are more
> protecting against system hangs and other inter-connectivity
> issues.

That is also likely irrelevant here. The firmware in the flash
SSD does not know about the system setup, and the DRBD is
probably configured to request synchronous writes on the
secondary with protocol "C".

BTW I don't know whether the process(es) writing to the DRBD
primary also request synchronous writes, but that's hopefully the
case too, if the VD layer has been configured properly.

> The real system solution is to have some quantity of non
> volatile DRAM that you can stage writes (either a PCI-e card
> like a FlashTec or one or more nvDIMMs).

If this were the case then the VD layer and the DRBD layer could
be told not to use sync writes, but the numbers reported seem to
indicate that sync writes are happening.

> This is how the "major vendors" deal with sync writes.

At the system level, but at the device level the "major vendors"
put a large capacitor in "enterprise" SSDs for two reasons, one
of them to allow the persistence of the RAM write buffer, to
minimize write amplification and erase latency (the other is not
relevant here).

[ ... ]

>> * Small writes are a very challenging workload for flash SSDs
>>   without battery/capacitor-backed caches.

> Even with battery backup, small writes create garbage
> collection, so while batteries may give you some short term
> bursts,

That problem is mitigated with bigger overprovisioning in
"enterprise" class flash SSDs. It can also be done in those of
the "consumerish" class by partitioning them appropriately, or
with 'hdparm -N'; but that does not seem to be the case here,
becase the reported stats show a small number of IOPS with lowish
queues sizes and not that huge latencies.

> longer term, you still have to do the writes.

Unfortunately flash SSDs don't merely have to "do the writes",
as things are quite different: as I mentioned above the issue is
the large erase blocks (and the several milliseconds it takes to
erase one).

In the absence of power backing for the write cache, every sync
write, for example a 4KiB one, is (usually) stored immediately to
a flash chip, which means (usually) a lot of write amplification
because of RMW on the 8MiB (or larger) erase block plus the large
latency (often near 10 milliseconds) of the erase operation
before erase block programming.

That largely explains why in the tests I have mentioned small
sync write IOPS for many "consumerish" flash SSDs top at around
100, instead of the usual > 10,000 for small non-sync writes.

Some flash SSDs use an additional SLC buffer with smaller erase
blocks and lower latency to reduce the problem with flushing sync
writes directly to MLC etc, and that may explain why the 520s are
better than the 530s (if the 520s have an SLC buffer, but IIRC
intel started using an SLC buffer with the 540 series).

=46lash SSDs have only been popular for around 5 years, so it is
understandable that some important aspects of their performance
envelope (like what may happen on sync writes) is not well known
yet.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
