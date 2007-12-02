From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Kernel 2.6.23.9 / P35 Chipset + WD 750GB Drives (reset port)
Date: Mon, 03 Dec 2007 00:25:09 +0300
Message-ID: <475322B5.9020504@msgid.tls.msk.ru>
References: <Pine.LNX.4.64.0712010619150.25643@p34.internal.lan>	<Pine.LNX.4.64.0712011310410.30316@fbirervta.pbzchgretzou.qr>	<Pine.LNX.4.64.0712010722590.28887@p34.internal.lan>	<20071201174733.646a5c35@absurd>	<Pine.LNX.4.64.0712011155110.6257@p34.internal.lan>	<Pine.LNX.4.64.0712020409280.30169@p34.internal.lan> <20071202221418.6f269022@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071202221418.6f269022@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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

There's some (probably timing-related) bug with spurious completions
during NCQ.  Alot of people are seeing this same effect with different
drives and controllers.  Tejun is working on it.  It's different to
reproduce.

Search for "spurious completion" - there are many hits...

/mjt
