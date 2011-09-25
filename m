From: "Marcin M. Jessa" <lists@yazzy.org>
Subject: Re: Green drives and RAID arrays with partity
Date: Mon, 26 Sep 2011 00:21:10 +0200
Message-ID: <4E7FA956.9000501@yazzy.org>
References: <4E7F0A31.4070001@yazzy.org> <4E7F13E8.4080606@hardwarefreak.com> <4E7F3A80.7010308@yazzy.org> <4E7F40A4.6040704@hardwarefreak.com>
Reply-To: lists@yazzy.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7F40A4.6040704@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/25/11 4:54 PM, Stan Hoeppner wrote:

> Are the drives screwed into the case's internal drive cage?
Yes.

>Directly
> connected to the motherboard SATA ports with cables?

Yes. I've 6 SATA3 ports on the motherboard and the drives are connected 
directly.

>Or, do you have the
> drives mounted in any kind of SATA hot/cold swap cage? The cheap ones of
> these are notorious for causing exactly the kind of drop outs you've
> experienced. Post a link to your case and any drive related peripherals.

I don't have a hot/cold swap cage. This is my case: 
http://www.fractal-design.com/?view=product&category=2&prod=54

> Did you suffer a power event? I.e. a sag, brown out?

No, nothing like that.

>Is the system
> connected to a good quality working UPS?

It is connected to an UPS but not an expensive one.

> Something else you should always mention: How long did it all "just
> work" before having problems? A few hours? Days? Weeks? Months?

Two of the drives were falling out of the array pretty often.
My motherboard has a built in RAID controller which I do not use.
To begin with the BIOS settings were set to recognize drives as IDE 
resulting in two of the drives connected to SATA 1 and SATA 2 ports were 
failing and dropping off the array.
They would show as UDMA/100 drives whereas the other drives were showing as
SATA link up 6.0 Gbps (SStatus 133 SControl 300)
ATA-8: ST2000DL003-9VT166, CC32, max UDMA/133
I changed this BIOS setting and all the drives have been recognized as 
the same with the same speed.
I also bought new SATA cables for the failing drives, specifically for 
SATA 3. That did not help and the drives kept on failing (maybe once a 
week?). These 2 drives always failed at about the same time.

Shortly after a 3rd. drive failed leaving me with a broken Raid array.

>Had you
> made any hardware changes to the system recently before the failure
> event?
No, there were no changes.

If so what? Did you upgrade your kernel/drivers recently, or any
> software in the storage stack? Is the PSU flaky? How old is it? A flaky
> PSU can drop drives out of arrays like hot potatoes when there is heavy
> access and thus heavy current draw.

The PSU should be fine. I pulled it off a working server which had been 
stable for long time.



-- 

Marcin M. Jessa
