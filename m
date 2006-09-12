From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 08/19] dmaengine: enable multiple clients and operations
Date: Tue, 12 Sep 2006 13:15:57 +0400
Message-ID: <20060912091557.GC8432@2ka.mipt.ru>
References: <1158015632.4241.31.camel@dwillia2-linux.ch.intel.com> <20060911231817.4737.49381.stgit@dwillia2-linux.ch.intel.com> <4505F4D0.7010901@garzik.org> <e9c3a7c20609111714h1b88f8cbid99c567d7f3e997c@mail.gmail.com> <adairjt3nz4.fsf@cisco.com> <e9c3a7c20609112318o7febe296he6162ddd494499fd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e9c3a7c20609112318o7febe296he6162ddd494499fd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Roland Dreier <rdreier@cisco.com>, Jeff Garzik <jeff@garzik.org>, neilb@suse.de, linux-raid@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, christopher.leech@intel.com
List-Id: linux-raid.ids

On Mon, Sep 11, 2006 at 11:18:59PM -0700, Dan Williams (dan.j.williams@gmail.com) wrote:
> Or is this an example of the where "Do What You Must, And No More"
> comes in, i.e. don't worry about making a generic RAID5_DMA while
> there is only one implementation existence?
> 
> I also want to pose the question of whether the dmaengine interface
> should handle cryptographic transforms?  We already have Acrypto:
> http://tservice.net.ru/~s0mbre/blog/devel/acrypto/index.html.  At the
> same time since IOPs can do Galois Field multiplication and XOR it
> would be nice to take advantage of that for crypto acceleration, but
> this does not fit the model of a device that Acrypto supports.

Each acrypto crypto device provides set of capabilities it supports, and
when user requests some operation, acrypto core selects device with the
maximum speed for given capabilities, so one can easily add there GF
multiplication devices. Acrypto supports "sync" mode too in case your
hardware is synchronous (i.e. it does not provide interrupt or other
async event when operation is completed).

P.S. acrypto homepage with some design notes and supported features
can be found here:
http://tservice.net.ru/~s0mbre/old/?section=projects&item=acrypto

> Dan

-- 
	Evgeniy Polyakov
