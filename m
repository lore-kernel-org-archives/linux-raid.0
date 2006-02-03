From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [RFC][PATCH 001 of 3] MD Acceleration: Base ADMA interface
Date: Fri, 3 Feb 2006 11:11:21 +0300
Message-ID: <20060203081121.GA3434@2ka.mipt.ru>
References: <1138929154.20036.43.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1138929154.20036.43.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, Chris Leech <christopher.leech@intel.com>, "Grover, Andrew" <andrew.grover@intel.com>, Deepak Saxena <dsaxena@plexity.net>
List-Id: linux-raid.ids

Hello, Dan.

On Thu, Feb 02, 2006 at 06:12:34PM -0700, Dan Williams (dan.j.williams@intel.com) wrote:
> This is a draft implementation of the ADMA interface.  The basic premise
> is an interface that receives descriptors from a client and processes
> them in a separate thread.  The descriptors address a wide range of
> commands (xor, copy, compare, etc).  
> 
> On the front end a client can assume that operations queued to an engine
> will be executed in queued order.  On the backend it is expected that
> multiple hardware DMA channels may comprise a single ADMA engine.  For
> example an XOR channel and a normal memory copy channel could be
> presented to a client as a single ADMA engine.
> 
> The descriptor should remain under complete control of the engine.  This
> allows the backend engine code to format the descriptor according to any
> hardware requirements/constraints.  For this reason all access to
> descriptor variables from the client side is through accessor routines.
> Later on theses routines will take into account engine specific
> descriptor constraints.
> 
> For now this code makes some pio_adma_engine assumptions which will be
> addressed in future releases.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>


I have some comments about asynchronous usage of adma_queue_desc(),
adma_run(eng) and adma_spin_wait().

Existense of adma_spin_wait() is a sign of tricky bugs in near future, 
since it hurts performance by busy loop and creates possibility to catch a race,
if busy flag will be set/cleared in the way adma_spin_wait() will not
see it.

I would recommend to modify state machine in async md_raid and eliminate
adma_spin_wait() completely.

In acrypto crypto provider can specially mark crypto_session (descriptor in your case)
so when provider calls queueing mechanism (adma_queue_desc() in your case)
session is not queued but processed immediately(adma_run()), so there is no need in busy waiting.

Btw, as optimisation step, it is very usefull sometimes (if queueing
context allows to sleep) to call needed callbacks directly and do not
postpone work to be done by thread.

-- 
	Evgeniy Polyakov
