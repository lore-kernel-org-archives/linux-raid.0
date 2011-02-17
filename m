From: NeilBrown <neilb@suse.de>
Subject: Re: md road-map: 2011
Date: Thu, 17 Feb 2011 11:55:12 +1100
Message-ID: <20110217115512.010eefc0@notabene.brown>
References: <20110216212751.51a294aa@notabene.brown>
	<ijgr9p$7v8$1@dough.gmane.org>
	<20110217083531.3090a348@notabene.brown>
	<ijhje3$ocd$1@dough.gmane.org>
	<20110217100139.7520893d@notabene.brown>
	<ijhq7p$pjv$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ijhq7p$pjv$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 17 Feb 2011 01:30:49 +0100 David Brown <david.brown@hesbynett.no>
wrote:

> Do filesystems re-try reads when there is a failure?  Could you return 
> fail on one read, then success on a re-read, which could be interpreted 
> as "dying, but not yet dead" by the file system?
> 

Not normally.  The underlying device is assumed to perform all retrys that
are reasonable.  Retrying again at the FS level would be pointless.

It certainly would be possibly to return some sort of "data not very safe"
indicator, which a disk drive could set if it needed to retry the read.
However you need to get buy-in from some FS developer before it is worth the
effort.

NeilBrown

