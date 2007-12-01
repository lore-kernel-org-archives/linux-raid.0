From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.23.9 / P35 Chipset + WD 750GB Drives (reset port)
Date: Sat, 1 Dec 2007 11:55:30 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712011155110.6257@p34.internal.lan>
References: <Pine.LNX.4.64.0712010619150.25643@p34.internal.lan>
 <Pine.LNX.4.64.0712011310410.30316@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0712010722590.28887@p34.internal.lan> <20071201174733.646a5c35@absurd>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071201174733.646a5c35@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 1 Dec 2007, Janek Kozicki wrote:

> Justin Piszcz said:     (by the date of Sat, 1 Dec 2007 07:23:41 -0500 (EST))
>
>>>> dd if=/dev/zero of=/dev/sdc
>>
>> The purpose is with any new disk its good to write to all the blocks and
>> let the drive to all of the re-mapping before you put 'real' data on it.
>> Let it crap out or fail before I put my data on it.
>
> better use badblocks. It writes data, then reads it afterwards:
> In this example the data is semi random (quicker than /dev/urandom ;)
>
> badblocks -c 10240 -s -w -t random -v /dev/sdc
>
> -- 
> Janek Kozicki                                                         |
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Will give this a shot and see if I can reproduce the error, thanks.
