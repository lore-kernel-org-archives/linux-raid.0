From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Small fix for 2.4 md.c - using device information before lock_dev()
Date: Thu, 13 Mar 2003 11:54:27 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15983.54979.45962.241612@notabene.cse.unsw.edu.au>
References: <20030312140646.GJ32759@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Lars Marowsky-Bree on Wednesday March 12
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday March 12, lmb@suse.de wrote:
> Good morning,
> 
> I've been testing md under UML. It appears that UML is exposing a minor bug in
> md.c: it is trying to use information about the device (in particular,
> blk_sizes[]) before having imported it (which calls lock_dev() and thus makes
> the information available in the first place).
> 
> This was exposed because UML resets the blk_sizes[] information to zero on
> ubd_release().
> 
> Working patch attached; it just reorders the function calls. Please apply to
> 2.4 if appropriate.
> 

Thanks ... that's a subtle one.  
It appears not be be an issue with 2.5 as you cannot even get at the
size before doing the bdget - which is good.

I'll send it to Marcelo.

NeilBrown
