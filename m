From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: [PATCH 08/19] dmaengine: enable multiple clients and operations
Date: Mon, 11 Sep 2006 23:18:59 -0700
Message-ID: <e9c3a7c20609112318o7febe296he6162ddd494499fd@mail.gmail.com>
References: <1158015632.4241.31.camel@dwillia2-linux.ch.intel.com>
	 <20060911231817.4737.49381.stgit@dwillia2-linux.ch.intel.com>
	 <4505F4D0.7010901@garzik.org>
	 <e9c3a7c20609111714h1b88f8cbid99c567d7f3e997c@mail.gmail.com>
	 <adairjt3nz4.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <adairjt3nz4.fsf@cisco.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: Jeff Garzik <jeff@garzik.org>, neilb@suse.de, linux-raid@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, christopher.leech@intel.com, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
List-Id: linux-raid.ids

On 9/11/06, Roland Dreier <rdreier@cisco.com> wrote:
>     Jeff> Are we really going to add a set of hooks for each DMA
>     Jeff> engine whizbang feature?
...ok, but at some level we are going to need a file that has:
EXPORT_SYMBOL_GPL(dma_whizbang_op1)
. . .
EXPORT_SYMBOL_GPL(dma_whizbang_opX)
correct?


>     Dan> What's the alternative?  But, also see patch 9 "dmaengine:
>     Dan> reduce backend address permutations" it relieves some of this
>     Dan> pain.
>
> I guess you can pass an opcode into a common "start operation" function.
But then we still have the problem of being able to request a memory
copy operation of a channel that only understands xor, a la Jeff's
comment to patch 12:

"Further illustration of how this API growth is going wrong.  You should
create an API such that it is impossible for an XOR transform to ever
call non-XOR-transform hooks."

> With all the memcpy / xor / crypto / etc. hardware out there already,
> we definitely have to get this interface right.
>
>  - R.

I understand what you are saying Jeff, the implementation can be made
better, but something I think is valuable is the ability to write
clients once like NET_DMA and RAID5_DMA and have them run without
modification on any platform that can provide the engine interface
rather than needing a client per architecture
IOP_RAID5_DMA...FOO_X_RAID5_DMA.

Or is this an example of the where "Do What You Must, And No More"
comes in, i.e. don't worry about making a generic RAID5_DMA while
there is only one implementation existence?

I also want to pose the question of whether the dmaengine interface
should handle cryptographic transforms?  We already have Acrypto:
http://tservice.net.ru/~s0mbre/blog/devel/acrypto/index.html.  At the
same time since IOPs can do Galois Field multiplication and XOR it
would be nice to take advantage of that for crypto acceleration, but
this does not fit the model of a device that Acrypto supports.

Dan
