From: Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v2 2/2] md: enable io polling
Date: Sat, 15 Feb 2020 04:25:26 +0900
Message-ID: <20200214192526.GA10991@redsun51.ssa.fujisawa.hgst.com>
References: <20200211191729.4745-1-andrzej.jakowski@linux.intel.com>
 <20200211191729.4745-3-andrzej.jakowski@linux.intel.com>
 <20200211211334.GB3837@redsun51.ssa.fujisawa.hgst.com>
 <e9941d4d-c403-4177-526d-b3086207f31a@linux.intel.com>
 <20200212214207.GA6409@redsun51.ssa.fujisawa.hgst.com>
 <f516e2b2-1988-03ca-f966-5f26771717ff@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f516e2b2-1988-03ca-f966-5f26771717ff@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrzej Jakowski <andrzej.jakowski@linux.intel.com>
Cc: axboe@kernel.dk, song@kernel.org, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

On Thu, Feb 13, 2020 at 01:19:42PM -0700, Andrzej Jakowski wrote:
> On 2/12/20 2:42 PM, Keith Busch wrote:
> > Okay, that's a nice subtlety. But it means the original caller gets the
> > cookie from the last submission in the chain. If md recieves a single
> > request that has to be split among more than one member disk, the cookie
> > you're using to control the polling is valid only for one of the
> > request_queue's and may break others.
> 
> Correct, I agree that it is an issue. I can see at least two ways how to solve it:
>  1. Provide a mechanism in md accounting for outstanding IOs, storing cookie information 
>     for them. md_poll() will then use valid cookie's
>  2. Provide similar mechanism abstracted for stackable block devices and block layer could
>     handle completions for subordinate bios in an abstracted way in blk_poll() routine.
> How do you Guys see this going?

Honestly, I don't see how this is can be successful without a more
significant change than you may be anticipating. I'd be happy to hear if
there's a better solution, but here's what I'm thinking:

You'd need each stacking layer to return a cookie that its poll function
can turn into a list of { request_queue, blk_qc_t } tuples for each bio
the stacking layer created so that it can chain the poll request to the
next layers.

The problems are that the stacking layers don't get a cookie for the
bio's it submits from within the same md_make_request() context. Even if
you could get the cookie associated with those bios, you either allocate
more memory to track these things, or need polling bio list link fields
added 'struct bio', neither of which seem very appealing.

Do you have a better way in mind?
