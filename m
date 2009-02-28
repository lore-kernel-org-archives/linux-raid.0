From: Brad <brad46526@gmail.com>
Subject: Re: System hangs on raid md recovery/resync - revisit
Date: Sat, 28 Feb 2009 20:41:37 +1000
Message-ID: <da290bd50902280241y4102d5c3p73ce506b4195e5e9@mail.gmail.com>
References: <da290bd50902271732m54a32ad6r5797f618f5af7d7@mail.gmail.com>
	 <alpine.DEB.2.00.0902280407520.17966@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0902280407520.17966@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Feb 28, 2009 at 7:08 PM, Justin Piszcz <jpiszcz@lucidpixels.com=
> wrote:
>
> On Sat, 28 Feb 2009, Brad wrote:
>
>> Hi. =A0I'd like to revisit a problem I put to the mailing list on th=
e
>> 27th July 2008.
>>
>> My linux system hangs if I have a lengthy recovery of a raid-1
>> device going on at the same time as any significant network
>> traffic.
>> ...
>
> I have the same mobo:
>
> Handle 0x0001, DMI type 1, 27 bytes
> System Information
> =A0 =A0 =A0 =A0Manufacturer: Gigabyte Technology Co., Ltd.
> =A0 =A0 =A0 =A0Product Name: P35-DS4

How did you get that information, please?  Another linux command
for me to learn?!  :-)

> Have a RAID1 and RAID5, I do not use the jmicron SATA ports, only the=
 intel
> ones and add-on pci-e cards, never had any problems with the raid vol=
umes.
> =A0The NIC is sort of flaky though [in linux], I recommend using an i=
ntel
> pci-e 1gbps card.

I've had another problem with the Realtek network driver ... under netw=
ork
load it seemed to miss interrupts and/or pass them to the IDE driver, w=
hich
would print out errors about unexpected/unknown interrupts.  I had to t=
ake
IDE out of my kernel.

I *think* my current hanging problem was even worse when the pata_jmicr=
on
driver module - which I need to use the ATA DVD drive connected to one =
of the
JMicron's IDE ports - shared the same interrupt as the Realtek driver. =
 I
couldn't find a way to change interrupts (can one do that at will with =
the
Linux kernel?) so my backup script unloads the pata_jmicron module
before it attaches the third backup disk to the md1 array.

But it still hangs if there's any significant network traffic.  Maybe,
even though I've gotten rid of anything using the same IRQ as the
Realtek - IDE or pata_jmicron - the NIC driver is still flubbing interr=
upts
and that's confusing the kernel?

Thanks for the advice Justin.  Maybe the solution is to abandon use
of the Realtek NIC (a pity to 'waste' what's freely available on the
motherboard, though, in a way).


Brad
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
