From: David Brown <david@westcontrol.com>
Subject: Re: raid5/raid6 write performance question
Date: Fri, 18 Feb 2011 10:56:34 +0100
Message-ID: <ijlfpe$ief$1@dough.gmane.org>
References: <AANLkTinRCMJq3bt5jmQfJ1PRfN1S-ZoJB0HXeMzFeqSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinRCMJq3bt5jmQfJ1PRfN1S-ZoJB0HXeMzFeqSA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17/02/2011 19:52, Patrick J. LoPresti wrote:
> I have a fair amount of experience with hardware RAID devices, but now
> I am investigating Linux software RAID and I have a question.  Well, a
> few questions.
>

I'll give some answers, but I am not sure about all the details.  I hope 
that someone else will correct me if I'm wrong :-)

> The classic problem for RAID5/RAID6 write performance, especially when
> striping across many drives, is that a single small write requires
> reading in the entire stripe from all disks to calculate the new
> syndrome block(s).
>

You don't need to read the whole stripe (at least, not for RAID5 - I 
don't know enough about RAID6 to comment).

With RAID5, the parity is the xor of all the other blocks in the stripe. 
  So if you only want to change one block, you can read the old block 
and the old parity block, and calculate the new parity block as the xor 
of the old data block, the old parity block, and the new data block.

You still have to do some reads then a write, but at least you don't 
need to read the whole stripe.

I presume that's the way md RAID5 implements small writes.

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
>

My understanding is that md keeps a cache of the stripes in ram.  Any 
writes must be completed to the disk itself, rather than just the stripe 
cache, before being reported to the file system as completed, as this 
cache is volatile.  But the next time you make a small write to a stripe 
that is in the cache, it can avoid the reads.  Of course, the cache will 
also be used for reads.

The size of this cache is configurable - using a larger stripe cache 
will give you a higher hit ratio, and thus faster small writes on 
average.  But the same ram can be used for other types of caches - 
directory entry caches, file caches, etc.  The best balance will depend 
on your load - for a read-mostly array, ram will probably be better 
spent as file cache, while for a write-mostly array the stripe cache is 
more important.


My understanding of hardware raid cards is that the have stripe caches, 
but these are typically volatile.  A non-volatile cache would mean you 
can't swap out controllers or disks when the system is switched off, as 
some of the data might be in the controller card's cache instead of the 
disks.

For high-end systems, your battery backup must not only keep the cache 
alive, but it should keep your disks running so that the cache can be 
flushed to disk when there is a power failure.  Then the controller will 
be able to report a write as "complete" when it is cached, and handle 
the flush to disk in the background.

Less high-end systems would, I believe, handle the cache in the same way 
as md raid - the stripe cache in ram would help avoid the reads before 
writing to part of a RAID 5 stripe.  Typically, this on-board cache will 
be a lot smaller than you would have in an md RAID system.



