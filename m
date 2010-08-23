From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/6] md: remove dependency on __GFP_NOFAIL
Date: Mon, 23 Aug 2010 13:37:45 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1008231326500.20535@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com> <alpine.DEB.2.00.1008161954310.17924@chino.kir.corp.google.com> <20100823122606.47524cef.akpm@linux-foundation.org> <alpine.DEB.2.00.1008231229410.14622@chino.kir.corp.google.com>
 <20100823130109.6da43a58.akpm@linux-foundation.org> <alpine.DEB.2.00.1008231303410.17716@chino.kir.corp.google.com> <20100823132315.6906ddbe.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100823132315.6906ddbe.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 23 Aug 2010, Andrew Morton wrote:

> > > Hows about you add a helper function
> > > 
> > > 	void *[kmalloc|alloc_page]_retrying_forever_because_i_suck(lots of args)
> > > 
> > > then convert the callsites to use that, then nuke __GFP_NOFAIL?
> > > 
> > 
> > That would only serve as documentation
> 
> Is that bad?
> 

It implies that these calls are special in some way, basically to mean 
we have no sane error handling for failures, when in reality this is only 
a function of the allocation order when the context does not have 
__GFP_FS.  You may as well just add BUG_ON(!nreg) here instead.

I thought my "/* FIXME: this may potentially loop forever */" was 
sufficient to mean that the allocation must succeed independent of the 
page allocator's implementation, but perhaps you find greping for 
[kmalloc|alloc_page.*]_nofail easier?

I'm not sure what flags such a function would be checking for since the 
page allocator determines whether the oom killer is called or not.  If 
current is killed, an order-0 allocation will succeed because of 
TIF_MEMDIE, and if another task is killed, we must still loop waiting for 
the free memory even with __GFP_FS.
