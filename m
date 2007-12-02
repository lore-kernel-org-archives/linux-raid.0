From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.23.9 / P35 Chipset + WD 750GB Drives (reset port)
Date: Sun, 2 Dec 2007 16:21:44 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712021619520.5379@p34.internal.lan>
References: <Pine.LNX.4.64.0712010619150.25643@p34.internal.lan>
 <Pine.LNX.4.64.0712011310410.30316@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0712010722590.28887@p34.internal.lan> <20071201174733.646a5c35@absurd>
 <Pine.LNX.4.64.0712011155110.6257@p34.internal.lan>
 <Pine.LNX.4.64.0712020409280.30169@p34.internal.lan> <20071202221418.6f269022@absurd>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071202221418.6f269022@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sun, 2 Dec 2007, Janek Kozicki wrote:

> Justin Piszcz said:     (by the date of Sun, 2 Dec 2007 04:11:59 -0500 (EST))
>
>> The badblocks did not do anything; however, when I built a software raid 5
>> and the performed a dd:
>>
>> /usr/bin/time dd if=/dev/zero of=fill_disk bs=1M
>>
>> I saw this somewhere along the way:
>>
>> [42332.936706] ata5.00: spurious completions during NCQ issue=0x0
>> SAct=0x7000 FIS=004040a1:00000800
>> [42333.240054] ata5: soft resetting port
>
> I know nothing about NCQ ;) But I find it interesting that *slower*
> access worked fine while *fast* access didn't.
>
> If I understand you correctly:
>
> - badblocks is slower, and you said that it worked flawlessly, right?
> - getting from /dev/zero is the fastest thing you can do, and it fails...
>
> I'd check jumpers on HDD and if there is any, set it to 1.5 Gb speed
> instead of default 3.0 Gb. Or sth. along that way. I remember seeing
> such jumper on one of my HDDs (I don't remember the exact speed
> numbers though).
>
> Also on one forum I remember about problems occurring when HDD was
> working at maximum speed, which was faster than the IO controller
> could handle.
>
> I dunno. It's just what came to my mind...
> -- 
> Janek Kozicki                                                         |
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Thanks for the suggestions, but BTW NCQ OFF on (raptors anyway) is 30 to 
50 megabytes per second faster in a RAID 5 configuration.  NCQ slows 
things down for those disks.

There are no jumpers (by default) on the 750GB WD Caviar's btw..

So far with NCQ off I've been pounding the disks and have not been able to 
reproduce the error but with NCQ on and some DD's or some raid creations, 
it is reproducible (or appears to be)-- did it twice.

Justin.
