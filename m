From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 7/8] raid5: raid5d handle stripe in batch way
Date: Thu, 7 Jun 2012 14:35:47 +0800
Message-ID: <20120607063547.GC779@kernel.org>
References: <20120604080152.098975870@kernel.org>
 <20120604080344.262680737@kernel.org>
 <20120607113239.6a64b64d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120607113239.6a64b64d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

On Thu, Jun 07, 2012 at 11:32:39AM +1000, NeilBrown wrote:
> On Mon, 04 Jun 2012 16:01:59 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > Let raid5d handle stripe in batch way to reduce conf->device_lock locking.
> > 
> > Signed-off-by: Shaohua Li <shli@fusionio.com>
> 
> I like this.
> I don't think it justifies a separate function.
> 
> #define MAX_STRIPE_BATCH 8
> struct stripe_head *batch[MAX_STRIPE_BATCH]
> int batch_size = 0;
> 
> ...
> 
> while (batch_size < MAX_STRPE_BATCH &&
>        (sh = __get_priority_stripe(conf)) != NULL)
>      batch[batch_size++] = sh;
> 
> spin_unlock(&conf->device_lock);
> if (batch_size == 0)
>      break;
> 
> handled += batch_size;
> 
> for (i = 0; i < batch_size; i++)
>      handle_stripe(batch[i]);
> cond_resched();
> if (....) md_check_recovery(mddev);
> 
> spin_lock_irq(&conf->lock);
> for (i = 0; i < batch_size; i++)
>      __release_stripe(batch[i]);
> 
> 
> something like that?

the 8th patch does the same thing, so I moved the code to a separate function.
