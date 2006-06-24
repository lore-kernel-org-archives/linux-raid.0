From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Sat, 24 Jun 2006 08:40:47 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0606240840100.10312@p34.internal.lan>
References: <449AEB7C.6040108@cjx.com> <op.tblclqd3cigqcu@apollo13>
 <fd8d0180606230226w10b1982ay2916805d9aa0e3bb@mail.gmail.com> <449BE381.6070000@cjx.com>
 <fd8d0180606230630x3f6b1ab7g444716cf8d5ab2c2@mail.gmail.com>
 <68c491a60606230746m5c1f0301g8e00fdd4f0e0739b@mail.gmail.com>
 <449C0505.8000601@tmr.com> <fd8d0180606230834t18427168jd776d33980f516b2@mail.gmail.com>
 <17564.52087.651968.635043@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17564.52087.651968.635043@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Francois Barre <francois.barre@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Sat, 24 Jun 2006, Neil Brown wrote:

> On Friday June 23, francois.barre@gmail.com wrote:
>>> The problem is that there is no cost effective backup available.
>>
>> One-liner questions :
>> - How does Google make backups ?
>
> No, Google ARE the backups :-)
>
>> - Aren't tapes dead yet ?
>
> LTO-3 does 300Gig, and LTO-4 is planned.
> They may not cope with tera-byte arrays in one hit, but they still
> have real value.
>
>> - What about a NUMA principle applied to storage ?
>
> You mean an Hierarchical Storage Manager?  Yep, they exist.  I'm sure
> SGI, EMC and assorted other TLAs could sell you one.
>
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

LTO3 is 400GB native and we've seen very good compression, so 800GB-1TB 
per tape.


