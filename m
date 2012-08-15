From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: OT: silent data corruption reading from hard drives
Date: Wed, 15 Aug 2012 22:55:43 +0100
Message-ID: <20524.6904.183888.747899@tree.ty.sabi.co.UK>
References: <50191ADE.10809@fastmail.fm>
	<5019D052.4000409@hardwarefreak.com>
	<20120802091917.32fb0ca5@natsu>
	<501A316C.3020305@hardwarefreak.com>
	<20120802140634.6f729d07@natsu>
	<1343926790.28421.140661109896017.1A222237@webmail.messagingengine.com>
	<501AB9D8.1030404@turmel.org>
	<1343932322.14845.140661109934445.709DABBB@webmail.messagingengine.com>
	<501BD3E6.6050004@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <501BD3E6.6050004@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

> In my opinion, any corruption noticed in a non-ECC system is
> most likely due to the RAM.

That's pretty common, but many disk drive models also have bugs,
and most hw RAID host adapters have many (terrible) bugs.

> You really need to run memtest86 on your system, preferably
> for 24 hours or more.

Even that is not conclusive. Some "memory" errors are due to
activity/noise spikes on the PCI/PCIe bus due to hw bugs or
poorly electrically designed cards.

>>> Hard drives write extensive ECC payloads to catch
>>> corruptions there; SATA and SAS protocols have CRC checks on
>>> every frame transferred;

A warning to the masses: USB mass storage is weak as to this and
in particular as to error recovery, and most USB chipsets
(especially USB-drive ones, but also motherboard ones) are
massively buggy.

>>> the PCIe bus uses CRC checks on each lane, with low-level
>>> encoding very similar to SATA.  Even modern processors are
>>> using PCIe-style encoded [ ... ]

> [ ... ] machine handling data you really care about

... should have end-to-end verification, that is the data itself
should be checksummed at least to detect corruption. For example
by putting it into checksummed containers (even just ZIP without
compression).

> should have ECC ram.

Oh yes, and any machine should have ECC RAM as the cost is
really modest. Unfortunately the usual evil marketers like to
segment artificially the market into cheap stuff without ECC and
premium stuff with ECC, and will not put ECC into cheap stuff to
avoid tempting business customers to buy it instead of the
premium stuff.
