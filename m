From: "Sean Kormilo" <skormilo@nortelnetworks.com>
Subject: Re: [PATCH] md - 1 of 12 - Missing mddev_put in md resync code
Date: 13 Mar 2003 08:48:09 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1047563289.30797.13.camel@wmery000.ca.nortel.com>
References: <E18sxOy-0004pf-00@notabene.cse.unsw.edu.au>
	 <1047491327.30792.3.camel@wmery000.ca.nortel.com>
	 <15983.43970.946123.962678@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15983.43970.946123.962678@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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
  

