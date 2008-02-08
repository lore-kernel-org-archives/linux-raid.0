From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Any inexpensive hardware recommendations for PCI interface
 cards?
Date: Fri, 8 Feb 2008 08:54:55 -0500 (EST)
Message-ID: <alpine.DEB.1.00.0802080854390.11577@p34.internal.lan>
References: <11ae01c86a44$aff357a0$0603a8c0@meanmachine> <47AC5162.4080700@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47AC5162.4080700@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Steve Fairbairn <steve@fairbairn-family.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 8 Feb 2008, Bill Davidsen wrote:

> Steve Fairbairn wrote:
>> Can anyone see any issues with what I'm trying to do?
>> 
>
> No.
>
>> Are there any known issues with IT8212 cards (They worked as straight
>> disks on linux fine)?
>> 
>
> No idea, don't have that card.
>
>> Is anyone using an array with disks on PCI interface cards?
>> 
>
> Works. I've mixed PATA, SATA, onboard, PCI, and firewire (lack of controllers 
> is the mother of invention). As long as the device under the raid works, the 
> raid should work.
>
>> Is there an issue with mixing motherboard interfaces and PCI card based
>> ones?
>> 
>
> Not that I've found.
>
>> Does anyone recommend any inexpensive (probably SATA-II) PCI interface
>> cards?
>> 
>
> Not I. Large drives have have cured me of FrankenRAID setups recently, other 
> than to build little arrays out of USB devices for backup.
>
> -- 
> Bill Davidsen <davidsen@tmr.com>
> "Woe unto the statesman who makes war without a reason that will still
> be valid when the war is over..." Otto von Bismark 
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

The promise tx4 pci works great and supports sata/300+ncq/etc $60-$70.

Justin.
