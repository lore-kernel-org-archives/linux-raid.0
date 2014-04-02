From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Hardware advice for software raid
Date: Wed, 02 Apr 2014 04:42:17 -0500
Message-ID: <533BDB79.7020902@hardwarefreak.com>
References: <CAPSPcXjo5J-Omj+94RkKPXSNUwBHT4GWKmkYuWV9htniZNf+sw@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPSPcXjo5J-Omj+94RkKPXSNUwBHT4GWKmkYuWV9htniZNf+sw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Barrett Lewis <barrett.lewis.mitsi@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/1/2014 2:09 PM, Barrett Lewis wrote:
> I have a dedicated, consumer hw, media/file server with a 6 drive
> raid6 of 2tb drives, all plugged directly into the sata ports on my
> motherboard, an asrock z77. =20

There are 6 models of the Asrock z77.  All but one contain a PCH
heatsink designed to look cool rather than properly cool the chip.  The
Asrock z77 Extreme 11 has a fan so is an exception, and also has an
onboard 8 port LSI SAS controller (9211-8i), so I assume you do not hav=
e
the Extreme 11.

> A while back I had a problem which seemed
> like cascade failure of drives, but Stan Hoeppner and Phil Turmel
> helped me to figure out it was a PSU having gone bad and delivering
> dirty power.
>=20
> After replacing the PSU things worked fine, or so I thought.  At some
> point I noticed I have quite a bit of trouble making it through a
> resync without the machine locking up.  When I realized it wasn't tie=
d
> to a resync in particular but any extended heavy I/O, I lowered the
> sync_speed_max to 10,000, I was able to get through a repair (no
> mismatches found!).

With consumer PC hardware random lockups occurring only under heavy dis=
k
IO are most often the result of thermal buildup in the PCH (Northbridge=
)
chip.  This can occur when all the drives are connected to its SATA
ports as in your case, but it can also occur when using one or more
SAS/SATA HBAs if the PCIe slots are connected through the PCH.  The odd=
s
are very good that your lockups are a result of the poor PCH heatsink
design on the Asrock boards exacerbated by insufficient case airflow
across the heatsink.  What case is this z77 board in?  Be specific
please so I can pull up the schematic.

Regardless of case the solution is straightforward and inexpensive:
install a low profile solid copper active cooler, such as this one:

http://www.frozencpu.com/products/6717/vid-102/Enzotech_SLF-1_Forged_Co=
pper_Northbridge_Southbridge_Low-Profile_Heatsink.html?tl=3Dg40c16s501

The SLF-1 has 53-59mm hole spacing.  Asrock doesn't provide such
information in their manual and after 30 minutes I can't find forum
posts or other sources presenting this info.  Measure your PCH heatsink
mounting hole spacing before ordering.  If it's less than 53mm
center-to-center you need the SLF-30, and if it's more than 59mm you
need the SLF-40.  If you think your case airflow over the PCH is
actually greater than zero you can go with the CNB-R1 passive unit whic=
h
has 3 mounting rings to fit all hole spacings.  But with it you lose tw=
o
expansion slots.  Here's the product lineup:

http://www.enzotechnology.com/air_cooling.htm

There are other brands.  Enzo products are solid copper and compact,
with these 3 fan models fitting under your PCIe cards.  You lose no PCI
slots as with nearly all other chipset coolers.  I recommend them
because they are high quality and work well, which is why they are also
more expensive than most others.  That being the case, ~$35 including
shipping is a small sum to part with to eliminate the lockups.

> I'm guessing that the motherboard has some problem (perhaps
> originating from the bad PSU?), and I want to switch to a dedicated
> HBA card to make this more modular.

The one glaring problem is the woefully inadequate PCH heatsink.
Replacing it as suggested will very likely eliminate the lockups, for
about 1/8th the cost of a discrete LSI HBA.  And if it doesn't you will
still have increased the lifespan of the PCH chip by at least a couple
of years due to lowering operating temperature by 10-15=B0C or more.

> Stan had suggested the LSI SATA/SAS 9211-8i in many threads in the
> archives.  If I use this card as my HBA, is there any particular
> motherboard which would be better suited than others?

Wait and cross this bridge later.  If it turns out this board has other
problems that we can't identify and fix, there's a micro-ATX Intel
server board with 6 SATA-2 ports on the PCH, socket LGA 1155, dual Inte=
l
GbE ports, integrated video, etc for ~$160 at Newegg.  Your CPU,  RAM,
and drives will drop right in, and you won't have to spend another $200
on the LSI.  It'll save you ~$150 overall compared to a consumer board+=
LSI.

Cheers,

Stan


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
