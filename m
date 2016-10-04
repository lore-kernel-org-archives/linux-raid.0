From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] async_pq_val: fix DMA memory leak
Date: Tue, 4 Oct 2016 13:26:55 -0700
Message-ID: <CAPcyv4gNo3ftFrDJzHby0PbyhwwNmw0tLRB6=wLM7sAVMtqi=Q@mail.gmail.com>
References: <20161004201758.13876-1-jmaggard@netgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161004201758.13876-1-jmaggard@netgear.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Maggard <jmaggard10@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, Justin Maggard <jmaggard@netgear.com>, Vinod Koul <vinod.koul@intel.com>
List-Id: linux-raid.ids

[ adding Vinod ]

On Tue, Oct 4, 2016 at 1:17 PM, Justin Maggard <jmaggard10@gmail.com> wrote:
> Add missing dmaengine_unmap_put(), so we don't OOM during RAID6 sync.
>
> Fixes: 1786b943dad0 ("async_pq_val: convert to dmaengine_unmap_data")
> Signed-off-by: Justin Maggard <jmaggard@netgear.com>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>


> ---
>  crypto/async_tx/async_pq.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
> index 08b3ac6..f83de99 100644
> --- a/crypto/async_tx/async_pq.c
> +++ b/crypto/async_tx/async_pq.c
> @@ -368,8 +368,6 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
>
>                 dma_set_unmap(tx, unmap);
>                 async_tx_submit(chan, tx, submit);
> -
> -               return tx;
>         } else {
>                 struct page *p_src = P(blocks, disks);
>                 struct page *q_src = Q(blocks, disks);
> @@ -424,9 +422,11 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
>                 submit->cb_param = cb_param_orig;
>                 submit->flags = flags_orig;
>                 async_tx_sync_epilog(submit);
> -
> -               return NULL;
> +               tx = NULL;
>         }
> +       dmaengine_unmap_put(unmap);
> +
> +       return tx;
>  }
>  EXPORT_SYMBOL_GPL(async_syndrome_val);
>
> --
> 2.10.1
>
