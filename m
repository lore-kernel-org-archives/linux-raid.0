From: "Jean-Rene Cormier" <jean-rene.cormier@cipanb.ca>
Subject: Re: Software RAID1 problems
Date: Sun, 2 Mar 2003 10:41:08 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <003301c2e0c9$c5eee010$8400a8c0@jrc>
References: <Pine.LNX.3.96.1030301170531.29069A-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message -----
From: "Alvin Oga" <aoga@Maggie.Linux-Consulting.com>
To: "Jean-Rene Cormier" <jean-rene.cormier@cipanb.ca>
Cc: <linux-raid@vger.kernel.org>
Sent: Saturday, March 01, 2003 9:08 PM
Subject: Re: Software RAID1 problems


>
> On Sat, 1 Mar 2003, Jean-Rene Cormier wrote:
>
> > Yes that was a typo sorry. I did reformat /dev/md0 and a when it started
> > formating it gave me those errors again. I did a little searching and
the
> > problem is not in the raid array, but I'm still not sure what is causing
the
> > problem. The error was:
> >
> > hde: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> > hde: drive not ready for command
> > hde: status timeout: status=0xf0 { Busy }
> > hde: drive not ready for command
> > ide2: reset: success
>
> make sure you have the same speed disks on the same ide cable
> - best to use only one ide drive per cable
> - do NOT mix ata-33 w/ ata-66 w/ ata-100 w/ ata-133 on the same
> cable

Both drives are new 60Gb Maxtor DiamondMax Plus 9 on separate IDE channels
on a Promise Ultra TX2 IDE card

> use better and SHORTER ide cables ??   ( should be 80 conductor )

I did switch the cable on the drives to see if it would make a difference
and it's still the same drive who gave me those errors so I guess it's not
the cables.

> make sure you do NOT have kinks in the ide cable ( keep it straight )
>
> make sure your kernel has the ide chipset support enabled for your
> motherboard

I noticed yesterday that my kernel didn't have IDE support for the Promise
Ultra compiled in so I recompiled the kernel with it. I'll put the drive
back in the computer and try it again to see if it works better

> -- otherwise... you have a failing or dead disk drive...
> -- if its an ibm deskstar... get rid of it...

I'll try this drive in another computer to see what it'll say.

Thanks

Jean-Rene Cormier

