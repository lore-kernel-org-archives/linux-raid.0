From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Write and verify correct data to read-failed sectors before degrading
 array?
Date: Fri, 17 Sep 2004 10:39:55 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16714.12891.987589.769643@cse.unsw.edu.au>
References: <41420D07.4060001@steeleye.com>
	<16709.12517.514905.627708@cse.unsw.edu.au>
	<41487D18.1050000@steeleye.com>
	<4149700F.6060509@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tim Small on Thursday September 16
To: Tim Small <tim@buttersideup.com>
Cc: Paul Clements <paul.clements@steeleye.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday September 16, tim@buttersideup.com wrote:
> Just thinking out loud here, but I wonder if the following change is 
> possible or worth making to this code?  For a failed read, where the 
> block is then successfully read from another drive, then attempt to 
> write the correct data for this block to the device with the read 
> failure (to try to see if the drive firmware thinks this sector is still 
> usable, and if not then maybe it will reallocate the failed sector).  If 
> this write succeeds, and can be verified, then don't mark the sector bad 
> (maybe just complain with a printk)..
> 
> This would get around a lot of mirror failures that I see in 
> operation..  In the past, I've had mirrors go bad with individual failed 
> sectors in different locations on both drives, the array is then 
> unusable (and the database server is dead, in my experience) unless you 
> manually try to knit it back together with dd.

Yes.  Great idea.  Just as good as every other time it gets suggested :-)
Unfortunately no-one has presented any actual *code* yet, and I
haven't found/made/allocated time to do it.

   http://neilb.web.cse.unsw.edu.au/SoftRaid/01084418693

NeilBrown

