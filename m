From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm PATCH 0/3] *** fix gcc warnings ***
Date: Wed, 3 Mar 2010 10:59:53 +1100
Message-ID: <20100303105953.16f919cb@notabene.brown>
References: <cover.1267264723.git.bluca@comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1267264723.git.bluca@comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 27 Feb 2010 11:14:43 +0100
Luca Berra <bluca@comedia.it> wrote:

> building current git with -O2 -Wall -Werror aborts with compiler warnings
> patch 1 fixes a strict-aliasing violation
> patch 2 addresses trivial to fix warning
> patch 3 is just _WRONG_: there is no clear way to bailout from the functions in
> Grow.c, and i have no idea if aborting would leave the array in an inconsistent
> state. For the time being I just decided to please gcc by storing the result
> somwere, but it is never checked.

Thanks.
I needed to add -D_FORTIFY_SOURCE=2 to get all those warnings as well,
so I've told the Makefile about that.

Your patches were space-damaged somehow so I didn't apply them directly, but
I have fixed up all the warnings, sometimes the same way that you did,
soemthings differently.

Thanks.

NeilBrown


> 
> L.
> 
> Luca Berra (3):
>    fix gcc warnings about strict-aliasing rules
>    fix compiler warnings
>    workaround unused_results
> 
>   Grow.c     |   30 +++++++++++++++++++-----------
>   mdmon.c    |    2 +-
>   restripe.c |    2 +-
>   util.c     |    4 ++--
>   4 files changed, 23 insertions(+), 15 deletions(-)
> 
> 

