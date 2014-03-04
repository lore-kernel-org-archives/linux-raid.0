From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: raid5 write latency is 10x the drive latency
Date: Tue, 4 Mar 2014 22:36:12 +0000
Message-ID: <21270.21852.212278.318577@tree.ty.sabi.co.uk>
References: <CAGRgLy55eAiam-JJFzUAZH581odHu8o9Pxt6y8jbcj92v+q6CQ@mail.gmail.com>
	<21268.65296.503057.601739@tree.ty.sabi.co.uk>
	<CAGRgLy542j-G2WAbRdqGf26xfnQ5wkCqnEmgPecHtEp-WpXOSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy542j-G2WAbRdqGf26xfnQ5wkCqnEmgPecHtEp-WpXOSA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>> Also what type of device? Which size of the stripe cache
>> (very important)?  Which chunk size? Which drive write cache
>> setting? Which use of barriers? Which filesystem? Which
>> elevator? Which flusher parameters? Which tool settings? How
>> many threads?

> As you probably know, each entry in the MD stripe cache is a
> kind of a mini-stripe of 4K blocks (this is what is called
> "struct stripe_head" in the code).

Agreed, and I have been calling them "stripelet".

So we both share the notion that a 64KiB*(4+1) stripe with a
data capacity of 256KiB is actually made of 16 "mini-stripes" or
"stripelets" of 4KiB*(4+1) "pages". I had asked a specific
question about this some time ago:

  http://sourceforge.net/p/jfs/mailman/message/27438194/

Now it is interesting to note that within a stripe, all
stripelets share the same parity device, but if a write crosses
stripes the parity devices are diffent.

> [ ... ] In my test, MD chunk size is 64K, so yes, it is needed
> to load more than one stripe-head each time. [ ... ]

> As for other parameters you mentioned, I can post all of them,
> but at this point, I only care how much write latency MD adds
> above the write latency that the drives demonstrate. I am not
> sure why you find this funny, BTW.

Because it is so amazingly (euphemism alert) optimistic.

You are wondering about latency, and you seem to consider
caching, barriers, elevator, flusher, etc. irrelevant to that
story, as if they did not have a massive and *variable* impact
on latency. MD RAID is in theory and in practice "just" an IO
remapper (and multiplexer), but the total latency you see is a
product of all the latencies of the components between program
and storage medium.

I have tried to give same very explicit hints as to how this
matters, pointing out very loudly that your overall results are
quite "unexpected":

>> Because some of the numbers look a bit amazing or strange:
>> 
>> * Only 20% of IOPS are reads, which is pretty miraculous.
>> [ ... ]
>> * Each drive delivers over 1,000 4kiB IOPS (mixed r/W), which is
>> also pretty miraculous if they are disk drives, and terrible if
>> they are flash drives.
>> [ ... ]
>> and the percent of reads goes down to 16.6% almost exactly.
>> These numbers tell a story, a pretty strong story.

The story the numbers tell you is: the throughput you are
getting is way too high for 8KiB random writes on a RAID5, and
the number of reads is way too low:

  If writing in each stripelet 2x 4kiB pages out of 4+1,
  the code has to write at least 2x data pages and a
  parity page, and to compute the new value of the parity
  page has two options:
    * read the other 2x data pages, compute new parity page
      from all 4x data pages.
    * read current parity page, the old contents of the 2x data
      pages, subtract them from the parity page.
  Either way it is 2x reads or 3x reads, every 3x writes.

Therefore *obviously* random IOPS are being turned into
sequential ones. We are seeing over 1,000 IOPS per member device
on a purely random test, and disk drives can do at best 100-150
random IOPS. You are not bothering to say what kind of devices
you are using, but it matters a great deal to understanding what
is going on to compare the IOPS observed with the peak ones the
devices are doing. it is amazingly (euphemism alert) optimistic
to assume that "details" like elevator, drive caching, type of
device etc. are irrelevant, because they don't add a *constant*
chunk of latency.

The *obvious* conclusion is that the whole IO subsystem is
trading *massively* latency for throughput. The page cache, the
elevator, the stripe cache, etc. are all there to try and turn
random RMW into sequential pure writes as much as possible.

>>> [ ... ] with RMW that raid5 is doing, we can expect 2x of the
>>> drive latency
>> 
>> HAHAHAHAHAHA! HAHAHAHAHAHAHAHAHA! You made my day.

>>> (1x to load the stipe-head, 1x to update the required
>>> stripe-head blocks on disk).
>> 
>> Amazing! Send patches! :-)

> I studied the raid5 code at some point,

That's irrelevant without a realistic insight on what *must* be
going on.

> and here is the flow for writing a 4Kb block onto a 2+1 raid5
> with 4K chunk size:

That's a bit of a different case and is irrelevant.

> So besides loaing and writing out the stripe-head, there is
> only the parity calculation, which I don't know at this point
> how much time does it take. (In my test, the CPU had a good
> amount of idle time, BTW). Do you agree that this is the flow?
> Or you see some other places, where millis can be spent, which
> I missed?

>>> raid5d thread is busy updating the bitmap
>> 
>> Using a bitmap and worrying about write latency, I had not even
>> thought about that as a possibility. Extremely funny!

> Can you please clarify what to do you find so funny here?

That's so extremely funny I must be disturbing the neighbours
with my guffaws...

The analysis above is based on the peculiar assumption that MD
RAID5 is a "pure" IO remapper and multiplexer, and indeed it is,
from the point of view of logic flow. But from the point of view
of *event* flow, of timing, MD RAID5 must be very careful indeed
to preserve proper semantics, and this means achieving something
like "transactions". This implies very subtle and very costly
(in terms of latency) ordering and locking of reads and writes.

