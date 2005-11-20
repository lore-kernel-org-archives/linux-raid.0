From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 write performance
Date: Mon, 21 Nov 2005 10:39:11 +1100
Message-ID: <17281.2335.968305.691148@cse.unsw.edu.au>
References: <200511190440.jAJ4efw15919@www.watkins-home.com>
	<437EB0A6.8040807@h3c.com>
	<17278.48635.585763.580503@cse.unsw.edu.au>
	<437F13B4.1070308@bppiac.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Farkas Levente on Saturday November 19
Sender: linux-raid-owner@vger.kernel.org
To: Farkas Levente <lfarkas@bppiac.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday November 19, lfarkas@bppiac.hu wrote:
> Neil Brown wrote:
> 
> > The other is to use a filesystem that allows the problem to be avoided
> > by making sure that the only blocks that can be corrupted are dead
> > blocks.
> > This could be done with a copy-on-write filesystem that knows about the
> > raid5 geometry, and only ever writes to a stripe when no other blocks
> > on the stripe contain live data.
> > I've been working on a filesystem which does just this, and hope to
> > have it available in a year or two (it is a back-ground 'hobby'
> > project). 
> 
> why are you waiting so long? why not just release the project plan, and 
> any pre-pre-alpha code? that's the point of the cathedral and the 
> bazaar. may be others can help, find bugs, write code, etc..

Uhmm... maybe I'm just selfish and want to have all the fun to myself (it
is as much a learning exercise as anything else)... or maybe I want to
be a coder rather than a project manager...

Despite the 'release early / release often' mantra, I think it is
possible to release something too early.  People look, find nothing
there, lose interest and never come back.

However I'm possibly at the stage were it might be worth making the
project more visible...  I'll think about it and let you know....

Thanks for your interest

NeilBrown
