From: Doug Dumitru <doug@easyco.com>
Subject: Re: kernel checksumming performance vs actual raid device performance
Date: Tue, 23 Aug 2016 11:27:58 -0700
Message-ID: <CAFx4rwT0jt9NCu4imruPUhfAR71=cvHwx-kdZxoTniZaQcPByQ@mail.gmail.com>
References: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
 <CAFx4rwQj3_JTNiS0zsQjp_sPXWkrp0ggjg_UiR7oJ8u0X9PQVA@mail.gmail.com>
 <CAJvUf-Dqesy2TJX7W-bPakzeDcOoNy0VoSWWM06rKMYMhyhY7g@mail.gmail.com>
 <CAFx4rwSQQuqeCFm+60+Gm75D49tg+mVjU=BnQSZThdE7E6KqPQ@mail.gmail.com>
 <CAJvUf-BoEJte8TF7_Su90CnjAiJ6q57m+PdGhxHA4cx5AEtxSg@mail.gmail.com> <51443e5b-3eef-c35f-8ee7-ad3e85e4e76c@redhat.com>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51443e5b-3eef-c35f-8ee7-ad3e85e4e76c@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Matt Garman <matthew.garman@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mr. Ledford,

I think your explanation of RAID "dirty" read performance is a bit off.

If you have 64KB chunks, this describes the layout.  I don't think
this also requires 64K reads.  I know that this is true with RAID-5,
and I am pretty sure it applies to raid-6 as well.  So if you do 4K
reads, you should see 4K reads to all the member drives.

You can verify this pretty easily with iostat.

Mr. Garman,

Your results are a lot worse than expected.  I always assume that a
raid "dirty" read will try to hit the disk hard.  This implies issuing
the 22 reads requests in parallel.  This is how "SSD" folks think.  It
is possible that this code is old enough to be in an HDD "mindset" and
that the requests are issued sequentially.  If so, then this is
something to "fix" in the raid code (I use the term fix here loosely
as this is not really a bug).

Can you run an iostat during your degraded test, and also a top run
over 20+ seconds with kernel threads showing up.  Even better would be
a perf capture, but you might not have all the tools installed.  You
can always try:

perf record -a sleep 20

then

perf report

should show you the top functions globally over the 20 second sample.
If you don't have perf loaded, you might (or might not) be able to
load it from the distro.

Doug


On Tue, Aug 23, 2016 at 11:00 AM, Doug Ledford <dledford@redhat.com> wrote:
> On 8/23/2016 10:54 AM, Matt Garman wrote:
>> On Tue, Aug 16, 2016 at 11:36 AM, Doug Dumitru <doug@easyco.com> wrote:
>>> The RAID rebuild for a single bad drive "should" be an XOR and should run at
>>> 200,000 kb/sec (the default speed_limit_max).  I might be wrong on this and
>>> this might still need a full RAID-6 syndrome compute, but I dont think so.
>>>
>>> The rebuild might not hit 200MB/sec if the drive you replaced is
>>> "conditioned".  Be sure to secure erase any non-new drive before you replace
>>> it.
>>>
>>> Your read IOPS will compete with now busy drives which may increase the IO
>>> latency a lot, and slow you down a lot.
>>>
>>> One out of 22 read OPS will be to the bad drive, so this will now take 22
>>> reads to re-construct the IO.  The reconstruction is XOR, so pretty cheap
>>> from a CPU point of view.  Regardless, your IOPS total will double.
>>>
>>> You can probably mitigate the amount of degradation by lowering the rebuild
>>> speed, but this will make the rebuild take longer, so you are messed up
>>> either way.  If the server has "down time" at night, you might lower the
>>> rebuild to a really small value during the day, and up it at night.
>>
>> OK, right now I'm looking purely at performance in a degraded state,
>> no rebuild taking place.
>>
>> We have designed a simple read load test to simulate the actual
>> production workload.  (It's not perfect of course, but a reasonable
>> approximation.  I can share with the list if there's interest.)  But
>> basically it just runs multiple threads of reading random files
>> continuously.
>>
>> When the array is in a pristine state, we can achieve read throughput
>> of 8000 MB/sec (at the array level, per iostat with 5 second samples).
>>
>> Now I failed a single drive.  Running the same test, read performance
>> drops all the way down to 200 MB/sec.
>>
>> I understand that IOPS should double, which to me says we should
>> expect a roughly 50% read performance drop (napkin math).  But this is
>> a drop of over 95%.
>>
>> Again, this is with no rebuild taking place...
>>
>> Thoughts?
>
> This depends a lot on how you structured your raid array.  I didn't see
> your earlier emails, so I'm inferring from the "one out of 22 reads will
> be to the bad drive" that you have a 24 disk raid6 array?  If so, then
> that's 22 data disks and 2 parity disks per stripe.  I'm gonna use that
> as the basis for my next statement even if it's slightly wrong.
>
> Doug was right in that you will have to read 21 data disks and 1 parity
> disk to reconstruct reads from the missing block of any given stripe.
> And while he is also correct that this doubles IO ops needed to get your
> read data, it doesn't address the XOR load to get your data.  With 19
> data disks and 1 parity disk, and say a 64k chunk size, you have to XOR
> 20 64k data blocks for 1 result.  If you are getting 200MB/s, you are
> actually achieving more like 390MB/s of data read, with 190MB/s of it
> being direct reads, and then you are using XOR on 200MB/s in order to
> generate the other 10MB/s of results.
>
> The question of why that performance is so bad is probably (and I say
> probably because without actually testing it this is just some hand-wavy
> explanation based upon what I've tested and found in the past, but may
> not be true today) due to a couple factors:
>
> 1) 200MB/s of XOR is not insignificant.  Due to our single thread XOR
> routines, you can actually keep a CPU pretty busy with this.  Also, even
> though the XOR routines try to time their assembly 'just so' so that
> they can use the cache avoiding instructions, this fails more often than
> not so you end up blowing CPU caches while doing this work, which of
> course effects the overall system.  Possible fixes for this might include:
>         a) Multi-threaded XOR becoming the default (last I knew it wasn't,
> correct me if I'm wrong)
>         b) Improved XOR routines that deal with cache more intelligently
>         c) Creating a consolidated page cache/stripe cache (if we can read more
> of the blocks needed to get our data from cache instead of disk it helps
> reduce that IO ops issue)
>         d) Rearchitecting your arrays into raid50 instead of big raid6 array
>
> 2) Even though we theoretically doubled IO ops, we haven't addressed
> whether or not that doubling is done efficiently.  Testing would be
> warranted here to make sure that our reads for reconstruction aren't
> negatively impacting overall disk IO op capability.  We might be doing
> something that we can fix, such as interfering with merges or with
> ordering or with latency sensitive commands.  A person would need to do
> some deep inspection of how commands are being created and sent to each
> device in order to see if we are keeping them busy or our own latencies
> at the kernel level are leaving the disks idle and killing our overall
> throughput (or conversely has the random head seeks just gone so
> radically through the roof that the problem here really is the time it
> takes the heads to travel everywhere we are sending them).
>
>
> --
> Doug Ledford <dledford@redhat.com>
>     GPG Key ID: 0E572FDD
>



-- 
Doug Dumitru
EasyCo LLC
