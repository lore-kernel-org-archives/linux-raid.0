From: Berkey B Walker <berk@panix.com>
Subject: Re: recovering from a controller failure
Date: Sat, 29 May 2010 17:43:53 -0400
Message-ID: <4C018A99.9030900@panix.com>
References: <20100529190751.GM2167@flews.lairds.us> <4C01849D.8080101@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C01849D.8080101@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard <richard@sauce.co.nz>
Cc: Kyler Laird <kyler-keyword-linuxraid00.a7e7f0@lairds.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Good find, Richard.  Simplifies things a lot.  I liked the phrase 
"Abusively looping"  , as that was a technique I used to use (30 yr. ago)
b-


Richard wrote:
> Kyler Laird wrote:
>
>> I'd like to know if this is something I can recover.  I do have backups
>> but it's a huge pain to recover this much data.
>
> This happened to me before I discovered that LSI SAS1068E no longer 
> reliably tolerate querying via smartd/smartctl.
>
> Have a look at https://bugzilla.kernel.org/show_bug.cgi?id=14831
>
> and there is a patch that seems to fix it here:
>
> http://lkml.org/lkml/2010/4/26/335
>
> Use hdparm if you need serial numbers.
>
> In the the half dozen or so tests I have done, where more than 2 
> drives have been thrown out of md RAID6 arrays due to these controller 
> resets,
> reassembly using --force has worked with no data corruption, but this 
> may have been good luck.
>
> Regards,
>
> Richard
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
