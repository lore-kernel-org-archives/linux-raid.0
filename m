From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/2] md: make devices disappear when they are no longer
	needed.
Date: Mon, 24 Nov 2008 06:38:06 +0000
Message-ID: <20081124063806.GA28946@ZenIV.linux.org.uk>
References: <20081124035516.3465.66413.stgit@notabene.brown> <20081124035530.3465.26724.stgit@notabene.brown> <20081124042421.GY28946@ZenIV.linux.org.uk> <18730.12791.348848.849033@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18730.12791.348848.849033@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Tejun Heo <tj@kernel.org>, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

On Mon, Nov 24, 2008 at 03:47:51PM +1100, Neil Brown wrote:

> > What lifetime rules do you really want?  I never liked the tricks pulled
> > by md wrt gendisk lifetimes and that might be a good time to sort that
> > out for good...
> 
> I'm not sure what 'tricks' you are referring to.  Can you elaborate?
> 
> I want the gendisk to appear as soon as it is needed (not because I
> think that is necessarily a good idea, but it is legacy functionality that I
> don't think we can easily discard).  And I want them to disappear when
> they contain no information and have nothing referring to them.

"Tricks" are about md_probe() and weird allocation time for these suckers.
But OK, legacy API is a good argument.

So you want the rules of the same nature as for module refcount?  Then
the natural place to do that would be in failure exit of __blkdev_get()
and in normal path in blkdev_put() (for the final opener going away).

However, let's try to do it right - there's a *lot* of drivers where
we do no work in ->release() until it's the final one.  It would be
nice to accomodate them as well while we are at it...
