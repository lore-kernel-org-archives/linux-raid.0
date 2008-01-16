From: dean gaudet <dean@arctic.org>
Subject: Re: [PATCH 001 of 6] md: Fix an occasional deadlock in raid5
Date: Tue, 15 Jan 2008 21:01:17 -0800 (PST)
Message-ID: <alpine.DEB.0.999999.0801152059170.9578@twinlark.arctic.org>
References: <20080114123726.19968.patches@notabene> <1080114014525.20337@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1080114014525.20337@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@gmail.com>
List-Id: linux-raid.ids

On Mon, 14 Jan 2008, NeilBrown wrote:

> 
> raid5's 'make_request' function calls generic_make_request on
> underlying devices and if we run out of stripe heads, it could end up
> waiting for one of those requests to complete.
> This is bad as recursive calls to generic_make_request go on a queue
> and are not even attempted until make_request completes.
> 
> So: don't make any generic_make_request calls in raid5 make_request
> until all waiting has been done.  We do this by simply setting
> STRIPE_HANDLE instead of calling handle_stripe().
> 
> If we need more stripe_heads, raid5d will get called to process the
> pending stripe_heads which will call generic_make_request from a
> different thread where no deadlock will happen.
> 
> 
> This change by itself causes a performance hit.  So add a change so
> that raid5_activate_delayed is only called at unplug time, never in
> raid5.  This seems to bring back the performance numbers.  Calling it
> in raid5d was sometimes too soon...
> 
> Cc: "Dan Williams" <dan.j.williams@gmail.com>
> Signed-off-by: Neil Brown <neilb@suse.de>

probably doesn't matter, but for the record:

Tested-by: dean gaudet <dean@arctic.org>

this time i tested with internal and external bitmaps and it survived 8h 
and 14h resp. under the parallel tar workload i used to reproduce the 
hang.

btw this should probably be a candidate for 2.6.22 and .23 stable.

thanks
-dean
