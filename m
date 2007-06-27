From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [md-accel PATCH 00/19] md raid acceleration and the async_tx api
Date: Tue, 26 Jun 2007 21:02:33 -0700
Message-ID: <e9c3a7c20706262102h2a0ba25bg96e2ef3db7512e3@mail.gmail.com>
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
	 <Pine.LNX.4.64.0706262047320.12043@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706262047320.12043@filesrv1.baby-dragons.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 6/26/07, Mr. James W. Laferriere <babydr@baby-dragons.com> wrote:
>         Hello Dan ,
>
> On Tue, 26 Jun 2007, Dan Williams wrote:
> > Greetings,
> >
> > Per Andrew's suggestion this is the md raid5 acceleration patch set
> > updated with more thorough changelogs to lower the barrier to entry for
> > reviewers.  To get started with the code I would suggest the following
> > order:
> > [md-accel PATCH 01/19] dmaengine: refactor dmaengine around dma_async_tx_descriptor
> > [md-accel PATCH 04/19] async_tx: add the async_tx api
> > [md-accel PATCH 07/19] md: raid5_run_ops - run stripe operations outside sh->lock
> > [md-accel PATCH 16/19] dmaengine: driver for the iop32x, iop33x, and iop13xx raid engines
>   ...snip...
>
>         Can you please tell me against what linus kernel version these will
> apply against ?  Or at least tell me against which version they were diff'd ?

This patch set is against 2.6.22-rc6.  The git tree is periodically
rebased to track Linus' latest.

--
Dan
