From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Typical RAID5 transfer speeds
Date: Sun, 20 Dec 2009 17:18:56 -0800
Message-ID: <4877c76c0912201718l6d7ab948q4c57a07109678cb5@mail.gmail.com>
References: <B26AD6F5-45F6-4CC6-AE63-E4253E60076C@mac.com>
	 <4B2D4731.3090702@gmail.com>
	 <4877c76c0912192021s2c3da63au57f5dcb0391b3eb3@mail.gmail.com>
	 <4B2E6CDB.3000707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B2E6CDB.3000707@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: Matt Tehonica <matt.tehonica@mac.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Dec 20, 2009 at 10:28 AM, Roger Heflin <rogerheflin@gmail.com> =
wrote:
> Michael Evans wrote:
>>
>> On Sat, Dec 19, 2009 at 1:35 PM, Roger Heflin <rogerheflin@gmail.com=
>
>> wrote:
>>>
>>> Matt Tehonica wrote:
>>>>
>>>> I have a 4 disk RAID5 using a 2048K chunk size and using XFS files=
ystem.
>>>> =A0Typical file size is about 2GB-5GB. I usually get around 50MB/s=
ec
>>>> transfer
>>>> speed when writting files to the array. Is this typcial or is it b=
elow
>>>> normal? =A0A friend has a 20 disk RAID6 using the same filesystem =
and
>>>> chunk
>>>> size and gets around 150MB/sec. Any input on this??
>>>>
>>>> Thanks,
>>>> Matt
>>>
>>> Speed depends on how the disks are connected to the system, and how=
 many
>>> disks there are per connection, and what kind of disks they are.
>>>
>>> If your friend had a 20 disk raid6 on one 4port sata pci-32bit/33mh=
z card
>>> with port multipliers his total throughput would be <110mb/second r=
eads
>>> or
>>> writes, if your friend had 20 disks on 10+ port pcie-x16 cards his =
total
>>> possible speed would be much much higher, reads would be expected t=
o be
>>> 18x(rawdiskrate) if the machine could handle it.
>>>
>>> Also newer disks are faster than older disks.
>>>
>>> 1.5tb disks read/write at 125-130+ MB/second on a fast port.
>>> 1.5tb disks read/write at 75-80 MB/second on a PCI-32bit/33mhz port=
=2E
>>> 500gb disks read/write at 75-80 MB/second on a PCI-32bit/33mhz port=
=2E
>>> 250gb disks read/write at 50-55 MB/second on a fast port.
>>>
>>> And those PCI-32bit/33mhz ports are with only a single disk, put mo=
re
>>> than
>>> one on there, and the io rates drop...so 2 disk on pci-32bit/33mhz =
(old
>>> PCI)
>>> port will have <50MB/second each no matter how fast the disk is, pu=
t 3 on
>>> there and each disk is down to 33mhz, 4 25MB/second or less.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>> Speaking of 16x 16 port cards, why is it that it's so difficult to
>> find an 8 or 16 port 4 or 8/16x pcie adapter? =A0A good 1xpci-e to 2=
x
>> SATA costs like 25 to 50 USD. =A0Given the reduction in duplicate
>> components, it should not be hard to make a card with 8 ports for 10=
0
>> USD or less right? =A0I don't even want any intelligence, just norma=
l
>> disk to PCI-E lane connectin would be fine.
>>
>
> I am pretty sure it is lack of need.
>
> I believe someone mentioned supermicro has a 8 port pcie-x4 card, tha=
t is in
> the $100 range, but the driver for it is kind of new and has some iss=
ues at
> this time.
>

Wow, I had no idea these even existed (but I now know that I have to
use -really- specific search terms to find them).

The searches,

8-port pci-e OR pciexpress OR pci-express
16-port pci-e OR pciexpress OR pci-express

yield the desired results on Google's product search, though there
seems to be only one manufacturer, and only one seller currently.  I
guess most people building >6 drive arrays have the cash to waste on
limited boxed solutions or higher-end hardware controllers that
abstract the details (and often flexibility) from the system.

I'll have to remember the search for the next time I buy
upgrade/replacement hardware.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
