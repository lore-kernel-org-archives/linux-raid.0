From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: ATA Raid on a Dual Boot (Win 2K and Linux [kernel 2.6])?
Date: Thu, 28 Apr 2005 10:52:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.58.0504281043330.16175@chaos.egr.duke.edu>
References: <4270F5D6.2060004@web.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4270F5D6.2060004@web.de>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Muenkner <stefan.muenkner@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 28 Apr 2005 at 4:40pm, Stefan Muenkner wrote

> Has anybody experience with the following setup:
> 
> - I would like to set up the two disks as a mirror raid set using the
> ATA-Raid card.
> - A reasonable portion of the raid-set will then be partionend and used
> by windows.
> - (Probably) I would actually use a DOS/Win based program to
> pre-partition the rest of the mirrored disks for Linux
> - the remaining Linux partitions will then be used as a SW-Raid-1 set
> (with a LVM on top of it?).

If you're willing to pay a bit more, you could buy a "real" RAID card 
(e.g. a 3ware 8000 series) with support in both OSes.  Do a hardware 
mirror in the 3ware, and then both OSes will see a single drive via their 
native drivers.  A 8006-2 (2 port SATA) is $130 on buy.com.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
