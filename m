From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: [RFC][PATCH 001 of 3] MD Acceleration: Base ADMA interface
Date: Fri, 3 Feb 2006 16:58:02 -0700
Message-ID: <e9c3a7c20602031558m2b3498d5sd9be09bc072fed57@mail.gmail.com>
References: <1138929154.20036.43.camel@dwillia2-linux.ch.intel.com>
	 <20060203081121.GA3434@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060203081121.GA3434@2ka.mipt.ru>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org, Chris Leech <christopher.leech@intel.com>, "Grover, Andrew" <andrew.grover@intel.com>, Deepak Saxena <dsaxena@plexity.net>
List-Id: linux-raid.ids

Hi Evengiy,

On 2/3/06, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> I have some comments about asynchronous usage of adma_queue_desc(),
> adma_run(eng) and adma_spin_wait().
>
> Existense of adma_spin_wait() is a sign of tricky bugs in near future,
> since it hurts performance by busy loop and creates possibility to catch a race,
> if busy flag will be set/cleared in the way adma_spin_wait() will not
> see it.
>
> I would recommend to modify state machine in async md_raid and eliminate
> adma_spin_wait() completely.
>
> In acrypto crypto provider can specially mark crypto_session (descriptor in your case)
> so when provider calls queueing mechanism (adma_queue_desc() in your case)
> session is not queued but processed immediately(adma_run()), so there is no need in busy waiting.
>
> Btw, as optimisation step, it is very usefull sometimes (if queueing
> context allows to sleep) to call needed callbacks directly and do not
> postpone work to be done by thread.

Thanks for the feedback, I will implement these changes.  Also, now
that you have given me some hints as to the acrypto vocabulary, I can
start looking into integration and cross pollenation efforts.

Dan
