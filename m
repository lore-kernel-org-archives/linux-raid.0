From: Phil Turmel <philip@turmel.org>
Subject: Re: kernel checksumming performance vs actual raid device performance
Date: Tue, 23 Aug 2016 17:42:54 -0400
Message-ID: <9f7e40ae-3117-a936-2a9f-10e363e9f9a6@turmel.org>
References: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
 <CAFx4rwQj3_JTNiS0zsQjp_sPXWkrp0ggjg_UiR7oJ8u0X9PQVA@mail.gmail.com>
 <CAJvUf-Dqesy2TJX7W-bPakzeDcOoNy0VoSWWM06rKMYMhyhY7g@mail.gmail.com>
 <CAFx4rwSQQuqeCFm+60+Gm75D49tg+mVjU=BnQSZThdE7E6KqPQ@mail.gmail.com>
 <CAJvUf-BoEJte8TF7_Su90CnjAiJ6q57m+PdGhxHA4cx5AEtxSg@mail.gmail.com>
 <51443e5b-3eef-c35f-8ee7-ad3e85e4e76c@redhat.com>
 <CAFx4rwT0jt9NCu4imruPUhfAR71=cvHwx-kdZxoTniZaQcPByQ@mail.gmail.com>
 <CAJvUf-ApkKJXm7Jjiq=gXY9b9RrEvwA5u35xrMUjX2x0btVL4g@mail.gmail.com>
 <3e239b96-b06e-d33b-2e99-42ffa170d804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3e239b96-b06e-d33b-2e99-42ffa170d804@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Matt Garman <matthew.garman@gmail.com>, Doug Dumitru <doug@easyco.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/23/2016 04:15 PM, Doug Ledford wrote:

> You're raid device has a good chunk size for your usage pattern.  If you
> had a smallish chunk size (like 64k or 32k), I would actually expect
> things to behave differently.  But, then again, maybe I'm wrong and that
> would help.  With a smaller chunk size, you would be able to fit more
> stripes in the stripe cache using less memory.

This is not correct.  Parity operations in MD raid4/5/6 operate on 4k
blocks.  The stripe cache for an array is a collection of 4k elements
per member device.  Chunk size doesn't factor into the cache itself.

But see below....

> Makes sense.  I know the stripe cache size is conservative by default
> because of the fact that it's not shared with the page cache, so you
> might as well consider it's memory lost.  When you upped it to 64k, and
> you have 22 disks at 512k chunk, that 11MB per stripe and 65536 total
> allowed stripes which is a maximum memory consumption of around 700GB
> RAM.  I doubt you have that much in your machine, so I'm guessing it's
> simply using all available RAM that the page cache or something else
> isn't already using.  That's also explains why setting it higher doesn't
> provide any additional benefits ;-).

More likely the parity thread saturated and no more speed was possible.
Also possible that there would be a step change in performance again at
a much larger cache size.

>> While 200 MB/s of XOR sounds high, the kernel is "advertising" over
>> 8000 MB/s, per dmesg:
>>
>> [    6.386820] xor: automatically using best checksumming function:
>> [    6.396690]    avx       : 24064.000 MB/sec
>> [    6.414706] raid6: sse2x1   gen()  7636 MB/s
>> [    6.431725] raid6: sse2x2   gen()  3656 MB/s
>> [    6.448742] raid6: sse2x4   gen()  3917 MB/s
>> [    6.465753] raid6: avx2x1   gen()  5425 MB/s
>> [    6.482766] raid6: avx2x2   gen()  7593 MB/s
>> [    6.499773] raid6: avx2x4   gen()  8648 MB/s
>> [    6.499773] raid6: using algorithm avx2x4 gen() (8648 MB/s)
>> [    6.499774] raid6: using avx2x2 recovery algorithm
>>
>> (CPU is: Intel(R) Xeon(R) CPU E5-2620 v3 @ 2.40GHz.)

Parity operations in raid must always involve all (available) member
devices.  Read operations when not degraded won't generate any parity
operations.  Most large write operations and any degraded read
operations will involve all members, even if those members' data is not
part of the larger read/write request.

As chunk sizes get larger the odds grow that any given array I/O will
touch a fraction of the slice, causing I/O to members purely for parity
math.  Also, the odds rise that the starting point or ending point of an
array I/O operation will not be aligned to the stripe, making more
member I/O solely for parity math.

Then add in the fact that dd issues I/O requests one block at a time,
per the bs=? parameter.  So it is possible that data that would have
been sequential without parallel pressure (still in the stripe cache for
later reads) generates multiple parity calculations for fractional
stripe operations, just due to stripe size/alignment mismatch on single
dd dispatches.

What bs=? value are you using in your dd commands?  Based on your 512k
chunk, it should be 10240k for aligned operations and much larger than
that for unaligned.

FWIW, I use small chunk sizes -- usually 16k.

Phil
