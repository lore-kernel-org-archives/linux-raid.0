From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.23.9 / P35 Chipset + WD 750GB Drives (reset port)
Date: Sun, 2 Dec 2007 16:32:26 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712021630070.5379@p34.internal.lan>
References: <Pine.LNX.4.64.0712010619150.25643@p34.internal.lan>
 <Pine.LNX.4.64.0712011310410.30316@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0712010722590.28887@p34.internal.lan> <20071201174733.646a5c35@absurd>
 <Pine.LNX.4.64.0712011155110.6257@p34.internal.lan>
 <Pine.LNX.4.64.0712020409280.30169@p34.internal.lan> <20071202221418.6f269022@absurd>
 <475322B5.9020504@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <475322B5.9020504@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 3 Dec 2007, Michael Tokarev wrote:

>> Justin Piszcz said:     (by the date of Sun, 2 Dec 2007 04:11:59 -0500 (EST))
>>
>>> The badblocks did not do anything; however, when I built a software raid 5
>>> and the performed a dd:
>>>
>>> /usr/bin/time dd if=/dev/zero of=fill_disk bs=1M
>>>
>>> I saw this somewhere along the way:
>>>
>>> [42332.936706] ata5.00: spurious completions during NCQ issue=0x0
>>> SAct=0x7000 FIS=004040a1:00000800
>>> [42333.240054] ata5: soft resetting port
>
> There's some (probably timing-related) bug with spurious completions
> during NCQ.  Alot of people are seeing this same effect with different
> drives and controllers.  Tejun is working on it.  It's different to
> reproduce.
>
> Search for "spurious completion" - there are many hits...
>
> /mjt
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Thanks will check it out.
