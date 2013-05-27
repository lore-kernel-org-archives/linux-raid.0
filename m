From: Andrea Bolandrina <andrea.bola@yahoo.it>
Subject: Re: Best size partition for a mdadm array
Date: Mon, 27 May 2013 09:38:50 +0100
Message-ID: <CAOsORH-atqXVkkn+YWH+Q0pO0ZCKvRL3EWUpxa6h-GfsxsjdcQ@mail.gmail.com>
References: <CAOsORH9X6L+EZY5DEDfwbWkHPgL6Oz9yGC1JWf0nejLckVJg=w@mail.gmail.com>
 <51A2D4A5.6000907@smartguide.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51A2D4A5.6000907@smartguide.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Tudor Holton <tudor@smartguide.com.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Tudor.

All disks I have report the same size, even though they are different
brand/model
#fdisk -l | grep Disk
Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
Disk /dev/sdd: 2000.4 GB, 2000398934016 bytes
Disk /dev/sde: 2000.4 GB, 2000398934016 bytes
Disk /dev/sdf: 2000.4 GB, 2000398934016 bytes
Disk /dev/sdg: 2000.4 GB, 2000398934016 bytes

They are 2 WD RED (WDC WD20EFRX-68AX9N0),
1 WD GREEN (WDC WD20EARX-00PASB0) and
2 SAMSUNG (HD204UI).

If the 2 WD RED bahave as they should I might buy some more as soon as
the others fail,
otherwise I will try something different (that's why I want to keep
the system as flexible as possible).

The 2 samsung SMART infos are already "screaming for help" and,
actually, a third Samsung already failed last year.
Terrible drives, terrible support from Samsung that replaced the drive
(still under warranty) with a refurbished one that failed within 10
days from arrival.

Anyway, regarding how much free space to leave, another user suggested
2-10 MB should be sufficient.

Thanks for your infos.
Andrea

On Mon, May 27, 2013 at 4:36 AM, Tudor Holton <tudor@smartguide.com.au> wrote:
> Hi Andrea,
>
> I noticed your question wasn't answered, so I'll give it a shot. Bear in
> mind that I'm relatively new here, so take everything I say with a pinch
> of
> salt. :-)
>
> At some point in the past, manufacturers of hard disks released disks with
> the same "marketing" size but different actual capacities.  For example,
> instead of 1TB being a 1 Tebibyte 2^40 (1,099,511,627,776 bytes), they
> sold
> lower capacity drives by using a different base.   1TB could be 1000GB
> (10^3*2^30 = 1,073,741,824,000 bytes), 1024GB (2^10*10^9 =
> 1,024,000,000,000
> bytes) or even a "true" Terabyte at 10^12 bytes (1,000,000,000,000 bytes).
> If we were swapping brands, and moved from a 2^40 to a 10^12 model, then
> our
> array wouldn't fit anymore. :-(
>
> These days, things are a bit clearer as people understand the differences
> between the Terabytes and Tebibytes.
>
> Thankfully, most modern disk sizes are standardised, but still with some
> small variances.  It would be wise to look at the drives you have
> purchased
> and look at the actual storage capacity then take the lowest one and use
> that.  You may want to add in some additional buffer, also, just in case.
>
> I hope that helps you make your decision. :-)
>
> Cheers,
> Tudor.
>
>
> On 24/05/13 19:25, Andrea Bolandrina wrote:
>>
>> Hi All,
>>
>> In choosing the right size for a mdadm array the manual sais:
>> "Sometimes a replacement drive can be a little smaller than the
>> original drives though this should be minimised by IDEMA standards.
>> Such a replacement drive will be rejected by md.
>> To guard against this it can be useful to set the initial size
>> slightly smaller than the smaller device with the aim that it will
>> still be larger than any replacement."
>>
>> I want to do a 5x2TB md (raid 6) array .
>> Could you advise me how "slightly smaller" should my partitions be?
>>
>> 100MB smaller than the actual size? 1GB?
>>
>> Thank in advance for the attention.
>>
>> Regards,
>> Andrea
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
