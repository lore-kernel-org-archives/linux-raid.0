From: Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] dmaengine: clean up and abstract function types (was
 Re: [PATCH 08/19] dmaengine: enable multiple clients and operations)
Date: Mon, 18 Sep 2006 20:05:55 -0500
Message-ID: <20060918200555.74aedeae@localhost.localdomain>
References: <1158015632.4241.31.camel@dwillia2-linux.ch.intel.com>
	<20060911231817.4737.49381.stgit@dwillia2-linux.ch.intel.com>
	<4505F4D0.7010901@garzik.org>
	<20060915113817.6154aa67@localhost.localdomain>
	<20060915144423.500b529d@localhost.localdomain>
	<e9c3a7c20609181556n235d650eg16e5296f192bd2d5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20609181556n235d650eg16e5296f192bd2d5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: christopher.leech@intel.com, Jeff Garzik <jeff@garzik.org>, neilb@suse.de, linux-raid@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 18 Sep 2006 15:56:37 -0700 "Dan Williams" <dan.j.williams@gmail.com> wrote:

> On 9/15/06, Olof Johansson <olof@lixom.net> wrote:
> > On Fri, 15 Sep 2006 11:38:17 -0500 Olof Johansson <olof@lixom.net> wrote:

> > Chris/Dan: Please consider picking this up as a base for the added
> > functionality and cleanups.
> >
> Thanks for this Olof it has sparked some ideas about how to redo
> support for multiple operations.

Good. :)

> I think we should keep the operation type in the function name but
> drop all the [buf|pg|dma]_to_[buf|pg|dma] permutations.  The buffer
> type can be handled generically across all operation types.  Something
> like the following for a pg_to_buf memcpy.
> 
> struct dma_async_op_memcpy *op;
> struct page *pg;
> void *buf;
> size_t len;
> 
> dma_async_op_init_src_pg(op, pg);
> dma_async_op_init_dest_buf(op, buf);
> dma_async_memcpy(chan, op, len);

I'm generally for a more generic interface, especially in the address
permutation cases like above. However, I think it'll be a mistake to
keep the association between the API and the function names and types
so close.

What's the benefit of keeping a memcpy-specific dma_async_memcpy()
instead of a more generic dma_async_commit() (or similar)? We'll know
based on how the client/channel was allocated what kind of function is
requested, won't we?

Same goes for the dma_async_op_memcpy. Make it an union that has a type
field if you need per-operation settings. But as before, we'll know
what kind of op structure gets passed in since we'll know what kind of
operation is to be performed on it.

Finally, yet again the same goes for the op_init settings. I would even
prefer it to not be function-based, instead just direct union/struct
assignments.

struct dma_async_op op;
...

op.src_type = PG; op.src = pg;
op.dest_type = BUF; op.dest = buf;
op.len = len;
dma_async_commit(chan, op);

op might have to be dynamically allocated, since it'll outlive the
scope of this function. But the idea would be the same.


-Olof
