From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: 3ware escalade vs software raid, from a different jeff
Date: Fri, 20 Feb 2004 02:19:26 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0402200217080.2393@chaos.egr.duke.edu>
References: <Pine.LNX.4.44.0402191118090.10623-100000@praktifix.dwd.de>
 <Pine.LNX.4.58.0402190704420.25541@chaos.egr.duke.edu> <20040219175630.GA20790@datavibe.net>
 <4035571B.505@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4035571B.505@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Rev. Jeffrey Paul" <sneak@datavibe.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 19 Feb 2004 at 7:38pm, Jeff Garzik wrote

> Rev. Jeffrey Paul wrote:

> > I am looking at a four disk raid5 or raid10, and it seems like 
> > the interrupt load from four drives on four channels might be a bit 
> > excesive.  I'm going to be running critical services on the machine 
> > that the drives are in (namely mysql and nfs) and don't want to worry 
> > about performance.
> 
> Once your spindles can max out your PCI bus bandwidth, -then- you can 
> start worrying about PCI bandwidth and interrupt load ;-)

With some boards, it's actually pretty easy to do that.  ;)  Not with 4 
disks, as the OP is doing, but 8 disks on one 64bit/33MHz bus (3ware 
7500-8) can start to bump up against the PCI bandwidth.  I've got a couple 
servers with 2 3wares and 16 disks, and I need to put the 3wares on 
separate PCI busses to make sure I get the full speed out of the combined 
array (hardware RAID5, software RAID0).

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
