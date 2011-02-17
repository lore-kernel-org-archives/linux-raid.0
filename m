From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: raid5/raid6 write performance question
Date: Thu, 17 Feb 2011 21:13:00 +0100
Message-ID: <20110217201300.GC3296@lazy.lzy>
References: <AANLkTinRCMJq3bt5jmQfJ1PRfN1S-ZoJB0HXeMzFeqSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinRCMJq3bt5jmQfJ1PRfN1S-ZoJB0HXeMzFeqSA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 17, 2011 at 10:52:07AM -0800, Patrick J. LoPresti wrote:
> I have a fair amount of experience with hardware RAID devices, but now
> I am investigating Linux software RAID and I have a question.  Well, a
> few questions.
> 
> The classic problem for RAID5/RAID6 write performance, especially when
> striping across many drives, is that a single small write requires
> reading in the entire stripe from all disks to calculate the new
> syndrome block(s).
> 
> Hardware RAID controllers typically mitigate this problem by using a
> sizable (512MiB - 4GiB) non-volatile write-back cache, in the hopes
> that enough blocks will be written in a short period of time to
> populate an entire stripe.  Once an entire stripe is in the write-back
> cache, it can be written out with its syndrome blocks without having
> to read anything.
> 
> Of course, the cache has to be non-volatile (battery backed or solid
> state), because the kernel is expecting stuff it has written to disk
> not to vanish because of a power failure.
> 
> My question is this:  How does Linux RAID5/RAID6 avoid reading an
> entire stripe every time the kernel flushes a single page?  Does it
> have a (volatile?) cache?  Or does it rely on the kernel flushing lots
> of contiguous data in a single request?  Or something else?

This one I know... :-)
There is a cache (volatile, since it is in system RAM), which
can be tuned via sysfs.

I've an i7 xeon with 12GiB RAM, 4 HDDs RAID-5  and I set the
cache to 6GiB. This is dynamically allocated, so it uses RAM
only when needed.
Some benchmarks show that you can achieve the full 3 HDDs
speed in small data writes and sustained write.

I must say I was really impressed by the difference in
writing performances after increasing the cache, not only
in the benchmark world, but also with some I/O intensive
applications.

It made me rethink about the "quality" of the benchmarks
you can find around: it seems nobody understood this
capability of md.

Of course, in case of power failure, without UPS, you
risk a lot. Nevertheless, it depends on what are the
overall requirements, I guess.

> Does Linux RAID keep track of which disk blocks have already been
> written at least once, so that there is a difference between writing a
> block for the first time and updating it later?  (But I guess that
> would not make sense, since eventually all writes become updates as
> files are created and deleted.)

This one I do not know... :-)

bye,

-- 

piergiorgio
