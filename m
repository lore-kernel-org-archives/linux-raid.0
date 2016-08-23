From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: kernel checksumming performance vs actual raid device performance
Date: Tue, 23 Aug 2016 09:54:56 -0500
Message-ID: <CAJvUf-BoEJte8TF7_Su90CnjAiJ6q57m+PdGhxHA4cx5AEtxSg@mail.gmail.com>
References: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
 <CAFx4rwQj3_JTNiS0zsQjp_sPXWkrp0ggjg_UiR7oJ8u0X9PQVA@mail.gmail.com>
 <CAJvUf-Dqesy2TJX7W-bPakzeDcOoNy0VoSWWM06rKMYMhyhY7g@mail.gmail.com> <CAFx4rwSQQuqeCFm+60+Gm75D49tg+mVjU=BnQSZThdE7E6KqPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFx4rwSQQuqeCFm+60+Gm75D49tg+mVjU=BnQSZThdE7E6KqPQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Dumitru <doug@easyco.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Aug 16, 2016 at 11:36 AM, Doug Dumitru <doug@easyco.com> wrote:
> The RAID rebuild for a single bad drive "should" be an XOR and should run at
> 200,000 kb/sec (the default speed_limit_max).  I might be wrong on this and
> this might still need a full RAID-6 syndrome compute, but I dont think so.
>
> The rebuild might not hit 200MB/sec if the drive you replaced is
> "conditioned".  Be sure to secure erase any non-new drive before you replace
> it.
>
> Your read IOPS will compete with now busy drives which may increase the IO
> latency a lot, and slow you down a lot.
>
> One out of 22 read OPS will be to the bad drive, so this will now take 22
> reads to re-construct the IO.  The reconstruction is XOR, so pretty cheap
> from a CPU point of view.  Regardless, your IOPS total will double.
>
> You can probably mitigate the amount of degradation by lowering the rebuild
> speed, but this will make the rebuild take longer, so you are messed up
> either way.  If the server has "down time" at night, you might lower the
> rebuild to a really small value during the day, and up it at night.

OK, right now I'm looking purely at performance in a degraded state,
no rebuild taking place.

We have designed a simple read load test to simulate the actual
production workload.  (It's not perfect of course, but a reasonable
approximation.  I can share with the list if there's interest.)  But
basically it just runs multiple threads of reading random files
continuously.

When the array is in a pristine state, we can achieve read throughput
of 8000 MB/sec (at the array level, per iostat with 5 second samples).

Now I failed a single drive.  Running the same test, read performance
drops all the way down to 200 MB/sec.

I understand that IOPS should double, which to me says we should
expect a roughly 50% read performance drop (napkin math).  But this is
a drop of over 95%.

Again, this is with no rebuild taking place...

Thoughts?

Thanks again,
Matt
