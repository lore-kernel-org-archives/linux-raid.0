From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/3 v2] wait: introduce wait_event_exclusive_cmd
Date: Wed, 29 Apr 2015 11:31:09 +0200
Message-ID: <20150429093109.GS5029@twins.programming.kicks-ass.net>
References: <1430275735-20290-1-git-send-email-yuanhan.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1430275735-20290-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
List-Id: linux-raid.ids

On Wed, Apr 29, 2015 at 10:48:53AM +0800, Yuanhan Liu wrote:
> It's just a variant of wait_event_cmd(), with exclusive flag being set.
> 
> For cases like RAID5, which puts many processes to sleep until 1/4
> resources are free, a wake_up wakes up all processes to run, but
> there is one process being able to get the resource as it's protected
> by a spin lock. That ends up introducing heavy lock contentions, and
> hurts performance badly.
> 
> Here introduce wait_event_exclusive_cmd to relieve the lock contention
> naturally by letting wake_up just wake up one process.
> 
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>

Thanks!

Assuming you want to route this through Neil's MD tree:

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

> ---
>  include/linux/wait.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/include/linux/wait.h b/include/linux/wait.h
> index 2db8334..db78c72 100644
> --- a/include/linux/wait.h
> +++ b/include/linux/wait.h
> @@ -358,6 +358,19 @@ do {									\
>  	__ret;								\
>  })
>  
> +#define __wait_event_exclusive_cmd(wq, condition, cmd1, cmd2)		\
> +	(void)___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 1, 0,	\
> +			    cmd1; schedule(); cmd2)
> +/*
> + * Just like wait_event_cmd(), except it sets exclusive flag
> + */
> +#define wait_event_exclusive_cmd(wq, condition, cmd1, cmd2)		\
> +do {									\
> +	if (condition)							\
> +		break;							\
> +	__wait_event_exclusive_cmd(wq, condition, cmd1, cmd2);		\
> +} while (0)
> +
>  #define __wait_event_cmd(wq, condition, cmd1, cmd2)			\
>  	(void)___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0, 0,	\
>  			    cmd1; schedule(); cmd2)
> -- 
> 1.9.0
> 
