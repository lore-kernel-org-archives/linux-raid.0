From: Joe Landman <joe.landman@gmail.com>
Subject: Re: /dev/md2 stopped after changing SAS controller
Date: Sun, 15 May 2011 10:29:11 -0400
Message-ID: <4DCFE337.7090306@gmail.com>
References: <20110513202900.GA1926@apartia.fr> <4DCE99D0.1010900@hardwarefreak.com> <20110514151812.GA3074@apartia.fr> <4DCEC7C0.80306@hardwarefreak.com> <20110514191532.GA15753@apartia.fr> <4DCF12E1.1020809@hardwarefreak.com> <alpine.DEB.2.00.1105150922510.20305@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1105150922510.20305@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/15/2011 03:26 AM, Mikael Abrahamsson wrote:
> On Sat, 14 May 2011, Stan Hoeppner wrote:
>
>>
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16816101358
>> http://www.supermicro.com/manuals/other/AOC-SASLP-MV8.pdf
>>
>> Simple JBOD only HBA, no fakeRAID. Uses a Marvell 88SE6480 chip, 8
>> SAS/SATA ports via two SFF8087. $110 USD. I've heard minor rumblings
>> WRT the mvsas driver though I don't recall specifics. The board itself
>> is good quality, as with most things SuperMicro.
>
> MINOR!??? I've had this card for 1.5 years, it still not usable (as far
> as I can discern) as of 2.6.38. Do NOT buy it. Please stop recommending
> this card for Linux use unless it's to your enemies.

+1 to Mikael

We have a number of these.  They are pretty much useless.  We *do not 
recommend them for any purpose whatsoever*.  We got them to test, and 
they were and are wastes of money.

Again, this is why making sure that the bona fides of those making 
recommendations don't begin and end with a google search ...

>
> Buy a 1068E (3081E) based card, they've been working fine for a long time.
>

+1 on that.  We like the 3081E, and the 9211-8i for these purposes. 
Both work quite well.

Again, ignore these cards, they will absorb your money and your time.



-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics, Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
