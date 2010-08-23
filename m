From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/6] md: remove dependency on __GFP_NOFAIL
Date: Mon, 23 Aug 2010 13:08:53 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1008231303410.17716@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com> <alpine.DEB.2.00.1008161954310.17924@chino.kir.corp.google.com> <20100823122606.47524cef.akpm@linux-foundation.org> <alpine.DEB.2.00.1008231229410.14622@chino.kir.corp.google.com>
 <20100823130109.6da43a58.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100823130109.6da43a58.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 23 Aug 2010, Andrew Morton wrote:

> Hows about you add a helper function
> 
> 	void *[kmalloc|alloc_page]_retrying_forever_because_i_suck(lots of args)
> 
> then convert the callsites to use that, then nuke __GFP_NOFAIL?
> 

That would only serve as documentation of a caller that could potentially 
loop forever waiting for memory (which I did by adding "/* FIXME: this may 
potentially loop forever */") since all of the allocations in this 
patchset never loop in the code that was added, they already loop forever 
in the page allocator doing the same thing.  The hope is that kswapd will 
eventually be able to free memory since direct reclaim will usually fail 
for GFP_NOFS and we simply need to wait long enough for there to be 
memory.
