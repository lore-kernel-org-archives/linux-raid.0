From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/6] md: remove dependency on __GFP_NOFAIL
Date: Mon, 23 Aug 2010 13:13:12 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1008231310100.17716@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com> <alpine.DEB.2.00.1008161954310.17924@chino.kir.corp.google.com> <20100823122606.47524cef.akpm@linux-foundation.org> <alpine.DEB.2.00.1008231229410.14622@chino.kir.corp.google.com>
 <20100823130109.6da43a58.akpm@linux-foundation.org> <AANLkTikpTZfUE-XFCXJV6FdZy0ZTWeoPLF_qErvvjGOy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531368966-1584180509-1282594394=:17716"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikpTZfUE-XFCXJV6FdZy0ZTWeoPLF_qErvvjGOy@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pekka Enberg <penberg@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531368966-1584180509-1282594394=:17716
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 23 Aug 2010, Pekka Enberg wrote:

> > Hows about you add a helper function
> >
> >        void *[kmalloc|alloc_page]_retrying_forever_because_i_suck(lots of args)
> >
> > then convert the callsites to use that, then nuke __GFP_NOFAIL?
> 
> I'd prefer killing off __GFP_NOFAIL properly :-)
> 

And how is this not done properly if it's not even needed for any of the 
allocations in this patchset since the page allocator loops forever for 
their orders and context?  (This is why we don't need to add __GFP_NOWARN 
in its place.)

This is a cleanup patchset to remove the unnecessary use of __GFP_NOFAIL, 
there _are_ GFP_KERNEL | __GFP_NOFAIL allocations that need to be 
addressed in phase three.
--531368966-1584180509-1282594394=:17716--
