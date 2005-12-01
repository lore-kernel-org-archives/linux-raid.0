From: Neil Brown <neilb@suse.de>
Subject: Re: What is the status of the raid5 online resize patch ?
Date: Thu, 1 Dec 2005 20:40:52 +1100
Message-ID: <17294.50468.859025.329230@cse.unsw.edu.au>
References: <fd8d0180512010115v305905b2s@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Francois Barre on Thursday December 1
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday December 1, francois.barre@gmail.com wrote:
> Hello all,
> 
> Surfing on the web I found a patch from Steinar H. Gunderson which
> implements raid5 resize stuff.
> (http://marc.theaimsgroup.com/?l=linux-raid&m=112998877619952&w=2).
> It seems like it has been included in the 2.6.14 kernel
> (http://www.linuxhq.com/kernel/v2.6/14/drivers/md/raid5.c), but I

No, it hasn't been included.  The raid5 changes reflected at that url
are mostly 'bitmap write-intent log' which optionally accelerates
resync speed at a small cost of write speed.

> would be sure :
> - Is it really reliable ? Did you test it strongly enough to put the
> 'I trust it' label on it ?
> - Does it implement crash recovery now ?
> - Did anyone test a multiple growth (add 1 disk, then another, then...).
> 

However, I expect to have time to complete the very good work that
Steinar started early in the new year.  It will not be submitted to
-mm until it implements crash recovery and has been tested for
multiple growth and other scenarios. 
It will not go to -linus until it has been tested quite thoroughly
(preferably by more than just me) and I would feel comfortable using
it on my data.

I look forward you getting your test results after it is in -mm :-)

NeilBrown
