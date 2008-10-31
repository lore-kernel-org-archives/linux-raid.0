From: Mike Myers <mikesm559@yahoo.com>
Subject: Re: Adaptec raid congtrollers for SATA disks under software raid
Date: Fri, 31 Oct 2008 12:23:14 -0700 (PDT)
Message-ID: <824650.16419.qm@web30807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: David Lethe <david@santools.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, sometimes the onboard ports run a lot faster than a card because the card is hooked through a PCI bus that may be doing a lot of other things.

I have heard from various reports that the jbod performance of the card is fine, but that the RAID performance sucks (because of the hardware raid controller slowing things down).  But that is why I am asking folks here if they have any experience with these things in jbod mode vs raid mode.  Remember that I have no interest in using the hardware raid part of the card.  The 66 Mhz 64 bit PCI-X bus should limit things much.

thx
mike




----- Original Message ----
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Mike Myers <mikesm559@yahoo.com>
Cc: David Lethe <david@santools.com>; linux-raid@vger.kernel.org
Sent: Friday, October 31, 2008 11:48:58 AM
Subject: Re: Adaptec raid congtrollers for SATA disks under software raid


On Fri, 31 Oct 2008, Mike Myers wrote:

> Well, actually if the chips that manufacturer A uses are faster in software raid than manufacturer L...  :-)
>
> thx
> mike
>
>
Mike,

What sustained rates for sequential read/writes have you been able to 
achieve with multiple (HW) based PCI-X RAID cards?

Isn't there a drop in performance when exporting a drive via JBOD vs. 
directly attached to a SATA controller?  I remember raptors on a SiI 3112 
(or the raid chip on an ABIT IC7-G, its been awhile)-- in RAID mode on a 
motherboard, it was (this was a while ago) 40-50MiB/s whereas the same raptor
connected to a regular sata controller was closer to 70-80MiB/s (74GiB raptor).

Justin.


      
