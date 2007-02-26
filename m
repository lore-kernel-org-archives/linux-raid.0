From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: Linux Software RAID a bit of a weakness?
Date: Mon, 26 Feb 2007 14:40:18 -0500 (EST)
Message-ID: <alpine.LRH.0.82.0702261439030.302@chaos.egr.duke.edu>
References: <1172258378.21648.51.camel@cowie> <45DF46B7.3040707@maine.edu>
 <1172406243.3765.29.camel@cowie> <45E1E051.1020908@sauce.co.nz>
 <72dbd3150702260856p5053d028je85cacffb15a5536@mail.gmail.com>
 <1172510818.11898.33.camel@cowie>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1172510818.11898.33.camel@cowie>
Sender: linux-raid-owner@vger.kernel.org
To: Colin Simpson <csimpson@csl.co.uk>
Cc: David Rees <drees76@gmail.com>, Richard Scobie <richard@sauce.co.nz>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 26 Feb 2007 at 5:26pm, Colin Simpson wrote

> SATA isn't supported on RH 4's SMART.

Not true (for many SATA chipsets at least).  Just pass '-d ata' to 
smartctl.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
