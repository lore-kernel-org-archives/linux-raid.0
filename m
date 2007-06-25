From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: stripe_cache_size and performance
Date: Mon, 25 Jun 2007 14:20:49 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706251420260.15590@p34.internal.lan>
References: <Pine.LNX.4.64.0706211312480.5806@gheavc.wnzcbav.cig>
 <5d96567b0706211242p7f03bd1cw9102ae3e44d67cee@mail.gmail.com>
 <Pine.LNX.4.64.0706211808140.5806@gheavc.wnzcbav.cig>
 <5d96567b0706220801v76c1c19cl7448050e62e0860b@mail.gmail.com>
 <Pine.LNX.4.64.0706221110220.4196@p34.internal.lan> <467FF1D5.6080007@tmr.com>
 <Pine.LNX.4.64.0706251259430.15590@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706251259430.15590@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Raz <raziebe@gmail.com>, jnelson-linux-raid@jamponi.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 25 Jun 2007, Justin Piszcz wrote:

>
>
> On Mon, 25 Jun 2007, Bill Davidsen wrote:
>
>> Justin Piszcz wrote:
>>> I have found a 16MB stripe_cache_size results in optimal performance after 
>>> testing many many values :)
>> 
>> We have discussed this before, my experience has been that after 8 x stripe 
>> size the performance gains hit diminishing returns, particularly for 
>> typical write instead of big aligned blocks, possibly with O_DIRECT. I 
>> would suggest that as a target even on a low memory machine.
>> 
>> Do your tests show similar? I was only able to test three and four drive 
>> setups using dedicated drives.
>> 
>> -- 
>> bill davidsen <davidsen@tmr.com>
>> CTO TMR Associates, Inc
>> Doing interesting things with small computers since 1979
>> 
>
> I will re-benchmark with my current setup, however:
>
> Each of these are averaged over three runs:
>
> 128k_stripe: 69.2MB/s
> 256k_stripe: 105.3MB/s
> 512k_stripe: 142.0MB/s
> 1024k_stripe: 144.6MB/s
> 2048k_stripe: 208.3MB/s
> 4096k_stripe: 223.6MB/s
> 8192k_stripe: 226.0MB/s
> 16384k_stripe: 215.0MB/s
>
> This was with 6 sata disks.
>
> Justin.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I set it to 32 and my machine has several hung processes in D state, not 
good.  I will start with 128k and up.

Justin.
