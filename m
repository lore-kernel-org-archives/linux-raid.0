From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] [RFC] fix potential access after free: return value of
 blk_check_plugged() must be used schedule() safe
Date: Tue, 5 Apr 2016 17:49:56 -0700
Message-ID: <20160406004956.GA102852@kernel.org>
References: <20160405133657.GA3078@soda.linbit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160405133657.GA3078@soda.linbit>
Sender: linux-kernel-owner@vger.kernel.org
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Neil Brown <neilb@suse.de>, Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 05, 2016 at 03:36:57PM +0200, Lars Ellenberg wrote:
> blk_check_plugged() will return a pointer
> to an object linked on current->plug->cb_list.
> 
> That list may "at any time" be implicitly cleared by
> blk_flush_plug_list()
>  flush_plug_callbacks()
> either as a result of blk_finish_plug(),
> or implicitly by schedule() [and maybe other implicit mechanisms?]
> 
> If there is no protection against an implicit unplug
> between the call to blk_check_plug() and using its return value,
> that implicit unplug may have already happened,
> even before the plug is actually initialized or populated,
> and we may be using a pointer to already free()d data.

This isn't correct. flush plug is never called in preemption, which is designed
only called when the task is going to sleep. See sched_submit_work. Am I
missing anything?

Thanks,
Shaohua
