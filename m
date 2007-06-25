From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: stripe_cache_size and performance
Date: Mon, 25 Jun 2007 14:42:58 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706251442260.15590@p34.internal.lan>
References: <Pine.LNX.4.64.0706211312480.5806@gheavc.wnzcbav.cig>
 <5d96567b0706211242p7f03bd1cw9102ae3e44d67cee@mail.gmail.com>
 <Pine.LNX.4.64.0706211808140.5806@gheavc.wnzcbav.cig>
 <5d96567b0706220801v76c1c19cl7448050e62e0860b@mail.gmail.com>
 <Pine.LNX.4.64.0706221110220.4196@p34.internal.lan> <467FF1D5.6080007@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <467FF1D5.6080007@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Raz <raziebe@gmail.com>, jnelson-linux-raid@jamponi.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 25 Jun 2007, Bill Davidsen wrote:

> Justin Piszcz wrote:
>> I have found a 16MB stripe_cache_size results in optimal performance after 
>> testing many many values :)
>
> We have discussed this before, my experience has been that after 8 x stripe 
> size the performance gains hit diminishing returns, particularly for typical 
> write instead of big aligned blocks, possibly with O_DIRECT. I would suggest 
> that as a target even on a low memory machine.
>
> Do your tests show similar? I was only able to test three and four drive 
> setups using dedicated drives.
>
> -- 
> bill davidsen <davidsen@tmr.com>
> CTO TMR Associates, Inc
> Doing interesting things with small computers since 1979
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Running test with 10 RAPTOR 150 hard drives, expect it to take awhile 
until I get the results, avg them etc. :)

128k,256k,512k,1024k,2048k,4096k,8192k,16384k

Justin.
