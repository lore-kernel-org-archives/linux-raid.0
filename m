From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Fri, 30 Jul 2004 08:59:49 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0407300858200.503@chaos.egr.duke.edu>
References: <200407301116.42676.m.watts@eris.qinetiq.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200407301116.42676.m.watts@eris.qinetiq.com>
To: Mark Watts <m.watts@eris.qinetiq.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 30 Jul 2004 at 11:16am, Mark Watts wrote

> Basically anything involving I/O is causing the system to crawl.
> I can reliably reproduce this by doing:
> 
> 	mke2fs -j /dev/sda7
> 
> Where sda7 is a 600GB partition.
> 
> Basically the system load goes orbital and responsivness goes out the window.
> gkrellm only shows ~1MB/sec of disk activity and the processors (Dual Opteron) 
> are twiddling their thumbs (top shows 100% 'wa' state for both processors), 
> yet I can hardly do anything with any open applications.
> 
> Kernel is a 2.6.8rc1 kernel.org job.

Make sure that your driver and firmware versions match (check the 3ware 
site).  Also, have you tried other FSs?  I get *very* good performance out 
of 7500-8s using XFS on 2.4 (and hardware RAID5+software RAID0).  I 
haven't tried 2.6 yet.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
