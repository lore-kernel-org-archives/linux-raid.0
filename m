From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: building a large/fast server
Date: Wed, 29 Jan 2003 15:22:04 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0301291517200.12434-100000@chaos.egr.duke.edu>
References: <200301292012.MAA07478@astra.scripps.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200301292012.MAA07478@astra.scripps.edu>
To: Andy Arvai <arvai@scripps.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 29 Jan 2003 at 12:12pm, Andy Arvai wrote

> I'm in the process of designing a large server system. The primary
> consideration will be i/o performance (block read and write of large
> files and maximum i/o's per second) and a filesystem size of 2TB. I'm
> planning to go with 2 3ware 7500-8's, 16 Maxtor 4G160J8's (160GB) and
> do software raid0 between the 7500-8's (raid5). The filesystem will
> either be Reiser or Ext3. Any suggestions for fast dual cpu
> motherboards or comments are welcome. Thanks for any information.

Those boards need to be on separate PCI busses if you want to fully 
utilize them.  That means PIII or Xeon solutions only -- there aren't any 
dual AMD boards with more than one PCI bus yet.  You'll want to look at 
E7500 (or E7501 if they're in the channel yet) based boards.  I've got a 
system on just like that on a Supermicro P4DPE-G2 board that works rather 
nicely.

As for comments, in my testing on a single 3ware board (in hardware 
RAID5), ext3's write speeds sucked.  I'd suggest including XFS in your 
testing.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University

