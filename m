From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: RAID journal, requirements?
Date: Wed, 27 Jan 2016 01:15:20 +0100
Message-ID: <20160127001520.GH3039@otheros>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am very excited about the new journaling feature for RAID in md
and want to try it out soon.

Neil's article on LWN already gave a great overview and some hints
about it, but I am still a little unsure about the technical
requirements for the journal device. E.g. speed, reliability and
size-wise. And what the implications of failing them means.

I want to setup a small home NAS. My personal priorities are:
Firstly, low power-per-GB as it will be solar powered and battery
backed. Second priority is reliability. Performance is not that
important to me.

My current plan: Tiny ARM-based computer (Odroid C1+: 4x USB (2.0,
unfortunately) ports), 4x 2TB SATA HDDs (@0.7W idle, 1.7W max. each)
+ SATA-to-USB -> RAID5, microSD for OS + applications, an eMMC for
a RAID journal. (later, once they hopefully get available in April,
switch to the Turris Omnia which is ARM-based again but has
mini-PCIe, too, where I would attach mini-PCIe-to-SATA adapters)

Is it a stupid idea to use an eMMC for the journal in the first
place? I am unsure how quickly it would wear out. And seems like I
do not have SMART for it either... So it would probably fail badly
at some point. Is that an issue, can I simply replace the eMMC
then without any data loss? Will the current code at least try a
write-through directly to the HDDs once a journal disk throws
errors?

Does MD assume that an underlying device performs some sort of wear
leveling if necessary like SSDs do for instance - or does MD
itself distribute writes evenly over the journaling disk?
(Does anyone know whether eMMCs usually do some kind of wear leveling?)


Thanks for all your work on this awesome new feature! (and special
thanks to Neil for all the years of maintenance - it is a pitty you
have to step down :( )

Regards, Linus
