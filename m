From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: ANNOUNCE: mdadm 1.6.0 - A tool for managing Soft RAID under
     Linux
Date: Mon, 7 Jun 2004 07:46:23 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16579.37039.871130.882399@cse.unsw.edu.au>
References: <40498.194.60.85.4.1086343953.squirrel@194.60.85.4>
	<40C346A6.1000001@xss.co.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andreas Haumer on Sunday June 6
To: Andreas Haumer <andreas@xss.co.at>
Cc: Robin Bowes <robin-lists@robinbowes.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday June 6, andreas@xss.co.at wrote:
> 
> Hi!
> 
> Robin Bowes wrote:
> > Neil,
> >
> > I am interpreting this to mean that I can create, for example, a large (e.g. 1TB) RAID5
> > array and create smaller partitions (/home, /usr, etc) on top of the RAID5 array? Is
> > this correct?
> >
> Hm.
> Why would anyone use this, given that we can put LVM on
> top of SW-RAID?

> 
> 
> What are the advantages of a partitionable md device
> compared to a SWRAID+LVM configuration?
> 

Familiarity.  Simplicity.  Uniformity with other partitioning.

LVM certainly works, now "traditional" partitioning does too...

Choice is good.  Use whichever suits you.

NeilBrown