Because MD RAID5 is reading and writing to several devices whose
content is changing all the time, with very different speeds,
and potential different failures, and must give programs the
illusion that they are dealing with a single device with
reliable, consistent behaviour. For example a request to MD can
only complete when all the sequence of transactions involved in
the request have completed, and this for example involves
careful locking and ordering of updates to the parity page, to
the bitmap (if present), to the event counter in the per-device
MD superblock. All those updates must happen in the right order,
without overlapping with those from other transactions, and they
must all complete before an MD write can be considered complete.
Never mind that the current position (seek arm for disks) on
each device could be completely different, and the efforts of
the elevator are extremely time dependent and also massively
skew latency.

RAID5 does not just turn a logical request into a few device
requests and then returns "done"!

Never mind for example the effects using a filesystem type with
a journal, and the type of journal matters a great deal too.

> Should I not use the bitmap?

That is a tradeoff. using the bitmap as your numbers show has
two effects:

* IO patterns on the storage devices become significantly more
  random (if the bitmap is 'internal').
* All MD updates must wait for completion of the bitmap update
  before returning.

Is that worth the faster reconstruction? You choose.

>>> commented out the bitmap_unplug call
>> 
>> Ah plugging/unplugging one of the great examples of sheer
>> "genius" in the Linux code. We can learn a lot from it :-).

> Again, can you please clarify?

Plugging/unplugging is a sheer "genius" idea, aimed at trading
latency for throughput, in a very "genius" way. Nothing to do
with your troubles, it was just an aside to try and give you yet
another massive hint about latency vs. throughput tradeoffs.

> I was only trying to see whether raid5d does some other
> blocking operation, besides the bitmap update, and I learned
> that it doesn't.

Those 'R5_LOCKED' flags must not be present in the version of
code you have seen. There are many hints on how complicated
ordering and locking of RAID5 operations in:

  http://lxr.free-electrons.com/source/drivers/md/raid5.h

The section "Plugging:" (line 343) seems also pretty explicit.
etc. etc. But looking at the code is a bit blind...

> I realize that the bitmap update is required, just wanted to
> see if there is anything else that was blocking. Do you see
> anything wrong with this approach?

>>> Typically - without the bitmap update - raid5 call takes
>>> 400-500us, so I don't understand how the additional ~100ms
>>> of latency is gained

>> That's really really funny! Thanks! :-)

> Again, can you please clarify? I am happy to make your day,
> but if since you have taken time to comment on my email, I
> would like to at least understand what you meant.

Well, you seem to have tuned (by default or explicitly) your
whole IO subsystem to have as much latency as possible, for the
purpose of having higher throughput, and then you act surprised.

>> As to this, how are the 8KiB writes aligned? To 1KiB? 4KiB?
>> 8KiB? To something else?

> They were 4Kb aligned. Looking at the code, I don't think it
> matters much; if I had them them 8K aligned, it would still be
> required to load/update 2 stripe-heads for each write.

There is a small question of whether writes that cross stripe
boundaries are possible and/or frequent.

Also note that writing 8KiB within the same stripe means that
the two stripelets have the same parity drive, across stripes it
means different parity drives.

>> Is there any other activity on the same physical disks given
>> that the RAID members seem to be LVs?

> They are device-mapper devices (but not LVs),

An LV is just a device mapper device. LVM2 is just a frontend to
DM.

> and there was no other activity. The device-mappers lead to
> drives behind MegaRAID write-back caching. (Something tells me
> you will find this funny at best, [ ... ]

Uhmmmm, that is indeed (euphemism alert) not that awesome. More
caching, more strange things in the MegaRAID firmware...

> [ ... ] I am just trying to understand how much write latency
> MD can add on top of drives latencies).

HAHAHA HAHAHAHA. Indeed very funny. :-).

>> Also what's the size of those LV members of the MD set? It may
>> be quite small...

> Each one is 560GB. The whole MD usable space is ~2.2TB, so with a
> random workload over such huge capacity, MD stripe cache cannot help
> anyways.

But then how is it possible that you have such huge latencies
and such low read rates? You have reported 'iostat' output with
1 read every 5 writes, while I would expect 40%/60% or 50%/50%.

From a very similar test on a RAID5 I had created for fun, with
a tiny 'fio' test like this:

  bs=8k
  ioengine=libaio
  iodepth=4
  size=400g
  fsync=4
  runtime=60
  directory=/fs/tmp
  filename=FIO-TEST

  [rand-write]
  rw=randwrite
  stonewall</pre>

I see something like this:

  Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
  sdc2             45.00     6.00   20.00  111.00   260.00   452.00    10.87     1.22    9.34    4.20   10.27   2.32  30.40
  sdd2             48.00     8.00   29.00  117.00   308.00   500.00    11.07     1.34    9.15   12.55    8.31   2.82  41.20
  sde2             42.00     6.00   19.00  109.00   244.00   444.00    10.75     1.14    8.91    7.79    9.10   2.59  33.20
  sdf2             35.00     5.00   22.00  107.00   228.00   464.00    10.73     1.02    7.66    7.27    7.74   2.26  29.20
  sdg2             40.00     7.00   23.00  106.00   252.00   452.00    10.91     1.12    8.47    7.65    8.64   2.39  30.80
  md2               0.00     0.00    0.00  100.00     0.00  1344.00    26.88     0.00    0.00    0.00    0.00   0.00   0.00

Here the numbers are as expected: around 100-110 random IOPS per
device and a plausible ratio of reads to writes, plausible
transfer rates, with device latencies that look very much like
typical seek latencies, and MD latencies reported by 'fio'
between 20-50ms.

  Note: 7200RPM 1TB contemporary SATA drives, except for 'sdd2'
  which is a bit slower, IIRC default MD stripe cache, much
  tigther than default flusher parameters, 'deadline' elevator,
  barriers, ...).
