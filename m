From: Neil Brown <neilb@suse.de>
Subject: Re: Read errors on raid5 ignored, array still clean .. then
 disaster !!
Date: Fri, 29 Jan 2010 21:48:52 +1100
Message-ID: <20100129214852.00e565c4@notabene>
References: <4B5F6C73.30707@texsoft.it>
	<20100127074138.GA9607@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100127074138.GA9607@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 27 Jan 2010 08:41:38 +0100
Luca Berra <bluca@comedia.it> wrote:

> On Tue, Jan 26, 2010 at 11:28:03PM +0100, Giovanni Tessore wrote:
> > Is this some kind of bug?  
> No


I'm not sure I agree.
If a device is generating lots of read errors, we really should do something
proactive about that.
If there is a hot spare, then building onto that while keeping the original
active (yes, still on the todo list) would be a good thing to do.

v1.x metadata allows the number of corrected errors to be recorded across
restarts so a real long-term value can be used as a trigger.

So there certainly are useful improvements that could be made here.

NeilBrown

