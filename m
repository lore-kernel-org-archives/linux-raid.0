From: jim owens <jowens@hp.com>
Subject: Re: MD performance options: More =?windows-1252?Q?CPU=92s_or_?=
 =?windows-1252?Q?more_Hz=92s=3F?=
Date: Wed, 04 Nov 2009 14:09:43 -0500
Message-ID: <4AF1D177.6020200@hp.com>
References: <66781b10911040149q165edf1s94a86f179f9af9fc@mail.gmail.com>	 <4AF18A39.6010404@tmr.com>	 <66781b10911040634mcdc3c70jec3410c09003fb6c@mail.gmail.com>	 <4AF1A0B8.2080807@hp.com> <4AF1A1B4.2030405@hp.com>	 <4AF1A446.700@hp.com> <66781b10911040926i20ebdc5x27fa113562705890@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66781b10911040926i20ebdc5x27fa113562705890@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

mark delfman wrote:
> I think this is a great point... i had not thought of the extra two
> chunks of data being written... BUT, not sure if in this case it is
> the limiter as we are using 12 drives.

Disclaimer... I'm a filesystem guy not a raid guy, so someone
who is may say I'm completely wrong.

IMO 12 drives actually makes raid6 performance much worst.

Think it through, raid0 writes are substripe granularity,
raid6 must either write all 12 (10 data, 2 check) stripes
at once or if you write 1 stripe, read 9 data stripes to
build and write the 2 check stripes.

The problem is even if you have a good application sending
writes in the 10-stripe-length-multiples of the set, the
kernel layers may chunk it and deliver it to md in smaller
random sizes.

Unless it is a single stream writing and md buffers the
whole stripe set, writes will cause md reads.

And you will never have a single stream from a filesystem
because metadata will be updated at some point.  You can
minimize that by only doing overwrites.  Allocating writes
are terrible in all filesystems because a lot of metadata
has to be modified.  Metadata writes are also a performance
killer because they are small (usually under 1 stripe) and
always cause seeks.

> the hardware does bottleneck at around 1.6GBs for writes (reaches this
> with 8 / 9 drives).

So compare at 8 drives using raw writes of 6-stripe-lengths
where raid0 uses a 4 transfers for each 3 raid6 transfers.

jim
