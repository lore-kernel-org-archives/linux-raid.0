From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Recommended pci-e 1x SATA cards.
Date: Sun, 17 Apr 2011 15:26:25 -0500
Message-ID: <4DAB4CF1.8050409@hardwarefreak.com>
References: <4DA6CCFE.8020708@crc.id.au> <20110414185304.5bc1cca5@natsu> <4DA6F3B2.8080402@crc.id.au> <4DA7513C.5020505@hardwarefreak.com> <20110415105846.1c4ec630@natsu> <4DA8B91C.8050005@hardwarefreak.com> <20110416111554.09066e73@natsu> <4DA959E4.2080605@fnarfbargle.com> <4DA9FED8.2000308@hardwarefreak.com> <4DAA7E46.6040309@fnarfbargle.com> <4DAB3344.2090502@hardwarefreak.com> <alpine.DEB.2.00.1104172042570.14027@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1104172042570.14027@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, Roman Mamedov <rm@romanrm.ru>, Steven Haigh <netwiz@crc.id.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Abrahamsson put forth on 4/17/2011 1:45 PM:
> On Sun, 17 Apr 2011, Stan Hoeppner wrote:
> 
>> The fact that the Russian with 5 cards purchased in Dubai could
>> routinely demonstrate this problem with 2 of 5 identical cards, and
>> never on the other 3, points directly to a board QC isue.  Again, if
>> the problem were a design flaw in the IC itself, all 5 cards would
>> have exhibited the problem.
> 
> I think you're missing the point.

/me laughs.  I'm guessing that's because you're very late to this thread.

> A proper hardware design should detect errors in the chip, and should
> offline itself (or at least complain loudly). This is robustness in
> design, that if something goes wrong in the production process that QC
> doesn't find, card notices this and goes offline.

NOBODY in the PCB add-in card biz does this, except maybe in the
mainframe space.  You seem to be missing the fact that the SATA IC cost
$50 million (example) to bring to market in R&D and manufacturing cost.

The amount of money an individual board maker puts into his product to
which he solders this SATA IC is maybe $50k.  He uses the chip
producer's reference diagram to reduce his own R&D costs to the minimum
required.  THEN, he starts cutting corners, using cheap caps, resistors,
etc that don't meet the specifications set forth by the chip maker.
This is why you have 2/5 identical cards with a problem, and 3/5 that
don't.  Some of the components meet voltage/current specs, some don't.

> I personally have two of these controllers and they're working well, but
> I have to agree that it's very likely that these low-cost products are
> not as resilient to problems as the more expensive devices out there.

Not once have I stated that cheap cards are a "good" solution, whether
based on SiI, JMicron, or Marvell ICs.  The OP in Australia "demanded" a
cheap 2 port PCIe SATA card, and I recommended a SiI 3132 based card.
SiI was blanketly attacked, by one poster anyway, I defended it, and
rightfully so.  The chips themselves (current product anyway) are fine.
 Many cards based on them have QC issues, which is not news to anyone in
this game more than a few years.  Many cheap cards based on Marvell and
JMicron chips have QC issues as well.  The problem here isn't the SATA
IC but the QC of the $15-25 USD card.

Again, I'm not sure what "point" you believe I'm missing.  My hardware
experience likely puts me in the 90th percentile or above of members of
this list.  I've seen the manufacturing supply chain of both ultra cheap
and more expensive product for over 15 years.  I've seen disk
controllers, video cards, etc, from two manufacturers based on the same
IC.  The ultra cheap ones often experience problems the higher dollar
units due not.  This has been going on in this industry for 30 years.

The problem is almost never a design flaw with the main IC (whether
SCSI, SATA, GPU, etc), but almost always the board implementation.  The
big money is in the ICs, and they have high QC.  Board (PCB)
manufacturing cost is often $0.50 USD/board or less.  If all $0.50 of
that board making was QC, is that sufficient? (rhetorical)

-- 
Stan

