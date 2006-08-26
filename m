From: linux@horizon.com
Subject: Re: Linux: Why software RAID?
Date: 25 Aug 2006 23:50:34 -0400
Message-ID: <20060826035034.13307.qmail@science.horizon.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Hardware RAID can be (!= is) more tolerant of serious drive failures
> where a single drive locks up the bus. A high-end hardware RAID card 
> may be designed with independent controllers so a single drive failure
> cannot take other spindles down with it. The same can be accomplished 
> with sw RAID of course if the builder is careful to use multiple PCI 
> cards, etc. Sw RAID over your motherboard's onboard controllers leaves
> you vulnerable.

Which is exactly why I *like* SW RAID - I can, and do, have the mirrors
span controllers so a whole controller can fail without taking down
the system.

With HW RAID cards, if your controller dies, you're SOL.
