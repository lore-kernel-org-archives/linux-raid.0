From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: What SATA controller for software raid and/or lvm?
Date: Mon, 19 Jan 2004 14:19:44 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0401191411050.12676-100000@coffee.psychology.mcmaster.ca>
References: <1074469835.7611.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1074469835.7611.9.camel@localhost.localdomain>
To: =?ISO-8859-1?Q?Jo=EBl?= Bourquard <numlock@freesurf.ch>
Cc: mingz@ele.uri.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> However, before I rush and order these two Highpoint 1820's ($300), it

afaikt, HPT's driver is one that plugs into SCSI.  this by itself doesn't
mean it's bad (since libata and 3ware also do so, and are good).  the problem
is that it's not clear how well HPT will maintain the driver, updating it 
when the SCSI layers above it change (or the kernel in general).

I'm going with promise 4-port cards: most server boards have two PCIX
buses, it gets painful to put more than 8 disks in a chassis anyway.
these days, a disk will do 70 MB/s, so expecting 560 MB/s out of a single 
card is probably over-optimistic anyway.

> it might help a lot of people on Linux-RAID... I mean, a 64-bit 133MHz
> SATA controller with 8 ports, for about $150 is really nice :-)

I don't mind two cheaper cards for the same thing.  it's easy to argue
that you shouldn't have the controller as a single point of failure, too.

regards, mark hahn.

