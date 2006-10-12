From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: MegaRaid problems..
Date: Thu, 12 Oct 2006 07:13:44 -0400 (EDT)
Message-ID: <Pine.LNX.4.62.0610120711580.23095@chaos.egr.duke.edu>
References: <200609241503.09808.Dexter.Filmore@gmx.de>
 <Pine.LNX.4.64.0609241829100.17345@coffee.psychology.mcmaster.ca>
 <Pine.LNX.4.56.0610120913480.11816@lion.drogon.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0610120913480.11816@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 12 Oct 2006 at 10:06am, Gordon Henderson wrote

> I'm wondering about things like the controllers needing some poking at the
> BIOS level, but I've looked and there isn't a JBOD mode - only various
> built-in RAID modes, so I've not created any RAID sets through the BIOS (I
> want raid 6 on this box over all 15 drives)

Some RAID cards don't explicitly have a JBOD mode but instead an option 
that says something like "Export unconfigured disks", and ISTR that 
MegaRAID may be that sort of card.  Poke about in the card BIOS a bit 
more.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
