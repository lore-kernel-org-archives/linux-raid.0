From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] md - 1 of 12 - Missing mddev_put in md resync code
Date: Thu, 13 Mar 2003 08:50:58 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15983.43970.946123.962678@notabene.cse.unsw.edu.au>
References: <E18sxOy-0004pf-00@notabene.cse.unsw.edu.au>
	<1047491327.30792.3.camel@wmery000.ca.nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sean Kormilo on  March 12
To: Sean Kormilo <skormilo@nortelnetworks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On  March 12, skormilo@nortelnetworks.com wrote:
> Neil,
> 
> Are these patches safe to apply against 2.4 kernels?

No.  There have been lots of changes since 2.4.  Some patches might
conceptually apply, but they would need a bit of work to make them
actually apply.

> 
> It looks like one or more of these might reduce the chances of the
> kernel oops I experience on occasion when manipulating arrays.

Would this be when removing a recently-failed device?  That can still
oops.  I should send in a patch for that...

> 
> Also, this appears to change some of the way rebuilds are done, and am
> interested to see if this impacts some of the rebuild performance issues
> I've been seeing.

These patches are about management, not performance.  They won't
affect rebuild performance at all.  It is already quite good in 2.4 I
believe.  But maybe my experience is different from your.

NeilBrown
