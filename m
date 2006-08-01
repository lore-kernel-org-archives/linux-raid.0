From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 004 of 9] md: Factor out part of raid10d into a separate
 function.
Date: Wed, 2 Aug 2006 06:27:21 +1000
Message-ID: <17615.47401.552607.980993@cse.unsw.edu.au>
References: <20060731172842.24323.patches@notabene>
	<1060731073208.24470@suse.de>
	<44CF8C2D.2010900@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Tuesday August 1
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday August 1, davidsen@tmr.com wrote:
> don't think this is better, NeilBrown wrote:
> 
> >raid10d has toooo many nested block, so take the fix_read_error
> >functionality out into a separate function.
> >  
> >
> 
> Definite improvement in readability. Will all versions of the compiler 
> do something appropriate WRT inlining or not?

As the separated function is called about once in a blue moon, it
hardly matters.  I'd probably rather it wasn't inlined so as to be
sure it doesn't clutter the L-1 cache when it isn't needed, but that's
the sort of thing I really want to leave to the compiler.

Maybe it would be good to stick an 'unlikely' or 'likely' in raid10d
to tell the compiler how likely a read error is...

NeilBrown
