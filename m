From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [md-accel PATCH 00/19] md raid acceleration and the async_tx
 api
Date: Wed, 27 Jun 2007 12:45:38 -0400
Message-ID: <46829432.4050302@tmr.com>
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de, akpm@linux-foundation.org, davem@davemloft.net, christopher.leech@intel.com, shannon.nelson@intel.com, herbert@gondor.apana.org.au, jeff@garzik.org
List-Id: linux-raid.ids

Dan Williams wrote:
> Greetings,
>
> Per Andrew's suggestion this is the md raid5 acceleration patch set
> updated with more thorough changelogs to lower the barrier to entry for
> reviewers.  To get started with the code I would suggest the following
> order:
> [md-accel PATCH 01/19] dmaengine: refactor dmaengine around dma_async_tx_descriptor
> [md-accel PATCH 04/19] async_tx: add the async_tx api
> [md-accel PATCH 07/19] md: raid5_run_ops - run stripe operations outside sh->lock
> [md-accel PATCH 16/19] dmaengine: driver for the iop32x, iop33x, and iop13xx raid engines
>
> The patch set can be broken down into three main categories:
> 1/ API (async_tx: patches 1 - 4)
> 2/ implementation (md changes: patches 5 - 15)
> 3/ driver (iop-adma: patches 16 - 19)
>
> I have worked with Neil to get approval of the category 2 changes.
> However for the category 1 and 3 changes there was no obvious
> merge-path/maintainer to work through.  I have thus far extrapolated
> Neil's comments about 2 out to 1 and 3, Jeff gave some direction on a
> early revision about the scalability of the API, and the patch set has
> picked up various fixes and suggestions from being in -mm for a few
> releases.  Please help me ensure that this code is ready for Linus to
> pull for 2.6.23.
>
> 	git://lost.foo-projects.org/~dwillia2/git/iop md-accel-linus
>   

Dan, I hope you will release these as a patchset against 2.6.22 when 
it's out or 2.6.21. I find I have a lot more confidence in results, good 
or bad, when comparing something I have run in production with just one 
patchset added. There are enough other changes in an -rc to confuse the 
issue, and I don't run them in production (at least not usually).

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

