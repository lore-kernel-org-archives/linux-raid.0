From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: Fix bug where new drives added to an md array sometimes
 don't sync properly.
Date: Fri, 20 Oct 2006 13:24:32 +1000
Message-ID: <17720.16752.361227.764674@cse.unsw.edu.au>
References: <20061005171233.6542.patches@notabene>
	<1061005071326.6578@suse.de>
	<45255C54.6060608@ilm.com>
	<4526DBCE.6070906@ilm.com>
	<17706.65210.999441.373846@cse.unsw.edu.au>
	<4536A848.8020908@ilm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Eli Stair on Wednesday October 18
Sender: linux-raid-owner@vger.kernel.org
To: Eli Stair <estair@ilm.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday October 18, estair@ilm.com wrote:
> 
> FYI, I'm testing 2.6.18.1 and noticed this mis-numbering of RAID10
> members issue is still extant.  Even with this fix applied to raid10.c, 
> I am still seeing repeatable issues with devices assuming a "Number" 
> greater than that which they had when removed from a running array.

That 'Number' change isn't a problem.  It is really just an arbitrary
label to track a device.  Once you fail a device and re-add it, md
considers it to be a new device.
As long as the 'RaidDevice' number is what you expect, everything is
working properly.

NeilBrown
