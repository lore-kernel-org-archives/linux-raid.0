From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Hardware advice for software raid
Date: Mon, 07 Apr 2014 22:53:25 -0500
Message-ID: <534372B5.6010506@hardwarefreak.com>
References: <CAPSPcXjo5J-Omj+94RkKPXSNUwBHT4GWKmkYuWV9htniZNf+sw@mail.gmail.com>	<533BDB79.7020902@hardwarefreak.com> <CAPSPcXi+RHQMtRA0v61dKH6jSnNgKAKK_1XvqnHe7hqsV2ZrPg@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPSPcXi+RHQMtRA0v61dKH6jSnNgKAKK_1XvqnHe7hqsV2ZrPg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Barrett Lewis <barrett.lewis.mitsi@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/7/2014 2:28 PM, Barrett Lewis wrote:
> Sorry for the delay, I didn't want to reply until I got time to get
> down into the machine and do some research.
...
> On Wed, Apr 2, 2014 at 4:42 AM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> 
>> There are 6 models of the Asrock z77.  All but one contain a PCH
>> heatsink designed to look cool rather than properly cool the chip.  The
>> Asrock z77 Extreme 11 has a fan so is an exception, and also has an
>> onboard 8 port LSI SAS controller (9211-8i), so I assume you do not have
>> the Extreme 11.
> 
>  Mine is the Z77 Extreme4, picture below.

Yep, same as all Z77s but for the Extreme 11.

>> With consumer PC hardware random lockups occurring only under heavy disk
>> IO are most often the result of thermal buildup in the PCH (Northbridge)
>> chip.  This can occur when all the drives are connected to its SATA
>> ports as in your case, but it can also occur when using one or more
>> SAS/SATA HBAs if the PCIe slots are connected through the PCH.  The odds
>> are very good that your lockups are a result of the poor PCH heatsink
>> design on the Asrock boards exacerbated by insufficient case airflow
>> across the heatsink.  What case is this z77 board in?  Be specific
>> please so I can pull up the schematic.
> 
> The case is an NZXT H2.  It has all (and only) the stock fans running.

This case seems to have a have a decent airflow design.

> Overheating would fit the way it is fine until a long heavy operation,
> and even then doesn't crash until a random time a ways into the
> operation.
> Much of the hardware stuff is outside of my domain of knowledge which
> is why I was leaning towards buying new equipment.

Replacing the heatsink is low cost, low risk.  If it doesn't fix the
problem and you end up replacing the mobo you can likely use it on the
new board's PCH as well.

> Is the PCH the part I circled in yellow?  http://i.imgur.com/safg5iW.jpg

Yep, that's it.  Notice the aesthetic cover attached over the heat sink
fins?  The aluminum heatsink under it has high thermal resistance due to
being aluminum and having a small fin surface area.  That cover
increases the thermal resistance further by preventing airflow from
reaching the fins.  Couple this with the fact that low quality thermal
interface material (TIM, paste, tape) is used on factory installed mobo
chipset heatsinks, and this demonstrates why the chip is likely getting
too hot under IO load.

> I've been doing a lot of googling and and see that the northbridge is
> usually between the PCIe slot and the CPU but there doesn't seem to be
> any large object in that place on this board.

Due to ever increasing integration, most mobos today have a single
system support chip in place of the previous north/south bridge duo.
Aftermarket heatsinks are typically sized such that larger units are for
the "northbridge" and smaller units for the "southbridge".
"Northbridge" heatsinks are typically used for single chip systems as
the mounting footprint and thermal output are similar.

> Can you confirm this is the proper part for me to measure for a new heatsink?

I can.  It is.

Do not attempt this with the system running.  Power down, remove all
external cables and sit the chassis on a table.  Ground yourself by
touching the chassis or a metal table leg, etc, to discharge any static
from your body.

Measure between the approximate centers of the two spring loaded plastic
mounting tabs.  You don't need an exact measurement to 1mm, but a
ballpark.  The hole spacing is fairly standardized by the industry.
Your measurement should fall into one of 3 ranges, and this will dictate
which heatsink you buy:

47.5 - 53mm
53   - 59mm
59   - 63mm

Let me know the measurement and I'll recommend the best unit for your
application.  It seems you won't be using all of your expansion slots
any time soon so going with a taller passive unit shouldn't be a
problem.  A taller/larger passive unit in a case with good airflow is
preferable to a low profile unit w/fan due to 2/3:1 greater mass, no fan
to fail, no noise.  After you select the heatsink I'll give you tips on
removing the current one and installing the new one.  Proper
installation is more important than which heatsink you install, as doing
it wrong may result in higher temperatures than what you have now.

As always, the devil is in the details.

Cheers,

Stan

