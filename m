From: Laurent CARON <lcaron@unix-scripts.info>
Subject: Re: Strange crash on Dell R720xd
Date: Wed, 17 Oct 2012 09:31:21 +0200
Message-ID: <20121017092903.ahgeefai@trusted.unix-scripts.info>
References: <20121015213522.kaiyahro@trusted.unix-scripts.info>
 <20121016090353.GB7428@liondog.tnic>
 <20121016112301.lavahnga@trusted.unix-scripts.info>
 <20121016124825.GA8509@x1.osrc.amd.com>
 <20121016145039.eizeigon@trusted.unix-scripts.info>
 <CAA9_cmf9XsQ7YPLfsvvjPjLxQGVde1yHqTanOjJxdjPcLRUK8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAA9_cmf9XsQ7YPLfsvvjPjLxQGVde1yHqTanOjJxdjPcLRUK8g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <djbw@fb.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
List-Id: linux-raid.ids

On Tue, Oct 16, 2012 at 10:58:49AM -0700, Dan Williams wrote:
> I think this may be a bug in __raid_run_ops that is only possible when
> raid offload and CONFIG_MULTICORE_RAID456 are enabled.  I'm thinking
> the descriptor is completed and recycled to another requester in the
> space between these two events:
> 
>                 ops_run_compute();
> 
>                 /* terminate the chain if reconstruct is not set to be run */
>                 if (tx && !test_bit(STRIPE_OP_RECONSTRUCT, &ops_request))
>                         async_tx_ack(tx);
> 
> ...don't use the experimental CONFIG_MULTICORE_RAID456 even if you
> leave IOAT DMA disabled.  A rework of the raid operation dma chaining
> is in progress, but may not be ready for a while.

Hi,

I usually don't use CONFIG_MULTICORE_RAID456 as it proved to be sluggish
and/or unstable in my experience, so I should be pretty safe letting I/O
AT DMA disabled for now on those bosex.

Thanks
