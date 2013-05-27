From: Tudor Holton <tudor@smartguide.com.au>
Subject: Re: Best size partition for a mdadm array
Date: Mon, 27 May 2013 13:36:05 +1000
Message-ID: <51A2D4A5.6000907@smartguide.com.au>
References: <CAOsORH9X6L+EZY5DEDfwbWkHPgL6Oz9yGC1JWf0nejLckVJg=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOsORH9X6L+EZY5DEDfwbWkHPgL6Oz9yGC1JWf0nejLckVJg=w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrea Bolandrina <andrea.bola@yahoo.it>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Andrea,

I noticed your question wasn't answered, so I'll give it a shot. Bear in 
mind that I'm relatively new here, so take everything I say with a pinch 
of salt. :-)

At some point in the past, manufacturers of hard disks released disks 
with the same "marketing" size but different actual capacities.  For 
example, instead of 1TB being a 1 Tebibyte 2^40 (1,099,511,627,776 
bytes), they sold lower capacity drives by using a different base.   1TB 
could be 1000GB (10^3*2^30 = 1,073,741,824,000 bytes), 1024GB (2^10*10^9 
= 1,024,000,000,000 bytes) or even a "true" Terabyte at 10^12 bytes 
(1,000,000,000,000 bytes).  If we were swapping brands, and moved from a 
2^40 to a 10^12 model, then our array wouldn't fit anymore. :-(

These days, things are a bit clearer as people understand the 
differences between the Terabytes and Tebibytes.

Thankfully, most modern disk sizes are standardised, but still with some 
small variances.  It would be wise to look at the drives you have 
purchased and look at the actual storage capacity then take the lowest 
one and use that.  You may want to add in some additional buffer, also, 
just in case.

I hope that helps you make your decision. :-)

Cheers,
Tudor.

On 24/05/13 19:25, Andrea Bolandrina wrote:
> Hi All,
>
> In choosing the right size for a mdadm array the manual sais:
> "Sometimes a replacement drive can be a little smaller than the
> original drives though this should be minimised by IDEMA standards.
> Such a replacement drive will be rejected by md.
> To guard against this it can be useful to set the initial size
> slightly smaller than the smaller device with the aim that it will
> still be larger than any replacement."
>
> I want to do a 5x2TB md (raid 6) array .
> Could you advise me how "slightly smaller" should my partitions be?
>
> 100MB smaller than the actual size? 1GB?
>
> Thank in advance for the attention.
>
> Regards,
> Andrea
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

