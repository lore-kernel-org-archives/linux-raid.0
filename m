From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v6 08/11] md/r5cache: r5cache recovery: part 1
Date: Tue, 15 Nov 2016 16:33:31 -0800
Message-ID: <20161116003331.pzqxktfjwcqyx6wo@kernel.org>
References: <20161110204623.3484694-1-songliubraving@fb.com>
 <20161110204623.3484694-9-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161110204623.3484694-9-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn
List-Id: linux-raid.ids

On Thu, Nov 10, 2016 at 12:46:20PM -0800, Song Liu wrote:
> Recovery of write-back cache has different logic to write-through only
> cache. Specifically, for write-back cache, the recovery need to scan
> through all active journal entries before flushing data out. Therefore,
> large portion of the recovery logic is rewritten here.
> 
> To make the diffs cleaner, we split the rewrite as follows:
> 
> 1. In this patch, we:
>       - add new data to r5l_recovery_ctx
>       - add new functions to recovery write-back cache
>    The new functions are not used in this patch, so this patch does not
>    change the behavior of recovery.
> 
> 2. In next patch, we:
>       - modify main recovery procedure r5l_recovery_log() to call new
>         functions
>       - remove old functions
> 
> With cache feature, there are 2 different scenarios of recovery:
> 1. Data-Parity stripe: a stripe with complete parity in journal.
> 2. Data-Only stripe: a stripe with only data in journal (or partial
>    parity).
> 
> The code differentiate Data-Parity stripe from Data-Only stripe with
> flag STRIPE_R5C_WRITE_OUT.
> 
> For Data-Parity stripes, we use the same procedure as raid5 journal,
> where all the data and parity are replayed to the RAID devices.
> 
> For Data-Only strips, we need to finish complete calculate parity and
> finish the full reconstruct write or RMW write. For simplicity, in
> the recovery, we load the stripe to stripe cache. Once the array is
> started, the stripe cache state machine will handle these stripes
> through normal write path.
> 
> r5c_recovery_flush_log contains the main procedure of recovery. The
> recovery code first scans through the journal and loads data to
> stripe cache. The code keeps tracks of all these stripes in a list
> (use sh->lru and ctx->cached_list), stripes in the list are
> organized in the order of its first appearance on the journal.
> During the scan, the recovery code assesses each stripe as
> Data-Parity or Data-Only.
> 
> During scan, the array may run out of stripe cache. In these cases,
> the recovery code will also call raid5_set_cache_size to increase
> stripe cache size. If the array still runs out of stripe cache
> because there isn't enough memory, the array will not assemble.
> 
> At the end of scan, the recovery code replays all Data-Parity
> stripes, and sets proper states for Data-Only stripes. The recovery
> code also increases seq number by 10 and rewrites all Data-Only
> stripes to journal. This is to avoid confusion after repeated
> crashes. More details is explained in raid5-cache.c before
> r5c_recovery_rewrite_data_only_stripes().

I'm ok with this patch in current stage. This one has a lot of areas to
improve:
- the r5c_recovery_lookup_stripe algorithm looks silly
- r5c_recovery_analyze_meta_block will read the data twice. One in verify
  checksum and the other in loading to stripe. We could estimate the maximum
  pages a meata could use, then read data to the pages. we could do the read in
  very checksum and then copy the data to stripe.
- r5c_recovery_rewrite_data_only_stripes doesn't need to use sync io, we can
  dispatch several io and wait in batch.

Please remember to fix these later.

Thanks,
Shaohua
