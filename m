From: Neil Brown <neilb@suse.de>
Subject: Re: spare group
Date: Tue, 12 Jun 2007 16:59:47 +1000
Message-ID: <18030.17507.290572.911043@notabene.brown>
References: <466D51EE.7030509@avaxio.net>
	<18029.57132.285522.284156@notabene.brown>
	<466E3E58.8050105@avaxio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tomka Gergely on Tuesday June 12
Sender: linux-raid-owner@vger.kernel.org
To: tomka@avaxio.net
Cc: "Linux, Raid lista" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday June 12, tomka@avaxio.net wrote:
> >> According to the source:
> >>
> >> * If an array has active < raid && spare == 0 && spare_group !=NULL
> >> * Look for another array with spare > 0 and active == raid and same 
> >> spare_group
> >> * if found, choose a device and hotremove/hotadd
> >>
> >> This is not happening. What is my mistake?
> > 
> > Is "mdadm --monitor" running?  That is required to perform
> > spare-migration.
> 
> Yes, of course.

Good - I need to get the obvious things out of the way first :-)

(reads code).

Ahhh. You are using version-1 superblocks aren't you?  That code only
works for version-0.90 superblocks.  That was careless of me.  It
shouldn't be hard to make it work more generally, but it looks like it
will be slightly more than trivial.  I'll try to get you a patch in
the next day or so (feel free to remind me if I seem to have
forgotten).

Thanks for testing and reporting this problem.

NeilBrown
