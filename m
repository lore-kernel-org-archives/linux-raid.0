From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mismatch_cnt != 0
Date: Mon, 25 Feb 2008 07:05:56 -0500 (EST)
Message-ID: <alpine.DEB.1.00.0802250705370.17154@p34.internal.lan>
References: <alpine.DEB.1.00.0802230434100.3809@p34.internal.lan> <47C01D79.4010708@msgid.tls.msk.ru> <alpine.DEB.1.00.0802230904130.15989@p34.internal.lan> <alpine.DEB.1.00.0802231044050.30201@p34.internal.lan> <18368.51540.448400.111882@fisica.ufpr.br>
 <alpine.DEB.1.00.0802240424050.14270@p34.internal.lan> <20080224173828.23e0a7e7@absurd>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080224173828.23e0a7e7@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sun, 24 Feb 2008, Janek Kozicki wrote:

> Justin Piszcz said:     (by the date of Sun, 24 Feb 2008 04:26:39 -0500 (EST))
>
>> Kernel 2.6.24.2 I've seen it on different occasions, for this last time
>> though it may have been due to a power outage that lasted > 2hours and
>> obviously the UPS did not hold up that long.
>
> you should connect UPS through RS-232 or USB, and if a power-down
> event is detected - issue hibernate or shutdown. Currently I am
> issuing hibernate in this case, works pretty well for 2.6.22 and up.
>
> --
> Janek Kozicki                                                         |
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I have it hooked up but it was a weird day for the power going on and off 
many times for upwards of 2-3 hours and then it died for 2+ hours.

Justin.
