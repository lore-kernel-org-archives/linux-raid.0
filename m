From: Neil Brown <neilb@suse.de>
Subject: Re: making raid5 more robust against block errors
Date: Thu, 30 Mar 2006 18:11:04 +1100
Message-ID: <17451.33928.930200.457912@cse.unsw.edu.au>
References: <Pine.LNX.4.62.0603300849110.30836@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mikael Abrahamsson on Thursday March 30
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 30, swmike@swm.pp.se wrote:
> 
> Is there any work going on to handle readerrors on a raid5 disk being 
> handled by recreating the faulty block from the other disks and just 
> rewriting the block, instead of kicking the disk out?

It's done. 2.6.15 I think, but definitely in 2.6.16.

NeilBrown
