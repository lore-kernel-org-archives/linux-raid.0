From: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Subject: Re: Software RAID1 problems
Date: Sat, 1 Mar 2003 17:08:37 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1030301170531.29069A-100000@Maggie.Linux-Consulting.com>
References: <004901c2e01e$323fd500$8400a8c0@jrc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <004901c2e01e$323fd500$8400a8c0@jrc>
To: Jean-Rene Cormier <jean-rene.cormier@cipanb.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Sat, 1 Mar 2003, Jean-Rene Cormier wrote:

> Yes that was a typo sorry. I did reformat /dev/md0 and a when it started
> formating it gave me those errors again. I did a little searching and the
> problem is not in the raid array, but I'm still not sure what is causing the
> problem. The error was:
> 
> hde: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> hde: drive not ready for command
> hde: status timeout: status=0xf0 { Busy }
> hde: drive not ready for command
> ide2: reset: success

make sure you have the same speed disks on the same ide cable
	- best to use only one ide drive per cable
	- do NOT mix ata-33 w/ ata-66 w/ ata-100 w/ ata-133 on the same
	cable

use better and SHORTER ide cables ??   ( should be 80 conductor )

make sure you do NOT have kinks in the ide cable ( keep it straight )

make sure your kernel has the ide chipset support enabled for your
motherboard


-- otherwise... you have a failing or dead disk drive...
	-- if its an ibm deskstar... get rid of it...

c ya
alvin

