From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Tue, 15 Dec 2015 13:44:06 -0600
Message-ID: <CAE9DZUS=AVydRoDZav-Mvq9VyPuM4Z+0iQgxy9KDJG9yB2NZ8g@mail.gmail.com>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
	<566B6C8F.7020201@turmel.org>
	<CAE9DZURoHBRHq2M0spkTrBGoXmw9QjoARb_Gc6C6OvM9940aMA@mail.gmail.com>
	<566BA6E5.6030008@turmel.org>
	<CAE9DZUT42rCgjSacbs170ftzBtC4i83TRvk7CGeELqpYg3hVzw@mail.gmail.com>
	<CAK2H+edazVORrVovWDeTA8DmqUL+5HRH-AcRwg8KkMas=o+Cog@mail.gmail.com>
	<CAE9DZURBQxteib=hW6FskuJCJTxZDWhy5kMVy2u1hU5Nkg8Khg@mail.gmail.com>
	<CAK2H+ed-3Z8SR20t8rpt3Fb48c3X2Jft=qZoiY9emC2nQww1xQ@mail.gmail.com>
	<CAE9DZUQHBycc5+Z2YrJtWZRYxOUMu3pgnaEQSrsyeCZEv8vndA@mail.gmail.com>
	<CAE9DZUT1v+CFZOs33CC+JrWcX_WHBu+WW78AynkWqJN+LLoqDA@mail.gmail.com>
	<CAK2H+ecMvDLdYLhMtMQbP7Ygw-VohG7LGZ2n7H+LAXQ1waJK3A@mail.gmail.com>
	<CAE9DZUSbt7Kfwd9S3K_SXY7fVRk-vq5RhrPzKs4XO8uhyfPh3Q@mail.gmail.com>
	<CAE9DZUQxT_5L0bW5m9SZ_d2GU6sZS8k0qD=g+o112qM4V=cJkw@mail.gmail.com>
	<22128.11867.847781.946791@quad.stoffel.home>
	<CAE9DZURepRB3k-pBnRg2Tx8GCzAr6zCzv+LJy4mK4CDdAkBYVQ@mail.gmail.com>
	<56706858.2040908@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56706858.2040908@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: John Stoffel <john@stoffel.org>, Mark Knecht <markknecht@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Dec 15, 2015 at 1:22 PM, Phil Turmel <philip@turmel.org> wrote:
> Hi Dallas,
>
> On 12/15/2015 12:30 PM, Dallas Clement wrote:
>> Thanks guys for all the ideas and help.
>>
>> Phil,
>>
>>> Very interesting indeed. I wonder if the extra I/O in flight at high
>>> depths is consuming all available stripe cache space, possibly not
>>> consistently. I'd raise and lower that in various combinations with
>>> various combinations of iodepth.  Running out of stripe cache will cause
>>> premature RMWs.
>>
>> Okay, I'll play with that today.  I have to confess I'm not sure that
>> I completely understand how the stripe cache works.  I think the idea
>> is to batch I/Os into a complete stripe if possible and write out to
>> the disks all in one go to avoid RMWs.  Other than alignment issues,
>> I'm unclear on what triggers RMWs.  It seems like as Robert mentioned
>> that if the I/Os block size is stripe aligned, there should never be
>> RMWs.
>>
>> My stripe cache is 8192 btw.
>>
>
> Stripe cache is the kernel's workspace to compute parity or to recover
> data from parity.  It works on 4k blocks.  Per "man md", the units are
> number of such blocks per device.  *The blocks in each cache stripe are
> separated from each other on disk by the chunk size*.
>
> Let's examine some scenarios for your 128k chunk size, 12 devices.  You
> have 8192 cache stripes of 12 blocks each:
>
> 1) Random write of 16k.  4 stripes will be allocated from the cache for
> *all* of the devices, and filled for the devices written.  The raid5
> state machine lets them sit briefly for a chance for more writes to the
> other blocks in each stripe.
>
> 1a) If none come in, MD will request a read of the old data blocks and
> the old parities.  When those arrive, it'll compute the new parities and
> write both parities and new data blocks.  Total I/O: 32k read, 32k write.
>
> 1b) If other random writes come in for those stripes, chunk size spaced,
> MD will wait a bit more.  Then it will read in any blocks that weren't
> written, compute parity, and write all the new data and parity.  Total
> I/O: 16k * n, possibly some reads, the rest writes.
>
> 2) Sequential write of stripe-aligned 1408k.  The first 128k allocates
> 64 cache stripes and fills their first block.  The next 128k fills the
> second block of each cache stripe.  And so on, filling all the data
> blocks in the cache stripes.  MD shortly notices a full cache stripe
> write on each, so it just computes the parities and submits all of those
> writes.
>
> 3) Sequential write of 256k, aligned or not.  As above, but you only
> fill two blocks in each cache stripe.  MD then reads 1152k, computes
> parity, and writes 384k.
>
> 4) Multiple back-to-back writes of 1408k aligned.  First grabs 64 cache
> stripes and shortly queues all of those writes.  Next grabs another 64
> cache stripes and queues more writes. And then another 64 caches stripes
> and writes.  Underlying layer, as its queue grows, notices the adjacency
> of chunk writes from multiple top-level writes and starts merging.
> Stripe caches are still held, though, until each write is completed.  If
> 128 top-level writes are in flight (8192/64), you've exhausted your
> stripe cache.  Note that this is writes in flight in your application
> *and* writes in flight from anything else.  Keeping in mind that merging
> might actually raise the completion latency for the earlier writes.
>
> I'm sure you can come up with more.  The key is that stripe parity
> calculations must be performed on blocks separated on disk by the chunk
> size.  Really big chunk sizes don't actually help parity raid, since
> everything is broken down to 4k for the stripe cache, then re-merged
> underneath it.
>
>> I with this were for fun! ;)  Although this has been a fun discussion.
>> I've learned a ton.  This effort is for work though.  I'd be all over
>> the SSDs and caching otherwise.  I'm trying to characterize and then
>> squeeze all of the performance I can out of a legacy NAS product.  I
>> am constrained by the existing hardware.  Unfortunately I do not have
>> the option of using SSDs or hardware RAID controllers.  I have to rely
>> completely on Linux RAID.
>>
>> I also need to optimize for large sequential writes (streaming video,
>> audio, large file transfers), iSCSI (mostly used for hosting VMs), and
>> random I/O (small and big files) as you would expect with a NAS.
>
> On spinning rust, once you introduce any random writes, you've
> effectively made the entire stack a random workload.  This is true for
> all raid levels, but particularly true for parity raid due to the RMW
> cycles.  If you really need great sequential performance, you can't
> allow the VMs and the databases and small files on the same disks.
>
> That said, I recommend a parity raid chunk size of 16k or 32k for all
> workloads.  Greatly improves spatial locality for random writes, reduces
> stripe cache hogging for sequential writes, and doesn't hurt sequential
> reads too much.
>
> Phil

Wow!  Thanks a ton Phil.  This is incredibly helpful!  It looks like I
need to do some experimenting with smaller chunk sizes.  Just one more
question:  what stripe cache size do you recommend for this system?
It has 8 GB of RAM, but can't use all of it for RAID as this NAS needs
to run multiple applications.  I understand that in the >= 4.1 kernels
the stripe cache grows dynamically.
