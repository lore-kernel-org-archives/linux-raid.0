From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Any inexpensive hardware recommendations for PCI interface
 cards?
Date: Fri, 8 Feb 2008 14:40:01 -0500 (EST)
Message-ID: <alpine.DEB.1.00.0802081439120.11577@p34.internal.lan>
References: <11ae01c86a44$aff357a0$0603a8c0@meanmachine> <47AC5162.4080700@tmr.com> <alpine.DEB.1.00.0802080854390.11577@p34.internal.lan> <20080208190147.GA24083@teal.hq.k1024.org> <alpine.DEB.1.00.0802081423040.11577@p34.internal.lan>
 <20080208193834.GB24083@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080208193834.GB24083@teal.hq.k1024.org>
Sender: linux-raid-owner@vger.kernel.org
To: Iustin Pop <iusty@k1024.org>
Cc: Bill Davidsen <davidsen@tmr.com>, Steve Fairbairn <steve@fairbairn-family.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 8 Feb 2008, Iustin Pop wrote:

> On Fri, Feb 08, 2008 at 02:24:15PM -0500, Justin Piszcz wrote:
>>
>>
>> On Fri, 8 Feb 2008, Iustin Pop wrote:
>>
>>> On Fri, Feb 08, 2008 at 08:54:55AM -0500, Justin Piszcz wrote:
>>>> The promise tx4 pci works great and supports sata/300+ncq/etc $60-$70.
>>>
>>> Wait, I have used tx4 pci up until ~2.6.22 and it didn't support AFAIK
>>> ncq. Are you sure that current driver supports NCQ? I might then revive
>>> that card :)
>>>
>>> thanks,
>>> iustin
>>>
>>
>> Whoa nice catch, I meant the Promise 300 TX4 which now retails for $59.99
>> w/free ship.
>>
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16816102062
>
> :)
>
> Actually, I exactly meant Promise 300 TX4 (the board is in my hand: chip
> says PDC40718). The HW supports NCQ, but the linux sata_promise driver
> didn't support NCQ when I tested it. Can someone confirm it does today
> (2.6.24) NCQ?
>
> iustin
>

I used the board with a Seagate 400GiB/NCQ drive and I recall seeing Port 
Up 3.0Gbps/NCQ (31/32) within the scrolling text upon boot--
but it was awhile ago.

Justin.
