From: Doug Dumitru <doug@easyco.com>
Subject: Re: Prefetch in /lib/raid6/avx2.c
Date: Thu, 6 Oct 2016 10:32:07 -0700
Message-ID: <CAFx4rwS3sJBQu651mMX0_1Ni07=ftN9jFv=n2LVMSH=fZV67yQ@mail.gmail.com>
References: <CAFx4rwS5-TCWKxRYpXHeRsfTiJ=mTV0gxoL-yUuqoEbpXst08A@mail.gmail.com>
 <20161005231710.GB2804@kernel.org> <12EF8D94C6F8734FB2FF37B9FBEDD1739B85E450@EXCHANGE.collogia.de>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD1739B85E450@EXCHANGE.collogia.de>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: Shaohua Li <shli@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, "gayatri.kammela@intel.com" <gayatri.kammela@intel.com>, "ravi.v.shankar@intel.com" <ravi.v.shankar@intel.com>, "hpa@zytor.com" <hpa@zytor.com>, "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "yuanhan.liu@intel.com" <yuanhan.liu@intel.com>
List-Id: linux-raid.ids

On Thu, Oct 6, 2016 at 12:27 AM, Markus Stockhausen
<stockhausen@collogia.de> wrote:
>> Von: linux-raid-owner@vger.kernel.org [linux-raid-owner@vger.kernel.org]&quot; im Auftrag von &quot;Shaohua Li [shli@kernel.org]
>> Gesendet: Donnerstag, 6. Oktober 2016 01:17
>> An: Doug Dumitru
>> Cc: linux-raid; gayatri.kammela@intel.com; ravi.v.shankar@intel.com; hpa@zytor.com; yu-cheng.yu@intel.com; yuanhan.liu@intel.com
>> Betreff: Re: Prefetch in /lib/raid6/avx2.c
>>
>> On Sun, Oct 02, 2016 at 03:40:09PM -0700, Doug Dumitru wrote:
>> > I have been doing some high bandwidth testing of raid-6, and the
>> > pretetch in raid6_avx24_gen_syndrome appears to be less than optimal.
>> >
>> > This is my patch (against 4.4.0-38 [Ubuntu 16.04LTS)
>> >
>> > --- cut here ---
>> > --- lib/raid6/avx2.c0   2016-10-01 21:42:25.280347868 -0700
>> > +++ lib/raid6/avx2.c    2016-10-02 15:35:48.168480760 -0700
>> > @@ -189,10 +189,8 @@
>> >
>> >                 for (z = z0; z >= 0; z--) {
>> >
>> > -                       asm volatile("prefetchnta %0" : : "m" (dptr[z][d]));
>> > -                       asm volatile("prefetchnta %0" : : "m" (dptr[z][d+32]));
>> > -                       asm volatile("prefetchnta %0" : : "m" (dptr[z][d+64]));
>> > -                       asm volatile("prefetchnta %0" : : "m" (dptr[z][d+96]));
>> > +                       asm volatile("prefetchnta %0" : : "m" (dptr[z][d+128]));
>> > +                       asm volatile("prefetchnta %0" : : "m" (dptr[z][d+192]));
>
> From the first look that looks strange.
>
> 1) It will add 2 prefetches for the last blocks beyond the data. Feels like bad coding.

This is correct, but the original code adds four prefetches beyond the
buffer.  My understanding is that an extra prefetch is often less
expensive than the test to avoid it.

I would also mention that the original code probably can have the
[d+32] and [d+96] removed without issue.  The comments imply 32 byte
cache lines, which sounds overly generic, especially for AVX2 specific
code.

> 2) The prefetch for the next block is already in the next loop (d+128)

The loop is 256 bytes (4 x AVX2 registers), so the prefetch is only
for the data that is to be immediately used in the next 20 or so
instructions.

I tried other iterations, including prefetching a disk ahead [z-1][d]
and [z-1][d+128] (disks are traversed backwards), but this was slower
in testing.  I also tried a lot of manual unrolling to tweak the extra
prefetches out, but still this simple case tested better.

I was actually surprised by how much it helped.  Again, my test is
very synthetic (it does use the raid6 code end-to-end, but with a lot
of experimental patches).  Also, my array has 24 disks so the pretetch
is actually 44 cache lines early (which seems like a lot, but then
again, it does fit easily in L1).

>
> Maybe the prefetcher takes longer than expected. And thus the next loop
> will benefit from the "relocated" hint.
>
>> >
>> >                         asm volatile("vpcmpgtb %ymm4,%ymm1,%ymm5");
>> >                         asm volatile("vpcmpgtb %ymm6,%ymm1,%ymm7");
>> > --- cut here ---
>> >
>> > In perf, the cpu cycles goes from 5.3% to 3.0% for
>> > raid6_avx24_gen_syndrome in my test and throughput increases from
>> > about 8.2GB/sec to almost 10GB/sec.  It is a very "synthetic" test,
>> > but the avx2 code does seem to be a factor.
>> >
>> > I suspect other SSE and AVX "unroll variants" have similar issues, but
>> > I have not tested those.
>> >
>> > My test system is an E5-1650 v3 (single socket) with DDR4.  This might
>> > help dual sockets even more.
>>
>> CC some intel folks to see if they have ideas
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Doug Dumitru
EasyCo LLC
