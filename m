From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: building a large/fast server
Date: Wed, 29 Jan 2003 21:22:35 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0301292117410.24750-100000@uplift.swm.pp.se>
References: <200301292012.MAA07478@astra.scripps.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200301292012.MAA07478@astra.scripps.edu>
To: Andy Arvai <arvai@scripps.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 29 Jan 2003, Andy Arvai wrote:

> I'm in the process of designing a large server system. The primary
> consideration will be i/o performance (block read and write of large
> files and maximum i/o's per second) and a filesystem size of 2TB. I'm
> planning to go with 2 3ware 7500-8's, 16 Maxtor 4G160J8's (160GB) and
> do software raid0 between the 7500-8's (raid5). The filesystem will
> either be Reiser or Ext3. Any suggestions for fast dual cpu
> motherboards or comments are welcome. Thanks for any information.

1:st up if you want high write speeds:

Don't use the internal RAID5 of the 3wares, use software RAID5. Hmm, if 
you really want high write speeds, skip RAID5 altogether and go for 
mirroring.

If you want to be able to transfer these files quickly over the network, 
skip the SMP and go for the fastest possible single cpu system you can 
get, get one with multiple PCI buses that can handle 66MHz/64bit PCI 
(serverworks chipset for instance). Get a good gigabit network card, I 
personally like the Syskonnect series.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

