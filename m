From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: MD performance options: More CPUs or more Hzs?
Date: Thu, 05 Nov 2009 13:34:58 +0100
Message-ID: <871vkdtaj1.fsf_-_@frosties.localdomain>
References: <66781b10911040149q165edf1s94a86f179f9af9fc@mail.gmail.com>
	<4AF18A39.6010404@tmr.com>
	<66781b10911040634mcdc3c70jec3410c09003fb6c@mail.gmail.com>
	<4AF1A0B8.2080807@hp.com> <4AF1A1B4.2030405@hp.com>
	<4AF1A446.700@hp.com>
	<66781b10911040926i20ebdc5x27fa113562705890@mail.gmail.com>
	<4AF1D177.6020200@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF1D177.6020200@hp.com> (jim owens's message of "Wed, 04 Nov
	2009 14:09:43 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

jim owens <jowens@hp.com> writes:

> mark delfman wrote:
>> I think this is a great point... i had not thought of the extra two
>> chunks of data being written... BUT, not sure if in this case it is
>> the limiter as we are using 12 drives.
>
> Disclaimer... I'm a filesystem guy not a raid guy, so someone
> who is may say I'm completely wrong.
>
> IMO 12 drives actually makes raid6 performance much worst.

Yes, but not for the reason you say for this test.

> Think it through, raid0 writes are substripe granularity,
> raid6 must either write all 12 (10 data, 2 check) stripes
> at once or if you write 1 stripe, read 9 data stripes to
> build and write the 2 check stripes.

I think theoretically you could update the p and q chunks but afaik
linux doesn't support that and always recomputes.

> The problem is even if you have a good application sending
> writes in the 10-stripe-length-multiples of the set, the
> kernel layers may chunk it and deliver it to md in smaller
> random sizes.

That should just fill the stripe cache till the stripe is complete or
the cache is full.

> Unless it is a single stream writing and md buffers the
> whole stripe set, writes will cause md reads.

Which I think he is testing exactly.

> And you will never have a single stream from a filesystem
> because metadata will be updated at some point.  You can
> minimize that by only doing overwrites.  Allocating writes
> are terrible in all filesystems because a lot of metadata
> has to be modified.  Metadata writes are also a performance
> killer because they are small (usually under 1 stripe) and
> always cause seeks.

Again the stripe cache should mitigate that. And ext4 (with external
journal?) should not write metadata so often anyway.

What about btrfs? The COW semantic could really improve thigs as it
will not overwrite a block from an old stripe but lineary fill new
stripes.

>> the hardware does bottleneck at around 1.6GBs for writes (reaches this
>> with 8 / 9 drives).

That would indicate that you reached the limit of your controler or
bus(es).

Lets assume we can transfere 1.6GB/s of data to the 12 drives (as
raid0 shows we can). So each drive can get 136MB/s. In a 12 disk raid6
there are 10 data chunks and 2 parity so ideal performance would be
1.36GB/s. Certainly more than the 700MB/s measured. So do look at top
and see where the cpu usage lies.

> So compare at 8 drives using raw writes of 6-stripe-lengths
> where raid0 uses a 4 transfers for each 3 raid6 transfers.

Well, do compare raid6 with 4,5,6,7,8,9,10,11 and 12 disks. The more
disks you have the more expensive the parity calculation becomes. Also
consider running 2 6 disk raid5. Not quite as secure but if speed is
more important...

MfG
        Goswin
