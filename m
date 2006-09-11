From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 01/19] raid5: raid5_do_soft_block_ops
Date: Mon, 11 Sep 2006 19:34:03 -0400
Message-ID: <4505F26B.3040003@garzik.org>
References: <1158015632.4241.31.camel@dwillia2-linux.ch.intel.com> <20060911231740.4737.48922.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060911231740.4737.48922.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, christopher.leech@intel.com
List-Id: linux-raid.ids

Dan Williams wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> 
> raid5_do_soft_block_ops consolidates all the stripe cache maintenance
> operations into a single routine.  The stripe operations are:
> * copying data between the stripe cache and user application buffers
> * computing blocks to save a disk access, or to recover a missing block
> * updating the parity on a write operation (reconstruct write and
> read-modify-write)
> * checking parity correctness
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> 
>  drivers/md/raid5.c         |  289 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/raid/raid5.h |  129 +++++++++++++++++++-
>  2 files changed, 415 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 4500660..8fde62b 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1362,6 +1362,295 @@ static int stripe_to_pdidx(sector_t stri
>  	return pd_idx;
>  }
>  
> +/*
> + * raid5_do_soft_block_ops - perform block memory operations on stripe data
> + * outside the spin lock.
> + */
> +static void raid5_do_soft_block_ops(void *stripe_head_ref)

This function absolutely must be broken up into multiple functions, 
presumably one per operation.

	Jeff



