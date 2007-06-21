From: Raz <raziebe@gmail.com>
Subject: Re: stripe_cache_size and performance
Date: Thu, 21 Jun 2007 21:42:56 +0200
Message-ID: <5d96567b0706211242p7f03bd1cw9102ae3e44d67cee@mail.gmail.com>
References: <Pine.LNX.4.64.0706211312480.5806@gheavc.wnzcbav.cig>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706211312480.5806@gheavc.wnzcbav.cig>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

What is your raid configuration ?
Please note that the stripe_cache_size is acting as a bottle neck in some cases.



On 6/21/07, Jon Nelson <jnelson-linux-raid@jamponi.net> wrote:
>
> I've been futzing with stripe_cache_size on a 3x component raid5,
> using 2.6.18.8-0.3-default on x86_64 (openSUSE 10.2).
>
> With the value set at 4096 I get pretty great write numbers.
> 2048 and on down the write numbers slowly drop.
>
> However, at values above 512 the 'check' performance is terrible. By
> 'check' performance I mean the value displayed by /proc/mdstat after
> I issue:
>
> echo check > /sys/block/md0/md/sync_action
>
> When I say "terrible" I mean < 3MB/s.
> When I use 384, the performance goes to ~70MB/s
> 512.. 72-73MB/s
> 640.. 73-74MB/s
>
> 768.. 3300 K/s. Wow!
>
> Can somebody 'splain to me what is going on?
>
> --
> Jon Nelson <jnelson-linux-raid@jamponi.net>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Raz
