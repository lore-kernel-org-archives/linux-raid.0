From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Fri, 30 Jul 2004 09:30:31 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0407300929140.503@chaos.egr.duke.edu>
References: <200407301116.42676.m.watts@eris.qinetiq.com>
 <Pine.LNX.4.58.0407300858200.503@chaos.egr.duke.edu>
 <200407301424.25496.m.watts@eris.qinetiq.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200407301424.25496.m.watts@eris.qinetiq.com>
To: Mark Watts <m.watts@eris.qinetiq.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 30 Jul 2004 at 2:24pm, Mark Watts wrote

> > Make sure that your driver and firmware versions match (check the 3ware
> > site).  Also, have you tried other FSs?  I get *very* good performance out
> > of 7500-8s using XFS on 2.4 (and hardware RAID5+software RAID0).  I
> > haven't tried 2.6 yet.
> 
> I'm running the latest firmware from www.3ware.com (FE8S 1.05.00.068)
> Driver is v1.26.00.039 from kernel 2.6.8rc1
> 
> Obviously these aren't the same, but I can only see drivers for RedHat or 
> generic 2.4 kernels on the 3ware site, not 2.6.x

Bah.  They have the 2.6 driver under "In Engineering Phase", and it's that 
same version.  For 2.4 they tie certain driver and firmware versions 
together as a "software release", but apparently they aren't doing this 
for 2.6 yet.  Sorry for the noise.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
