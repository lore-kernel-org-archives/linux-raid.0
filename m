From: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Subject: Re: Hardware advice for software raid
Date: Mon, 7 Apr 2014 14:28:09 -0500
Message-ID: <CAPSPcXi+RHQMtRA0v61dKH6jSnNgKAKK_1XvqnHe7hqsV2ZrPg@mail.gmail.com>
References: <CAPSPcXjo5J-Omj+94RkKPXSNUwBHT4GWKmkYuWV9htniZNf+sw@mail.gmail.com>
	<533BDB79.7020902@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <533BDB79.7020902@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sorry for the delay, I didn't want to reply until I got time to get
down into the machine and do some research.

On Tue, Apr 1, 2014 at 2:43 PM, Scott D'Vileskis <sdvileskis@gmail.com> wrote:
> I would take a close look at your motherboard's capacitors and make
> sure none are bulging.

I checked and none that I can see are visibly bulging.

> Additionally, it might be worth running a memtest overnight, although
> bad memory would only be responsible if you heavy IO also came with
> heavy memory usage.

I have actually run memtest for 48 hours since this started happening
and not found any problem with the memory.
That was my first thought too though.



On Wed, Apr 2, 2014 at 4:42 AM, Stan Hoeppner <stan@hardwarefreak.com> wrote:

> There are 6 models of the Asrock z77.  All but one contain a PCH
> heatsink designed to look cool rather than properly cool the chip.  The
> Asrock z77 Extreme 11 has a fan so is an exception, and also has an
> onboard 8 port LSI SAS controller (9211-8i), so I assume you do not have
> the Extreme 11.

 Mine is the Z77 Extreme4, picture below.


> With consumer PC hardware random lockups occurring only under heavy disk
> IO are most often the result of thermal buildup in the PCH (Northbridge)
> chip.  This can occur when all the drives are connected to its SATA
> ports as in your case, but it can also occur when using one or more
> SAS/SATA HBAs if the PCIe slots are connected through the PCH.  The odds
> are very good that your lockups are a result of the poor PCH heatsink
> design on the Asrock boards exacerbated by insufficient case airflow
> across the heatsink.  What case is this z77 board in?  Be specific
> please so I can pull up the schematic.

The case is an NZXT H2.  It has all (and only) the stock fans running.

Overheating would fit the way it is fine until a long heavy operation,
and even then doesn't crash until a random time a ways into the
operation.
Much of the hardware stuff is outside of my domain of knowledge which
is why I was leaning towards buying new equipment.

Is the PCH the part I circled in yellow?  http://i.imgur.com/safg5iW.jpg

I've been doing a lot of googling and and see that the northbridge is
usually between the PCIe slot and the CPU but there doesn't seem to be
any large object in that place on this board.
Can you confirm this is the proper part for me to measure for a new heatsink?

Thanks
