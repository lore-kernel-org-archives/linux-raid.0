From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: resync duration ?
Date: Mon, 18 May 2009 11:02:41 -0400
Message-ID: <4A117891.1000909@tmr.com>
References: <1308264373.20090514150647@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1308264373.20090514150647@kaneda.iguw.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Rainer Fuegenstein wrote:
> Hi guys,
>
> I'm a but confused about the duration of a raid5 resync:
>
> - occasionally, my server with 4*750 gb sata raid5 crashed (because of
> problems with the power supply); after rebooting it took about 10 to 12
> hours to resync the raid5 (guess it just re-created some parity
> information or however it works internally, but didn't have to copy
> any data)
>
>   
I have a test machine which crashes regularly (used for kernel and 
hardware tests), and that sounds long. Are you running without a bitmap, 
by any chance?

> - right now I replaced one 750GB disk with a 1.5TB disk, but now
> resyncing (according to /proc/mdstat) it is supposed to take only 160
> minutes ?! although it needs top copy data to a blank disk ?
>
> is this normal or should I be worried, especially before I pull out
> the next 750GB disk and replace it with the next 1.5TB disk ?
>
> tnx in advance.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


