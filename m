From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v7 00/10] raid5-cache: enabling cache features
Date: Fri, 18 Nov 2016 13:22:48 -0800
Message-ID: <20161118212248.fabrldq5r5xclly4@kernel.org>
References: <20161117232445.1798305-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161117232445.1798305-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn
List-Id: linux-raid.ids

On Thu, Nov 17, 2016 at 03:24:35PM -0800, Song Liu wrote:
> These are the 7th version of patches to enable write cache part of
> raid5-cache. The journal part was released with kernel 4.4.
> 
> The caching part uses same disk format of raid456 journal, and provides
> acceleration to writes. Write operations are committed (bio_endio) once
> the data is secured in journal. Reconstruct and RMW are postponed to
> writing-out phase, which is usually not on the critical path.
> 
> The changes are organized in 10 patches (details below).
> 
> Patch for chunk_aligned_read in earlier RFC is not included yet
> (http://marc.info/?l=linux-raid&m=146432700719277). But we may still need
> some optimizations later, especially for SSD raid devices.
> 
> Changes between v7 and v6 (http://marc.info/?l=linux-raid&m=147881079931937):
>  1. Incorprate feedbacks;
>  2. Modify representation of write-back state machine to use STRIPE_R5C_CACHING
>     instead of STRIPE_R5C_WRITE_OUT. This reduces state trasitions in
>     write-through mode;
>  3. For prexor, allocate extra orig_page instead of page;
>  4. Rename and refactor of some functions and variables;
>  5. Remove path 11 (handle alloc_page failure). I will propose a simpler retry
>     patch later.

Thanks for doing this, Song! And thanks Neil for the code review! I think this
series are in good shape. We do have a lot of todo stuffes to make these work
well, but we can always improve based on these. And since the default setting
is write-through, there should be no regression (hopefully). I'm going to apply
them to my for-next tree. If you have further bug fixes/improvements, please do
them against the for-next tree.

I don't apply the last patch though. That one doesn't work well for !write-back
case (sorry, didn't notice it in last review), as for write-through, we don't
need do any flush/fua. Please send an updated patch, I'll apply.

I'll list the todo here so we don't forget:
- makes read not enter state machine
- write checkpoint block to make recovery faster
- improve recovery
- handle memory allocation failure
- allow removing journal capability if journal disk fails

And of course performance tuning.

Thanks,
Shaohua 
