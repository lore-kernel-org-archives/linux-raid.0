From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: /dev/md2 stopped after changing SAS controller
Date: Sun, 15 May 2011 09:26:24 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1105150922510.20305@uplift.swm.pp.se>
References: <20110513202900.GA1926@apartia.fr> <4DCE99D0.1010900@hardwarefreak.com> <20110514151812.GA3074@apartia.fr> <4DCEC7C0.80306@hardwarefreak.com> <20110514191532.GA15753@apartia.fr> <4DCF12E1.1020809@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DCF12E1.1020809@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 14 May 2011, Stan Hoeppner wrote:

>
> http://www.newegg.com/Product/Product.aspx?Item=N82E16816101358
> http://www.supermicro.com/manuals/other/AOC-SASLP-MV8.pdf
>
> Simple JBOD only HBA, no fakeRAID.  Uses a Marvell 88SE6480 chip, 8
> SAS/SATA ports via two SFF8087.  $110 USD.  I've heard minor rumblings
> WRT the mvsas driver though I don't recall specifics.  The board itself
> is good quality, as with most things SuperMicro.

MINOR!??? I've had this card for 1.5 years, it still not usable (as far as 
I can discern) as of 2.6.38. Do NOT buy it. Please stop recommending this 
card for Linux use unless it's to your enemies.

Buy a 1068E (3081E) based card, they've been working fine for a long time.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
