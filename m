From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: raid10 vs raid5 - strange performance
Date: Sun, 30 Mar 2008 12:16:59 +0100
Message-ID: <18415.30379.492224.350276@tree.ty.sabi.co.uk>
References: <bb145bd20803251433q1018703cva56ea20e9bedf3c6@mail.gmail.com>
	<20080325233649.GA632@rap.rap.dk>
	<bb145bd20803251837x7ef1fa9dk6191fcaea7b02144@mail.gmail.com>
	<20080326072416.GA8674@rap.rap.dk>
	<bb145bd20803261016t351e4b98rb8989cc6c849108f@mail.gmail.com>
	<20080326192935.GB18621@rap.rap.dk>
	<47EAACAB.7070203@tmr.com>
	<bb145bd20803261902g44e88f64p982607b88d864678@mail.gmail.com>
	<47EEA5BB.5080106@tmr.com>
	<20080330085528.GC17756@rap.rap.dk>
	<20080330093420.GB21050@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080330093420.GB21050@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

>>> The md raid10,f2 generally has modest write performance, if
>>> U is a single drive speed, write might range between 1.5U to
>>> (N-1)/2*U depending on tuning. Read speed is almost always
>>> (N-1)*U, which is great for many applications. Playing with
>>> chunk size, chunk buffers, etc, can make a large difference
>>> in write performance.

>> Hmm, I have other formulae for this. raid10,f2 write speed
>> would rather be U*N/2, and read speed be U*N - possibly
>> enhanced by also having bigger chunks than on a regular
>> non-raid disk, and enhanced by lower access times. The
>> formulae are both for sequential and random reads.

Well, that's very optimistic, because writing to different
halves of disks in a staggered way has two impacts.

For example as you say here to bottom "mirror" half of each disk
can be rather slower than the outer "read" half:

> And also faster transfer rates due to using the outer tracks
> of the disk. This factor could amount to up to a factor of 2
> when reading from the high end of the array vs reading from
> the high end of the bare disk.

But then for writing on RAID10 f2 writing to an outer and inner
half only reduces a little the surface write speed *across the
RAID10*: in RAID10 n2 write speed goes from say mx(80,80)MB/s to
max(40,40)MB/s as one writes each disk top to bottom, with an
average of 60MB/s, but on RAID10 f2 it goes from max(80,60)MB/s
to max(60,40)MB/s, or average 50MB/s.

In other words if one looks at the longitudinal (sequential)
speed, RAID10 f2 read speed is that of the first half, as you
write, but write speed is limited to that of the second half
(because in writing to both halves on must wait for both writes
to complete).

But write speed is not just longitudinal speed, and things get
complicated because of the different latitudes of writing,
involving seeking between inner and outer half on long writes.

RAID10 f2 in effect means "mirror the upper half of a disk onto
the lower half of the next disk".

Suppose then a write to chunk 0 and all disks are 250MB ones,
are at rest and their arms are on cylinder 0: the sequence of
block writes that make up the chunk write goes to both the upper
half of the first disk and to the lower half of the second disk
nearly simultaneously, and total time is

  max(
    (rotational latency+write 1 chunk at 80MB/s),
    (seek to cylinder 15200 + (rotational latency+write 1 chunk at 60MB/s))
  )

But now suppose that you are writing *two* chunks back-to-back,
the queue of requests on the first 3 disks will be:

   first:	write chunk 0 to cylinder 0

   second:	write chunk 0 to cylinder 15200
		write chunk 1 to cylinder 0

   third:	write chunk 1 to cylinder 15200

There is latitudinal interference between writing a mirror copy
of chunk 0 to the lower half of the second disk and the writing
immediately afterwards of the first copy of chunk 1 to the upper
half of the same disk.

Of course if you write many chunks, the situation that happens
here on the second disk will happen on all disks, and all disks
will be writing to some cylinder in the second half of each disk
and to 15200 cylinders above that.

The cost of each seek and how many seeks depend on the disk and
chuink size (as pointed out in the quote above) and how fast
write requests are issued and the interaction with the elevator;
for example I'd guess that 'anticipatory' is good with RAID10
f2, but given the unpleasant surprises with the rather demented
(to use a euphemism) queueing logic within Linux that would have
to be confirmed.
