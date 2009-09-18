From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Can md/mdadm deal with non-standard size of internal bitmap?
Date: Fri, 18 Sep 2009 20:53:41 +0200
Message-ID: <slrnhb7lpl.dbe.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <slrnhacnu6.2i5.Mario.Holbe@darkside.dyn.samba-tng.org>
 <1253036371.9142.1.camel@lgelinas>
 <a3e5286cc1c820e87ed6383246394545.squirrel@neil.brown.name>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:
> with 1.x metdata there is no "standard size" for bitmaps.

Okay, I was just not sure about superblock-updates and things like that.

> mdadm chooses an amount of space to reserve based roughly on the
> size of the device.
> It doesn't take into about the chunksize and alignment and so push the
> data region to the very end of the device as suggested, though that
> would not be particularly hard to do I suspect.

It would not be hard to implement but I'm not sure about all the
side-effects it has. Some easy ones are:
1. it breaks backwards-compatibility especially in the --assume-clean
   RAID-reconstruction case
2. it may harm when the array shall be grown in the future (i.e. to
   bigger components) by means of a reduction of the grown device's
   netto capacity compared to the unaligned case

So if you (or somebody else) intend to do it, please don't make it
default.


regards
   Mario
-- 
<eckes> wenn die nsa spam filtern wuerde...
<Neral> einfach china kappen
*** Signoff: Chinah (ix.irc.at linz.irc.at)

