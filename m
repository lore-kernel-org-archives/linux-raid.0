From: o1bigtenor <o1bigtenor@gmail.com>
Subject: Re: Raid settings
Date: Mon, 29 Aug 2016 04:26:00 -0500
Message-ID: <CAPpdf59b4Cd4CTa5Mfg=1qQk_Gvk4pr+Tm5YJ_5OD5STufzX2g@mail.gmail.com>
References: <CAPpdf5_T=JjjUw2H5pAShmj4V6b5U8aALxDsiZvjyTUYy58DmQ@mail.gmail.com>
 <57C35ED0.2030107@youngman.org.uk> <CAPpdf5-pCNLQXmnNQGTVufCKMULcjFPKL8riTnd8Aba4ORtW2g@mail.gmail.com>
 <038ec076-aa03-993f-7c9a-15f09fac02b4@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <038ec076-aa03-993f-7c9a-15f09fac02b4@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Aug 28, 2016 at 9:46 PM, Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:
> On 29/08/16 12:28, o1bigtenor wrote:
snip
>>>
>>> Without knowing what you want, we can't know what's best for you.
>>
>> That's what it seems like - - - its possible to justify any setup.
>>
>> I have 2 - 4 disc setups both running raid 10 trying to get s fairly high
>> level
>> of security yet also some through put.
>>
>> I'm asking because what do I do if I need to have say 10 to 25 TB of
>> online
>> storage.
>>
>> Do I go for my raid 10 with 2 sets of 6 TB discs or is there a better way
>> to
>> achieve high levels of security AND throughput?
>>
>> What about for the next level of storage (my thinking here) or at 35 to
>> 100 TB?
>>
>> Maybe the better question is - - - how do I decide what I want?
>>
>
> Hi,
> I think you are forgetting that there are multiple factors, you are only
> looking at the storage capacity, and to some degree protection. You also
> need to consider what sort of performance you want to achieve, and this is
> usually the deciding factor.

Your examples also point to cost being a possible major factor.
>
> To get 25TB, you can easily use 3 x 10TB drives in RAID0 .... but if you
> want some level of protection, then you could choose 4 in RAID5, or 5 in
> RAID6, or 6 in RAID10.
> You of course have the same options when you want 35, or 100, or 1000TB
> etc...
> RAID10 will scale linearly, simply keep adding drives in pairs, and you will
> continue to have the similar level of protection (I guess the chance of a
> pair of drives failing increases as you have more pairs)...
> RAID5/6 you will likely want to use RAID50/60 with no more than X drives in
> each RAID5/6 part, where X is determined by your
> performance/storage/reliability decisions.
>
> After all that, you then need to look at another dozen options, (bitmap,
> chunk size, etc etc), which will also have a significant impact on
> performance (and reliability).

I've looked but haven't been able to find anything that discusses the
points that
have been raised so far. Would you point me to a, or some, documents that
discuss these options?
What are the options besides the 2 you mentioned?

What I'm looking for is a methodology for the decision rather than a blanket
answer at this point. Thought initially that there might be a 'best' answer but
now its looking like a much much more fluid thing.
>
> To get 35TB, you might do either 16 x 8TB drives in RAID10 (40TB) or you can
> do 7 x 8TB drives in RAID6 (at these capacities, I'd strongly suggest you
> skip RAID5). You could also consider doing 14 x 8TB drives in RAID60 (two
> sets of 7 drives).
>
> PS, you will want to use this range of drives:
> http://www.wdc.com/en/products/internal/nas/

Thanks for the tip.
>
> Or equivalent, as long as it definitely supports SCT/ERC.
>

Regards

Dee
