From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] md - 1 of 12 - Missing mddev_put in md resync code
Date: Fri, 14 Mar 2003 13:42:11 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15985.16771.885438.47395@notabene.cse.unsw.edu.au>
References: <E18sxOy-0004pf-00@notabene.cse.unsw.edu.au>
	<1047491327.30792.3.camel@wmery000.ca.nortel.com>
	<15983.43970.946123.962678@notabene.cse.unsw.edu.au>
	<1047563289.30797.13.camel@wmery000.ca.nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sean Kormilo on  March 13
To: Sean Kormilo <skormilo@nortelnetworks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On  March 13, skormilo@nortelnetworks.com wrote:
> > Would this be when removing a recently-failed device?  That can still
> > oops.  I should send in a patch for that...
> 
> Yes in fact, that is the one I was seeing.
> 

That one *should* be fixed in 2.4.-current-bk, but probably not
completely.  It is actually rather hard to get it just-right in 2.4.
I substantially reworked the 2.5 code so that proper locking could be
done so that this sort of problem could be avoided.  
2.4 will porbably have to stay with "close-enough".

> 
> I have an odd problem where the first rebuild performs as expected
> (about 40MB/s), but any subsequent rebuild plods along at about 6-7MB/s.
> There is no IO activity on the system other than the rebuild during my
> tests.

Does upping /proc/sys/dev/raid/speed_limit_min affect the speed?

Does increasing the magic "32" in is_mddev_idle help?

> 
> I tried putting in a couple of debug printk's here and there in the code
> that backs off the resync, and the printk's themselves returned the
> performance back to expected levels... some kind of a timing problem
> perhaps?

Don't you  hate that!

NeilBrown
