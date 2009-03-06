From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: move headers out of include/linux/raid/
Date: Fri, 6 Mar 2009 14:26:45 +1100
Message-ID: <18864.38901.234155.887209@notabene.brown>
References: <20090303183016.GA28645@lst.de>
	<18863.15699.843356.342040@notabene.brown>
	<20090305115735.GA24504@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Christoph Hellwig on Thursday March 5
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 5, hch@infradead.org wrote:
> On Thu, Mar 05, 2009 at 01:47:47PM +1100, Neil Brown wrote:
> > On Tuesday March 3, hch@lst.de wrote:
> > > Move the headers with the local structures for the disciplines and
> > > bitmap.h into drivers/md/ so that they are more easily grepable for
> > > hacking and not far away.  md.h is left where it is for now as there
> > > are some uses from the outside.
> > > 
> > 
> > I really like this, thanks.  I much prefer having the includes with
> > the C files where they are truly local.
> > 
> > I've added a few patches to move md_k.h into drivers/md as well.
> > I'll include them below for reference.
> 
> Btw, I think md_k.h should just be named md.h after that move, and the
> old md.h in include/linux/raid/ should just go away once all the
> function declarations & co are moved out.
> 

Yes, of course.
That makes it much tidier.

All done and pushed to git://neil.brown.name/md for-next
to be picked up by -next on Monday I guess.

Thanks!
NeilBrown
