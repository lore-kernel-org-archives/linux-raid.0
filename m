From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ASYNC_TX: fix the bug in async_tx_run_dependencies
Date: Thu, 4 Sep 2008 14:19:45 -0700
Message-ID: <20080904141945.f5c4c3eb.akpm@linux-foundation.org>
References: <1220478231-8725-1-git-send-email-yanok@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1220478231-8725-1-git-send-email-yanok@emcraft.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ilya Yanok <yanok@emcraft.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, wd@denx.de, yur@emcraft.com, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Thu,  4 Sep 2008 01:43:51 +0400
Ilya Yanok <yanok@emcraft.com> wrote:

> From: Yuri Tikhonov <yur@emcraft.com>
> 
> Should clear the next pointer of the TX if we are sure that the
> next TX (say NXT) will be submitted to the channel too. Overwise,
> we break the chain of descriptors, because we lose the information
> about the next descriptor to run. So next time, when invoke
> async_tx_run_dependencies() with TX, it's TX->next will be NULL, and
> NXT will be never submitted.
> 
> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>

This patch should include your signed-off-by: as well.  Because you
were on the delivery path, as described in
Documentation/SubmittingPatches, section 12.  

> 
> diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
> index 85eaf7b..e8362c1 100644
> --- a/crypto/async_tx/async_tx.c
> +++ b/crypto/async_tx/async_tx.c
> @@ -137,7 +137,8 @@ async_tx_run_dependencies(struct dma_async_tx_descriptor *tx)
>  		spin_lock_bh(&next->lock);
>  		next->parent = NULL;
>  		_next = next->next;
> -		next->next = NULL;
> +		if (_next && _next->chan == chan)
> +			next->next = NULL;
>  		spin_unlock_bh(&next->lock);
>  
>  		next->tx_submit(next);

Dan, please review asap?
