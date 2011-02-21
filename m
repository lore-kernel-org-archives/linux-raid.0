From: Doug Dumitru <doug@easyco.com>
Subject: Re: SSD - TRIM command
Date: Mon, 21 Feb 2011 11:51:24 -0800
Message-ID: <AANLkTikCxjXbTAPNX-OQBMeNfUa4zKzaXk=C078Z837x@mail.gmail.com>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>
	<4D517F4F.4060003@gmail.com>
	<4D5245DF.4020401@hardwarefreak.com>
	<iiu4rc$9ju$1@dough.gmane.org>
	<AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com>
	<iiud2r$qci$1@dough.gmane.org>
	<4D62ACFE.4020401@cfl.rr.com>
	<AANLkTim6qJRZABYj4y_1sL6xq7y_w-STbaC4MK3U05ug@mail.gmail.com>
	<AANLkTimxTBTGupRk_1nSajjoWBstHdzVVpF4kEN3Y6XU@mail.gmail.com>
	<AANLkTikR+bKrGUCxnsnNz0vJVGOWoPiP0b618sZNBdqU@mail.gmail.com>
	<AANLkTik+xMXqA1+bM=AAhsqtCha-rDcVNr3Qkd-AmbNY@mail.gmail.com>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik+xMXqA1+bM=AAhsqtCha-rDcVNr3Qkd-AmbNY@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

To be technically accurate, trim is a hint to a storage device that
has a "block translation layer" that can take advantage of knowing
that a block contains no meaningful data.

Flash needs trim only if flash has an FTL (Flash Translation Layer)
that is re-mapping blocks in such a manner as free blocks are helpful
in making this process more efficient.  Older SSDs did not support
trim and had no real need for it.  If you look at the FTL used with
simple Flash (think CF cards, SD cards, and USB sticks) trim does not
help them.  Trim and wear leveling are un-related and don't really
impact each other.

On the linux side trim is "discard".  This is actually a much better
abstraction as it does not imply SSDs.

Any type of block device that does dynamic block remapping will likely
be helped (at least somewhat) by discard.  The only examples of this I
can think of off-hand are 1) my Flash SuperCharger code, and 2)
block-level de-dupe engines.  I am sure other examples will be created
over time.

Hopefully, discard can be driven down the stack.  I would personally
prefer the linux community declare that discard and zero writes are
identical.  If an SSD supports trim and linux wants to translate a
discard into a trim at the device driver layer, and the SSD is
non-deterministic, then that SSD is broken.  Then again, my attitude
about this is very arrogant and I think the trim spec was broken from
the beginning.

--
Doug Dumitru
EasyCo LLC
