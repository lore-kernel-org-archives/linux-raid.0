From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Subject: RE: [PATCH] md - 1 of 12 - Missing mddev_put in md resync code
Date: Thu, 13 Mar 2003 09:42:28 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8075D5C3061B9441944E1373776451180F077C@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Sean Kormilo <skormilo@nortelnetworks.com>, Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was seeing similar rebuild performance on my large number of RAID1
arrays (the first rebuilds went speedy and subsequent ones slowed down
after the first ones completed).  I bumped up the speed_limit_min and
the rebuild performance went up to where I expected it to be. 

What were you speed_limit_[min|max]?

-----Original Message-----
From: Sean Kormilo [mailto:skormilo@nortelnetworks.com] 
Sent: Thursday, March 13, 2003 8:48 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH] md - 1 of 12 - Missing mddev_put in md resync code


Neil,

> 
> No.  There have been lots of changes since 2.4.  Some patches might 
> conceptually apply, but they would need a bit of work to make them 
> actually apply.

Ok, then I won't give it a try. Thanks for the heads up.
> 
> > 
> > It looks like one or more of these might reduce the chances of the 
> > kernel oops I experience on occasion when manipulating arrays.
> 
> Would this be when removing a recently-failed device?  That can still 
> oops.  I should send in a patch for that...

Yes in fact, that is the one I was seeing.


> These patches are about management, not performance.  They won't 
> affect rebuild performance at all.  It is already quite good in 2.4 I 
> believe.  But maybe my experience is different from your.

I have an odd problem where the first rebuild performs as expected
(about 40MB/s), but any subsequent rebuild plods along at about 6-7MB/s.
There is no IO activity on the system other than the rebuild during my
tests.

I tried putting in a couple of debug printk's here and there in the code
that backs off the resync, and the printk's themselves returned the
performance back to expected levels... some kind of a timing problem
perhaps?

Sean.

-- 

Sean C. Kormilo, STORM Software Architect, Nortel Networks
              email: skormilo@nortelnetworks.com
  

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html
