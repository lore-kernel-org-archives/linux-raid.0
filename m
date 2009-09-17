From: John Bridges <john.bridges@gmail.com>
Subject: Re: recommended 4port SATA controller ?
Date: Thu, 17 Sep 2009 14:37:09 -0700
Message-ID: <fa3b69580909171437s1074d7daqc4df84580ac9a9c3@mail.gmail.com>
References: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm a fan of the SuperMicro AOC-SAT2-MV8, great card.
http://www.supermicro.com/products/accessories/addon/AOC-SAT2-MV8.cfm

It's an 8 port PCI-X card, works in both PCI and PCI-X slots.

SATA2

Drivers for Linux are stable, built in.

You can disable the BIOS to put a LOT of cards into a single machine
(I have four in one machine).

Costs about $100

http://www.newegg.com/Product/Product.aspx?Item=3DN82E16815121009

Reliable card from a real company.


On Thu, Sep 17, 2009 at 4:44 AM, Rainer Fuegenstein
<rfu@kaneda.iguw.tuwien.ac.at> wrote:
> hi,
>
> I need to move my 4 disk raid5 array from a motherboard with 4 onboar=
d SATA
> ports to a mainboard with just 2 ports. therefore I'm looking for a r=
eliable
> and inexpensive 4port PCI controller.
>
> the less raid features it has the better since I fear that a raid con=
troller
> may initially write some management informationen (signatures etc.) t=
o the
> disks and therefore damage the linux raid5 setup.
>
> And, if possible, it should have low power consumption since it is ab=
out to
> be used in a small server powered by photovoltaic panels.
>
> any recommendations aprreciated.
>
> thanks and best regards.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
