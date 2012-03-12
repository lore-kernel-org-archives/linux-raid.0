From: pg@lxra2.to.sabi.co.UK (Peter Grandi)
Subject: Re: Striping does not increase performance.
Date: Mon, 12 Mar 2012 14:33:41 +0000
Message-ID: <20318.2373.994959.666477@tree.ty.sabi.co.UK>
References: <CAKFseUN8-Rb1x5j-JM+q3CLEXnFO0ieAmBG_5tVcxu4NAz0ojA@mail.gmail.com>
	<20120312125720.GL4558@voyageur.mas.nom.fr>
	<CAKFseUO5CVHBLhcY19DWzqhf-Ebrn7c-=iwxANuRcqwTV0PyBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKFseUO5CVHBLhcY19DWzqhf-Ebrn7c-=iwxANuRcqwTV0PyBg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> The server is a 36 bay 3,5" supermicro chassis filled with
>>> 36x 2TB SATA 7200 RPM disks.
[ ... ]

>>> I used a bandwidth random read test I found on the Fusion IO
>>> website. after every test i ran: sync; echo 3 >/proc/sys/vm/drop_caches;

Given that the FIO parameters below specify O_DIRECT and cache
invalidation (which is itself redundant with O_DIRECT), 'sync' or
dropping caches are pointless. Which makes me suspect that you ar
eclear as to what you are measuring, or what you want to measure,
an impression very much reinforced by several other details.

But congratulations on choosing FIO, it is one of the few tools
that can, used advisedly, give somewhat relevant numbers.

>>> Once booted I created 3 raid6 MD devices of 10 disks each
>>> (16TB netto each) with 6 global hotspares in the same
>>> sparegroup.  All MD devices have a chunk size of 64KB
>>> fio --name=test1 --ioengine=sync --direct=1 --rw=randread --bs=1m
>>> --runtime=10 --filename=/dev/md0 --iodepth=1 --invalidate=1
>>> read : io=518144KB, bw=51726KB/s, iops=50 , runt= 10017msec

So you have a stripe size of 64KiB*8 => 512KiB. Each random read
takes 1 IOPS to position the heads, and then reads two stripes,
which involves at least one and perhaps two head alignment times
(probably 1/2 of full rotation).

So each random read in figures should cost about 10-15ms cylinder
positioning time plus 1MiB read off 8 disks each capable of
around 90MB/s each (average between inner and outer cylinders)
which is another 2ms plus around 1-2 times 1/2 rotational
latency, and that's probably another 2-3ms, for a total of around
15-20ms per transaction average.

Your results result seems pretty much in line with this, with
small variations.

You have just discovered that single threaded/depth random
transfers on a RAID set are not much faster than on a single
disk. :-)

[ ... ]

>>> For the next test I wanted to see if i could double the
>>> performance by striping an LV over 2 md's (so instead of
>>> using 10 disks/spindles, use 20 disks/spindles)

That's an astonishing expectation. It is hard to imagine for me
why reading that 1MiB twice as fast would give significantly
better "performance" (whatever you mean by that) when you have a
seek+align interval at the same frequency, and that's the
dominant cost.

[ ... ]

>>> fio --name=test3 --ioengine=sync --direct=1 --rw=randread --bs=1m
>>> --runtime=10 --filename=/dev/dm-0 --iodepth=1 --invalidate=1
>>> Now things are getting interesting:
>>> read : io=769024KB, bw=76849KB/s, iops=75 , runt= 10007msec
>>> Now the total IO's in 10 seconds are 16x larger than
>>> before. [ ... ]  The IO's per disk seem to be in 64KB blocks
>>> still only now with a large MERGE figure besides it.

That's not terribly interesting. It has second order effects, but
otherwise fairly irrelevant. You are doing O_DIRECT IO on the LV,
but then the DM layer can rearrange things. The disks can do IO
in 4KiB sectors only, and the alternative is between one command
with a count of N or N commands with a count of 1, and that's not
that big a difference. Also because SATA specifies a rather
primitive ability to queue commands.

>>>  Each disk now does around 60 IOPS!

Much the same as before in effect.

Please note that when people talk "IOPS" what they really mean is
"fully random IOPS", that is SEEKS. You can get a lot of IOPS
even on hard disks if they are sequential and short. What matters
is numbers of random seeks. Multiplying by N the "IOPS" by doing
transfers in 1/4 the size is insignificant.

[ ... various aother attempts ... ]

>>> 1) Am I overlooking/not understanding something obvious why I
>>> can't improve performance on the system?

What kind of "performance" do you expect? Your tests are almost
entirely dominated by single threaded synchronous seeks, and you
are getting more or less what the hw can deliver for those, with
small variations depending on layering of IO scheduling.

>>> 2) Why are the LVM tests performing better as opposed to
>>> only using MD(s)?

Slightly different scheduling as various layers rearrange the
flow and timing of requests.

>>> 3) Why is the performance in test3 split between the two PV's
>>> and not aggregated? Bottleneck somewhere, and if so how can I
>>> check which is it?

"Doctor, if I hammer a nail through my hand it hurts a lot"
"Don't do it" :-).

>>> 4) Why are the IO's suddenly split into 4KB blocks when using
>>> striping/raid0? All chunk/block/stripe sizes are 64KB.

IO layers can rearrange things as much as they please. Even
O_DIRECT really just means "no page cache", not "do physical IO
one-to-one with logical IO", even if currently under Linux it
usually implies that.

>>> 5) Any recommendations how to improve performance with this
>>> configuration and not limited at the performance of 10 disks?

Again, what does "performance" mean to you? For which workload
profile?

>> Please check alignement of each level of stockage. Because
>> this disk present to controller a block size of 512 bytes ,
>> but internal use a 4k block size.

That matters almost only for *writes*. Unaligned reads cost a lot
less, and on a 128KiB transaction size (two chunks on each disk)
the extra cost (two extra sector reads) should be unimportant.

> [ ... ] not use partitions on the drives so the whole disk
> /dev/sdb is used as md component device, i was in the
> understanding that if not using partitions the alignment is
> correct or am i wrong?

Not necessarily, but usually yes.
