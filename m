From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: [md-accel PATCH 00/19] md raid acceleration and the async_tx
 api
Date: Tue, 26 Jun 2007 20:49:41 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0706262047320.12043@filesrv1.baby-dragons.com>
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Dan ,

On Tue, 26 Jun 2007, Dan Williams wrote:
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
  ...snip...

 	Can you please tell me against what linus kernel version these will 
apply against ?  Or at least tell me against which version they were diff'd ?
 		Tia ,  JimL
-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
