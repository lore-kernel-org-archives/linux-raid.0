From: Neil Brown <neilb@suse.de>
Subject: Re: ANNOUNCE: mdadm 3.1 - A tool for managing Soft RAID under Linux
Date: Thu, 29 Oct 2009 14:34:40 +1100
Message-ID: <19177.3408.86696.273122@notabene.brown>
References: <19167.52667.86006.270614@notabene.brown>
	<1256218491.11010.13.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Kasper Sandberg on Thursday October 22
Sender: linux-raid-owner@vger.kernel.org
To: Kasper Sandberg <postmaster@metanurb.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 22, postmaster@metanurb.dk wrote:
> On Thu, 2009-10-22 at 14:12 +1100, Neil Brown wrote:
> > Hot on the heals of 3.0.3 I am pleased to announce the availability of
> >    mdadm version 3.1
> <snip>
> > You should only upgrade if you need to use, or which to test, these
> > features.
> 
> Why is that? because its more untested than older versions, or because
> of some other thing? i guess what im asking is, should people that dont
> need these features keep on the older branches indefinitely, or just
> hold off for some more testing? (aka grab it when the distribution
> update arrives)

"just hold off for some more testing".

The new functionality in 3.1 is still very fresh and I would rather
people had to make a deliberate decision to install the new code in
order to use it, rather than just finding that it works and assuming
that it is completely reliable.

I have received some very valuable feedback on 3.1 already and will
fix a number of issues in 3.1.1.  At that point I suspect I will
suggest people upgrade.

Thanks,
NeilBrown


> 
> > 	
> > NeilBrown 22nd October 2009
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
