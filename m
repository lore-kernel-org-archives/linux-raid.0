From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: Software RAID-0 striping over Hardware RAID-5
Date: Mon, 20 Sep 2004 09:55:50 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0409200953110.6936@chaos.egr.duke.edu>
References: <1a1.29d2b13e.2e8039e4@aol.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1a1.29d2b13e.2e8039e4@aol.com>
To: AndyLiebman@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 20 Sep 2004 at 9:49am, AndyLiebman@aol.com wrote

> Have you ever tested your systems while one of your RAID5 arrays is 
> rebuilding or verifying? (I'm about to do that right now). I'm wondering if Linux 
> Software RAID-0 might falter if one of the two arrays is significantly slower than 
> the other (while rebuilding)?

I've had arrays under normal (sporadically heavy) usage during a rebuild, 
and there wasn't a problem.

> My inclination is to not use a hot spare. Instead, I rely on 3ware's email 
> notification feature to alert me that a drive needs to be replaced. I always 
> keep a spare handy that can be popped into place immediately. Also, I want to 
> have control over when rebuilding takes place. It would be a bad thing to rebuild 
> during certain critical high I/O moments of the day -- whereas rebuilding at 
> night would be much less stressful on the system. Do you see anything wrong 
> with this approach? 

Yes -- it requires you to be on call 24x7 for maximum protection.  And 
even then the level of protection is less than with a hot spare, given 
that it will take you time to get from whereever you are to whereever the 
server is.  Also, disks can sometimes have a tendency to go in quick 
succession.  I would *strongly* recommend a hot spare.

Remember, you're cutting your reliability in half by striping the two 
arrays.  Why not maximally protect those individual arrays?

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
